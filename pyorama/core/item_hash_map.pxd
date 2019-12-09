cimport cython
from pyorama.libs.c cimport *
from pyorama.core.item_vector cimport *

ctypedef struct PairC:
    char *key
    size_t key_length
    uint32_t key_hash
    uint64_t value

@cython.final
cdef class ItemHashMap:
    cdef:
        ItemVector pairs
        size_t max_items
        size_t num_items
        size_t item_size

    cdef char *c_get_key_data(self, bytes key) nogil
    cdef uint64_t c_get_key_length(self, bytes key) nogil
    cdef uint32_t c_get_key_hash(self, bytes key) nogil
    cdef void c_append(self, bytes key, uint64_t value) except *
    cdef void _c_insert(self, PairC *pair) nogil#private
    cdef void _c_resize(self, size_t new_max_items)#private
    cdef PairC *_c_get_pair(self, bytes key)#private
    cdef void c_remove(self, bytes key) except *
    cdef uint64_t c_get(self, bytes key) except *
    cdef void c_set(self, bytes key, uint64_t value) except *
    cdef bint c_contains(self, bytes key) nogil