from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.core.slot_manager cimport *
from pyorama.data.vector cimport *
from pyorama.event.listener cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.sdl2 cimport *

cpdef enum EventSlot:
    EVENT_SLOT_LISTENER

cpdef enum EventItemType:
    EVENT_ITEM_TYPE_LISTENER_KEY

cpdef enum:
    MAX_EVENT_TYPES = 65536

#maps to uint16_t (looking at SDL_LASTEVENT = 0xFFFF = 65535)
#Will use this to ensure value is within bounds
cpdef enum EventType:
    EVENT_TYPE_WINDOW = SDL_WINDOWEVENT
    EVENT_TYPE_KEY_DOWN = SDL_KEYDOWN
    EVENT_TYPE_KEY_UP = SDL_KEYUP
    EVENT_TYPE_MOUSE_MOTION = SDL_MOUSEMOTION
    EVENT_TYPE_MOUSE_BUTTON_DOWN = SDL_MOUSEBUTTONDOWN
    EVENT_TYPE_MOUSE_BUTTON_UP = SDL_MOUSEBUTTONUP
    EVENT_TYPE_MOUSE_WHEEL = SDL_MOUSEWHEEL

    EVENT_TYPE_JOYSTICK_AXIS = SDL_JOYAXISMOTION
    EVENT_TYPE_JOYSTICK_BALL = SDL_JOYBALLMOTION
    EVENT_TYPE_JOYSTICK_HAT = SDL_JOYHATMOTION
    EVENT_TYPE_JOYSTICK_BUTTON_DOWN = SDL_JOYBUTTONDOWN
    EVENT_TYPE_JOYSTICK_BUTTON_UP = SDL_JOYBUTTONUP
    EVENT_TYPE_JOYSTICK_ADDED = SDL_JOYDEVICEADDED
    EVENT_TYPE_JOYSTICK_REMOVED = SDL_JOYDEVICEREMOVED

    #Non-SDL2 EventTypes
    EVENT_TYPE_ENTER_FRAME = SDL_USEREVENT#0x8000 (32768)
    EVENT_TYPE_USER = SDL_USEREVENT + 1024#reserve some EventType slots for pyorama
    EVENT_TYPE_LAST = SDL_LASTEVENT

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

cpdef enum WindowEventType:
    WINDOW_EVENT_TYPE_SHOWN = SDL_WINDOWEVENT_SHOWN
    WINDOW_EVENT_TYPE_HIDDEN = SDL_WINDOWEVENT_HIDDEN
    WINDOW_EVENT_TYPE_EXPOSED = SDL_WINDOWEVENT_EXPOSED
    WINDOW_EVENT_TYPE_MOVED = SDL_WINDOWEVENT_MOVED
    WINDOW_EVENT_TYPE_RESIZED = SDL_WINDOWEVENT_RESIZED
    WINDOW_EVENT_TYPE_SIZE_CHANGED = SDL_WINDOWEVENT_SIZE_CHANGED
    WINDOW_EVENT_TYPE_MINIMIZED = SDL_WINDOWEVENT_MINIMIZED
    WINDOW_EVENT_TYPE_MAXIMIZED = SDL_WINDOWEVENT_MAXIMIZED
    WINDOW_EVENT_TYPE_RESTORED = SDL_WINDOWEVENT_RESTORED
    WINDOW_EVENT_TYPE_ENTER = SDL_WINDOWEVENT_ENTER
    WINDOW_EVENT_TYPE_LEAVE = SDL_WINDOWEVENT_LEAVE
    WINDOW_EVENT_TYPE_FOCUS_GAINED = SDL_WINDOWEVENT_FOCUS_GAINED
    WINDOW_EVENT_TYPE_FOUCS_LOST = SDL_WINDOWEVENT_FOCUS_LOST
    WINDOW_EVENT_TYPE_CLOSE = SDL_WINDOWEVENT_CLOSE
    WINDOW_EVENT_TYPE_TAKE_FOCUS = SDL_WINDOWEVENT_TAKE_FOCUS
    WINDOW_EVENT_TYPE_HIT_TEST = SDL_WINDOWEVENT_HIT_TEST

cdef class EventSystem:
    cdef:
        double timestamp
        SlotManager slots
        dict slot_sizes
        PyObject *listener_handles[MAX_EVENT_TYPES]
        #SlotMap listener_keys
        #PyObject *listeners[65536]
        #bint registered_listeners[65536]
        #SDL_Joystick *joysticks[65536]
    
    #cpdef uint16_t event_type_register(self) except *#cannot unregister event types
    #cpdef bint event_type_check_registered_listeners(self, uint16_t event_type) except *
    #cpdef void event_type_emit(self, uint16_t event_type, dict event_data=*) except *
    
    #cdef ListenerKeyC *key_c_get_ptr(self, Handle listener) except *
    #cdef ListenerC *listener_c_get_ptr(self, Handle listener) except *

    #cdef dict parse_joystick_axis_event(self, SDL_JoyAxisEvent event)
    #cdef dict parse_joystick_ball_event(self, SDL_JoyBallEvent event)
    #cdef dict parse_joystick_hat_event(self, SDL_JoyHatEvent event)
    #cdef dict parse_joystick_button_event(self, SDL_JoyButtonEvent event)
    #cdef dict parse_joystick_device_event(self, SDL_JoyDeviceEvent event)
    #cdef dict parse_keyboard_event(self, SDL_KeyboardEvent event)
    #cdef dict parse_mouse_button_event(self, SDL_MouseButtonEvent event)
    #cdef dict parse_mouse_motion_event(self, SDL_MouseMotionEvent event)
    #cdef dict parse_mouse_wheel_event(self, SDL_MouseWheelEvent event)
    #cdef dict parse_user_event(self, SDL_UserEvent event)
    cdef dict parse_window_event(self, SDL_WindowEvent event)

    cpdef void update(self, double timestamp) except *