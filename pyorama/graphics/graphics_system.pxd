from pyorama.core.slot_manager cimport *
from pyorama.data.hash_map cimport *
from pyorama.data.vector cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.graphics.view cimport *
from pyorama.graphics.window cimport *
from pyorama.graphics.frame_buffer cimport *

DEF GRAPHICS_MAX_VIEWS = 2**16

cpdef enum GraphicsSlot:
    GRAPHICS_SLOT_WINDOW
    GRAPHICS_SLOT_FRAME_BUFFER
    GRAPHICS_SLOT_VIEW

cdef class GraphicsSystem:
    cdef:
        str name
        SlotManager slots
        dict slot_sizes
        SDL_Window *root_window
        uint64_t root_window_id
        SDL_SysWMinfo *wmi
        bint[GRAPHICS_MAX_VIEWS] used_views
        uint16_t[GRAPHICS_MAX_VIEWS] free_views
        size_t free_view_index
        HashMap window_ids

    cdef void c_init_sdl2(self) except *
    cdef void c_quit_sdl2(self) except *
    cdef void c_init_bgfx(self) except *
    cdef void c_quit_bgfx(self) except *
    cdef uint16_t c_get_next_view_index(self) except *
    cdef void c_swap_root_window(self, bint use_vsync) except *