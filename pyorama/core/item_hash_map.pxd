cimport cython
from pyorama.core.item_vector cimport *
from pyorama.libs.c cimport *

"""
This is a faster alternative to dict. It makes several optimizations/assumptions:
* Inlines all functions (fairly negligible/dubious, may primarily help with the hash function call)
* Forces keys and values to be of uint64_t type (or something that can be cast to it...)
* Uses open addressing rather than chaining (to avoid linked list traversal)
* Only compares by key (not hashed_key) since keys are just uint64_t as well (saves extra check)
* Given that ItemVector only uses power-of-two sizes, replaced expensive modulo (%) with bitwise and (&) operation
* Robin hood hashing was attempted previously
    * But in combination with backwards shifting was slower on insert/delete
    * Equivalent on get (maybe slightly faster)
"""

@cython.final
cdef class ItemHashMap:
    cdef:
        ItemVector items
        size_t num_items

    cdef inline void c_insert(self, uint64_t key, uint64_t value) except *
    cdef inline void c_remove(self, uint64_t key) except *
    cdef inline uint64_t c_get(self, uint64_t key) except *
    cdef inline size_t c_get_index(self, uint64_t key) except *
    cdef inline uint64_t c_hash(self, uint64_t key) nogil
    cdef inline bint c_contains(self, uint64_t key) nogil
    cdef inline void c_grow_if_needed(self) except *
    cdef inline void c_shrink_if_needed(self) except *
    cdef inline void c_resize(self, size_t new_max_items) except *