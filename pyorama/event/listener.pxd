from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.app cimport *
from pyorama.core.handle cimport *
from pyorama.core.vector cimport *

ctypedef struct ListenerKeyC:
    Handle handle
    uint16_t event_type
    size_t index

ctypedef struct ListenerC:
    Handle key
    uint16_t event_type
    PyObject *callback
    PyObject *args
    PyObject *kwargs

cdef ListenerC *c_listener_get_ptr(Handle handle) except *
cdef Handle c_listener_create() except *
cdef void c_listener_delete(Handle handle) except *

cdef class Listener(HandleObject):
    @staticmethod
    cdef Listener c_from_handle(Handle handle)
    cdef ListenerC *c_get_ptr(self) except *
    cpdef void create(self, bytes event_type_name, object callback, list args=*, dict kwargs=*) except *
    cpdef void delete(self) except *