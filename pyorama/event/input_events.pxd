from pyorama.libs.c cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.event.event_system cimport *

cdef void c_joystick_axis_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_ball_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_hat_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_button_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_device_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_keyboard_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_mouse_button_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_mouse_motion_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_mouse_wheel_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *