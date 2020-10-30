from pyorama.graphics.graphics_manager cimport *

cdef class VertexFormat:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef VertexFormatC *get_ptr(self) except *
    cpdef void create(self, list comps) except *
    cpdef void delete(self) except *