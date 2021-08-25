cdef dict vertex_attribute_map = {
    b"a_position": VERTEX_ATTRIBUTE_POSITION,
    b"a_normal": VERTEX_ATTRIBUTE_NORMAL,
    b"a_tangent": VERTEX_ATTRIBUTE_TANGENT,
    b"a_bitangent": VERTEX_ATTRIBUTE_BITANGENT,
    b"a_color_0": VERTEX_ATTRIBUTE_COLOR_0,
    b"a_color_1": VERTEX_ATTRIBUTE_COLOR_1,
    b"a_color_2": VERTEX_ATTRIBUTE_COLOR_2,
    b"a_color_3": VERTEX_ATTRIBUTE_COLOR_3,
    b"a_indices": VERTEX_ATTRIBUTE_INDICES,
    b"a_weight": VERTEX_ATTRIBUTE_WEIGHT,
    b"a_tex_coord_0": VERTEX_ATTRIBUTE_TEX_COORD_0,
    b"a_tex_coord_1": VERTEX_ATTRIBUTE_TEX_COORD_1,
    b"a_tex_coord_2": VERTEX_ATTRIBUTE_TEX_COORD_2,
    b"a_tex_coord_3": VERTEX_ATTRIBUTE_TEX_COORD_3,
    b"a_tex_coord_4": VERTEX_ATTRIBUTE_TEX_COORD_4,
    b"a_tex_coord_5": VERTEX_ATTRIBUTE_TEX_COORD_5,
    b"a_tex_coord_6": VERTEX_ATTRIBUTE_TEX_COORD_6,
    b"a_tex_coord_7": VERTEX_ATTRIBUTE_TEX_COORD_7,
}

cdef VertexLayoutC *vertex_layout_get_ptr(Handle vertex_layout) except *:
    return <VertexLayoutC *>graphics.slots.c_get_ptr(vertex_layout)

cpdef Handle vertex_layout_create(BufferFormat attributes, list normalize, list cast_to_int) except *:
    cdef:
        Handle vertex_layout
        VertexLayoutC *vertex_layout_ptr
        size_t i
        size_t num_attributes
        BufferFieldC *a
        VertexAttribute a_name
        size_t a_count
        bint a_norm
        bint a_as_int
        VertexAttributeType a_type
        bgfx_vertex_layout_t *layout_ptr

    vertex_layout = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_LAYOUT)
    vertex_layout_ptr = vertex_layout_get_ptr(vertex_layout)
    layout_ptr = &vertex_layout_ptr.bgfx_id
    bgfx_vertex_layout_begin(layout_ptr, bgfx_get_renderer_type())
    num_attributes = attributes.num_fields
    for i in range(num_attributes):
        a = &attributes.fields[i]
        a_name = vertex_attribute_map.get(a.name, VERTEX_ATTRIBUTE_COUNT)
        if a_name == VERTEX_ATTRIBUTE_COUNT:
            raise ValueError("Vertex Layout: unsupported attribute field name {0}".format(a.name))
        if a.type_ == BUFFER_FIELD_TYPE_U8: a_type = VERTEX_ATTRIBUTE_TYPE_U8
        elif a.type_ == BUFFER_FIELD_TYPE_U16: a_type = VERTEX_ATTRIBUTE_TYPE_I16
        elif a.type_ == BUFFER_FIELD_TYPE_F32: a_type = VERTEX_ATTRIBUTE_TYPE_F32
        else:
            raise ValueError("Vertex Layout: unsupported attribute field type {0}".format(a.type_))
        a_count = a.count
        a_norm = <bint>normalize[i]
        a_as_int = <bint>cast_to_int[i]
        bgfx_vertex_layout_add(
            layout_ptr, 
            <bgfx_attrib_t>a_name, 
            a_count, 
            <bgfx_attrib_type_t>a_type, 
            a_norm, 
            a_as_int,
        )
    bgfx_vertex_layout_end(layout_ptr)
    return vertex_layout

cpdef void vertex_layout_delete(Handle vertex_layout) except *:
    graphics.slots.c_delete(vertex_layout)