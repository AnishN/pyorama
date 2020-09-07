cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_vector cimport *
from pyorama.libs.c cimport *

ctypedef uint8_t ItemType

@cython.final
cdef class ItemSlotMap:
    cdef:
        ItemVector items
        ItemVector indices
        ItemVector erase
        ItemType item_type
        uint32_t free_list_front
        uint32_t free_list_back

    cdef Handle c_create(self) except *
    cdef void c_delete(self, Handle handle) except *
    cdef void *c_get_ptr(self, Handle handle) except *
    cdef bint c_is_free_list_empty(self) except *
    cdef bint c_is_handle_valid(self, Handle handle) except *