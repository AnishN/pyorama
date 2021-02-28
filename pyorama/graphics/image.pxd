from pyorama.graphics.graphics_manager cimport *

cdef class Image:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef ImageC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef ImageC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef ImageC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, uint16_t width, uint16_t height, uint8_t[::1] data=*, size_t bytes_per_channel=*, size_t num_channels=*) except *
    cpdef void create_from_file(self, bytes file_path, bint flip_x=*, bint flip_y=*, bint premultiply_alpha=*) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, uint8_t[::1] data=*) except *
    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *
    cpdef uint8_t[::1] get_data(self) except *