from pyorama.graphics.graphics_manager cimport *

cdef class Image:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef ImageC *get_ptr(self) except *
    cpdef void create(self, uint16_t width, uint16_t height, uint8_t[::1] data=*, size_t bytes_per_channel=*, size_t num_channels=*) except *
    cpdef void create_from_file(self, bytes file_path, bint flip_x=*, bint flip_y=*, bint premultiply_alpha=*) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, uint8_t[::1] data=*) except *
    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *
    cpdef uint8_t[::1] get_data(self) except *