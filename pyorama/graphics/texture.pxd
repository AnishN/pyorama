from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *

cdef class Texture:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle

    cdef TextureC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(TextureC *texture_ptr, Handle sampler, Handle image) nogil

    @staticmethod
    cdef void c_clear(TextureC *texture_ptr) nogil