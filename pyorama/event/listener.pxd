from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF, Py_XINCREF, Py_XDECREF 
from pyorama.app cimport *
from pyorama.data.handle cimport *
from pyorama.data.vector cimport *

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

cdef class Listener(HandleObject):
    cdef ListenerC *get_ptr(self) except *
    cpdef void create(self, bytes event_type_name, object callback, list args=*, dict kwargs=*) except *
    cpdef void delete(self) except *