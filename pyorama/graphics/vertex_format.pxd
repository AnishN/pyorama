from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.buffer_enums cimport *

ctypedef struct VertexCompC:
    Handle handle
    char[256] name
    size_t name_length
    VertexCompType type
    size_t count
    bint normalized
    size_t offset

ctypedef struct VertexFormatC:
    Handle handle
    VertexCompC[16] comps
    size_t count
    size_t stride

cdef class VertexFormat:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef VertexFormatC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef VertexFormatC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef VertexFormatC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, list comps) except *
    cpdef void delete(self) except *