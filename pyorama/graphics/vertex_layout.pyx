cdef VertexLayoutC *vertex_layout_get_ptr(Handle vertex_layout) except *:
    return <VertexLayoutC *>graphics.slots.c_get_ptr(vertex_layout)

cpdef Handle vertex_layout_create(list attributes) except *:
    cdef:
        Handle vertex_layout
        VertexLayoutC *vertex_layout_ptr
        size_t i
        size_t num_attributes
        tuple attribute
        VertexAttribute a_name
        size_t a_count
        VertexAttributeType a_type
        bint a_norm = False
        bint a_as_int = False
        bgfx_vertex_layout_t *layout_ptr

    vertex_layout = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_LAYOUT)
    vertex_layout_ptr = vertex_layout_get_ptr(vertex_layout)
    layout_ptr = &vertex_layout_ptr.layout
    bgfx_vertex_layout_begin(layout_ptr, bgfx_get_renderer_type())
    num_attributes = len(attributes)
    for i in range(num_attributes):
        attribute = <tuple>attributes[i]
        a_name, a_count, a_type = attribute
        bgfx_vertex_layout_add(
            layout_ptr, 
            <bgfx_attrib_t>a_name, 
            a_count, 
            <bgfx_attrib_type_t>a_type, 
            a_norm, 
            a_as_int,
        )
    bgfx_vertex_layout_end(layout_ptr)
    vertex_layout_ptr.bgfx_id = bgfx_create_vertex_layout(layout_ptr)
    return vertex_layout

cpdef void vertex_layout_delete(Handle vertex_layout) except *:
    cdef:
        VertexLayoutC *vertex_layout_ptr
    vertex_layout_ptr = vertex_layout_get_ptr(vertex_layout)
    bgfx_destroy_vertex_layout(vertex_layout_ptr.bgfx_id)
    graphics.slots.c_delete(vertex_layout)