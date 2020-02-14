cimport cython
from pyorama.core.item_vector cimport *
from pyorama.libs.c cimport *

"""
Map uint64_t unhashed keys to uint64_t values allocated in array.
Instead of using string keys (which are slower to hash).
Hashing here purely ensures uniform distribution.
"""

@cython.final
cdef class ItemHashMap:
    cdef:
        ItemVector items
        size_t num_items

    cdef inline void c_insert(self, uint64_t key, uint64_t value) except *
    cdef inline void c_remove(self, uint64_t key) except *
    cdef inline uint64_t c_get(self, uint64_t key) except *
    cdef inline uint64_t c_hash(self, uint64_t key) nogil
    cdef inline bint c_contains(self, uint64_t key) nogil
    cdef inline void c_grow_if_needed(self) except *
    cdef inline void c_shrink_if_needed(self) except *
    cdef inline void c_resize(self, size_t new_max_items) except *