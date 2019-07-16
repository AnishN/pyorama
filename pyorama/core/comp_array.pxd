from cython cimport view
from cpython.buffer cimport *
from pyorama.libs.c cimport *

cdef class CompArray:
    cdef:
        void *items
        size_t max_items
        size_t item_size
        bytes item_format
    
    cpdef void init(self, size_t max_items, size_t item_size, bytes item_format) except *
    cpdef void free(self)

    cdef void *c_get_ptr(self, size_t i=*) nogil
    cdef void c_get(self, size_t i, void *item) nogil
    cdef void c_set(self, size_t i, void *item) nogil
    cdef void c_swap(self, size_t a, size_t b) nogil
    cdef void c_clear(self, size_t i) nogil
    cdef void c_clear_all(self) nogil