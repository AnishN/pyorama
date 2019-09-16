from pyorama.core.error cimport *
from pyorama.core.handle cimport *
from pyorama.core.item_vector cimport *
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
    cdef Error c_link(GraphicsManager graphics, Handle program) nogil

    @staticmethod
    cdef Error c_get_link_error(GraphicsManager graphics, Handle program, char **error, size_t *error_len) nogil

    @staticmethod
    cdef Error c_setup_attributes(GraphicsManager graphics, Handle program)# nogil

    @staticmethod
    cdef Error c_setup_uniforms(GraphicsManager graphics, Handle program)# nogil

    @staticmethod
    cdef void c_bind(GraphicsManager graphics, Handle program) nogil
        
    @staticmethod
    cdef void c_unbind(GraphicsManager graphics, Handle program) nogil