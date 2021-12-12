cdef class IndexBuffer(HandleObject):

    cdef IndexBufferC *get_ptr(self) except *:
        return <IndexBufferC *>graphics.slots.c_get_ptr(self.handle)

    cpdef void create(self, IndexLayout index_layout, Buffer index_data, bint dynamic=False) except *:
        cdef:
            Handle index_buffer
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_INDEX_BUFFER)
        index_buffer_ptr = self.get_ptr()
        index_buffer_ptr.index_layout = index_layout
        index_buffer_ptr.dynamic = dynamic
        memory_ptr = bgfx_copy(index_data.items, index_data.num_items * index_data.item_size)
        if index_buffer_ptr.index_layout == INDEX_LAYOUT_U16:
            index_buffer_ptr.bgfx_id = bgfx_create_index_buffer(memory_ptr, BGFX_BUFFER_NONE)
            index_buffer_ptr.num_indices = index_data.num_items * index_data.item_size / sizeof(uint16_t)
        elif index_buffer_ptr.index_layout == INDEX_LAYOUT_U32:
            index_buffer_ptr.bgfx_id = bgfx_create_index_buffer(memory_ptr, BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32)
            index_buffer_ptr.num_indices = index_data.num_items * index_data.item_size / sizeof(uint32_t)

    cpdef void delete(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        index_buffer_ptr = self.get_ptr()
        bgfx_destroy_index_buffer(index_buffer_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0