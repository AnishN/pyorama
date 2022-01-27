from pyorama.core.error cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *

"""
This is a faster alternative to dict. It makes several optimizations/assumptions:
* Forces keys and values to be of uint64_t type (or something that can be cast to it...)
* Uses open addressing rather than chaining (to avoid linked list traversal)
* Only compares by key (not hashed_key) since keys are just uint64_t as well (saves extra check)
* Given that Vector only uses power-of-two sizes, replaced expensive modulo (%) with bitwise and (&) operation
* Robin hood hashing was attempted previously
    * But in combination with backwards shifting was slower on insert/delete
    * Equivalent on get (maybe slightly faster)
"""

ctypedef struct IntHashMapC:
    VectorC items
    size_t num_items

cdef Error int_hash_map_init(IntHashMapC *hash_map) nogil
cdef void int_hash_map_free(IntHashMapC *hash_map) nogil
cdef void int_hash_map_insert(IntHashMapC *hash_map, uint64_t key, uint64_t value) nogil
cdef void int_hash_map_remove(IntHashMapC *hash_map, uint64_t key) nogil
cdef uint64_t int_hash_map_get(IntHashMapC *hash_map, uint64_t key) nogil
cdef Error int_hash_map_get_index(IntHashMapC *hash_map, uint64_t key, size_t *index_ptr) nogil
cdef uint64_t int_hash_map_hash(uint64_t key) nogil
cdef bint int_hash_map_contains(IntHashMapC *hash_map, uint64_t key) nogil
cdef void int_hash_map_grow_if_needed(IntHashMapC *hash_map) nogil
cdef void int_hash_map_shrink_if_needed(IntHashMapC *hash_map) nogil
cdef Error int_hash_map_resize(IntHashMapC *hash_map, size_t new_max_items) nogil