cdef class View:

    cdef ViewC *c_get_ptr(self) except *:
        return <ViewC *>graphics.slots.c_get_ptr(self.handle)

    cpdef void create(self) except *:
        cdef:
            ViewC *view_ptr
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_VIEW)
        view_ptr = self.c_get_ptr()
        view_ptr.index = graphics.c_get_next_view_index()

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