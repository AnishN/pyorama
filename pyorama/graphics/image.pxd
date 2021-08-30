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

cdef ImageC *image_get_ptr(Handle image) except *
cpdef Handle image_create_from_data(uint8_t[::1] pixels, uint16_t width, uint16_t height) except *
cpdef Handle image_create_from_file(bytes file_path) except *
cpdef void image_delete(Handle image) except *
cpdef void image_flip_x(Handle image) except *
cpdef void image_flip_y(Handle image) except *
cpdef void image_premultiply_alpha(Handle image) except *
cpdef void image_write_to_file(Handle image, bytes file_path, ImageFileType file_type) except *