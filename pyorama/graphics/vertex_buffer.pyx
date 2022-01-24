cdef class VertexBuffer(HandleObject):

    cdef VertexBufferC *get_ptr(self) except *:
        return <VertexBufferC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create_static(VertexLayout layout, list vertices):
        cdef:
            VertexBuffer vertex_buffer
        
        vertex_buffer = VertexBuffer.__new__(VertexBuffer)
        vertex_buffer.create_static(layout, vertices)
        return vertex_buffer

    cpdef void create_static(self, VertexLayout layout, list vertices) except *:
        cdef:
            VertexLayoutC *layout_ptr
            size_t num_vertices
            size_t num_attributes
            size_t vertex_size
            size_t num_vertex_items
            size_t i, j, k, m, n
            tuple vertex
            AttributeC *a_ptr
            VertexValueC a_value
            size_t a_size
            uint8_t *data
            uint8_t[::1] data_mv
        
        layout_ptr = layout.get_ptr()
        num_vertices = len(vertices)
        vertex_size = layout_ptr.vertex_size
        num_attributes = layout_ptr.num_attributes
        data = <uint8_t *>calloc(num_vertices, vertex_size)
        if data == NULL:
            raise MemoryError("VertexBuffer: unable to allocate vertex data")
        
        n = 0
        for i in range(num_vertices):
            vertex = <tuple>vertices[i]
            num_vertex_items = len(vertex)
            m = 0
            for j in range(num_attributes):
                a_ptr = &layout_ptr.attributes[j]
                for k in range(a_ptr.count):
                    if m >= num_vertex_items:
                        raise ValueError("VertexBuffer: attempting to get vertex data outside of layout bounds")
                    if a_ptr.type_ == ATTRIBUTE_TYPE_U8:
                        a_value.u8 = <uint8_t>vertex[m]
                        memcpy(&data[n], &a_value.u8, sizeof(uint8_t))
                        n += sizeof(uint8_t)
                    elif a_ptr.type_ == ATTRIBUTE_TYPE_I16:
                        a_value.i16 = <int16_t>vertex[m]
                        memcpy(&data[n], &a_value.i16, sizeof(int16_t))
                        n += sizeof(int16_t)
                    elif a_ptr.type_ == ATTRIBUTE_TYPE_F32:
                        a_value.f32 = <float>vertex[m]
                        memcpy(&data[n], &a_value.f32, sizeof(float))
                        n += sizeof(float)
                    m += 1
        data_mv = <uint8_t[:num_vertices * vertex_size]>data
        self.create_static_from_array(layout, data_mv, copy=False)
    
    @staticmethod
    def init_create_static_from_array(VertexLayout layout, uint8_t[::1] vertices):
        cdef:
            VertexBuffer vertex_buffer
        
        vertex_buffer = VertexBuffer.__new__(VertexBuffer)
        vertex_buffer.create_static_from_array(layout, vertices)
        return vertex_buffer

    cpdef void create_static_from_array(self, VertexLayout layout, uint8_t[::1] vertices, bint copy=True) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
            VertexLayoutC *layout_ptr
            bgfx_memory_t *memory_ptr
            size_t num_vertices
            size_t num_attributes
            size_t vertex_size
            size_t num_vertex_items
            size_t i, j, k, m, n
            tuple vertex
            AttributeC *a_ptr
            VertexValueC a_value
            size_t a_size
            uint8_t *data

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_BUFFER)
        vertex_buffer_ptr = self.get_ptr()
        layout_ptr = layout.get_ptr()

        vertex_size = layout_ptr.vertex_size
        num_vertices = vertices.shape[0] / vertex_size
        num_attributes = layout_ptr.num_attributes
        if copy:
            data = <uint8_t *>calloc(num_vertices, vertex_size)
            if data == NULL:
                raise MemoryError("VertexBuffer: unable to allocate vertex data")
            memcpy(data, &vertices[0], num_vertices * vertex_size)
        else:
            data = &vertices[0]
        memory_ptr = bgfx_make_ref(data, num_vertices * vertex_size)
        vertex_buffer_ptr.bgfx_id.static = bgfx_create_vertex_buffer(
            memory_ptr, 
            &layout_ptr.bgfx_id, 
            BGFX_BUFFER_NONE,
        )
        vertex_buffer_ptr.layout = layout.handle
        vertex_buffer_ptr.data = data
        vertex_buffer_ptr.num_vertices = num_vertices
        vertex_buffer_ptr.type_ = VERTEX_BUFFER_TYPE_STATIC

    cpdef void delete(self) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
        vertex_buffer_ptr = self.get_ptr()
        if vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_STATIC:
            bgfx_destroy_vertex_buffer(vertex_buffer_ptr.bgfx_id.static)
        elif vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_DYNAMIC:
            bgfx_destroy_dynamic_vertex_buffer(vertex_buffer_ptr.bgfx_id.dynamic)
        elif vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_TRANSIENT:
            pass
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void update(self) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
        vertex_buffer_ptr = self.get_ptr()
        if vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_STATIC:
            pass
        elif vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_DYNAMIC:
            pass
        elif vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_TRANSIENT:
            pass

    cpdef cy_view.array get_view_array(self):
        cdef:
            VertexBufferC *vertex_buffer_ptr
            VertexLayoutC *vertex_layout_ptr
            size_t num_vertices
            size_t vertex_size
            cdef cy_view.array out

        vertex_buffer_ptr = self.get_ptr()
        vertex_layout_ptr = <VertexLayoutC *>graphics.slots.c_get_ptr(vertex_buffer_ptr.layout)
        num_vertices = vertex_buffer_ptr.num_vertices
        vertex_size = vertex_layout_ptr.vertex_size
        out = cy_view.array(
            shape=(num_vertices,), 
            itemsize=vertex_size, 
            format=vertex_layout_ptr.format_, 
            allocate_buffer=False,
        )
        out.data = <char *>vertex_buffer_ptr.data
        return out
    
    cpdef uint8_t[::1] get_raw_view_array(self) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
            VertexLayoutC *vertex_layout_ptr
            size_t num_vertices
            size_t vertex_size
            cdef uint8_t[::1] out

        vertex_buffer_ptr = self.get_ptr()
        vertex_layout_ptr = <VertexLayoutC *>graphics.slots.c_get_ptr(vertex_buffer_ptr.layout)
        num_vertices = vertex_buffer_ptr.num_vertices
        vertex_size = vertex_layout_ptr.vertex_size
        out = <uint8_t[:num_vertices * vertex_size]>vertex_buffer_ptr.data
        return out