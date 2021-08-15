import struct as py_struct

cdef object MEMORY_ERROR = MemoryError("Buffer: cannot allocate memory")

cdef class Buffer:

    def __cinit__(self):
        pass
    
    def __dealloc__(self):
        pass

    cpdef void init(self, bytes item_format, size_t num_items) except *:
        cdef:
            uint8_t *items_ptr
        self.num_items = num_items
        self.item_format = item_format
        self.item_size = py_struct.calcsize(self.item_format)
        items_ptr = <uint8_t *>calloc(self.num_items, self.item_size)
        if items_ptr == NULL:
            raise MEMORY_ERROR
        self.items = <uint8_t[:self.num_items * self.item_size]>items_ptr

    cpdef void init_and_set_items(self, bytes item_format, list items, bint is_flat=False, size_t num_row_items=0) except *:
        cdef:
            size_t num_items = <size_t>len(items)
        self.init(item_format, num_items)
        self.set_items(items, is_flat=is_flat, num_row_items=num_row_items)

    cpdef void free(self) except *:
        self.item_size = 0
        self.num_items = 0
        self.item_format = None
        free(&self.items[0])
        self.items = None
    
    cpdef void set_items(self, list items, size_t start_index=0, bint is_flat=False, size_t num_row_items=0) except *:
        cdef:
            tuple item
            size_t num_items = len(items)
            size_t offset = 0
        
        if not is_flat:
            for i in range(start_index, num_items):
                item = <tuple>items[i]
                py_struct.pack_into(self.item_format, self.items, offset, *item)
                offset += self.item_size
        else:
            for i in range(start_index, num_items):
                item = <tuple>items[i:i+num_row_items]
                py_struct.pack_into(self.item_format, self.items, offset, *item)
                offset += self.item_size