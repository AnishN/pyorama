cdef IndexBufferC *c_index_buffer_get_ptr(Handle handle) except *:
    cdef:
        IndexBufferC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.index_buffers, handle, <void **>&ptr))
    return ptr

cdef Handle c_index_buffer_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.index_buffers, &handle))
    return handle

cdef void c_index_buffer_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.index_buffers, handle)

cdef class IndexBuffer(HandleObject):

    @staticmethod
    cdef IndexBuffer c_from_handle(Handle handle):
        cdef IndexBuffer obj
        if handle == 0:
            raise ValueError("IndexBuffer: invalid handle")
        obj = IndexBuffer.__new__(IndexBuffer)
        obj.handle = handle
        return obj

    cdef IndexBufferC *c_get_ptr(self) except *:
        return c_index_buffer_get_ptr(self.handle)

    @staticmethod
    def init_create_static(IndexLayout layout, list indices):
        cdef:
            IndexBuffer index_buffer
        
        index_buffer = IndexBuffer.__new__(IndexBuffer)
        index_buffer.create_static(layout, indices)
        return index_buffer

    cpdef void create_static(self, IndexLayout layout, list indices) except *:
        cdef:
            size_t num_indices
            size_t index_size
            size_t i
            uint16_t index_u16
            uint32_t index_u32
            uint16_t flags
            uint8_t *data
            uint8_t[::1] data_mv

        num_indices = len(indices)
        if layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
        elif layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)

        data = <uint8_t *>calloc(num_indices, index_size)
        if data == NULL:
            raise MemoryError("IndexBuffer: unable to allocate index data")
        if layout == INDEX_LAYOUT_U16:
            for i in range(num_indices):
                index_u16 = <uint16_t>indices[i]
                memcpy(&data[i * index_size], &index_u16, index_size)
        elif layout == INDEX_LAYOUT_U32:
            for i in range(num_indices):
                index_u32 = <uint32_t>indices[i]
                memcpy(&data[i * index_size], &index_u32, index_size)

        data_mv = <uint8_t[:num_indices * index_size]>data
        self.create_static_from_array(layout, data_mv, copy=False)
    
    @staticmethod
    def init_create_static_from_array(IndexLayout layout, uint8_t[::1] indices):
        cdef:
            IndexBuffer index_buffer
        
        index_buffer = IndexBuffer.__new__(IndexBuffer)
        index_buffer.create_static_from_array(layout, indices)
        return index_buffer
    
    cpdef void create_static_from_array(self, IndexLayout layout, uint8_t[::1] indices, bint copy=True) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr
            size_t num_indices
            size_t index_size
            ArrayC data
            bgfx_index_buffer_handle_t bgfx_id
            char[2] format_

        self.handle = c_index_buffer_create()
        index_buffer_ptr = self.c_get_ptr()
        if layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
            flags = BGFX_BUFFER_NONE
            format_[0] = b"H"
        elif layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
            flags = BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32
            format_[0] = b"I"
        num_indices = indices.shape[0] / index_size

        if copy:
            CHECK_ERROR(array_init(&data, index_size, num_indices))
            memcpy(data.items, &indices[0], num_indices * index_size)
        else:
            data.items = &indices[0]
            data.max_items = num_indices
            data.item_size = index_size
        memory_ptr = bgfx_make_ref(data.items, num_indices * index_size)
        bgfx_id = bgfx_create_index_buffer(memory_ptr, flags)

        index_buffer_ptr.layout = layout
        index_buffer_ptr.format_ = format_
        index_buffer_ptr.type_ = INDEX_BUFFER_TYPE_STATIC
        index_buffer_ptr.bgfx_id.static = bgfx_id
        index_buffer_ptr.memory_ptr = memory_ptr
        index_buffer_ptr.resizable = False
        index_buffer_ptr.data.fixed = data

    @staticmethod
    def init_create_dynamic_fixed(IndexLayout layout, size_t num_indices):
        cdef:
            IndexBuffer index_buffer
        
        index_buffer = IndexBuffer.__new__(IndexBuffer)
        index_buffer.create_dynamic_fixed(layout, num_indices)
        return index_buffer

    cpdef void create_dynamic_fixed(self, IndexLayout layout, size_t num_indices) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr
            size_t index_size
            ArrayC data
            bgfx_dynamic_index_buffer_handle_t bgfx_id
            char[2] format_

        self.handle = c_index_buffer_create()
        index_buffer_ptr = self.c_get_ptr()
        if layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
            flags = BGFX_BUFFER_NONE
            format_[0] = b"H"
        elif layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
            flags = BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32
            format_[0] = b"I"

        CHECK_ERROR(array_init(&data, index_size, num_indices))
        memory_ptr = bgfx_make_ref(data.items, num_indices * index_size)
        bgfx_id = bgfx_create_dynamic_index_buffer(num_indices, flags)

        index_buffer_ptr.layout = layout
        index_buffer_ptr.format_ = format_
        index_buffer_ptr.type_ = INDEX_BUFFER_TYPE_DYNAMIC
        index_buffer_ptr.bgfx_id.dynamic = bgfx_id
        index_buffer_ptr.memory_ptr = memory_ptr
        index_buffer_ptr.resizable = False
        index_buffer_ptr.data.fixed = data
        
    @staticmethod
    def init_create_dynamic_resizable(IndexLayout layout):
        cdef:
            IndexBuffer index_buffer
        
        index_buffer = IndexBuffer.__new__(IndexBuffer)
        index_buffer.create_dynamic_resizable(layout)
        return index_buffer
    
    cpdef void create_dynamic_resizable(self, IndexLayout layout) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr
            size_t index_size
            VectorC data
            bgfx_dynamic_index_buffer_handle_t bgfx_id
            char[2] format_

        self.handle = c_index_buffer_create()
        index_buffer_ptr = self.c_get_ptr()
        if layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
            flags = BGFX_BUFFER_NONE | BGFX_BUFFER_ALLOW_RESIZE
            format_[0] = b"H"
            
        elif layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
            flags = BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32 | BGFX_BUFFER_ALLOW_RESIZE
            format_[0] = b"I"

        CHECK_ERROR(vector_init(&data, index_size))
        memory_ptr = bgfx_make_ref(data.items, 0)
        bgfx_id = bgfx_create_dynamic_index_buffer_mem(memory_ptr, flags)

        index_buffer_ptr.layout = layout
        index_buffer_ptr.type_ = INDEX_BUFFER_TYPE_DYNAMIC
        index_buffer_ptr.format_ = format_
        index_buffer_ptr.bgfx_id.dynamic = bgfx_id
        index_buffer_ptr.memory_ptr = memory_ptr
        index_buffer_ptr.resizable = True
        index_buffer_ptr.data.resizable = data

    cpdef void delete(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        index_buffer_ptr = self.c_get_ptr()
        if index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_STATIC:
            bgfx_destroy_index_buffer(index_buffer_ptr.bgfx_id.static)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_DYNAMIC:
            bgfx_destroy_dynamic_index_buffer(index_buffer_ptr.bgfx_id.dynamic)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_TRANSIENT:
            pass
        c_index_buffer_delete(self.handle)
        self.handle = 0

    cpdef void update(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr
        
        index_buffer_ptr = self.c_get_ptr()
        if index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_STATIC:
            raise ValueError("IndexBuffer: cannot update static buffer contents")
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_DYNAMIC:
            memory_ptr = bgfx_make_ref(
                index_buffer_ptr.data.resizable.items,
                index_buffer_ptr.data.resizable.num_items * self.get_index_size(),
            )
            index_buffer_ptr.memory_ptr = memory_ptr
            bgfx_update_dynamic_index_buffer(index_buffer_ptr.bgfx_id.dynamic, 0, memory_ptr)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_TRANSIENT:
            pass

    cpdef size_t get_num_indices(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        
        index_buffer_ptr = self.c_get_ptr()
        if index_buffer_ptr.resizable:
            return index_buffer_ptr.data.resizable.num_items
        else:
            return index_buffer_ptr.data.fixed.max_items
    
    cpdef size_t get_index_size(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            IndexLayout layout
        
        index_buffer_ptr = self.c_get_ptr()
        layout = index_buffer_ptr.layout
        if layout == INDEX_LAYOUT_U16:
            return sizeof(uint16_t)
        elif layout == INDEX_LAYOUT_U32:
            return sizeof(uint32_t)
        else:
            raise ValueError("IndexBuffer: invalid index layout")

    cdef char *c_get_index_format(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        index_buffer_ptr = self.c_get_ptr()
        return index_buffer_ptr.format_

    cpdef bytes get_index_format(self):
        return self.c_get_index_format()
    
    cdef uint8_t *c_get_indices(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        
        index_buffer_ptr = self.c_get_ptr()
        if index_buffer_ptr.resizable:
            return index_buffer_ptr.data.resizable.items
        else:
            return index_buffer_ptr.data.fixed.items

    cpdef cy_view.array get_view_array(self):
        cdef:
            IndexBufferC *index_buffer_ptr
            size_t num_indices
            size_t index_size
            char *index_format
            uint8_t *get_indices
            cdef cy_view.array out

        index_buffer_ptr = self.c_get_ptr()
        num_indices = self.get_num_indices()
        index_size = self.get_index_size()
        index_format = self.c_get_index_format()

        out = cy_view.array(
            shape=(num_indices,), 
            itemsize=index_size, 
            format=index_format, 
            allocate_buffer=False,
        )
        out.data = <char *>self.c_get_indices()
        return out
    
    cpdef uint8_t[::1] get_raw_view_array(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            size_t num_indices
            size_t index_size
            uint8_t *indices
            cdef uint8_t[::1] out

        index_buffer_ptr = self.c_get_ptr()
        num_indices = self.get_num_indices()
        index_size = self.get_index_size()
        indices = self.c_get_indices()
        out = <uint8_t[:num_indices * index_size]>indices
        return out