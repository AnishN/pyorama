from cpython.exc cimport PyErr_CheckSignals
from pyorama.event.event_manager cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.c cimport *
from pyorama.libs.gles2 cimport *
from pyorama.libs.sdl2 cimport *

cdef class App:
    cdef:
        readonly double ms_per_update
        double start_time
        double current_time
        double previous_time
        double accumulated_time
        double delta
        double timestamp
        uint64_t frequency
        readonly bint is_running
        readonly GraphicsManager graphics
        readonly EventManager events
    
    cdef double c_get_current_time(self) nogil