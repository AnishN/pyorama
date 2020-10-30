from pyorama.graphics.graphics_manager cimport *

cdef class UniformFormat:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef UniformFormatC *get_ptr(self) except *
    cpdef void create(self, bytes name, UniformType type, size_t count=*) except *
    cpdef void delete(self) except *