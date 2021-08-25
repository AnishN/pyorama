cdef VertexBufferC *vertex_buffer_get_ptr(Handle vertex_buffer) except *:
    return <VertexBufferC *>graphics.slots.c_get_ptr(vertex_buffer)

cpdef Handle vertex_buffer_create(Handle vertex_layout, Buffer vertex_data) except *:
    cdef:
        Handle vertex_buffer
        VertexBufferC *vertex_buffer_ptr
        VertexLayoutC *vertex_layout_ptr
        bgfx_memory_t *memory_ptr

    vertex_buffer = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_BUFFER)
    vertex_buffer_ptr = vertex_buffer_get_ptr(vertex_buffer)
    vertex_layout_ptr = vertex_layout_get_ptr(vertex_layout)
    vertex_buffer_ptr.vertex_layout = vertex_layout
    vertex_buffer_ptr.num_vertices = vertex_data.num_items#vertex_data.items.shape[0] / vertex_layout_ptr.bgfx_id.stride
    memory_ptr = bgfx_copy(vertex_data.items, vertex_data.num_items * vertex_data.item_size)
    vertex_buffer_ptr.bgfx_id = bgfx_create_vertex_buffer(memory_ptr, &vertex_layout_ptr.bgfx_id, BGFX_BUFFER_NONE)
    return vertex_buffer

cpdef void vertex_buffer_delete(Handle vertex_buffer) except *:
    cdef:
        VertexBufferC *vertex_buffer_ptr
    vertex_buffer_ptr = vertex_buffer_get_ptr(vertex_buffer)
    bgfx_destroy_vertex_buffer(vertex_buffer_ptr.bgfx_id)
    graphics.slots.c_delete(vertex_buffer)