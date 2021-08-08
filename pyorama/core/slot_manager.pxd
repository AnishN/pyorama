from cpython.object cimport *
from cpython.ref cimport *
from pyorama.data.handle cimport *
from pyorama.data.slot_map cimport *

DEF MAX_ITEM_TYPES = 256

cdef class SlotManager:
    
    cdef:
        cdef size_t num_slot_types
        cdef bint registered_maps[MAX_ITEM_TYPES]
        PyObject *slot_maps[MAX_ITEM_TYPES]
    
    cdef void c_init(self, dict slot_type_sizes) except *
    cdef void c_free(self) except *
    cdef void c_check_slot_type(self, uint8_t slot_type) except *
    cdef Handle c_create(self, uint8_t slot_type) except *
    cdef void c_delete(self, Handle handle) except *
    cdef void *c_get_ptr(self, Handle handle) except *
    cdef void *c_get_ptr_by_index(self, uint8_t slot_type, size_t index) except *
    cdef void *c_get_ptr_unsafe(self, Handle handle) nogil
    cdef SlotMap get_slot_map(self, uint8_t slot_type)