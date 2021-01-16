from pyorama.graphics.graphics_manager cimport *

cdef class UniformFormat:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef UniformFormatC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef UniformFormatC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef UniformFormatC *get_ptr(self) except *
    cpdef void create(self, bytes name, UniformType type, size_t count=*) except *
    cpdef void delete(self) except *