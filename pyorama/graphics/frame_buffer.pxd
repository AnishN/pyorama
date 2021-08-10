from pyorama.data.handle cimport *
from pyorama.libs.bgfx cimport *
from pyorama.graphics.window cimport *

ctypedef struct FrameBufferC:
    Handle handle
    bgfx_frame_buffer_handle_t bgfx_id
    uint16_t width
    uint16_t height
    bgfx_texture_format_t texture_format
    uint64_t texture_flags
    char *name
    size_t name_length

cdef FrameBufferC *frame_buffer_get_ptr(Handle frame_buffer) except *
cpdef Handle frame_buffer_create_from_window(Handle window) except *
cpdef void frame_buffer_delete(Handle frame_buffer) except *