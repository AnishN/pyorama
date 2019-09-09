cdef void item_array_init(ItemArrayC *self, size_t item_size, size_t max_items) except *:
    self.max_items = max_items
    self.item_size = item_size
    self.items = <char *>calloc(self.max_items, self.item_size)
    if self.items == NULL:
        raise MemoryError("ItemArrayC: cannot allocate memory")

cdef void item_array_free(ItemArrayC *self) nogil:
    self.max_items = 0
    self.item_size = 0
    free(self.items)
    self.items = NULL

cdef void item_array_get_ptr(ItemArrayC *self, size_t index, void **item_ptr) nogil:
    if 0 <= index < self.max_items: 
        item_ptr[0] = self.items + (self.item_size * index)
    else:
        item_ptr[0] = NULL

cdef void item_array_get(ItemArrayC *self, size_t index, void *item) nogil:
    cdef char *src
    if 0 <= index < self.max_items: 
        src = self.items + (self.item_size * index)
        memcpy(item, src, self.item_size)

cdef void item_array_set(ItemArrayC *self, size_t index, void *item) nogil:
    cdef char *dest
    if 0 <= index < self.max_items: 
        dest = self.items + (self.item_size * index)
        memcpy(dest, item, self.item_size)

cdef void item_array_clear(ItemArrayC *self, size_t index) nogil:
    cdef char *dest
    if 0 <= index < self.max_items:
        dest = self.items + (self.item_size * index)
        memset(dest, 0, self.item_size)

cdef void item_array_clear_all(ItemArrayC *self) nogil:
    memset(self.items, 0, self.max_items * self.item_size)

cdef void item_array_swap(ItemArrayC *self, size_t a, size_t b) nogil:
    cdef:
        char *a_ptr
        char *b_ptr
        size_t i
    if (0 <= a < self.max_items) and (0 <= b < self.max_items):
        item_array_get_ptr(self, a, <void **>&a_ptr)
        item_array_get_ptr(self, b, <void **>&b_ptr)
        for i in range(self.item_size):
            a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]