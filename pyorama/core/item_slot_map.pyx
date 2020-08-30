cdef object INVALID_HANDLE_ERROR = ValueError("ItemSlotMap: invalid handle")

"""
NOTE: 
Items in ItemSlotMap each now contain a handle member as the first member of their struct.
This member is set in the c_create function and is cleared (with the rest of the struct) in c_delete.
"""

cdef class ItemSlotMap:

    def __cinit__(self, size_t item_size, ItemType item_type):
        self.items = ItemVector(item_size)
        self.indices = ItemVector(sizeof(Handle))
        self.erase = ItemVector(sizeof(uint32_t))
        self.item_type = item_type
        self.free_list_front = <uint32_t>0xFFFFFFFF
        self.free_list_back = <uint32_t>0xFFFFFFFF
    
    def __dealloc__(self):
        self.item_type = 0
        self.free_list_front = <uint32_t>0xFFFFFFFF
        self.free_list_back = <uint32_t>0xFFFFFFFF        

    cdef Handle c_create(self) except *:
        cdef:
            Handle outer_id = 0
            Handle inner_id = 0
            uint32_t outer_index
            Handle *item_ptr#to write Handle into first member of item struct
        
        if self.c_is_free_list_empty():
            c_handle_set(&inner_id, self.items.num_items, 1, self.item_type, 0)
            outer_id = inner_id
            c_handle_set_index(&outer_id, self.indices.num_items)
            self.indices.c_push(&inner_id)
        else:
            outer_index = self.free_list_front
            self.indices.c_get(outer_index, &inner_id)
            self.free_list_front = c_handle_get_index(&inner_id)
            if self.c_is_free_list_empty():
                self.free_list_back = self.free_list_front
            c_handle_set_free(&inner_id, 0)
            c_handle_set_index(&inner_id, self.items.num_items)
            outer_id = inner_id
            c_handle_set_index(&outer_id, outer_index)
            self.indices.c_set(outer_index, &inner_id)

        self.items.c_push_empty()

        #start of handle item writing changes
        item_ptr = <Handle *>self.items.c_get_ptr(self.items.num_items - 1)
        item_ptr[0] = outer_id
        #end of handle item writing changes

        outer_index = c_handle_get_index(&outer_id)
        self.erase.c_push(&outer_index)
        return outer_id

    cdef void c_delete(self, Handle handle) except *:
        cdef:
            Handle inner_id
            Handle free_id
            Handle outer_id
            uint32_t inner_index
            uint32_t outer_index
        
        if not self.c_is_handle_valid(handle):
            raise INVALID_HANDLE_ERROR
        self.indices.c_get(c_handle_get_index(&handle), &inner_id)
        inner_index = c_handle_get_index(&inner_id)
        c_handle_set_free(&inner_id, True)
        c_handle_set_version(&inner_id, c_handle_get_version(&inner_id) + 1)
        c_handle_set_index(&inner_id, <uint32_t>0xFFFFFFFF)
        self.indices.c_set(c_handle_get_index(&handle), &inner_id)

        if self.c_is_free_list_empty():
            self.free_list_front = c_handle_get_index(&handle)
            self.free_list_back = self.free_list_front
        else:
            self.indices.c_get(self.free_list_back, &free_id)
            c_handle_set_index(&free_id, c_handle_get_index(&handle))
            self.indices.c_set(self.free_list_back, &free_id)
            self.free_list_back = c_handle_get_index(&handle)

        if inner_index != self.items.num_items - 1:
            self.items.c_swap(inner_index, self.items.num_items - 1)
            self.erase.c_swap(inner_index, self.erase.num_items - 1)
            self.erase.c_get(inner_index, &outer_index)
            self.indices.c_get(outer_index, &outer_id)
            c_handle_set_index(&outer_id, inner_index)
            self.indices.c_set(outer_index, &outer_id)

        self.items.c_pop_empty()
        self.erase.c_pop_empty()

    cdef void *c_get_ptr(self, Handle handle) except *:
        cdef:
            Handle inner_id
            void *item_ptr

        if not self.c_is_handle_valid(handle):
            raise INVALID_HANDLE_ERROR
        else:
            self.indices.c_get(c_handle_get_index(&handle), &inner_id)
            item_ptr = self.items.c_get_ptr(c_handle_get_index(&inner_id))
            return item_ptr

    cdef bint c_is_free_list_empty(self) nogil:
        return self.free_list_front == <uint32_t>0xFFFFFFFF

    cdef bint c_is_handle_valid(self, Handle handle) except *:
        cdef:
            uint32_t outer_index
            Handle inner_id

        outer_index = c_handle_get_index(&handle)
        if outer_index >= self.indices.num_items:
            return False
        elif c_handle_get_type(&handle) != self.item_type:
            return False
        self.indices.c_get(outer_index, &inner_id)
        if c_handle_get_index(&inner_id) < self.items.num_items:
            if c_handle_get_version(&handle) == c_handle_get_version(&inner_id):
                return True
        return False