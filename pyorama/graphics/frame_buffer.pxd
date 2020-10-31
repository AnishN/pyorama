from pyorama.graphics.graphics_manager cimport *

cdef class FrameBuffer:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef FrameBufferC *get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void attach_textures(self, dict textures) except *