cdef object BUFFER_FORMAT_MEMORY_ERROR = MemoryError("BufferFormat: cannot allocate fields")
cdef object BUFFER_MEMORY_ERROR = MemoryError("Buffer: cannot allocate items")
cdef object BUFFER_FREE_ERROR = MemoryError("Buffer: cannot free items if not owner")

cdef class BufferFormat:

    def __cinit__(self, list fields):
        cdef:
            size_t i
            tuple f
            bytes f_name
            BufferFieldC *f_ptr
        
        self.size = 0
        self.num_fields = <size_t>len(fields)
        self.fields = <BufferFieldC *>calloc(self.num_fields, sizeof(BufferFieldC))
        if self.fields == NULL:
            raise BUFFER_FORMAT_MEMORY_ERROR
        for i in range(self.num_fields):
            f = <tuple>fields[i]
            f_ptr = &self.fields[i]
            if type(f[0]) != bytes:
                raise ValueError("BufferFormat: field name must be a bytes object")
            f_name = <bytes>f[0]
            f_ptr.name_length = <size_t>len(f_name)
            strncpy(f_ptr.name, <char *>f_name, 256)
            #memset(f_ptr.name, 0, 256)
            #memcpy(f_ptr.name, <char *>f_name, f_ptr.name_length + 1)
            f_ptr.count = <size_t>f[1]
            f_ptr.type_ = <BufferFieldType>f[2]
            f_ptr.type_size = BufferFormat.c_get_field_type_size(f_ptr.type_)
            f_ptr.field_size = f_ptr.type_size * f_ptr.count
            self.size += f_ptr.field_size

    def __dealloc__(self):
        self.size = 0
        self.num_fields = 0
        free(self.fields)
        self.fields = NULL

    @staticmethod
    cdef size_t c_get_field_type_size(BufferFieldType field_type) nogil:
        if field_type == BUFFER_FIELD_TYPE_U8: return sizeof(uint8_t)
        elif field_type == BUFFER_FIELD_TYPE_U16: return sizeof(uint16_t)
        elif field_type == BUFFER_FIELD_TYPE_U32: return sizeof(uint32_t)
        elif field_type == BUFFER_FIELD_TYPE_U64: return sizeof(uint64_t)
        elif field_type == BUFFER_FIELD_TYPE_I8: return sizeof(int8_t)
        elif field_type == BUFFER_FIELD_TYPE_I16: return sizeof(int16_t)
        elif field_type == BUFFER_FIELD_TYPE_I32: return sizeof(int32_t)
        elif field_type == BUFFER_FIELD_TYPE_I64: return sizeof(int64_t)
        elif field_type == BUFFER_FIELD_TYPE_F32: return sizeof(float)
        elif field_type == BUFFER_FIELD_TYPE_F64: return sizeof(double)

    @staticmethod
    cdef BufferFieldValue c_convert_value(object value, BufferFieldType field_type) except *:
        cdef BufferFieldValue out
        if field_type == BUFFER_FIELD_TYPE_U8: out.u8 = <uint8_t>value
        elif field_type == BUFFER_FIELD_TYPE_U16: out.u16 = <uint16_t>value
        elif field_type == BUFFER_FIELD_TYPE_U32: out.u32 = <uint32_t>value
        elif field_type == BUFFER_FIELD_TYPE_U64: out.u64 = <uint64_t>value
        elif field_type == BUFFER_FIELD_TYPE_I8: out.i8 = <int8_t>value
        elif field_type == BUFFER_FIELD_TYPE_I16: out.i16 = <int16_t>value
        elif field_type == BUFFER_FIELD_TYPE_I32: out.i32 = <int32_t>value
        elif field_type == BUFFER_FIELD_TYPE_I64: out.i64 = <int64_t>value
        elif field_type == BUFFER_FIELD_TYPE_F32: out.f32 = <float>value
        elif field_type == BUFFER_FIELD_TYPE_F64: out.f64 = <double>value
        return out

