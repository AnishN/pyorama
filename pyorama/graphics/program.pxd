from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *

cdef class Program:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle
    
    @staticmethod
    cdef ProgramC *c_get_ptr(GraphicsManager graphics, Handle program) nogil
    cdef ProgramC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(GraphicsManager graphics, Handle program, Handle vertex_shader, Handle fragment_shader) nogil

    @staticmethod
    cdef void c_clear(GraphicsManager graphics, Handle program) nogil

    @staticmethod
    cdef bint c_compile(GraphicsManager graphics, Handle program) nogil