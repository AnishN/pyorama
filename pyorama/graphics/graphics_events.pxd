from pyorama.libs.c cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.event.event_system cimport *

cdef void c_window_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_enter_frame_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *