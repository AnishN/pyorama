cdef class VertexBuffer(HandleObject):

    cdef VertexBufferC *get_ptr(self) except *:
        return <VertexBufferC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(VertexLayout vertex_layout, Buffer vertex_data, bint dynamic=False):
        cdef:
            VertexBuffer vertex_buffer
        
        vertex_buffer = VertexBuffer.__new__(VertexBuffer)
        vertex_buffer.create(vertex_layout, vertex_data, dynamic)
        return vertex_buffer

    cpdef void create(self, VertexLayout vertex_layout, Buffer vertex_data, bint dynamic=False) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
            VertexLayoutC *vertex_layout_ptr
            bgfx_memory_t *memory_ptr

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_VERTEX_BUFFER)
        vertex_buffer_ptr = self.get_ptr()
        vertex_layout_ptr = vertex_layout.get_ptr()
        vertex_buffer_ptr.vertex_layout = vertex_layout.handle
        vertex_buffer_ptr.num_vertices = vertex_data.num_items#vertex_data.items.shape[0] / vertex_layout_ptr.bgfx_id.stride
        vertex_buffer_ptr.dynamic = dynamic
        memory_ptr = bgfx_copy(vertex_data.items, vertex_data.num_items * vertex_data.item_size)

        #if not vertex_buffer_ptr.dynamic:
        vertex_buffer_ptr.bgfx_id = bgfx_create_vertex_buffer(memory_ptr, &vertex_layout_ptr.bgfx_id, BGFX_BUFFER_NONE)
        #else:
        #vertex_buffer_ptr.bgfx_id = bgfx_create_dynamic_vertex_buffer_mem(memory_ptr, &vertex_layout_ptr.bgfx_id, BGFX_BUFFER_NONE)

    cpdef void delete(self) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
        vertex_buffer_ptr = self.get_ptr()
        bgfx_destroy_vertex_buffer(vertex_buffer_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void update(self) except *:
        cdef:
            VertexBufferC *vertex_buffer_ptr
        vertex_buffer_ptr = self.get_ptr()
        #if vertex_buffer_ptr.dynamic:
        #    bgfx_update_dynamic_vertex_buffer(vertex_buffer_ptr.bgfx_id, 0, data_ptr)