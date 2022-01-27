cdef float HASH_MAP_GROWTH_RATE = 2.0#same as vector
cdef float HASH_MAP_SHRINK_RATE = 0.5#same as vector
cdef float HASH_MAP_LOAD_FACTOR = 0.7
cdef float HASH_MAP_UNLOAD_FACTOR = 0.1

#Internal struct
ctypedef struct ItemC:
    uint64_t key
    uint64_t value
    bint used

cdef Error int_hash_map_init(IntHashMapC *hash_map) nogil:
    cdef:
        Error error
    
    error = vector_init(&hash_map.items, sizeof(ItemC))
    if error != NO_ERROR:
        return error
    hash_map.num_items = 0

cdef void int_hash_map_free(IntHashMapC *hash_map) nogil:
    vector_free(&hash_map.items)
    hash_map.num_items = 0

cdef void int_hash_map_insert(IntHashMapC *hash_map, uint64_t key, uint64_t value) nogil:
    cdef:
        size_t i
        uint64_t hashed_key
        size_t index
        ItemC *item_ptr
    
    int_hash_map_grow_if_needed(hash_map)
    hashed_key = int_hash_map_hash(key)

    for i in range(hash_map.items.max_items):
        index = (hashed_key + i) & (hash_map.items.max_items - 1)
        item_ptr = <ItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
        if item_ptr.used:
            if item_ptr.key == key:
                item_ptr.value = value
                return
        else:
            item_ptr.key = key
            item_ptr.value = value
            item_ptr.used = True
            hash_map.num_items += 1
            return

cdef void int_hash_map_remove(IntHashMapC *hash_map, uint64_t key) nogil:
    cdef:
        size_t index
        ItemC *item_ptr
    
    int_hash_map_shrink_if_needed(hash_map)
    int_hash_map_get_index(hash_map, key, &index)
    item_ptr = <ItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
    item_ptr.key = 0
    item_ptr.value = 0
    item_ptr.used = False
    hash_map.num_items -= 1

cdef uint64_t int_hash_map_get(IntHashMapC *hash_map, uint64_t key) nogil:
    cdef:
        size_t index
        ItemC *item_ptr
        
    int_hash_map_get_index(hash_map, key, &index)
    item_ptr = <ItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
    return item_ptr.value

cdef Error int_hash_map_get_index(IntHashMapC *hash_map, uint64_t key, size_t *index_ptr) nogil:
    cdef:
        size_t i
        uint64_t hashed_key
        size_t index
        ItemC *item_ptr
        
    hashed_key = int_hash_map_hash(key)
    for i in range(hash_map.items.max_items):
        index = (hashed_key + i) & (hash_map.items.max_items - 1)
        item_ptr = <ItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
        if item_ptr.used:
            if item_ptr.key == key:
                index_ptr[0] = index
    return INVALID_KEY_ERROR

cdef uint64_t int_hash_map_hash(uint64_t key) nogil:
    #Uses murmurhash-style finalizer
    cdef uint64_t out = key
    out ^= out >> 33
    out *= <uint64_t>0xFF51AFD7ED558CCD
    out ^= out >> 33
    out *= <uint64_t>0xC4CEB9FE1A85EC53
    out ^= out >> 33
    return out

cdef bint int_hash_map_contains(IntHashMapC *hash_map, uint64_t key) nogil:
    cdef:
        size_t i
        uint64_t hashed_key
        size_t index
        ItemC *item_ptr
        
    hashed_key = int_hash_map_hash(key)
    for i in range(hash_map.items.max_items):
        index = (hashed_key + i) & (hash_map.items.max_items - 1)
        item_ptr = <ItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
        if item_ptr.used:
            if item_ptr.key == key:
                return True
    return False

cdef void int_hash_map_grow_if_needed(IntHashMapC *hash_map) nogil:
    cdef size_t new_max_items
    if hash_map.num_items >= hash_map.items.max_items * HASH_MAP_LOAD_FACTOR:
        new_max_items = <size_t>(hash_map.items.max_items * HASH_MAP_GROWTH_RATE)
        int_hash_map_resize(hash_map, new_max_items)

cdef void int_hash_map_shrink_if_needed(IntHashMapC *hash_map) nogil:
    cdef size_t new_max_items
    if hash_map.num_items <= hash_map.items.max_items * HASH_MAP_UNLOAD_FACTOR:
        new_max_items = <size_t>(hash_map.items.max_items * HASH_MAP_SHRINK_RATE)
        int_hash_map_resize(hash_map, new_max_items)

cdef Error int_hash_map_resize(IntHashMapC *hash_map, size_t new_max_items) nogil: 
    cdef:
        ItemC *new_items
        uint64_t hashed_key
        size_t i, j
        size_t index
        ItemC *item_ptr
        ItemC *new_item_ptr
    
    new_items = <ItemC *>calloc(new_max_items, sizeof(ItemC))
    if new_items == NULL:
        return MEMORY_ERROR

    for i in range(hash_map.items.max_items):
        item_ptr = <ItemC *>(hash_map.items.items + (hash_map.items.item_size * i))
        hashed_key = int_hash_map_hash(item_ptr.key)
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

    free(hash_map.items.items)
    hash_map.items.items = <uint8_t *>new_items
    hash_map.items.max_items = new_max_items