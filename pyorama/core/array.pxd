from pyorama.libs.c cimport *
from pyorama.core.error cimport *

ctypedef struct ArrayC:
    uint8_t *items
    size_t max_items
    size_t item_size

cdef Error array_init(ArrayC *array, size_t item_size, size_t max_items) nogil
cdef void array_free(ArrayC *array) nogil
cdef void *array_c_get_ptr_unsafe(ArrayC *array, size_t index) nogil
cdef Error array_c_get_ptr(ArrayC *array, size_t index, void **item_ptr) nogil
cdef Error array_get(ArrayC *array, size_t index, void *item) nogil
cdef Error array_set(ArrayC *array, size_t index, void *item) nogil
cdef Error array_clear(ArrayC *array, size_t index) nogil
cdef void array_clear_all(ArrayC *array) nogil
cdef Error array_swap(ArrayC *array, size_t a, size_t b) nogil
cdef Error array_find(ArrayC *array, void *item, size_t *index) nogil
cdef bint array_contains(ArrayC *array, void *item) nogil