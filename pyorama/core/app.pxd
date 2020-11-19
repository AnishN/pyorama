from cpython.exc cimport PyErr_CheckSignals
from pyorama.event cimport *
from pyorama.graphics cimport *
from pyorama.physics.physics_manager cimport *
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
        readonly GraphicsManager graphics
        readonly EventManager event
        readonly PhysicsManager physics
    
    cdef double c_get_current_time(self) nogil