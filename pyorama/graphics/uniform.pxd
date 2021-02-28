from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.uniform_format cimport *

cdef class Uniform:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef UniformC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef UniformC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef UniformC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, UniformFormat format) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, object data, size_t index=*) except *