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

TODO: Robin Hood Hashing!!!
"""

#Internal struct
ctypedef struct ItemC:
    uint64_t key
    uint64_t hashed_key#Not needed for comparisons
    uint64_t value
    bint used
    size_t probe_length#Needed for Robin Hood Hashing

@cython.final
cdef class ItemHashMap:
    cdef:
        ItemVector items
        size_t num_items
        size_t max_probe_length

    cdef inline void c_insert(self, uint64_t key, uint64_t value) except *
    cdef inline void c_remove(self, uint64_t key) except *
    cdef inline uint64_t c_get(self, uint64_t key) except *
    cdef inline size_t c_get_index(self, uint64_t key) except *
    cdef inline uint64_t c_hash(self, uint64_t key) nogil
    cdef inline bint c_contains(self, uint64_t key) nogil
    cdef inline void c_grow_if_needed(self) except *
    cdef inline void c_shrink_if_needed(self) except *
    cdef inline void c_resize(self, size_t new_max_items) except *