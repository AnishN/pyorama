"""
cdef class View:
    cpdef void delete(self) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.c_get_ptr()
        view_ptr.index = 0
        graphics.slots.c_delete(self.handle)
        self.handle = 0
    
    cpdef void set_name(self, bytes name) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.c_get_ptr()
        bgfx_set_view_name(view_ptr.index, <char *>name)

    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.c_get_ptr()
        bgfx_set_view_rect(view_ptr.index, x, y, width, height)
    
    cpdef void set_clear(self, uint16_t flags, uint32_t rgba, float depth, uint8_t stencil) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.c_get_ptr()
        bgfx_set_view_clear(view_ptr.index, flags, rgba, depth, stencil)

    cpdef void set_frame_buffer(self, FrameBuffer fbo) except *:
        cdef:
            ViewC *view_ptr
            FrameBufferC *fbo_ptr
        view_ptr = self.c_get_ptr()
        fbo_ptr = fbo.c_get_ptr()
        bgfx_set_view_frame_buffer(view_ptr.index, fbo_ptr.bgfx_id)

    cpdef void submit(self) except *:
        pass
"""

cdef ViewC *view_get_ptr(Handle view) except *:
    return <ViewC *>graphics.slots.c_get_ptr(view)

cpdef Handle view_create() except *:
    cdef:
        Handle view
        ViewC *view_ptr
    view = graphics.slots.c_create(GRAPHICS_SLOT_VIEW)
    view_ptr = view_get_ptr(view)
    view_ptr.index = graphics.c_get_next_view_index()
    return view

cpdef void view_delete(Handle view) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.index = 0
    graphics.slots.c_delete(view)

cpdef void view_set_name(Handle view, bytes name) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    bgfx_set_view_name(view_ptr.index, <char *>name)

cpdef void view_set_rect(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    bgfx_set_view_rect(view_ptr.index, x, y, width, height)
    
#cpdef void view_set_rect_ratio(Handle view, uint16_t x, uint16_t y, bgfx_backbuffer_ratio_t ratio) except *
#cpdef void view_set_scissor(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
cpdef void view_set_clear(Handle view, uint16_t flags, uint32_t rgba, float depth, uint8_t stencil) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    bgfx_set_view_clear(view_ptr.index, flags, rgba, depth, stencil)

#cpdef void view_set_clear_mrt(Handle view, uint16_t flags, float depth, uint8_t stencil, uint8_t c0, uint8_t c1, uint8_t c2, uint8_t c3, uint8_t c4, uint8_t c5, uint8_t c6, uint8_t c7) except *
#cpdef void view_set_mode(Handle view, bgfxmode_t mode) except *
cpdef void view_set_frame_buffer(Handle view, Handle frame_buffer) except *:
    cdef:
        ViewC *view_ptr
        FrameBufferC *frame_buffer_ptr
    view_ptr = view_get_ptr(view)
    frame_buffer_ptr = frame_buffer_get_ptr(frame_buffer)
    bgfx_set_view_frame_buffer(view_ptr.index, frame_buffer_ptr.bgfx_id)

cpdef void view_set_transform(Handle view, Mat4 view_mat, Mat4 proj_mat) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    bgfx_set_view_transform(view_ptr.index, &view_mat.data, &proj_mat.data)

cpdef void view_set_vertex_buffer(Handle view, Handle vertex_buffer) except *:
    cdef:
        ViewC *view_ptr
        VertexBufferC *vertex_buffer_ptr
    view_ptr = view_get_ptr(view)
    vertex_buffer_ptr = vertex_buffer_get_ptr(vertex_buffer)
    bgfx_set_vertex_buffer(view_ptr.index, vertex_buffer_ptr.bgfx_id, 0, vertex_buffer_ptr.num_vertices)

cpdef void view_set_index_buffer(Handle view, Handle index_buffer) except *:
    cdef:
        ViewC *view_ptr
        IndexBufferC *index_buffer_ptr
    view_ptr = view_get_ptr(view)
    index_buffer_ptr = index_buffer_get_ptr(index_buffer)
    bgfx_set_index_buffer(index_buffer_ptr.bgfx_id, 0, index_buffer_ptr.num_indices)

cpdef void view_submit(Handle view, Handle program) except *:
    cdef:
        ViewC *view_ptr
        ProgramC *program_ptr
    view_ptr = view_get_ptr(view)
    program_ptr = program_get_ptr(program)
    bgfx_submit(view_ptr.index, program_ptr.bgfx_id, 0, BGFX_DISCARD_ALL)

cpdef void view_touch(Handle view) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    bgfx_touch(view_ptr.index)