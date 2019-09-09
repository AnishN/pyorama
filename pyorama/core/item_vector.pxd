from cython cimport view
from cpython.buffer cimport *
from pyorama.libs.c cimport *

ctypedef struct ItemVectorC:
    char *items
    size_t max_items
    size_t item_size
    size_t num_items

cdef void item_vector_init(ItemVectorC *self, size_t item_size) except *
cdef void item_vector_free(ItemVectorC *self) nogil
cdef void item_vector_push_empty(ItemVectorC *self) except *
cdef void item_vector_pop_empty(ItemVectorC *self) except *
cdef void item_vector_push(ItemVectorC *self, void *item) except *
cdef void item_vector_pop(ItemVectorC *self, void *item) except *
cdef void item_vector_get_ptr(ItemVectorC *self, size_t index, void **item_ptr) nogil
cdef void item_vector_get(ItemVectorC *self, size_t index, void *item) nogil
cdef void item_vector_set(ItemVectorC *self, size_t index, void *item) nogil
cdef void item_vector_clear(ItemVectorC *self, size_t index) nogil
cdef void item_vector_clear_all(ItemVectorC *self) nogil
cdef void item_vector_swap(ItemVectorC *self, size_t a, size_t b) nogil
cdef void item_vector_resize(ItemVectorC *self, size_t new_max_items) except *