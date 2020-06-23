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
    
    cdef ListenerKeyC *key_get_ptr(self, Handle listener) except *
    cdef ListenerC *listener_get_ptr(self, Handle listener) except *
    cpdef Handle listener_create(self, uint16_t event_type, object callback, list args=*, dict kwargs=*) except *
    cpdef void listener_delete(self, Handle listener) except *
    cdef dict parse_keyboard_event(self, SDL_KeyboardEvent event)
    cdef dict parse_mouse_button_event(self, SDL_MouseButtonEvent event)
    cdef dict parse_mouse_motion_event(self, SDL_MouseMotionEvent event)
    cdef dict parse_mouse_wheel_event(self, SDL_MouseWheelEvent event)
    cdef dict parse_user_event(self, SDL_UserEvent event)
    cdef dict parse_window_event(self, SDL_WindowEvent event)
    cpdef void update(self, double timestamp) except *