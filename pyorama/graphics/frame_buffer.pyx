cdef FrameBufferC *frame_buffer_get_ptr(Handle frame_buffer) except *:
    return <FrameBufferC *>graphics.slots.c_get_ptr(frame_buffer)

cpdef Handle frame_buffer_create_from_window(Handle window) except *:
    cdef:
        Handle frame_buffer
        FrameBufferC *frame_buffer_ptr
        WindowC *window_ptr

    frame_buffer = graphics.slots.c_create(GRAPHICS_SLOT_FRAME_BUFFER)
    frame_buffer_ptr = frame_buffer_get_ptr(frame_buffer)
    window_ptr = window_get_ptr(window)
    frame_buffer_ptr.bgfx_id = bgfx_create_frame_buffer_from_nwh(
        bgfx_get_window_nwh(graphics.wmi, window_ptr.sdl_ptr),
        window_ptr.width,
        window_ptr.height,
        BGFX_TEXTURE_FORMAT_BGRA8, 
        BGFX_TEXTURE_FORMAT_D24S8,
    )
    return frame_buffer

cpdef void frame_buffer_delete(Handle frame_buffer) except *:
    cdef:
        FrameBufferC *frame_buffer_ptr
    frame_buffer_ptr = frame_buffer_get_ptr(frame_buffer)
    bgfx_destroy_frame_buffer(frame_buffer_ptr.bgfx_id)
    graphics.slots.c_delete(frame_buffer)