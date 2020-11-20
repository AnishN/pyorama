from cpython.exc cimport PyErr_CheckSignals
from pyorama.event cimport *
from pyorama.graphics cimport *
from pyorama.physics.physics_manager cimport *
from pyorama.libs.c cimport *
from pyorama.libs.gles2 cimport *
from pyorama.libs.sdl2 cimport *

cdef class App:
    cdef:
        int target_fps
        bint use_vsync
        bint use_sleep
        
        list frame_times
        int num_frame_times
        uint64_t frame_count
        double start_time
        double current_time
        double previous_time
        double timestamp
        uint64_t frequency
        readonly GraphicsManager graphics
        readonly EventManager event
        readonly PhysicsManager physics
    
    cdef double c_get_current_time(self) nogil
    cpdef double get_frame_time(self) except *
    cpdef double get_fps(self) except *
    cdef void c_swap_root_window(self) except *
    