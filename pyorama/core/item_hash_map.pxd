cimport cython
from pyorama.libs.c cimport *

@cython.final
cdef class ItemHashMap:
    cdef dict hash_map

    cdef void c_append(self, bytes key, uint64_t value) except *
    cdef void c_remove(self, bytes key) except *
    cdef uint64_t c_get(self, bytes key) except *
    cdef bint c_contains(self, bytes key)