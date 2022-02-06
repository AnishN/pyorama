from pyorama.core.handle cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *

ctypedef struct SlotMapC:
    VectorC items
    VectorC indices
    VectorC erase
    uint8_t slot_type
    uint32_t free_list_front
    uint32_t free_list_back

"""
NOTE: 
Items in SlotMap each now contain a handle member as the first member of their struct.
This member is set in the c_create function and is cleared (with the rest of the struct) in c_delete.
"""

cdef inline Error slot_map_init(SlotMapC *slot_map, uint8_t slot_type, size_t slot_size) nogil:
    cdef:
        Error error
    
    error = vector_init(&slot_map.items, slot_size)
    if error != NO_ERROR:
        return error
    error = vector_init(&slot_map.indices, sizeof(Handle))
    if error != NO_ERROR:
        return error
    error = vector_init(&slot_map.erase, sizeof(uint32_t))
    if error != NO_ERROR:
        return error
    slot_map.slot_type = slot_type
    slot_map.free_list_front = <uint32_t>0xFFFFFFFF
    slot_map.free_list_back = <uint32_t>0xFFFFFFFF

cdef inline void slot_map_free(SlotMapC *slot_map) nogil:
    vector_free(&slot_map.items)
    vector_free(&slot_map.indices)
    vector_free(&slot_map.erase)
    slot_map.slot_type = 0
    slot_map.free_list_front = <uint32_t>0xFFFFFFFF
    slot_map.free_list_back = <uint32_t>0xFFFFFFFF

cdef inline Error slot_map_create(SlotMapC *slot_map, Handle *handle_ptr) nogil:
    cdef:
        Handle outer_id = 0
        Handle inner_id = 0
        uint32_t outer_index
        Handle *item_ptr#to write Handle into first member of item struct
        Error error
    
    if slot_map_is_free_list_empty(slot_map):
        handle_set(&inner_id, slot_map.items.num_items, 1, slot_map.slot_type, 0)
        outer_id = inner_id
        handle_set_index(&outer_id, slot_map.indices.num_items)
        error = vector_push(&slot_map.indices, &inner_id)
        if error != NO_ERROR:
            return error
    else:
        outer_index = slot_map.free_list_front
        vector_get(&slot_map.indices, outer_index, &inner_id)
        slot_map.free_list_front = handle_get_index(&inner_id)
        if slot_map_is_free_list_empty(slot_map):
            slot_map.free_list_back = slot_map.free_list_front
        handle_set_free(&inner_id, 0)
        handle_set_index(&inner_id, slot_map.items.num_items)
        outer_id = inner_id
        handle_set_index(&outer_id, outer_index)
        vector_set(&slot_map.indices, outer_index, &inner_id)
    error = vector_push_empty(&slot_map.items)
    if error != NO_ERROR:
        return error
    error = vector_get_ptr(&slot_map.items, slot_map.items.num_items - 1, <void **>&item_ptr)
    item_ptr[0] = outer_id
    outer_index = handle_get_index(&outer_id)
    error = vector_push(&slot_map.erase, &outer_index)
    if error != NO_ERROR:
        return error
    handle_ptr[0] = outer_id

cdef inline Error slot_map_delete(SlotMapC *slot_map, Handle handle) nogil:
    cdef:
        Handle inner_id
        Handle free_id
        Handle outer_id
        uint32_t inner_index
        uint32_t outer_index
        Error error
    
    if not slot_map_is_handle_valid(slot_map, handle):
        return INVALID_HANDLE_ERROR
    
    inner_id = (<Handle *>vector_get_ptr_unsafe(&slot_map.indices, handle_get_index(&handle)))[0]

    inner_index = handle_get_index(&inner_id)
    handle_set_free(&inner_id, True)
    handle_set_version(&inner_id, handle_get_version(&inner_id) + 1)
    handle_set_index(&inner_id, <uint32_t>0xFFFFFFFF)
    vector_set(&slot_map.indices, handle_get_index(&handle), &inner_id)

    if slot_map_is_free_list_empty(slot_map):
        slot_map.free_list_front = handle_get_index(&handle)
        slot_map.free_list_back = slot_map.free_list_front
    else:
        free_id = (<Handle *>vector_get_ptr_unsafe(&slot_map.indices, slot_map.free_list_back))[0]
        handle_set_index(&free_id, handle_get_index(&handle))
        vector_set(&slot_map.indices, slot_map.free_list_back, &free_id)
        slot_map.free_list_back = handle_get_index(&handle)

    if inner_index != slot_map.items.num_items - 1:
        vector_swap(&slot_map.items, inner_index, slot_map.items.num_items - 1)
        vector_swap(&slot_map.erase, inner_index, slot_map.erase.num_items - 1)
        vector_get(&slot_map.erase, inner_index, &outer_index)
        vector_get(&slot_map.indices, outer_index, &outer_id)
        handle_set_index(&outer_id, inner_index)
        vector_set(&slot_map.indices, outer_index, &outer_id)

    vector_pop_empty(&slot_map.items)
    vector_pop_empty(&slot_map.erase)

cdef inline void *slot_map_get_ptr_unsafe(SlotMapC *slot_map, Handle handle) nogil:
    cdef:
        Handle *inner_id
        void *item_ptr

    inner_id = <Handle *>vector_get_ptr_unsafe(&slot_map.indices, handle_get_index(&handle))
    item_ptr = vector_get_ptr_unsafe(&slot_map.items, handle_get_index(inner_id))
    return item_ptr

cdef inline Error slot_map_get_ptr(SlotMapC *slot_map, Handle handle, void **item_ptr) nogil:
    """
    if not slot_map_is_handle_valid(slot_map, handle):
        return INVALID_HANDLE_ERROR
    else:
        item_ptr[0] = slot_map_get_ptr_unsafe(slot_map, handle)
        #slot_map.indices.c_get(handle_get_index(&handle), &inner_id)
        #item_ptr[0] = slot_map.items.c_get_ptr(handle_get_index(&inner_id))
    """
    cdef:
        Error error
        Handle *inner_id
    if handle_get_type(&handle) != slot_map.slot_type:
        return INVALID_HANDLE_ERROR
    error = vector_get_ptr(&slot_map.indices, handle_get_index(&handle), <void **>&inner_id)
    if error != NO_ERROR:
        return error
    error = vector_get_ptr(&slot_map.items, handle_get_index(inner_id), item_ptr)
    if error != NO_ERROR:
        return error

cdef inline bint slot_map_is_free_list_empty(SlotMapC *slot_map) nogil:
    return slot_map.free_list_front == <uint32_t>0xFFFFFFFF

cdef inline bint slot_map_is_handle_valid(SlotMapC *slot_map, Handle handle) nogil:
    cdef:
        uint32_t outer_index
        Handle inner_id
        Error error

    if handle_get_type(&handle) != slot_map.slot_type:
        return False
    outer_index = handle_get_index(&handle)
    if outer_index >= slot_map.indices.num_items:
        return False
    error = vector_get(&slot_map.indices, outer_index, &inner_id)
    if error != NO_ERROR:
        return False
    if handle_get_index(&inner_id) < slot_map.items.num_items:
        if handle_get_version(&handle) == handle_get_version(&inner_id):
            return True
    return False