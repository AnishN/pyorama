from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.core.slot_manager cimport *
from pyorama.data.vector cimport *
from pyorama.event.listener cimport *
from pyorama.event.input_events cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.sdl2 cimport *

cpdef enum EventSlot:
    EVENT_SLOT_LISTENER

cpdef enum EventItemType:
    EVENT_ITEM_TYPE_LISTENER_KEY

cpdef enum:
    MAX_EVENT_TYPES = 65536

ctypedef void (*EventFuncC)(uint16_t, SDL_Event *, PyObject *)

cdef class EventSystem:
    cdef:
        str name
        double timestamp
        SlotManager slots
        dict slot_sizes
        VectorC listener_handles[MAX_EVENT_TYPES]
        #SlotMap listener_keys
        #PyObject *listeners[65536]
        #bint registered_listeners[65536]
        SDL_Joystick *joysticks[65536]
        IntHashMapC c_event_funcs
        dict py_event_funcs
    
    #cpdef uint16_t event_type_register(self) except *#cannot unregister event types
    #cpdef bint event_type_check_registered_listeners(self, uint16_t event_type) except *

    cpdef uint16_t event_type_register(self) except *
    cpdef void py_event_type_bind(self, uint16_t event_type, object func_obj) except *
    cdef void c_event_type_bind(self, uint16_t event_type, EventFuncC func_ptr) except *
    #cdef event_type_register_bind(self, object parse_func) except *

    cpdef void event_type_emit(self, uint16_t event_type, dict event_data=*) except *
    
    #cdef ListenerKeyC *key_c_get_ptr(self, Handle listener) except *
    #cdef ListenerC *listener_c_get_ptr(self, Handle listener) except *
    cpdef void update(self, double timestamp) except *