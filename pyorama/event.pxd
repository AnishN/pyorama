cimport cython
from cpython.ref cimport *
from pyorama.core.item cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.core.item_vector cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.keyboard cimport *

ctypedef struct ListenerC:
    EventTypes event_type
    size_t index
    PyObject *callback
    PyObject *user_data

ctypedef uint32_t EventType
cpdef enum EventTypes:
    EVENT_TYPE_NONE = 0
    EVENT_TYPE_WINDOW = SDL_WINDOWEVENT
    EVENT_TYPE_KEY_DOWN = SDL_KEYDOWN
    EVENT_TYPE_KEY_UP = SDL_KEYUP
    EVENT_TYPE_MOUSE_BUTTON_DOWN = SDL_MOUSEBUTTONDOWN
    EVENT_TYPE_MOUSE_BUTTON_UP = SDL_MOUSEBUTTONUP
    EVENT_TYPE_MOUSE_MOTION = SDL_MOUSEMOTION
    EVENT_TYPE_MOUSE_WHEEL = SDL_MOUSEWHEEL
    EVENT_TYPE_USER = SDL_USEREVENT

cpdef enum WindowEventTypes:
    WINDOW_EVENT_TYPE_SHOWN = SDL_WINDOWEVENT_SHOWN
    WINDOW_EVENT_TYPE_HIDDEN = SDL_WINDOWEVENT_HIDDEN
    WINDOW_EVENT_TYPE_EXPOSED = SDL_WINDOWEVENT_EXPOSED
    WINDOW_EVENT_TYPE_MOVED = SDL_WINDOWEVENT_MOVED
    WINDOW_EVENT_TYPE_RESIZED = SDL_WINDOWEVENT_RESIZED
    WINDOW_EVENT_TYPE_CHANGED = SDL_WINDOWEVENT_SIZE_CHANGED
    WINDOW_EVENT_TYPE_MINIMIZED = SDL_WINDOWEVENT_MINIMIZED
    WINDOW_EVENT_TYPE_MAXIMIZED = SDL_WINDOWEVENT_MAXIMIZED
    WINDOW_EVENT_TYPE_RESTORED = SDL_WINDOWEVENT_RESTORED
    WINDOW_EVENT_TYPE_ENTER = SDL_WINDOWEVENT_ENTER
    WINDOW_EVENT_TYPE_LEAVE = SDL_WINDOWEVENT_LEAVE
    WINDOW_EVENT_TYPE_FOCUS_GAINED = SDL_WINDOWEVENT_FOCUS_GAINED
    WINDOW_EVENT_TYPE_FOCUS_LOST = SDL_WINDOWEVENT_FOCUS_LOST
    WINDOW_EVENT_TYPE_CLOSE = SDL_WINDOWEVENT_CLOSE
    WINDOW_EVENT_TYPE_TAKE_FOCUS = SDL_WINDOWEVENT_TAKE_FOCUS
    WINDOW_EVENT_TYPE_HIT_TEST = SDL_WINDOWEVENT_HIT_TEST

@cython.final
cdef class EventManager:
    cdef dict listener_map
    cdef ItemSlotMap listeners
    cdef size_t num_user_event_types
    cdef ItemVector free_user_event_types

    cdef void c_check_user_event_type(self, EventType event_type) except *
    cdef dict c_parse_window_event(self, SDL_WindowEvent *event, double time_stamp)
    cdef dict c_parse_key_down_event(self, SDL_KeyboardEvent *event, double time_stamp)
    cdef dict c_parse_key_up_event(self, SDL_KeyboardEvent *event, double time_stamp)
    cdef dict c_parse_mouse_button_down_event(self, SDL_MouseButtonEvent *event, double time_stamp)
    cdef dict c_parse_mouse_button_up_event(self, SDL_MouseButtonEvent *event, double time_stamp)
    cdef dict c_parse_mouse_motion_event(self, SDL_MouseMotionEvent *event, double time_stamp)
    cdef dict c_parse_mouse_wheel_event(self, SDL_MouseWheelEvent *event, double time_stamp)
    cdef dict c_parse_user_event(self, SDL_UserEvent *event, double time_stamp)
    #cdef dict listener_types#maps listener Handles to EventTypes
    cdef ListenerC *c_listener_get_ptr(self, Handle listener) except *