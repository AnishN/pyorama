from pyorama.libs.c cimport *
from pyorama.libs.gles2 cimport *
from pyorama.libs.sdl2 cimport *

cdef class App:
    cdef:
        readonly double ms_per_update
        double current_time
        double previous_time
        double accumulated_time
        double delta
        uint64_t frequency
        readonly bint is_running
        readonly bint use_vsync
        readonly bint use_sleep
    
    cdef double c_get_current_time(self) nogil
    