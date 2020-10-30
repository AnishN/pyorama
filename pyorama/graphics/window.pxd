from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.sdl2 cimport *

cdef class Window:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef WindowC *get_ptr(self) except *
    cpdef void create(self, uint16_t width, uint16_t height, bytes title) except *
    cpdef void delete(self) except *
    cpdef void set_texture(self, Handle texture) except *
    cpdef void clear(self) except *
    cpdef void render(self) except *
    cpdef void set_title(self, bytes title) except *