from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.app cimport *
from pyorama.data.handle cimport *

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

"""
cdef class Listener:
    cdef:
        readonly Handle handle

    cdef ListenerC *c_get_ptr(self) except *
    cpdef void create(self, uint16_t event_type, object callback, list args=*, dict kwargs=*) except *
    cpdef void delete(self) except *
"""

cdef ListenerC *listener_get_ptr(Handle listener) except *
cpdef Handle listener_create(uint16_t event_type, object callback, list args=*, dict kwargs=*) except *
cpdef void listener_delete(Handle listener) except *