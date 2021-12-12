DEF MAX_ITEM_TYPES = 256

cdef class SlotManager:
    
    cdef void c_init(self, dict slot_type_sizes) except *:
        cdef:
            uint8_t slot_type
            size_t slot_size
            SlotMapC *slot_map
        
        self.num_slot_types = 0
        for slot_type, slot_size in slot_type_sizes.items():
            if 0 <= slot_type < MAX_ITEM_TYPES:
                self.registered_maps[slot_type] = True
                slot_map = &self.slot_maps[slot_type]
                slot_map_init(slot_map, slot_type, slot_size)
            else:
                raise ValueError("SlotManager: invalid slot type")

    cdef void c_free(self) except *:
        cdef:
            size_t i
        
        for i in range(MAX_ITEM_TYPES):
            if self.registered_maps[i]:
                slot_map_free(&self.slot_maps[i])
    
    cdef void c_check_slot_type(self, uint8_t slot_type) except *:
        if not self.registered_maps[slot_type]:
            raise ValueError("SlotManager: invalid slot type")
    
    cdef Handle c_create(self, uint8_t slot_type) except *:
        cdef:
            SlotMapC *slot_map
            Handle handle
            Error error
        
        self.c_check_slot_type(slot_type)
        slot_map = &self.slot_maps[slot_type]
        error = slot_map_create(slot_map, &handle)
        CHECK_ERROR(error)
        return handle

    cdef void c_delete(self, Handle handle) except *:
        cdef:
            uint8_t slot_type
            SlotMapC *slot_map
        
        slot_type = handle_get_type(&handle)
        self.c_check_slot_type(slot_type)
        slot_map = &self.slot_maps[slot_type]
        slot_map_delete(slot_map, handle)

    cdef void *c_get_ptr(self, Handle handle) except *:
        cdef:
            uint8_t slot_type
            SlotMapC *slot_map
            void *item_ptr
            Error error
        
        slot_type = handle_get_type(&handle)
        self.c_check_slot_type(slot_type)
        slot_map = &self.slot_maps[slot_type]
        error = slot_map_get_ptr(slot_map, handle, &item_ptr)
        CHECK_ERROR(error)
        return item_ptr

    cdef void *c_get_ptr_by_index(self, uint8_t slot_type, size_t index) except *:
        cdef:
            SlotMapC *slot_map
            void *item_ptr
        
        slot_map = &self.slot_maps[slot_type]
        error = vector_get_ptr(&slot_map.items, index, &item_ptr)
        CHECK_ERROR(error)
        return item_ptr

    cdef void *c_get_ptr_unsafe(self, Handle handle) nogil:
        cdef:
            uint8_t slot_type
            SlotMapC *slot_map
            void *item_ptr

        slot_type = handle_get_type(&handle)
        if self.registered_maps[slot_type]:
            slot_map = &self.slot_maps[slot_type]
            item_ptr = slot_map_get_ptr_unsafe(slot_map, handle)
            return item_ptr

    cdef SlotMapC *get_slot_map(self, uint8_t slot_type) except *:
        self.c_check_slot_type(slot_type)
        return &self.slot_maps[slot_type]