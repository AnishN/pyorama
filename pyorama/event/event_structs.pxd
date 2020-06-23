from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF 
from pyorama.core.handle cimport *
from pyorama.libs.c cimport *

ctypedef struct ListenerKeyC:
    Handle handle
    uint16_t event_type
    size_t index

ctypedef struct ListenerC:
    Handle key
    PyObject *callback
    PyObject *args
    PyObject *kwargs