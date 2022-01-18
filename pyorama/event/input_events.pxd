from pyorama.libs.c cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.event.event_system cimport *

cpdef enum JoystickHat:
    JOYSTICK_HAT_CENTERED = SDL_HAT_CENTERED
    JOYSTICK_HAT_UP = SDL_HAT_UP
    JOYSTICK_HAT_RIGHT = SDL_HAT_RIGHT
    JOYSTICK_HAT_DOWN = SDL_HAT_DOWN
    JOYSTICK_HAT_LEFT = SDL_HAT_LEFT
    JOYSTICK_HAT_RIGHT_UP = SDL_HAT_RIGHT | SDL_HAT_UP
    JOYSTICK_HAT_RIGHT_DOWN = SDL_HAT_RIGHT | SDL_HAT_DOWN
    JOYSTICK_HAT_LEFT_UP = SDL_HAT_LEFT | SDL_HAT_UP
    JOYSTICK_HAT_LEFT_DOWN = SDL_HAT_LEFT | SDL_HAT_DOWN

cpdef enum JoystickButtonState:
    JOYSTICK_BUTTON_STATE_PRESSED = SDL_PRESSED
    JOYSTICK_BUTTON_STATE_RELEASED = SDL_RELEASED

cdef void c_joystick_axis_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_ball_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_hat_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_button_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_joystick_device_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_keyboard_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_mouse_button_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_mouse_motion_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *
cdef void c_mouse_wheel_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *