cdef class FrameBuffer:

    cdef FrameBufferC *c_get_ptr(self) except *:
        return <FrameBufferC *>graphics.slots.c_get_ptr(self.handle)
    #cpdef void create(self, uint16_t width, uint16_t height, format, flags)
    #cpdef void create_scaled(self, ratio, format, flags)
    #cpdef void create_from_textures(self, list textures)
    #cpdef void create_from_attachment

    cpdef void create_from_window(self, Window window) except *:
        cdef:
            FrameBufferC *fbo_ptr
            WindowC *window_ptr

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_FRAME_BUFFER)
        fbo_ptr = self.c_get_ptr()
        window_ptr = window.c_get_ptr()
        fbo_ptr.bgfx_id = bgfx_create_frame_buffer_from_nwh(
            bgfx_get_window_nwh(graphics.wmi, window_ptr.sdl_ptr),
            window_ptr.width,
            window_ptr.height,
            BGFX_TEXTURE_FORMAT_BGRA8, 
            BGFX_TEXTURE_FORMAT_D24S8,
        )

    #cpdef void set_name
    #cpdef Handle get_texture(self, uint8_t attachment)
    #cpdef destroy
    cpdef void delete(self) except *:
        cdef:
            FrameBufferC *fbo_ptr
        fbo_ptr = self.c_get_ptr()
        bgfx_destroy_frame_buffer(fbo_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0