cdef class Buffer:

    def __cinit__(self, BufferFormat item_format):
        self.item_format = item_format
        self.item_size = self.item_format.size
    
    def __dealloc__(self):
        self.item_format = None
        self.item_size = 0
    
    cpdef void init_empty(self, size_t num_items) except *:
        self.num_items = num_items
        self.items = <uint8_t *>calloc(self.num_items, self.item_size)
        if self.items == NULL:
            raise BUFFER_MEMORY_ERROR
        self.is_owner = True

    cpdef void init_from_bytes(self, bytes items, bint copy=True) except *:
        cdef size_t num_bytes = <size_t>len(items)
        self.num_items = num_bytes / self.item_size
        if copy:
            self.items = <uint8_t *>calloc(num_bytes, sizeof(uint8_t))
            if self.items == NULL:
                raise BUFFER_MEMORY_ERROR
            memcpy(self.items, <uint8_t *>items, num_bytes)
            self.is_owner = True
        else:
            self.items = <uint8_t *>items
            self.is_owner = False

    cpdef void init_from_list(self, list items, bint is_flat=False) except *:
        cdef:
            size_t i, j, k
            size_t v_index
            size_t num_item_values
            tuple item
            object value
            BufferFieldC *field_ptr
            BufferFieldValue c_value
            uint8_t *curr_item_ptr

        if is_flat:
            num_item_values = 0
            for i in range(self.item_format.num_fields):
                field_ptr = &self.item_format.fields[i]
                num_item_values += field_ptr.count
            self.num_items = <size_t>len(items) / num_item_values
            self.items = <uint8_t *>calloc(self.num_items, self.item_size)
            if self.items == NULL:
                raise BUFFER_MEMORY_ERROR
            self.is_owner = True
            curr_item_ptr = self.items
            v_index = 0
            for i in range(self.num_items):
                for j in range(self.item_format.num_fields):
                    field_ptr = &self.item_format.fields[j]
                    for k in range(field_ptr.count):
                        #print(i, j, k, v_index, field_ptr.type_size, self.item_size, self.num_items)
                        value = <object>items[v_index]
                        c_value = BufferFormat.c_convert_value(value, field_ptr.type_)
                        memcpy(curr_item_ptr, &c_value, field_ptr.type_size)
                        curr_item_ptr += field_ptr.type_size
                        v_index += 1
        else:
            self.num_items = <size_t>len(items)
            self.items = <uint8_t *>calloc(self.num_items, self.item_size)
            if self.items == NULL:
                raise BUFFER_MEMORY_ERROR
            self.is_owner = True
            curr_item_ptr = self.items
            for i in range(self.num_items):
                item = <tuple>items[i]
                v_index = 0
                for j in range(self.item_format.num_fields):
                    field_ptr = &self.item_format.fields[j]
                    for k in range(field_ptr.count):
                        value = <object>item[v_index]
                        c_value = BufferFormat.c_convert_value(value, field_ptr.type_)
                        memcpy(curr_item_ptr, &c_value, field_ptr.type_size)
                        curr_item_ptr += field_ptr.type_size
                        v_index += 1

    cdef void c_init_from_ptr(self, uint8_t *items, size_t num_items, bint copy=True) except *:
        self.num_items = num_items
        if copy:
            self.items = <uint8_t *>calloc(self.num_items, self.item_size)
            if self.items == NULL:
                raise BUFFER_MEMORY_ERROR
            memcpy(self.items, items, self.num_items * self.item_size)
            self.is_owner = True
        else:
            self.items = items
            self.is_owner = False

    cpdef void free(self) except *:
        if self.is_owner:
            free(self.items); self.items = NULL
            self.num_items = 0
            self.is_owner = False
        else:
            raise BUFFER_FREE_ERROR

    cpdef uint8_t[::1] get_view(self) except *:
        return <uint8_t[:self.num_items * self.item_size]>self.items