from pyorama.graphics.graphics_manager cimport *

ctypedef struct LightC:
    Handle handle

cdef class Light:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef LightC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *