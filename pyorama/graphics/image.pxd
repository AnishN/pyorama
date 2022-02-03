from pyorama.core.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.libs.stb_image cimport *

cpdef enum ImageFileType:
    IMAGE_FILE_TYPE_PNG
    IMAGE_FILE_TYPE_JPG

ctypedef struct ImageC:
    Handle handle
    uint8_t *pixels
    uint16_t width
    uint16_t height
    size_t num_channels

cdef ImageC *c_image_get_ptr(Handle handle) except *
cdef Handle c_image_create() except *
cdef void c_image_delete(Handle handle) except *

cdef class Image(HandleObject):
    @staticmethod
    cdef Image c_from_handle(Handle handle)
    cdef ImageC *c_get_ptr(self) except *
    cpdef void create_from_data(self, uint8_t[::1] pixels, uint16_t width, uint16_t height, size_t num_channels=*) except *
    cpdef void create_from_file(self, bytes file_path, size_t num_channels=*) except *
    cpdef void delete(self) except *
    cpdef uint8_t[::1] get_pixels(self)
    cpdef uint8_t[:, :, ::1] get_shaped_pixels(self)
    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *