from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.core.slot_manager cimport *
from pyorama.data.vector cimport *
from pyorama.data.str_hash_map cimport *
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
        char *event_type_names[MAX_EVENT_TYPES]
        StrHashMapC event_type_names_map
        SDL_Joystick *joysticks[65536]
        IntHashMapC c_event_funcs
        dict py_event_funcs
    
    cpdef void event_type_register(self, bytes name, uint16_t event_type=*) except *
    cpdef uint16_t event_type_get_id(self, bytes name) except *
    cpdef void py_event_type_bind(self, bytes name, object func_obj) except *
    cdef void c_event_type_bind(self, bytes name, EventFuncC func_ptr) except *
    cpdef void event_type_emit(self, bytes name, dict event_data=*) except *
    cpdef void update(self, double timestamp) except *