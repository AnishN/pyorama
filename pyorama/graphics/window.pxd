from pyorama.app cimport *
from pyorama.core.handle cimport *
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

cpdef enum WindowFlags:
    WINDOW_FLAGS_FULLSCREEN = SDL_WINDOW_FULLSCREEN
    WINDOW_FLAGS_FULLSCREEN_DESKTOP = SDL_WINDOW_FULLSCREEN_DESKTOP
    #SDL_WINDOW_OPENGL (not needed since only bgfx is being used)
    #SDL_WINDOW_VULKAN (not needed since only bgfx is being used)
    WINDOW_FLAGS_SHOWN = SDL_WINDOW_SHOWN
    WINDOW_FLAGS_HIDDEN = SDL_WINDOW_HIDDEN
    WINDOW_FLAGS_BORDERLESS = SDL_WINDOW_BORDERLESS
    WINDOW_FLAGS_RESIZABLE = SDL_WINDOW_RESIZABLE
    WINDOW_FLAGS_MINIMIZED = SDL_WINDOW_MINIMIZED
    WINDOW_FLAGS_MAXIMIZED = SDL_WINDOW_MAXIMIZED
    WINDOW_FLAGS_INPUT_GRABBED = SDL_WINDOW_INPUT_GRABBED
    #WINDOW_FLAGS_INPUT_FOCUS = SDL_WINDOW_INPUT_FOCUS (cannot cleanly toggle and too new/buggy)
    #WINDOW_FLAGS_MOUSE_FOCUS = SDL_WINDOW_MOUSE_FOCUS (cannot cleanly toggle and too new/buggy)
    #SDL_WINDOW_FOREIGN (not needed since sdl2 is creating)
    #SDL_WINDOW_ALLOW_HIGHDPI (not truly cross-platform yet, ios/osx only)
    WINDOW_FLAGS_MOUSE_CAPTURED = SDL_WINDOW_MOUSE_CAPTURE
    #SDL_WINDOW_ALWAYS_ON_TOP (x11 only)
    #SDL_WINDOW_SKIP_TASKBAR (x11 only)
    #SDL_WINDOW_UTILITY (x11 only)
    #SDL_WINDOW_TOOLTIP (x11 only)
    #SDL_WINDOW_POPUP_MENU (x11 only)

cdef WindowC *c_window_get_ptr(Handle handle) except *
cdef Handle c_window_create() except *
cdef void c_window_delete(Handle handle) except *

cdef class Window(HandleObject):
    @staticmethod
    cdef Window c_from_handle(Handle handle)
    cdef WindowC *c_get_ptr(self) except *
    cpdef void create(self, uint16_t width, uint16_t height, bytes title, uint32_t flags=*) except *
    cpdef void load_from_id(self, uint32_t id_) except *
    cpdef void delete(self) except *
    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *
    cpdef tuple get_size(self)
    cpdef bytes get_title(self)
    cpdef uint32_t get_flags(self) except *
    cpdef uint64_t get_id(self) except *
    cpdef bint is_fullscreen(self) except *
    cpdef bint is_fullscreen_desktop(self) except *
    cpdef bint is_shown(self) except *
    cpdef bint is_hidden(self) except *
    cpdef bint is_borderless(self) except *
    cpdef bint is_resizable(self) except *
    cpdef bint is_minimized(self) except *
    cpdef bint is_maximized(self) except *
    cpdef bint is_input_grabbed(self) except *
    cpdef bint is_mouse_captured(self) except *
    cpdef void set_width(self, uint16_t width) except *
    cpdef void set_height(self, uint16_t height) except *
    cpdef void set_size(self, uint16_t width, uint16_t height) except *
    cpdef void set_title(self, bytes title) except *
    cpdef void set_flags(self, uint32_t flags) except *
    cpdef void set_fullscreen(self) except *
    cpdef void set_fullscreen_desktop(self) except *
    cpdef void set_shown(self) except *
    cpdef void set_hidden(self) except *
    cpdef void set_borderless(self, bint borderless) except *
    cpdef void set_resizable(self, bint resizable) except *
    cpdef void set_minimized(self) except *
    cpdef void set_maximized(self) except *
    cpdef void set_restored(self) except *
    cpdef void toggle_fullscreen(self) except *
    cpdef void toggle_fullscreen_desktop(self) except *
    cpdef void toggle_shown(self) except *
    cpdef void toggle_hidden(self) except *
    cpdef void toggle_borderless(self) except *
    cpdef void toggle_resizable(self) except *
    cpdef void toggle_minimized(self) except *
    cpdef void toggle_maximized(self) except *