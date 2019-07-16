cdef class CompMap:
    
    cpdef void init(self, size_t max_comps, CompType comp_type, size_t comp_size, bytes comp_format) except *:
        self.max_comps = max_comps
        self.comp_type = comp_type
        self.comp_size = comp_size
        self.comp_format = comp_format
        
        self.comps = CompArray()
        self.indices = CompArray()
        self.erase = CompArray()

        self.num_comps = 0
        self.num_indices = 0#includes free and used indices...
        self.free_list_head = 0xFFFFFFFF#front of free_list, pop off head
        self.free_list_tail = self.free_list_head#back of free_list, push on tail

        self.comps.init(self.max_comps, self.comp_size, self.comp_format)
        self.indices.init(self.max_comps, sizeof(Comp), b"Q")
        self.erase.init(self.max_comps, sizeof(uint32_t), b"I")

    cpdef void free(self):
        self.max_comps = 0
        self.comp_size = 0
        self.comp_format = b""
        self.comp_type = 0

        self.comps.free()
        self.indices.free()
        self.erase.free()
        self.num_comps = 0
        self.num_indices = 0
        self.free_list_head = 0xFFFFFFFF
        self.free_list_tail = self.free_list_head
    
    cpdef Comp create(self) except 0:
        cdef:
            Comp outer_comp
            Comp inner_comp
            Comp *inner_comp_ptr
            uint32_t outer_index
        
        if self.num_comps == self.max_comps:
            raise ValueError("CompMap: cannot create comp")
        elif self.c_is_free_list_empty():
            handle_set(&inner_comp, self.num_comps, 1, self.comp_type, 0)
            outer_comp = inner_comp
            handle_set_index(&outer_comp, self.num_indices)
            self.indices.c_set(self.num_indices, &inner_comp)
            self.num_indices += 1
        else:
            outer_index = self.free_list_head
            inner_comp_ptr = <Comp *>self.indices.c_get_ptr(outer_index)
            self.free_list_head = handle_get_index(inner_comp_ptr)
            if self.c_is_free_list_empty():
                self.free_list_tail = self.free_list_head
            handle_set_free(inner_comp_ptr, 0)
            handle_set_index(inner_comp_ptr, self.num_comps)
            outer_comp = inner_comp_ptr[0]
            handle_set_index(&outer_comp, outer_index)
            self.comps.c_clear(self.num_comps)
        outer_index = handle_get_index(&outer_comp)
        self.erase.c_set(self.num_comps, &outer_index)
        self.num_comps += 1        
        memset(self.c_get(outer_comp), 0, self.comp_size)
        return outer_comp

    cpdef int delete(self, Comp comp) except -1:
        cdef:
            Comp inner_comp
            uint32_t inner_index
            uint32_t old_index
            size_t a
            size_t b
        
        if not self.c_is_comp_valid(comp):
            raise ValueError("CompMap: invalid comp")

        self.indices.c_get(handle_get_index(&comp), &inner_comp)
        inner_index = handle_get_index(&inner_comp)
        handle_set_free(&inner_comp, 1)
        handle_set_version(&inner_comp, handle_get_version(&inner_comp) + 1)
        handle_set_index(&inner_comp, 0xFFFFFFFF)
        self.indices.c_set(handle_get_index(&comp), &inner_comp)
        
        if self.c_is_free_list_empty():
            self.free_list_head = handle_get_index(&comp)
            self.free_list_tail = self.free_list_head
        else:
            old_index = handle_get_index(&comp)
            handle_set_index(<Comp *>self.indices.c_get_ptr(self.free_list_tail), old_index)
            self.free_list_tail = old_index
        
        if inner_index != self.num_comps - 1: 
            a = inner_index
            b = self.num_comps - 1
            self.comps.c_swap(a, b)
            self.erase.c_swap(a, b)
            self.erase.c_get(inner_index, &old_index)
            handle_set_index(<Comp *>self.indices.c_get_ptr(old_index), inner_index)
        self.num_comps -= 1

    cdef void *c_get(self, Comp comp) nogil:
        cdef:
            uint32_t index
            void *obj
        
        index = self.c_get_index(comp)
        obj = self.comps.c_get_ptr(index)
        return obj
    
    cdef uint32_t c_get_index(self, Comp comp) nogil:
        cdef:
            Comp inner_comp
            uint32_t index
        
        self.indices.c_get(handle_get_index(&comp), &inner_comp)
        index = handle_get_index(&inner_comp)
        return index
        
    cdef bint c_is_free_list_empty(self) nogil:
        if self.free_list_head == <uint32_t>0xFFFFFFFF:
            return True
        return False
        
    cdef bint c_is_comp_valid(self, Comp comp) nogil:
        cdef Comp inner_comp

        if handle_get_index(&comp) >= self.num_indices:
            return False
        self.indices.c_get(handle_get_index(&comp), &inner_comp)
        if handle_get_index(&inner_comp) < self.num_comps:
            if handle_get_type(&comp) == self.comp_type:
                if handle_get_version(&comp) == handle_get_version(&inner_comp):
                    return True
        return False