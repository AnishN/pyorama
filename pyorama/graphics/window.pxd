from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.texture cimport *
from pyorama.libs.sdl2 cimport *

ctypedef struct WindowC:
    Handle handle
    SDL_Window *sdl_ptr
    uint16_t width
    uint16_t height
    char[256] title
    size_t title_length
    Handle texture

cdef class Window:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef WindowC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, uint16_t width, uint16_t height, bytes title) except *
    cpdef void delete(self) except *
    cpdef void set_texture(self, Texture texture) except *
    cpdef void clear(self) except *
    cpdef void render(self) except *
    cpdef void set_title(self, bytes title) except *