from pyorama.app cimport *
from pyorama.data.handle cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct WindowC:
    Handle handle
    SDL_Window *sdl_ptr
    uint64_t sdl_id
    uint16_t width
    uint16_t height
    char[256] title
    size_t title_length
    uint32_t flags

cdef WindowC *window_get_ptr(Handle window) except *
cpdef Handle window_create(uint16_t width, uint16_t height, bytes title) except *
cpdef void window_delete(Handle window) except *
#cpdef void window_load_from_id(Handle window, uint64_t window_id) except *

cpdef uint16_t window_get_width(Handle window) except *
cpdef uint16_t window_get_height(Handle window) except *
cpdef tuple window_get_size(Handle window)
cpdef bytes window_get_title(Handle window)
cpdef uint32_t window_get_flags(Handle window) except *
cpdef uint64_t window_get_id(Handle window) except *

cpdef void window_set_width(Handle window, uint16_t width) except *
cpdef void window_set_height(Handle window, uint16_t height) except *
cpdef void window_set_size(Handle window, uint16_t width, uint16_t height) except *
cpdef void window_set_title(Handle window, bytes title) except *
cpdef void window_set_flags(Handle window, uint32_t flags) except *