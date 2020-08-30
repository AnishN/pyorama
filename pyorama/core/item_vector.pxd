cimport cython
from pyorama.libs.c cimport *

@cython.final
cdef class ItemVector:
    cdef:
        char *items
        size_t max_items
        size_t item_size
        size_t num_items
    
    cdef void c_push_empty(self) except *
    cdef void c_pop_empty(self) except *
    cdef void c_push(self, void *item) except *
    cdef void c_pop(self, void *item) except *
    cdef void *c_get_ptr(self, size_t index) except *
    cdef void c_get(self, size_t index, void *item) except *
    cdef void c_set(self, size_t index, void *item) except *
    cdef void c_clear(self, size_t index) except *
    cdef void c_clear_all(self) nogil
    cdef void c_swap(self, size_t a, size_t b) except *
    cdef void c_resize(self, size_t new_max_items) except *
    cdef void c_grow_if_needed(self) except *
    cdef void c_shrink_if_needed(self) except *
    cdef void c_insert_empty(self, size_t index) except *
    cdef void c_insert(self, size_t index, void *item) except *
    cdef void c_remove_empty(self, size_t index) except *
    cdef void c_remove(self, size_t index, void *item) except *