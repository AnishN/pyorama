from pyorama.event.event_manager cimport *

cdef class Listener:
    cdef:
        readonly Handle handle
        readonly EventManager event

    cdef ListenerC *c_get_ptr(self) except *
    cpdef void create(self, uint16_t event_type, object callback, list args=*, dict kwargs=*) except *
    cpdef void delete(self) except *