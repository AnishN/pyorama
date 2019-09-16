from cython cimport view
from cpython.buffer cimport *
from pyorama.core.error cimport *
from pyorama.libs.c cimport *

ctypedef struct ItemVectorC:
    char *items
    size_t max_items
    size_t item_size
    size_t num_items

cdef class ItemVector:

    @staticmethod
    cdef Error c_init(ItemVectorC *self, size_t item_size) nogil

    @staticmethod
    cdef void c_free(ItemVectorC *self) nogil

    @staticmethod
    cdef Error c_push_empty(ItemVectorC *self) nogil

    @staticmethod
    cdef Error c_pop_empty(ItemVectorC *self) nogil

    @staticmethod
    cdef Error c_push(ItemVectorC *self, void *item) nogil

    @staticmethod
    cdef Error c_pop(ItemVectorC *self, void *item) nogil

    @staticmethod
    cdef void c_get_ptr(ItemVectorC *self, size_t index, void **item_ptr) nogil

    @staticmethod
    cdef void c_get(ItemVectorC *self, size_t index, void *item) nogil

    @staticmethod
    cdef void c_set(ItemVectorC *self, size_t index, void *item) nogil

    @staticmethod
    cdef void c_clear(ItemVectorC *self, size_t index) nogil

    @staticmethod
    cdef void c_clear_all(ItemVectorC *self) nogil

    @staticmethod
    cdef void c_swap(ItemVectorC *self, size_t a, size_t b) nogil

    @staticmethod
    cdef Error c_resize(ItemVectorC *self, size_t new_max_items) nogil