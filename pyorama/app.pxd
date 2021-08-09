from cpython.exc cimport PyErr_CheckSignals
from pyorama.event.event_system cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.core.user_system cimport *

cdef:
    public GraphicsSystem graphics
    public UserSystem audio
    public EventSystem event
    public UserSystem physics

    int target_fps
    size_t num_frame_times
    size_t frame_count
    bint use_vsync
    bint use_sleep
    bint running
    list frame_times
    int frequency
    double start_time
    double curr_time
    double prev_time

cdef double c_get_current_time() nogil