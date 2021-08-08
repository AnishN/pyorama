from pyorama.app cimport *
from pyorama.data.handle cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.graphics.frame_buffer cimport *

ctypedef struct WindowC:
    Handle handle
    SDL_Window *sdl_ptr
    uint16_t width
    uint16_t height
    char[256] title
    size_t title_length
    uint32_t flags
    Handle fbo

cdef class Window:
    cdef:
        readonly Handle handle
    
    cdef WindowC *c_get_ptr(self) except *
    cpdef void create(self, uint16_t width, uint16_t height, bytes title) except *
    cpdef void delete(self) except *
    cpdef void load_from_id(self, uint64_t window_id) except *

    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *
    cpdef tuple get_size(self)
    cpdef bytes get_title(self)
    cpdef uint32_t get_flags(self) except *
    cpdef void get_frame_buffer(self, FrameBuffer fbo) except *

    cpdef void set_width(self, uint16_t width) except *
    cpdef void set_height(self, uint16_t height) except *
    cpdef void set_size(self, uint16_t width, uint16_t height) except *
    cpdef void set_title(self, bytes title) except *
    cpdef void set_flags(self, uint32_t flags) except *