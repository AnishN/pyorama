cdef object MEMORY_ERROR = MemoryError("ItemVector: cannot allocate memory")
cdef object INVALID_INDEX_ERROR = ValueError("ItemVector: invalid index")
cdef object POP_EMPTY_ERROR = ValueError("ItemVector: cannot pop from empty container")

cdef float VECTOR_GROWTH_RATE = 2.0
cdef float VECTOR_SHRINK_RATE = 0.5
cdef float VECTOR_SHRINK_THRESHOLD = 0.25
cdef size_t VECTOR_INITIAL_MAX_ITEMS = 4

cdef class ItemVector:

    def __cinit__(self, size_t item_size):
        #print("init {0}".format(self))
        self.max_items = VECTOR_INITIAL_MAX_ITEMS
        self.item_size = item_size
        self.num_items = 0
        self.items = <char *>calloc(self.max_items, self.item_size)
        if self.items == NULL:
            raise MEMORY_ERROR

    def __dealloc__(self):
        #print("free {0}".format(self))
        self.max_items = 0
        self.item_size = 0
        self.num_items = 0
        free(self.items)
        self.items = NULL

    cdef inline void c_push_empty(self) except *:
        cdef char *item
        self.c_grow_if_needed()
        item = self.items + (self.item_size * self.num_items)
        memset(item, 0, self.item_size)
        self.num_items += 1

    cdef inline void c_pop_empty(self) except *:
        if self.num_items <= 0:
            raise POP_EMPTY_ERROR
        self.c_shrink_if_needed()
        self.num_items -= 1

    cdef inline void c_push(self, void *item) except *:
        self.c_grow_if_needed()
        self.c_set(self.num_items, item)
        self.num_items += 1

    cdef inline void c_pop(self, void *item) except *:
        if self.num_items <= 0:
            raise POP_EMPTY_ERROR
        self.c_shrink_if_needed()
        self.c_get(self.num_items - 1, item)
        self.num_items -= 1

    cdef inline void *c_get_ptr(self, size_t index) except *:
        if 0 <= index < self.max_items: 
            return self.items + (self.item_size * index)
        else:
            raise INVALID_INDEX_ERROR

    cdef inline void c_get(self, size_t index, void *item) except *:
        cdef char *src
        if 0 <= index < self.max_items: 
            src = self.items + (self.item_size * index)
            memcpy(item, src, self.item_size)
        else:
            raise INVALID_INDEX_ERROR

    cdef inline void c_set(self, size_t index, void *item) except *:
        cdef char *dest
        if 0 <= index < self.max_items: 
            dest = self.items + (self.item_size * index)
            memcpy(dest, item, self.item_size)
        else:
            raise INVALID_INDEX_ERROR

    cdef inline void c_clear(self, size_t index) except *:
        cdef char *dest
        if 0 <= index < self.max_items:
            dest = self.items + (self.item_size * index)
            memset(dest, 0, self.item_size)
        else:
            raise INVALID_INDEX_ERROR

    cdef inline void c_clear_all(self) nogil:
        memset(self.items, 0, self.max_items * self.item_size)

    cdef inline void c_swap(self, size_t a, size_t b) except *:
        cdef:
            char *a_ptr
            char *b_ptr
            size_t i
        if (0 <= a < self.num_items) and (0 <= b < self.num_items):
            a_ptr = <char *>self.c_get_ptr(a)
            b_ptr = <char *>self.c_get_ptr(b)
            for i in range(self.item_size):
                a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]
        else:
            raise INVALID_INDEX_ERROR

    cdef inline void c_resize(self, size_t new_max_items) except *:
        cdef:
            char *new_items
            char *clear_start
            size_t clear_size
        new_items = <char *>realloc(self.items, new_max_items * self.item_size)
        if new_items == NULL:
            raise MEMORY_ERROR
        if new_max_items > self.max_items:
            clear_start = new_items + (self.item_size * self.max_items)
            clear_size = (new_max_items - self.max_items) * self.item_size
            memset(clear_start, 0, clear_size)
        self.items = new_items
        self.max_items = new_max_items

    cdef inline void c_grow_if_needed(self) except *:
        cdef size_t new_max_items
        if self.num_items >= self.max_items:
            new_max_items = <size_t>(self.max_items * VECTOR_GROWTH_RATE)
            self.c_resize(new_max_items)

    cdef inline void c_shrink_if_needed(self) except *:
        cdef size_t new_max_items
        if self.num_items < self.max_items * VECTOR_SHRINK_THRESHOLD:
            new_max_items = <size_t>(self.max_items * VECTOR_SHRINK_RATE)
            self.c_resize(new_max_items)

    cdef inline void c_insert_empty(self, size_t index) except *:
        cdef:
            void *dest
            void *src
            size_t size
            
        self.c_grow_if_needed()
        dest = self.c_get_ptr(index + 1)
        src = self.c_get_ptr(index)
        size = (self.num_items - index) * self.item_size
        memmove(dest, src, size)
        memset(src, 0, self.item_size)
        self.num_items += 1

    cdef inline void c_insert(self, size_t index, void *item) except *:
        cdef:
            void *dest
            void *src
            size_t size
            
        self.c_grow_if_needed()
        dest = self.c_get_ptr(index + 1)
        src = self.c_get_ptr(index)
        size = (self.num_items - index) * self.item_size
        memmove(dest, src, size)
        memcpy(src, item, self.item_size)
        self.num_items += 1
    
    cdef inline void c_remove_empty(self, size_t index) except *:
        cdef:
            void *dest
            void *src
            size_t size
        
        if self.num_items <= 0:
            raise POP_EMPTY_ERROR
        self.c_shrink_if_needed()
        dest = self.c_get_ptr(index)
        src = self.c_get_ptr(index + 1)
        size = (self.num_items - index - 1) * self.item_size
        memmove(dest, src, size)
        self.num_items -= 1
    
    cdef inline void c_remove(self, size_t index, void *item) except *:
        cdef:
            void *dest
            void *src
            size_t size
        
        if self.num_items <= 0:
            raise POP_EMPTY_ERROR
        self.c_shrink_if_needed()
        self.c_get(index, item)
        dest = self.c_get_ptr(index)
        src = self.c_get_ptr(index + 1)
        size = (self.num_items - index - 1) * self.item_size
        memmove(dest, src, size)
        self.num_items -= 1