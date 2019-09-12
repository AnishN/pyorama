cdef float VECTOR_GROWTH_RATE = 2.0
cdef float VECTOR_SHRINK_RATE = 0.5
cdef float VECTOR_SHRINK_THRESHOLD = 0.25
cdef size_t VECTOR_INITIAL_MAX_ITEMS = 4

cdef class ItemVector:

    @staticmethod
    cdef void c_init(ItemVectorC *self, size_t item_size) except *:
        self.max_items = VECTOR_INITIAL_MAX_ITEMS
        self.item_size = item_size
        self.num_items = 0
        self.items = <char *>calloc(self.max_items, self.item_size)
        if self.items == NULL:
            raise MemoryError("ItemVectorC: cannot allocate memory")

    @staticmethod
    cdef void c_free(ItemVectorC *self) nogil:
        self.max_items = 0
        self.item_size = 0
        self.num_items = 0
        free(self.items)
        self.items = NULL

    @staticmethod
    cdef void c_push_empty(ItemVectorC *self) except *:
        cdef:
            size_t new_max_items
            char *new_items
            char *item
        if self.num_items >= self.max_items:
            new_max_items = <size_t>(self.max_items * VECTOR_GROWTH_RATE)
            ItemVector.c_resize(self, new_max_items)
        item = self.items + (self.item_size * self.num_items)
        memset(item, 0, self.item_size)
        self.num_items += 1

    @staticmethod
    cdef void c_pop_empty(ItemVectorC *self) except *:
        cdef:
            size_t new_max_items
            char *new_items
        if self.num_items <= 0:
            raise MemoryError("ItemVectorC: cannot pop from empty container")
        elif self.num_items < self.max_items * VECTOR_SHRINK_THRESHOLD:
            new_max_items = <size_t>(self.max_items * VECTOR_SHRINK_RATE)
            ItemVector.c_resize(self, new_max_items)
        self.num_items -= 1

    @staticmethod
    cdef void c_push(ItemVectorC *self, void *item) except *:
        cdef:
            size_t new_max_items
            char *new_items
        if self.num_items >= self.max_items:
            new_max_items = <size_t>(self.max_items * VECTOR_GROWTH_RATE)
            ItemVector.c_resize(self, new_max_items)
        ItemVector.c_set(self, self.num_items, item)
        self.num_items += 1

    @staticmethod
    cdef void c_pop(ItemVectorC *self, void *item) except *:
        cdef:
            size_t new_max_items
            char *new_items
        if self.num_items <= 0:
            raise MemoryError("ItemVectorC: cannot pop from empty container")
        elif self.num_items < self.max_items * VECTOR_SHRINK_THRESHOLD:
            new_max_items = <size_t>(self.max_items * VECTOR_SHRINK_RATE)
            ItemVector.c_resize(self, new_max_items)
        ItemVector.c_get(self, self.num_items - 1, item)
        self.num_items -= 1

    @staticmethod
    cdef void c_get_ptr(ItemVectorC *self, size_t index, void **item_ptr) nogil:
        if 0 <= index < self.max_items: 
            item_ptr[0] = self.items + (self.item_size * index)
        else:
            item_ptr[0] = NULL

    @staticmethod
    cdef void c_get(ItemVectorC *self, size_t index, void *item) nogil:
        cdef char *src
        if 0 <= index < self.max_items: 
            src = self.items + (self.item_size * index)
            memcpy(item, src, self.item_size)

    @staticmethod
    cdef void c_set(ItemVectorC *self, size_t index, void *item) nogil:
        cdef char *dest
        if 0 <= index < self.max_items: 
            dest = self.items + (self.item_size * index)
            memcpy(dest, item, self.item_size)

    @staticmethod
    cdef void c_clear(ItemVectorC *self, size_t index) nogil:
        cdef char *dest
        if 0 <= index < self.max_items:
            dest = self.items + (self.item_size * index)
            memset(dest, 0, self.item_size)

    @staticmethod
    cdef void c_clear_all(ItemVectorC *self) nogil:
        memset(self.items, 0, self.max_items * self.item_size)

    @staticmethod
    cdef void c_swap(ItemVectorC *self, size_t a, size_t b) nogil:
        cdef:
            char *a_ptr
            char *b_ptr
            size_t i
        if (0 <= a < self.num_items) and (0 <= b < self.num_items):
            ItemVector.c_get_ptr(self, a, <void **>&a_ptr)
            ItemVector.c_get_ptr(self, b, <void **>&b_ptr)
            for i in range(self.item_size):
                a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]

    @staticmethod
    cdef void c_resize(ItemVectorC *self, size_t new_max_items) except *:
        cdef char *new_items
        new_items = <char *>realloc(self.items, new_max_items * self.item_size)
        if new_items == NULL:
            raise MemoryError("ItemVectorC: cannot reallocate memory")
        self.items = new_items
        self.max_items = new_max_items