cimport cython
from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF 
from pyorama.libs.sdl2 cimport *

@cython.final
cdef class EventManager:
    cdef:
        double timestamp
        dict listeners#maps EventType to corresponding ItemSlotMap of added event listeners.
    
    cdef dict parse_keyboard_event(self, SDL_KeyboardEvent keyboard_event)
    cdef dict parse_mouse_button_event(self, SDL_MouseButtonEvent mouse_button_event)
    cdef dict parse_mouse_motion_event(self, SDL_MouseMotionEvent mouse_motion_event)
    cdef dict parse_mouse_wheel_event(self, SDL_MouseWheelEvent mouse_wheel_event)
    cdef dict parse_user_event(self, SDL_UserEvent user_event)
    cdef dict parse_window_event(self, SDL_WindowEvent window_event)
    cpdef void update(self, double timestamp) except *