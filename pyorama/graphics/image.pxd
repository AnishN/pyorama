from pyorama.core.error cimport *
from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.sdl2 cimport *

cdef class Image:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle
    
    cdef ImageC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(ImageC *image_ptr, size_t width, size_t height, uint8_t *pixels) nogil

    @staticmethod
    cdef Error c_init_from_file(ImageC *image_ptr, char *file_path) nogil

    @staticmethod
    cdef void c_clear(ImageC *image_ptr) nogil