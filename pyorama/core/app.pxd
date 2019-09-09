from pyorama.libs.c cimport *
from pyorama.libs.gl cimport *
from pyorama.libs.sdl2 cimport *

cdef class App:
    cdef:
        double ms_per_update
        double current_time
        double previous_time
        double accumulated_time
        double delta
        uint64_t frequency
        bint is_running
        bint use_vsync
        bint use_sleep
        cdef SDL_Window *root_window
        cdef SDL_GLContext root_context
    
    cdef double c_get_current_time(self) nogil
    