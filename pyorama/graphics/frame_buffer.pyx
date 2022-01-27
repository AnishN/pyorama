cdef class FrameBuffer(HandleObject):

    @staticmethod
    cdef FrameBuffer c_from_handle(Handle handle):
        cdef FrameBuffer obj
        if handle == 0:
            raise ValueError("FrameBuffer: invalid handle")
        obj = FrameBuffer.__new__(FrameBuffer)
        obj.handle = handle
        return obj

    cdef FrameBufferC *c_get_ptr(self) except *:
        return <FrameBufferC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create_from_window(Window window):
        cdef:
            FrameBuffer frame_buffer

        frame_buffer = FrameBuffer.__new__(FrameBuffer)
        frame_buffer.create_from_window(window)
        return frame_buffer

    cpdef void create_from_window(self, Window window) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
            WindowC *window_ptr

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_FRAME_BUFFER)
        frame_buffer_ptr = self.c_get_ptr()
        window_ptr = window.c_get_ptr()
        frame_buffer_ptr.bgfx_id = bgfx_create_frame_buffer_from_nwh(
            bgfx_get_window_nwh(graphics.wmi, window_ptr.sdl_ptr),
            window_ptr.width,
            window_ptr.height,
            BGFX_TEXTURE_FORMAT_BGRA8, 
            BGFX_TEXTURE_FORMAT_D24S8,
        )

    cpdef void delete(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        frame_buffer_ptr = self.c_get_ptr()
        bgfx_destroy_frame_buffer(frame_buffer_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0