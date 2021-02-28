from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.program_enums cimport *

ctypedef struct UniformFormatC:
    Handle handle
    char[256] name
    size_t name_length
    UniformType type
    size_t count
    size_t size

cdef size_t c_uniform_type_get_size(UniformType type) nogil

cdef class UniformFormat:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef UniformFormatC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef UniformFormatC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef UniformFormatC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, bytes name, UniformType type, size_t count=*) except *
    cpdef void delete(self) except *