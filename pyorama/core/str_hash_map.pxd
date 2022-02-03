from pyorama.core.error cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *
from pyorama.libs.xxhash cimport *

ctypedef struct StrHashMapC:
    VectorC items
    size_t num_items

ctypedef struct StrHashMapItemC:
    char *key
    size_t key_len
    uint64_t hashed_key
    uint64_t value
    bint used

#internal convenience function
cdef bint item_match(StrHashMapItemC *item_ptr, char *key, size_t key_len, uint64_t hashed_key) nogil
cdef void item_set(StrHashMapItemC *item_ptr, char *key, size_t key_len, uint64_t hashed_key, uint64_t value, bint used) nogil

cdef Error str_hash_map_init(StrHashMapC *hash_map) nogil
cdef void str_hash_map_free(StrHashMapC *hash_map) nogil
cdef void str_hash_map_insert(StrHashMapC *hash_map, char *key, size_t key_len, uint64_t value) nogil
cdef void str_hash_map_remove(StrHashMapC *hash_map, char *key, size_t key_len) nogil
cdef uint64_t str_hash_map_get(StrHashMapC *hash_map, char *key, size_t key_len) nogil
cdef Error str_hash_map_get_index(StrHashMapC *hash_map, char *key, size_t key_len, size_t *index_ptr) nogil
cdef uint64_t str_hash_map_hash(char *key, size_t key_len) nogil
cdef bint str_hash_map_contains(StrHashMapC *hash_map, char *key, size_t key_len) nogil
cdef void str_hash_map_grow_if_needed(StrHashMapC *hash_map) nogil
cdef void str_hash_map_shrink_if_needed(StrHashMapC *hash_map) nogil
cdef Error str_hash_map_resize(StrHashMapC *hash_map, size_t new_max_items) nogil
cdef Error str_hash_map_extend(StrHashMapC *hash_map_a, StrHashMapC *hash_map_b, bint overwrite=*) nogil