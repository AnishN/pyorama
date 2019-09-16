from cpython.buffer cimport *
from pyorama.core.error cimport *
from pyorama.core.handle cimport *
from pyorama.core.item_vector cimport *
from pyorama.libs.c cimport *

ctypedef uint8_t ItemType

ctypedef struct ItemSlotMapC:
    ItemVectorC items
    ItemVectorC indices
    ItemVectorC erase
    ItemType item_type
    uint32_t free_list_front
    uint32_t free_list_back

cdef class ItemSlotMap:

    @staticmethod
    cdef Error c_init(ItemSlotMapC *self, size_t item_size, ItemType item_type) nogil

    @staticmethod
    cdef void c_free(ItemSlotMapC *self) nogil

    @staticmethod
    cdef Error c_create(ItemSlotMapC *self, Handle *item_id) nogil

    @staticmethod
    cdef Error c_delete(ItemSlotMapC *self, Handle item_id) nogil

    @staticmethod
    cdef Error c_get_ptr(ItemSlotMapC *self, Handle item_id, void **item_ptr) nogil

    @staticmethod
    cdef bint _c_is_free_list_empty(ItemSlotMapC *self) nogil

    @staticmethod
    cdef bint _c_is_item_id_valid(ItemSlotMapC *self, Handle item_id) nogil