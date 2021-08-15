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

cdef WindowC *window_get_ptr(Handle window) except *
cpdef Handle window_create(uint16_t width, uint16_t height, bytes title, uint32_t flags=*) except *
cpdef void window_delete(Handle window) except *

cpdef uint16_t window_get_width(Handle window) except *
cpdef uint16_t window_get_height(Handle window) except *
cpdef tuple window_get_size(Handle window)
cpdef bytes window_get_title(Handle window)
cpdef uint32_t window_get_flags(Handle window) except *
cpdef uint64_t window_get_id(Handle window) except *

cpdef bint window_is_fullscreen(Handle window) except *
cpdef bint window_is_fullscreen_desktop(Handle window) except *
cpdef bint window_is_shown(Handle window) except *
cpdef bint window_is_hidden(Handle window) except *
cpdef bint window_is_borderless(Handle window) except *
cpdef bint window_is_resizable(Handle window) except *
cpdef bint window_is_minimized(Handle window) except *
cpdef bint window_is_maximized(Handle window) except *
cpdef bint window_is_input_grabbed(Handle window) except *
cpdef bint window_is_mouse_captured(Handle window) except *

cpdef void window_set_width(Handle window, uint16_t width) except *
cpdef void window_set_height(Handle window, uint16_t height) except *
cpdef void window_set_size(Handle window, uint16_t width, uint16_t height) except *
cpdef void window_set_title(Handle window, bytes title) except *
cpdef void window_set_flags(Handle window, uint32_t flags) except *

cpdef void window_set_fullscreen(Handle window) except *
cpdef void window_set_fullscreen_desktop(Handle window) except *
cpdef void window_set_shown(Handle window) except *
cpdef void window_set_hidden(Handle window) except *
cpdef void window_set_borderless(Handle window, bint borderless) except *
cpdef void window_set_resizable(Handle window, bint resizable) except *
cpdef void window_set_minimized(Handle window) except *
cpdef void window_set_maximized(Handle window) except *
cpdef void window_set_restored(Handle window) except *

cpdef void window_toggle_fullscreen(Handle window) except *
cpdef void window_toggle_fullscreen_desktop(Handle window) except *
cpdef void window_toggle_shown(Handle window) except *
cpdef void window_toggle_hidden(Handle window) except *
cpdef void window_toggle_borderless(Handle window) except *
cpdef void window_toggle_resizable(Handle window) except *
cpdef void window_toggle_minimized(Handle window) except *
cpdef void window_toggle_maximized(Handle window) except *