from pyorama.core.handle cimport *
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

cdef class FrameBuffer(HandleObject):
    @staticmethod
    cdef FrameBuffer c_from_handle(Handle handle)
    cdef FrameBufferC *c_get_ptr(self) except *
    cpdef void create_from_window(self, Window window) except *
    cpdef void delete(self) except *