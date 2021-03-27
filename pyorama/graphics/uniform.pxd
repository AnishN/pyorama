from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.uniform_format cimport *
from pyorama.graphics.program_enums cimport *

ctypedef struct UniformC:
    Handle handle
    Handle format
    uint8_t *data

cdef class Uniform:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    cdef UniformC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, UniformFormat format) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, object data, size_t index=*) except *