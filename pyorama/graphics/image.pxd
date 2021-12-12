from pyorama.data.handle cimport *
from pyorama.data.buffer cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.libs.c cimport *

cpdef enum ImageFileType:
    IMAGE_FILE_TYPE_PNG
    IMAGE_FILE_TYPE_JPG

ctypedef struct ImageC:
    Handle handle
    uint8_t *pixels
    uint16_t width
    uint16_t height
    size_t bytes_per_pixel

cdef class Image(HandleObject):

    cdef ImageC *get_ptr(self) except *
    cpdef void create_from_data(self, uint8_t[::1] pixels, uint16_t width, uint16_t height) except *
    cpdef void delete(self) except *
    cpdef uint8_t[::1] get_pixels(self)
    cpdef uint8_t[:, :, ::1] get_shaped_pixels(self)
    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *