from pyorama.graphics.graphics_manager cimport *

ctypedef struct RenderPassC:
    Handle handle
    Handle view

cdef class RenderPass:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef RenderPassC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef RenderPassC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef RenderPassC *get_ptr(self) except *
    
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *