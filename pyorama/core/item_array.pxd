from cython cimport view
from cpython.buffer cimport *
from pyorama.libs.c cimport *

ctypedef struct ItemArrayC:
    char *items
    size_t max_items
    size_t item_size

cdef void item_array_init(ItemArrayC *self, size_t item_size, size_t max_items) except *
cdef void item_array_free(ItemArrayC *self) nogil
cdef void item_array_get_ptr(ItemArrayC *self, size_t index, void **item_ptr) nogil
cdef void item_array_get(ItemArrayC *self, size_t index, void *item) nogil
cdef void item_array_set(ItemArrayC *self, size_t index, void *item) nogil
cdef void item_array_clear(ItemArrayC *self, size_t index) nogil
cdef void item_array_clear_all(ItemArrayC *self) nogil
cdef void item_array_swap(ItemArrayC *self, size_t a, size_t b) nogil