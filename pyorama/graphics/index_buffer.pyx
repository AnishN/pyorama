cdef IndexBufferC *index_buffer_get_ptr(Handle index_buffer) except *:
    return <IndexBufferC *>graphics.slots.c_get_ptr(index_buffer)

cpdef Handle index_buffer_create(IndexLayout index_layout, Buffer index_data) except *:
    cdef:
        Handle index_buffer
        IndexBufferC *index_buffer_ptr
        bgfx_memory_t *memory_ptr

    index_buffer = graphics.slots.c_create(GRAPHICS_SLOT_INDEX_BUFFER)
    index_buffer_ptr = index_buffer_get_ptr(index_buffer)
    index_buffer_ptr.index_layout = index_layout
    memory_ptr = bgfx_copy(&index_data.items[0], index_data.items.shape[0])
    if index_buffer_ptr.index_layout == INDEX_LAYOUT_UINT16:
        index_buffer_ptr.bgfx_id = bgfx_create_index_buffer(memory_ptr, BGFX_BUFFER_NONE)
        index_buffer_ptr.num_indices = index_data.items.shape[0] / sizeof(uint16_t)
    elif index_buffer_ptr.index_layout == INDEX_LAYOUT_UINT32:
        index_buffer_ptr.bgfx_id = bgfx_create_index_buffer(memory_ptr, BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32)
        index_buffer_ptr.num_indices = index_data.items.shape[0] / sizeof(uint32_t)
    return index_buffer

cpdef void index_buffer_delete(Handle index_buffer) except *:
    cdef:
        IndexBufferC *index_buffer_ptr
    index_buffer_ptr = index_buffer_get_ptr(index_buffer)
    bgfx_destroy_index_buffer(index_buffer_ptr.bgfx_id)
    graphics.slots.c_delete(index_buffer)