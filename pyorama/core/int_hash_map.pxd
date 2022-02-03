from pyorama.core.error cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *

ctypedef struct IntHashMapC:
    VectorC items
    size_t num_items

#Internal struct
ctypedef struct ItemC:
    uint64_t key
    uint64_t value
    bint used

cdef Error int_hash_map_init(IntHashMapC *hash_map) nogil
cdef void int_hash_map_free(IntHashMapC *hash_map) nogil
cdef Error int_hash_map_insert(IntHashMapC *hash_map, uint64_t key, uint64_t value) nogil
cdef Error int_hash_map_remove(IntHashMapC *hash_map, uint64_t key) nogil
cdef Error int_hash_map_get(IntHashMapC *hash_map, uint64_t key, uint64_t *value) nogil
cdef Error int_hash_map_get_index(IntHashMapC *hash_map, uint64_t key, size_t *index_ptr) nogil
cdef uint64_t int_hash_map_hash(uint64_t key) nogil
cdef bint int_hash_map_contains(IntHashMapC *hash_map, uint64_t key) nogil
cdef Error int_hash_map_grow_if_needed(IntHashMapC *hash_map) nogil
cdef Error int_hash_map_shrink_if_needed(IntHashMapC *hash_map) nogil
cdef Error int_hash_map_resize(IntHashMapC *hash_map, size_t new_max_items) nogil