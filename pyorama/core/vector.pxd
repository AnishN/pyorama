from pyorama.libs.c cimport *
from pyorama.core.error cimport *

ctypedef struct VectorC:
    uint8_t *items
    size_t max_items
    size_t item_size
    size_t num_items

cdef Error vector_init(VectorC *vector, size_t item_size) nogil
cdef void vector_free(VectorC *vector) nogil
cdef Error vector_push_empty(VectorC *vector) nogil
cdef Error vector_pop_empty(VectorC *vector) nogil
cdef Error vector_push(VectorC *vector, void *item) nogil
cdef Error vector_pop(VectorC *vector, void *item) nogil
cdef void *vector_get_ptr_unsafe(VectorC *vector, size_t index) nogil
cdef Error vector_get_ptr(VectorC *vector, size_t index, void **item_ptr) nogil
cdef Error vector_get(VectorC *vector, size_t index, void *item) nogil
cdef Error vector_set(VectorC *vector, size_t index, void *item) nogil
cdef Error vector_clear(VectorC *vector, size_t index) nogil
cdef void vector_clear_all(VectorC *vector) nogil
cdef Error vector_swap(VectorC *vector, size_t a, size_t b) nogil
cdef Error vector_resize(VectorC *vector, size_t new_max_items) nogil
cdef Error vector_grow_if_needed(VectorC *vector) nogil
cdef Error vector_shrink_if_needed(VectorC *vector) nogil
cdef Error vector_insert_empty(VectorC *vector, size_t index) nogil
cdef Error vector_insert(VectorC *vector, size_t index, void *item) nogil
cdef Error vector_remove_empty(VectorC *vector, size_t index) nogil
cdef Error vector_remove(VectorC *vector, size_t index, void *item) nogil
cdef Error vector_find(VectorC *vector, void *item, size_t *index) nogil
cdef bint vector_contains(VectorC *vector, void *item) nogil