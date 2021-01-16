from cpython.object cimport *
from cpython.ref cimport *
from pyorama.core.handle cimport *
from pyorama.core.item_slot_map cimport *

DEF MAX_ITEM_TYPES = 256

cdef class ItemManager:
    
    cdef:
        cdef size_t num_item_types
        cdef bint registered_item_types[MAX_ITEM_TYPES]
        PyObject *slot_maps[MAX_ITEM_TYPES]
    
    cpdef uint8_t register_item_types(self, dict item_types_info) except *
    cpdef void check_item_type(self, uint8_t item_type) except *
    cpdef Handle create(self, uint8_t item_type) except *
    cpdef void delete(self, Handle handle)
    cdef void *get_ptr(self, Handle handle) except *
    cdef void *get_ptr_unsafe(self, Handle handle) nogil
    cdef ItemSlotMap get_slot_map(self, uint8_t item_type)