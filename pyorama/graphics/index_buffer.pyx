cdef class IndexBuffer(HandleObject):

    cdef IndexBufferC *get_ptr(self) except *:
        return <IndexBufferC *>graphics.slots.c_get_ptr(self.handle)

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
            uint16_t flags
            uint8_t *data

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_INDEX_BUFFER)
        index_buffer_ptr = self.get_ptr()

        if layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
            flags = BGFX_BUFFER_NONE
        elif layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
            flags = BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32

        num_indices = indices.shape[0] / index_size
        if copy:
            data = <uint8_t *>calloc(num_indices, index_size)
            if data == NULL:
                raise MemoryError("IndexBuffer: unable to allocate index data")
            memcpy(data, &indices[0], num_indices * index_size)
        else:
            data = &indices[0]
        
        memory_ptr = bgfx_make_ref(data, num_indices * index_size)
        index_buffer_ptr.bgfx_id.static = bgfx_create_index_buffer(memory_ptr, flags)
        index_buffer_ptr.layout = layout
        index_buffer_ptr.data = data
        index_buffer_ptr.num_indices = num_indices
        index_buffer_ptr.type_ = INDEX_BUFFER_TYPE_STATIC

    cpdef void delete(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        index_buffer_ptr = self.get_ptr()
        if index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_STATIC:
            bgfx_destroy_index_buffer(index_buffer_ptr.bgfx_id.static)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_DYNAMIC:
            bgfx_destroy_dynamic_index_buffer(index_buffer_ptr.bgfx_id.dynamic)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_TRANSIENT:
            pass
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void update(self) except *:
        pass

    cpdef cy_view.array get_view_array(self):
        cdef:
            IndexBufferC *index_buffer_ptr
            IndexLayout index_layout
            size_t num_indices
            size_t index_size
            cdef cy_view.array out
            char[2] format_
        
        index_buffer_ptr = self.get_ptr()
        index_layout = index_buffer_ptr.layout
        num_indices = index_buffer_ptr.num_indices
        if index_layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
            format_[0] = b"H"
        elif index_layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
            format_[0] = b"I"
        out = cy_view.array(
            shape=(num_indices,), 
            itemsize=index_size, 
            format=&format_[0], 
            allocate_buffer=False,
        )
        out.data = <char *>index_buffer_ptr.data
        return out

    cpdef uint8_t[::1] get_raw_view_array(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            IndexLayout index_layout
            size_t num_indices
            size_t index_size
            cdef uint8_t[::1] out

        index_buffer_ptr = self.get_ptr()
        index_layout = index_buffer_ptr.layout
        num_indices = index_buffer_ptr.num_indices
        if index_layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
        elif index_layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
        out = <uint8_t[:num_indices * index_size]>index_buffer_ptr.data
        return out