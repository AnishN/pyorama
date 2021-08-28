cdef dict vertex_attribute_map = {
    b"a_position": VERTEX_ATTRIBUTE_POSITION,
    b"a_normal": VERTEX_ATTRIBUTE_NORMAL,
    b"a_tangent": VERTEX_ATTRIBUTE_TANGENT,
    b"a_bitangent": VERTEX_ATTRIBUTE_BITANGENT,
    b"a_color0": VERTEX_ATTRIBUTE_COLOR0,
    b"a_color1": VERTEX_ATTRIBUTE_COLOR1,
    b"a_color2": VERTEX_ATTRIBUTE_COLOR2,
    b"a_color3": VERTEX_ATTRIBUTE_COLOR3,
    b"a_indices": VERTEX_ATTRIBUTE_INDICES,
    b"a_weight": VERTEX_ATTRIBUTE_WEIGHT,
    b"a_texcoord0": VERTEX_ATTRIBUTE_TEXCOORD0,
    b"a_texcoord1": VERTEX_ATTRIBUTE_TEXCOORD1,
    b"a_texcoord2": VERTEX_ATTRIBUTE_TEXCOORD2,
    b"a_texcoord3": VERTEX_ATTRIBUTE_TEXCOORD3,
    b"a_texcoord4": VERTEX_ATTRIBUTE_TEXCOORD4,
    b"a_texcoord5": VERTEX_ATTRIBUTE_TEXCOORD5,
    b"a_texcoord6": VERTEX_ATTRIBUTE_TEXCOORD6,
    b"a_texcoord7": VERTEX_ATTRIBUTE_TEXCOORD7,
}

cdef VertexLayoutC *vertex_layout_get_ptr(Handle vertex_layout) except *:
    return <VertexLayoutC *>graphics.slots.c_get_ptr(vertex_layout)

cpdef Handle vertex_layout_create(BufferFormat attributes, set normalize=None, set cast_to_int=None) except *:
    cdef:
        Handle vertex_layout
        VertexLayoutC *vertex_layout_ptr
        size_t i
        size_t num_attributes
        BufferFieldC *a
        VertexAttribute a_name
        size_t a_count
        bint a_norm
        bint a_to_int
        VertexAttributeType a_type
        bgfx_vertex_layout_t *layout_ptr


    vertex_layout = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_LAYOUT)
    vertex_layout_ptr = vertex_layout_get_ptr(vertex_layout)
    layout_ptr = &vertex_layout_ptr.bgfx_id
    bgfx_vertex_layout_begin(layout_ptr, bgfx_get_renderer_type())
    num_attributes = attributes.num_fields
    if num_attributes > 16:
        raise ValueError("Vertex Layout: more than 16 fields not supported")
    if normalize == None: normalize = set()
    if cast_to_int == None: cast_to_int = set()

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
        a_norm = a.name in normalize
        a_to_int = a.name in cast_to_int
        bgfx_vertex_layout_add(
            layout_ptr, 
            <bgfx_attrib_t>a_name, 
            a_count, 
            <bgfx_attrib_type_t>a_type, 
            a_norm, 
            a_to_int,
        )
    bgfx_vertex_layout_end(layout_ptr)
    return vertex_layout

cpdef void vertex_layout_delete(Handle vertex_layout) except *:
    graphics.slots.c_delete(vertex_layout)