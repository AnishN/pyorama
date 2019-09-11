from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.sdl2 cimport *

cdef class Window:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle
    
    @staticmethod
    cdef WindowC *c_get_ptr(GraphicsManager graphics, Handle window) nogil
    cdef WindowC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(GraphicsManager graphics, Handle window, size_t width, size_t height, char *title, size_t title_len) nogil

    @staticmethod
    cdef void c_clear(GraphicsManager graphics, Handle window) nogil

    @staticmethod
    cdef void c_bind(GraphicsManager graphics, Handle window) nogil
        
    @staticmethod
    cdef void c_unbind(GraphicsManager graphics, Handle window) nogil

    @staticmethod
    cdef void c_swap_buffers(GraphicsManager graphics, Handle window) nogil