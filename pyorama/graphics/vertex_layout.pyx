cdef dict vertex_attribute_map = {
    b"a_position": ATTRIBUTE_POSITION,
    b"a_normal": ATTRIBUTE_NORMAL,
    b"a_tangent": ATTRIBUTE_TANGENT,
    b"a_bitangent": ATTRIBUTE_BITANGENT,
    b"a_color0": ATTRIBUTE_COLOR0,
    b"a_color1": ATTRIBUTE_COLOR1,
    b"a_color2": ATTRIBUTE_COLOR2,
    b"a_color3": ATTRIBUTE_COLOR3,
    b"a_indices": ATTRIBUTE_INDICES,
    b"a_weight": ATTRIBUTE_WEIGHT,
    b"a_texcoord0": ATTRIBUTE_TEXCOORD0,
    b"a_texcoord1": ATTRIBUTE_TEXCOORD1,
    b"a_texcoord2": ATTRIBUTE_TEXCOORD2,
    b"a_texcoord3": ATTRIBUTE_TEXCOORD3,
    b"a_texcoord4": ATTRIBUTE_TEXCOORD4,
    b"a_texcoord5": ATTRIBUTE_TEXCOORD5,
    b"a_texcoord6": ATTRIBUTE_TEXCOORD6,
    b"a_texcoord7": ATTRIBUTE_TEXCOORD7,
}

cdef class VertexLayout(HandleObject):

    cdef VertexLayoutC *get_ptr(self) except *:
        return <VertexLayoutC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(list attributes):
        cdef:
            VertexLayout vertex_layout

        vertex_layout = VertexLayout.__new__(VertexLayout)
        vertex_layout.create(attributes)
        return vertex_layout

    cpdef void create(self, list attributes) except *:
        cdef:
            VertexLayoutC *vertex_layout_ptr
            size_t i
            size_t num_attributes
            size_t a_size
            tuple a
            AttributeC *a_ptr
            bgfx_vertex_layout_t *layout_ptr

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_LAYOUT)
        vertex_layout_ptr = self.get_ptr()
        layout_ptr = &vertex_layout_ptr.bgfx_id
        bgfx_vertex_layout_begin(layout_ptr, bgfx_get_renderer_type())

        num_attributes = len(attributes)
        if num_attributes > 16:
            raise ValueError("VertexLayout: more than 16 attributes not supported")
        vertex_layout_ptr.num_attributes = num_attributes

        vertex_layout_ptr.vertex_size = 0
        for i in range(num_attributes):
            a = attributes[i]
            a_ptr = &vertex_layout_ptr.attributes[i]
            a_ptr.name = <AttributeName>a[0]
            a_ptr.type_ = <AttributeType>a[1]
            a_ptr.count = <size_t>a[2]
            if a_ptr.count < 1 or a_ptr.count > 4:
                raise ValueError("VertexLayout: attribute count outside of range [1, 4]")
            itoa(a_ptr.count, &vertex_layout_ptr.format_[2 * i], 10)
            a_ptr.normalize = <bint>a[3]
            a_ptr.cast_to_int = <bint>a[4]
            bgfx_vertex_layout_add(
                layout_ptr, 
                <bgfx_attrib_t>a_ptr.name, 
                a_ptr.count, 
                <bgfx_attrib_type_t>a_ptr.type_, 
                a_ptr.normalize, 
                a_ptr.cast_to_int,
            )
            if a_ptr.type_ == ATTRIBUTE_TYPE_U8: 
                a_size = sizeof(uint8_t) * a_ptr.count
                vertex_layout_ptr.format_[2 * i + 1] = b"B"
            elif a_ptr.type_ == ATTRIBUTE_TYPE_I16:
                a_size = sizeof(int16_t) * a_ptr.count
                vertex_layout_ptr.format_[2 * i + 1] = b"h"
            elif a_ptr.type_ == ATTRIBUTE_TYPE_F32:
                a_size = sizeof(float) * a_ptr.count
                vertex_layout_ptr.format_[2 * i + 1] = b"f"
            
            vertex_layout_ptr.vertex_size += a_size
        bgfx_vertex_layout_end(layout_ptr)

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0