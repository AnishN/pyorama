from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.shader cimport *

cdef class Program:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef ProgramC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef ProgramC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef ProgramC *get_ptr(self) except *

    cdef ProgramC *get_ptr(self) except *
    cpdef void create(self, Shader vertex, Shader fragment) except *
    cpdef void delete(self) except *
    cdef void _compile(self) except *
    cdef void _setup_attributes(self) except *
    cdef void _setup_uniforms(self) except *
    cdef void _bind_attributes(self, Handle buffer) except *
    cdef void _unbind_attributes(self) except *
    cdef void _bind_uniform(self, Handle uniform) except *