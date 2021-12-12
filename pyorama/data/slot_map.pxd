from pyorama.data.handle cimport *
from pyorama.data.vector cimport *
from pyorama.libs.c cimport *

ctypedef struct SlotMapC:
    VectorC items
    VectorC indices
    VectorC erase
    uint8_t slot_type
    uint32_t free_list_front
    uint32_t free_list_back

cdef Error slot_map_init(SlotMapC *slot_map, uint8_t slot_type, size_t slot_size) nogil
cdef void slot_map_free(SlotMapC *slot_map) nogil
cdef Error slot_map_create(SlotMapC *slot_map, Handle *handle_ptr) nogil
cdef Error slot_map_delete(SlotMapC *slot_map, Handle handle) nogil
cdef void *slot_map_get_ptr_unsafe(SlotMapC *slot_map, Handle handle) nogil
cdef Error slot_map_get_ptr(SlotMapC *slot_map, Handle handle, void **item_ptr) nogil
cdef bint slot_map_is_free_list_empty(SlotMapC *slot_map) nogil
cdef bint slot_map_is_handle_valid(SlotMapC *slot_map, Handle handle) nogil