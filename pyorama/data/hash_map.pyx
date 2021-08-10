cdef object KEY_ERROR = KeyError("HashMap: key not found")

cdef float HASH_MAP_GROWTH_RATE = 2.0#same as vector
cdef float HASH_MAP_SHRINK_RATE = 0.5#same as vector
cdef float HASH_MAP_LOAD_FACTOR = 0.7
cdef float HASH_MAP_UNLOAD_FACTOR = 0.1

#Internal struct
ctypedef struct ItemC:
    uint64_t key
    uint64_t value
    bint used

cdef class HashMap:
    def __cinit__(self):
        self.items = Vector()
    
    def __dealloc__(self):
        self.items = None

    cdef void c_init(self) except *:
        self.items.c_init(sizeof(ItemC))
        self.num_items = 0

    cdef void c_free(self) except *:
        self.items.c_free()
        self.num_items = 0

    cdef void c_insert(self, uint64_t key, uint64_t value) except *:
        cdef:
            size_t i
            uint64_t hashed_key
            size_t index
            ItemC *item_ptr
        
        self.c_grow_if_needed()
        hashed_key = self.c_hash(key)
        for i in range(self.items.max_items):
            index = (hashed_key + i) & (self.items.max_items - 1)
            item_ptr = <ItemC *>(self.items.items + (self.items.item_size * index))
            if item_ptr.used:
                if item_ptr.key == key:
                    item_ptr.value = value
                    return
            else:
                item_ptr.key = key
                item_ptr.value = value
                item_ptr.used = True
                self.num_items += 1
                return

    cdef void c_remove(self, uint64_t key) except *:
        cdef:
            size_t index
            ItemC *item_ptr
        
        self.c_shrink_if_needed()
        index = self.c_get_index(key)
        item_ptr = <ItemC *>(self.items.items + (self.items.item_size * index))
        item_ptr.key = 0
        item_ptr.value = 0
        item_ptr.used = False
        self.num_items -= 1

    cdef uint64_t c_get(self, uint64_t key) except *:
        cdef:
            size_t index
            ItemC *item_ptr
            
        index = self.c_get_index(key)
        item_ptr = <ItemC *>(self.items.items + (self.items.item_size * index))
        return item_ptr.value
    
    cdef size_t c_get_index(self, uint64_t key) except *:
        cdef:
            size_t i
            uint64_t hashed_key
            size_t index
            ItemC *item_ptr
            
        hashed_key = self.c_hash(key)
        for i in range(self.items.max_items):
            index = (hashed_key + i) & (self.items.max_items - 1)
            item_ptr = <ItemC *>(self.items.items + (self.items.item_size * index))
            if item_ptr.used:
                if item_ptr.key == key:
                    return index
        raise KEY_ERROR
    
    cdef uint64_t c_hash(self, uint64_t key) nogil:
        #Uses murmurhash-style finalizer
        cdef uint64_t out = key
        out ^= out >> 33
        out *= <uint64_t>0xFF51AFD7ED558CCD
        out ^= out >> 33
        out *= <uint64_t>0xC4CEB9FE1A85EC53
        out ^= out >> 33
        return out

    cdef bint c_contains(self, uint64_t key) nogil:
        cdef:
            size_t i
            uint64_t hashed_key
            size_t index
            ItemC *item_ptr
            
        hashed_key = self.c_hash(key)
        for i in range(self.items.max_items):
            index = (hashed_key + i) & (self.items.max_items - 1)
            item_ptr = <ItemC *>(self.items.items + (self.items.item_size * index))
            if item_ptr.used:
                if item_ptr.key == key:
                    return True
        return False

    cdef void c_grow_if_needed(self) except *:
        cdef size_t new_max_items
        if self.num_items >= self.items.max_items * HASH_MAP_LOAD_FACTOR:
            new_max_items = <size_t>(self.items.max_items * HASH_MAP_GROWTH_RATE)
            self.c_resize(new_max_items)

    cdef void c_shrink_if_needed(self) except *:
        cdef size_t new_max_items
        if self.num_items <= self.items.max_items * HASH_MAP_UNLOAD_FACTOR:
            new_max_items = <size_t>(self.items.max_items * HASH_MAP_SHRINK_RATE)
            self.c_resize(new_max_items)

    cdef void c_resize(self, size_t new_max_items) except *: 
        cdef:
            ItemC *new_items
            uint64_t hashed_key
            size_t i, j
            size_t index
            ItemC *item_ptr
            ItemC *new_item_ptr
        
        new_items = <ItemC *>calloc(new_max_items, sizeof(ItemC))
        if new_items == NULL:
            raise MemoryError()

        for i in range(self.items.max_items):
            item_ptr = <ItemC *>(self.items.items + (self.items.item_size * i))
            hashed_key = self.c_hash(item_ptr.key)
            if item_ptr.used:
                for j in range(new_max_items):
                    index = (hashed_key + j) & (new_max_items - 1)
                    new_item_ptr = new_items + index
                    if new_item_ptr.used:
                        if new_item_ptr.key == item_ptr.key:
                            new_item_ptr.value = item_ptr.value
                            break
                    else:
                        new_item_ptr.key = item_ptr.key
                        new_item_ptr.value = item_ptr.value
                        new_item_ptr.used = True
                        break

        free(self.items.items)
        self.items.items = <char *>new_items
        self.items.max_items = new_max_items

    """
    def print(self):
        cdef:
            size_t i
            ItemC *item
            list items = []
        for i in range(self.items.max_items):
            item = <ItemC *>self.items.c_get_ptr(i)
            items.append((i, item.key, item.value, item.used))
        print(items)
    """