from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.uniform_format cimport *

cdef class Uniform:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef UniformC *get_ptr(self) except *
    cpdef void create(self, UniformFormat format) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, object data, size_t index=*) except *