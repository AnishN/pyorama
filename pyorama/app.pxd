from cpython.exc cimport PyErr_CheckSignals
from pyorama.debug_ui.debug_ui_system cimport *
from pyorama.event.event_system cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.asset.asset_system cimport *

cpdef enum PlatformOS:
    PLATFORM_OS_WINDOWS
    PLATFORM_OS_LINUX
    PLATFORM_OS_MACOS
    PLATFORM_OS_UNKNOWN

cdef:
    public GraphicsSystem graphics_system
    public EventSystem event_system
    public AssetSystem asset_system

cdef:
    PlatformOS platform_os
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
cdef PlatformOS c_get_platform_os() nogil