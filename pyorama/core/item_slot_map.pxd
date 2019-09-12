from cpython.buffer cimport *
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
    cdef void c_init(ItemSlotMapC *self, size_t item_size, ItemType item_type) except *

    @staticmethod
    cdef void c_free(ItemSlotMapC *self) nogil

    @staticmethod
    cdef void c_create(ItemSlotMapC *self, Handle *item_id) except *

    @staticmethod
    cdef void c_delete(ItemSlotMapC *self, Handle item_id) except *

    @staticmethod
    cdef void c_get_ptr(ItemSlotMapC *self, Handle item_id, void **item_ptr) nogil

    @staticmethod
    cdef bint _c_is_free_list_empty(ItemSlotMapC *self) nogil

    @staticmethod
    cdef bint _c_is_item_id_valid(ItemSlotMapC *self, Handle item_id) nogil

"""
cdef void item_slot_map_init(ItemSlotMapC *self, size_t item_size, ItemType item_type) except *
cdef void item_slot_map_free(ItemSlotMapC *self) nogil
cdef void item_slot_map_create(ItemSlotMapC *self, Handle *item_id) except *
cdef void item_slot_map_delete(ItemSlotMapC *self, Handle item_id) except *
cdef void item_slot_map_get_ptr(ItemSlotMapC *self, Handle item_id, void **item_ptr) nogil
"""