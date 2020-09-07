cimport cython
from pyorama.libs.c cimport *

@cython.final
cdef class ItemArray:
    cdef:
        char *items
        size_t max_items
        size_t item_size

    cdef void *c_get_ptr(self, size_t index) except *
    cdef void c_get(self, size_t index, void *item) except *
    cdef void c_set(self, size_t index, void *item) except *
    cdef void c_clear(self, size_t index) except *
    cdef void c_clear_all(self) except *
    cdef void c_swap(self, size_t a, size_t b) except *