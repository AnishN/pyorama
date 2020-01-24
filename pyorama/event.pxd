cimport cython
from cpython.ref cimport *
from pyorama.core.item_slot_map cimport *

ctypedef struct ListenerC:
    PyObject *func
    PyObject *params

@cython.final
cdef class EventManager:
    cdef dict listeners