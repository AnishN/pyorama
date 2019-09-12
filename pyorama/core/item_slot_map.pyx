cdef class ItemSlotMap:
    
    @staticmethod
    cdef void c_init(ItemSlotMapC *self, size_t item_size, ItemType item_type) except *:
        ItemVector.c_init(&self.items, item_size)
        ItemVector.c_init(&self.indices, sizeof(Handle))
        ItemVector.c_init(&self.erase, sizeof(uint32_t))
        self.item_type = item_type
        self.free_list_front = <uint32_t>0xFFFFFFFF
        self.free_list_back = <uint32_t>0xFFFFFFFF

    @staticmethod
    cdef void c_free(ItemSlotMapC *self) nogil:
        ItemVector.c_free(&self.items)
        ItemVector.c_free(&self.indices)
        ItemVector.c_free(&self.erase)
        self.item_type = 0
        self.free_list_front = <uint32_t>0xFFFFFFFF
        self.free_list_back = <uint32_t>0xFFFFFFFF

    @staticmethod
    cdef void c_create(ItemSlotMapC *self, Handle *item_id) except *:
        cdef:
            Handle outer_id = 0
            Handle inner_id = 0
            uint32_t outer_index
        
        if ItemSlotMap._c_is_free_list_empty(self):
            handle_set(&inner_id, self.items.num_items, 1, self.item_type, 0)
            outer_id = inner_id
            handle_set_index(&outer_id, self.indices.num_items)
            ItemVector.c_push(&self.indices, &inner_id)
        else:
            outer_index = self.free_list_front
            ItemVector.c_get(&self.indices, outer_index, &inner_id)
            self.free_list_front = handle_get_index(&inner_id)
            if ItemSlotMap._c_is_free_list_empty(self):
                self.free_list_back = self.free_list_front
            handle_set_free(&inner_id, 0)
            handle_set_index(&inner_id, self.items.num_items)
            outer_id = inner_id
            handle_set_index(&outer_id, outer_index)
            ItemVector.c_set(&self.indices, outer_index, &inner_id)

        ItemVector.c_push_empty(&self.items)
        outer_index = handle_get_index(&outer_id)
        ItemVector.c_push(&self.erase, &outer_index)
        item_id[0] = outer_id

    @staticmethod
    cdef void c_delete(ItemSlotMapC *self, Handle item_id) except *:
        cdef:
            Handle inner_id
            Handle free_id
            Handle outer_id
            uint32_t inner_index
            uint32_t outer_index
        
        if not ItemSlotMap._c_is_item_id_valid(self, item_id):
            return
        ItemVector.c_get(&self.indices, handle_get_index(&item_id), &inner_id)
        inner_index = handle_get_index(&inner_id)
        handle_set_free(&inner_id, True)
        handle_set_version(&inner_id, handle_get_version(&inner_id) + 1)
        handle_set_index(&inner_id, <uint32_t>0xFFFFFFFF)
        ItemVector.c_set(&self.indices, handle_get_index(&item_id), &inner_id)

        if ItemSlotMap._c_is_free_list_empty(self):
            self.free_list_front = handle_get_index(&item_id)
            self.free_list_back = self.free_list_front
        else:
            ItemVector.c_get(&self.indices, self.free_list_back, &free_id)
            handle_set_index(&free_id, handle_get_index(&item_id))
            ItemVector.c_set(&self.indices, self.free_list_back, &free_id)
            self.free_list_back = handle_get_index(&item_id)

        if inner_index != self.items.num_items - 1:
            ItemVector.c_swap(&self.items, inner_index, self.items.num_items - 1)
            ItemVector.c_swap(&self.erase, inner_index, self.erase.num_items - 1)
            ItemVector.c_get(&self.erase, inner_index, &outer_index)
            ItemVector.c_get(&self.indices, outer_index, &outer_id)
            handle_set_index(&outer_id, inner_index)
            ItemVector.c_set(&self.indices, outer_index, &outer_id)

        ItemVector.c_pop_empty(&self.items)
        ItemVector.c_pop_empty(&self.erase)

    @staticmethod
    cdef void c_get_ptr(ItemSlotMapC *self, Handle item_id, void **item_ptr) nogil:
        cdef Handle inner_id

        if not ItemSlotMap._c_is_item_id_valid(self, item_id):
            item_ptr[0] = NULL
        else:
            ItemVector.c_get(&self.indices, handle_get_index(&item_id), &inner_id)
            ItemVector.c_get_ptr(&self.items, handle_get_index(&inner_id), item_ptr)
        
    @staticmethod
    cdef bint _c_is_free_list_empty(ItemSlotMapC *self) nogil:
        return self.free_list_front == <uint32_t>0xFFFFFFFF

    @staticmethod
    cdef bint _c_is_item_id_valid(ItemSlotMapC *self, Handle item_id) nogil:
        cdef:
            uint32_t outer_index
            Handle inner_id

        outer_index = handle_get_index(&item_id)
        if outer_index >= self.indices.num_items:
            return False
        elif handle_get_type(&item_id) != self.item_type:
            return False
        ItemVector.c_get(&self.indices, outer_index, &inner_id)
        if handle_get_index(&inner_id) < self.items.num_items:
            if handle_get_version(&item_id) == handle_get_version(&inner_id):
                return True
        return False