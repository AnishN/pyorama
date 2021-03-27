cimport cython
from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.core.handle cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.event.event_enums cimport *
from pyorama.event.event_structs cimport *
from pyorama.event.event_utils cimport *
from pyorama.libs.sdl2 cimport *

@cython.final
cdef class EventManager:
    cdef:
        double timestamp
        ItemSlotMap listener_keys
        PyObject *listeners[65536]
        bint registered[65536]
        SDL_Joystick *joysticks[65536]
    
    cpdef uint16_t event_type_register(self) except *#cannot unregister event types
    cpdef bint event_type_check_registered(self, uint16_t event_type) except *
    cpdef void event_type_emit(self, uint16_t event_type, dict event_data=*) except *
    
    cdef ListenerKeyC *key_c_get_ptr(self, Handle listener) except *
    cdef ListenerC *listener_c_get_ptr(self, Handle listener) except *

    cdef dict parse_joystick_axis_event(self, SDL_JoyAxisEvent event)
    cdef dict parse_joystick_ball_event(self, SDL_JoyBallEvent event)
    cdef dict parse_joystick_hat_event(self, SDL_JoyHatEvent event)
    cdef dict parse_joystick_button_event(self, SDL_JoyButtonEvent event)
    cdef dict parse_joystick_device_event(self, SDL_JoyDeviceEvent event)
    cdef dict parse_keyboard_event(self, SDL_KeyboardEvent event)
    cdef dict parse_mouse_button_event(self, SDL_MouseButtonEvent event)
    cdef dict parse_mouse_motion_event(self, SDL_MouseMotionEvent event)
    cdef dict parse_mouse_wheel_event(self, SDL_MouseWheelEvent event)
    cdef dict parse_user_event(self, SDL_UserEvent event)
    cdef dict parse_window_event(self, SDL_WindowEvent event)

    cpdef void update(self, double timestamp) except *