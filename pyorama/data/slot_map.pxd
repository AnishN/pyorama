from pyorama.data.handle cimport *
from pyorama.data.vector cimport *
from pyorama.libs.c cimport *

cdef class SlotMap:
    cdef:
        Vector items
        Vector indices
        Vector erase
        uint8_t slot_type
        uint32_t free_list_front
        uint32_t free_list_back

    cdef void c_init(self, uint8_t slot_type, size_t slot_size) except *
    cdef void c_free(self) except *
    cdef Handle c_create(self) except *
    cdef void c_delete(self, Handle handle) except *
    cdef void *c_get_ptr_unsafe(self, Handle handle) nogil
    cdef void *c_get_ptr(self, Handle handle) except *
    cdef bint c_is_free_list_empty(self) except *
    cdef bint c_is_handle_valid(self, Handle handle) except *