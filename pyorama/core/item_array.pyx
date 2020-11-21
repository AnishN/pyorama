cdef object MEMORY_ERROR = MemoryError("ItemArray: cannot allocate memory")
cdef object INVALID_INDEX_ERROR = ValueError("ItemArray: invalid index")

cdef class ItemArray:
    
    def __cinit__(self, size_t item_size, size_t max_items):
        self.max_items = max_items
        self.item_size = item_size
        self.items = <char *>calloc(self.max_items, self.item_size)
        if self.items == NULL:
            raise MEMORY_ERROR
    
    def __dealloc__(self):
        self.max_items = 0
        self.item_size = 0
        free(self.items)
        self.items = NULL

    cdef void *c_get_ptr_unsafe(self, size_t index) nogil:
        return self.items + (self.item_size * index)

    cdef void *c_get_ptr(self, size_t index) except *:
        if 0 <= index < self.max_items: 
            return self.items + (self.item_size * index)
        else:
            raise INVALID_INDEX_ERROR

    cdef void c_get(self, size_t index, void *item) except *:
        cdef char *src
        if 0 <= index < self.max_items: 
            src = self.items + (self.item_size * index)
            memcpy(item, src, self.item_size)
        else:
            raise INVALID_INDEX_ERROR

    cdef void c_set(self, size_t index, void *item) except *:
        cdef char *dest
        if 0 <= index < self.max_items: 
            dest = self.items + (self.item_size * index)
            memcpy(dest, item, self.item_size)
        else:
            raise INVALID_INDEX_ERROR

    cdef void c_clear(self, size_t index) except *:
        cdef char *dest
        if 0 <= index < self.max_items:
            dest = self.items + (self.item_size * index)
            memset(dest, 0, self.item_size)
        else:
            raise INVALID_INDEX_ERROR

    cdef void c_clear_all(self) except *:
        memset(self.items, 0, self.max_items * self.item_size)

    cdef void c_swap(self, size_t a, size_t b) except *:
        cdef:
            char *a_ptr
            char *b_ptr
            size_t i
        if (0 <= a < self.max_items) and (0 <= b < self.max_items):
                a_ptr = <char *>self.c_get_ptr(a)
                b_ptr = <char *>self.c_get_ptr(b)
                for i in range(self.item_size):
                    a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]
        else:
            raise INVALID_INDEX_ERROR