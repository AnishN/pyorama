from pyorama.core.error cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *
from pyorama.libs.xxhash cimport *

"""
This is a (less) faster alternative to dict. It makes several optimizations/assumptions:
* Forces keys to be char * with specified length and values to be of uint64_t type (or something that can be cast to it...)
* Uses open addressing rather than chaining (to avoid linked list traversal)
* Requires comparision by hashed_key value, then by key_len, and then by key memcmp (so matches are more expensive).
* Given that Vector only uses power-of-two sizes, replaced expensive modulo (%) with bitwise and (&) operation
* Robin hood hashing was attempted previously
    * But in combination with backwards shifting was slower on insert/delete
    * Equivalent on get (maybe slightly faster)
"""

ctypedef struct StrHashMapC:
    VectorC items
    size_t num_items

ctypedef struct StrHashMapItemC:
    char *key
    size_t key_len
    uint64_t hashed_key
    uint64_t value
    bint used

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