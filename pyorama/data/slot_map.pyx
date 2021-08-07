cdef object INVALID_HANDLE_ERROR = ValueError("SlotMap: invalid handle")

"""
NOTE: 
Items in SlotMap each now contain a handle member as the first member of their struct.
This member is set in the c_create function and is cleared (with the rest of the struct) in c_delete.
"""

cdef class SlotMap:

    def __cinit__(self):
        self.items = Vector()
        self.indices = Vector()
        self.erase = Vector()
    
    def __dealloc__(self):
        self.items = None
        self.indices = None
        self.erase = None

    cdef void c_init(self, uint8_t slot_type, size_t slot_size) except *:
        self.items.c_init(slot_size)
        self.indices.c_init(sizeof(Handle))
        self.erase.c_init(sizeof(uint32_t))
        self.slot_type = slot_type
        self.free_list_front = <uint32_t>0xFFFFFFFF
        self.free_list_back = <uint32_t>0xFFFFFFFF

    cdef void c_free(self) except *:
        self.items.c_free()
        self.indices.c_free()
        self.erase.c_free()
        self.slot_type = 0
        self.free_list_front = <uint32_t>0xFFFFFFFF
        self.free_list_back = <uint32_t>0xFFFFFFFF

    cdef Handle c_create(self) except *:
        cdef:
            Handle outer_id = 0
            Handle inner_id = 0
            uint32_t outer_index
            Handle *item_ptr#to write Handle into first member of item struct
        
        if self.c_is_free_list_empty():
            handle_set(&inner_id, self.items.num_items, 1, self.slot_type, 0)
            outer_id = inner_id
            handle_set_index(&outer_id, self.indices.num_items)
            self.indices.c_push(&inner_id)
        else:
            outer_index = self.free_list_front
            self.indices.c_get(outer_index, &inner_id)
            self.free_list_front = handle_get_index(&inner_id)
            if self.c_is_free_list_empty():
                self.free_list_back = self.free_list_front
            handle_set_free(&inner_id, 0)
            handle_set_index(&inner_id, self.items.num_items)
            outer_id = inner_id
            handle_set_index(&outer_id, outer_index)
            self.indices.c_set(outer_index, &inner_id)
        self.items.c_push_empty()
        item_ptr = <Handle *>self.items.c_get_ptr(self.items.num_items - 1)
        item_ptr[0] = outer_id
        outer_index = handle_get_index(&outer_id)
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
        self.indices.c_get(handle_get_index(&handle), &inner_id)
        inner_index = handle_get_index(&inner_id)
        handle_set_free(&inner_id, True)
        handle_set_version(&inner_id, handle_get_version(&inner_id) + 1)
        handle_set_index(&inner_id, <uint32_t>0xFFFFFFFF)
        self.indices.c_set(handle_get_index(&handle), &inner_id)

        if self.c_is_free_list_empty():
            self.free_list_front = handle_get_index(&handle)
            self.free_list_back = self.free_list_front
        else:
            self.indices.c_get(self.free_list_back, &free_id)
            handle_set_index(&free_id, handle_get_index(&handle))
            self.indices.c_set(self.free_list_back, &free_id)
            self.free_list_back = handle_get_index(&handle)

        if inner_index != self.items.num_items - 1:
            self.items.c_swap(inner_index, self.items.num_items - 1)
            self.erase.c_swap(inner_index, self.erase.num_items - 1)
            self.erase.c_get(inner_index, &outer_index)
            self.indices.c_get(outer_index, &outer_id)
            handle_set_index(&outer_id, inner_index)
            self.indices.c_set(outer_index, &outer_id)

        self.items.c_pop_empty()
        self.erase.c_pop_empty()

    cdef void *c_get_ptr_unsafe(self, Handle handle) nogil:
        cdef:
            Handle *inner_id
            void *item_ptr

        inner_id = <Handle *>self.indices.c_get_ptr_unsafe(handle_get_index(&handle))
        item_ptr = self.items.c_get_ptr_unsafe(handle_get_index(inner_id))
        return item_ptr

    cdef void *c_get_ptr(self, Handle handle) except *:
        cdef:
            Handle inner_id
            void *item_ptr

        if not self.c_is_handle_valid(handle):
            raise INVALID_HANDLE_ERROR
        else:
            self.indices.c_get(handle_get_index(&handle), &inner_id)
            item_ptr = self.items.c_get_ptr(handle_get_index(&inner_id))
            return item_ptr

    cdef bint c_is_free_list_empty(self) except *:
        return self.free_list_front == <uint32_t>0xFFFFFFFF

    cdef bint c_is_handle_valid(self, Handle handle) except *:
        cdef:
            uint32_t outer_index
            Handle inner_id

        outer_index = handle_get_index(&handle)
        if outer_index >= self.indices.num_items:
            return False
        elif handle_get_type(&handle) != self.slot_type:
            return False
        self.indices.c_get(outer_index, &inner_id)
        if handle_get_index(&inner_id) < self.items.num_items:
            if handle_get_version(&handle) == handle_get_version(&inner_id):
                return True
        return False