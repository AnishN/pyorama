DEF HASH_MAP_GROWTH_RATE = 2.0#same as vector
DEF HASH_MAP_SHRINK_RATE = 0.5#same as vector
DEF HASH_MAP_LOAD_FACTOR = 0.7
DEF HASH_MAP_UNLOAD_FACTOR = 0.1

#internal convenience function
cdef bint item_match(StrHashMapItemC *item_ptr, char *key, size_t key_len, uint64_t hashed_key) nogil:
    if item_ptr.hashed_key == hashed_key and item_ptr.key_len == key_len:
        if memcmp(item_ptr.key, key, key_len) == 0:
            return True
    return False

cdef void item_set(StrHashMapItemC *item_ptr, char *key, size_t key_len, uint64_t hashed_key, uint64_t value, bint used) nogil:
    item_ptr.key = key
    item_ptr.key_len = key_len
    item_ptr.hashed_key = hashed_key
    item_ptr.value = value
    item_ptr.used = used

cdef Error str_hash_map_init(StrHashMapC *hash_map) nogil:
    cdef:
        Error error
    
    error = vector_init(&hash_map.items, sizeof(StrHashMapItemC))
    if error != NO_ERROR:
        return error
    hash_map.num_items = 0

cdef void str_hash_map_free(StrHashMapC *hash_map) nogil:
    vector_free(&hash_map.items)
    hash_map.num_items = 0

cdef void str_hash_map_insert(StrHashMapC *hash_map, char *key, size_t key_len, uint64_t value) nogil:
    cdef:
        size_t i
        uint64_t hashed_key
        size_t index
        StrHashMapItemC *item_ptr
    
    str_hash_map_grow_if_needed(hash_map)
    hashed_key = str_hash_map_hash(key, key_len)

    for i in range(hash_map.items.max_items):
        index = (hashed_key + i) & (hash_map.items.max_items - 1)
        item_ptr = <StrHashMapItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
        if item_ptr.used:
            if item_match(item_ptr, key, key_len, hashed_key):
                item_ptr.value = value
        else:
            item_set(item_ptr, key, key_len, hashed_key, value, True)
            hash_map.num_items += 1
            return

cdef void str_hash_map_remove(StrHashMapC *hash_map, char *key, size_t key_len) nogil:
    cdef:
        size_t index
        StrHashMapItemC *item_ptr
    
    str_hash_map_shrink_if_needed(hash_map)
    str_hash_map_get_index(hash_map, key, key_len, &index)
    item_ptr = <StrHashMapItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
    item_set(item_ptr, NULL, 0, 0, 0, False)
    hash_map.num_items -= 1

cdef uint64_t str_hash_map_get(StrHashMapC *hash_map, char *key, size_t key_len) nogil:
    cdef:
        size_t index
        StrHashMapItemC *item_ptr
        
    str_hash_map_get_index(hash_map, key, key_len, &index)
    item_ptr = <StrHashMapItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
    return item_ptr.value

cdef Error str_hash_map_get_index(StrHashMapC *hash_map, char *key, size_t key_len, size_t *index_ptr) nogil:
    cdef:
        size_t i
        uint64_t hashed_key
        size_t index
        StrHashMapItemC *item_ptr
        
    hashed_key = str_hash_map_hash(key, key_len)
    for i in range(hash_map.items.max_items):
        index = (hashed_key + i) & (hash_map.items.max_items - 1)
        item_ptr = <StrHashMapItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
        if item_ptr.used:
            if item_match(item_ptr, key, key_len, hashed_key):
                index_ptr[0] = index
                return NO_ERROR
    return INVALID_KEY_ERROR

cdef uint64_t str_hash_map_hash(char *key, size_t key_len) nogil:
    return XXH3_64bits(key, key_len)

cdef bint str_hash_map_contains(StrHashMapC *hash_map, char *key, size_t key_len) nogil:
    cdef:
        size_t i
        uint64_t hashed_key
        size_t index
        StrHashMapItemC *item_ptr
        
    hashed_key = str_hash_map_hash(key, key_len)
    for i in range(hash_map.items.max_items):
        index = (hashed_key + i) & (hash_map.items.max_items - 1)
        item_ptr = <StrHashMapItemC *>(hash_map.items.items + (hash_map.items.item_size * index))
        if item_ptr.used:
            if item_match(item_ptr, key, key_len, hashed_key):
                return True
    return False

cdef void str_hash_map_grow_if_needed(StrHashMapC *hash_map) nogil:
    cdef size_t new_max_items
    if hash_map.num_items >= hash_map.items.max_items * HASH_MAP_LOAD_FACTOR:
        new_max_items = <size_t>(hash_map.items.max_items * HASH_MAP_GROWTH_RATE)
        str_hash_map_resize(hash_map, new_max_items)

cdef void str_hash_map_shrink_if_needed(StrHashMapC *hash_map) nogil:
    cdef size_t new_max_items
    if hash_map.num_items <= hash_map.items.max_items * HASH_MAP_UNLOAD_FACTOR:
        new_max_items = <size_t>(hash_map.items.max_items * HASH_MAP_SHRINK_RATE)
        str_hash_map_resize(hash_map, new_max_items)

cdef Error str_hash_map_resize(StrHashMapC *hash_map, size_t new_max_items) nogil: 
    cdef:
        StrHashMapItemC *new_items
        uint64_t hashed_key
        size_t i, j
        size_t index
        StrHashMapItemC *item_ptr
        StrHashMapItemC *new_item_ptr
    
    new_items = <StrHashMapItemC *>calloc(new_max_items, sizeof(StrHashMapItemC))
    if new_items == NULL:
        return MEMORY_ERROR

    for i in range(hash_map.items.max_items):
        item_ptr = <StrHashMapItemC *>(hash_map.items.items + (hash_map.items.item_size * i))
        hashed_key = item_ptr.hashed_key#str_hash_map_hash(item_ptr.key)
        if item_ptr.used:
            for j in range(new_max_items):
                index = (hashed_key + j) & (new_max_items - 1)
                new_item_ptr = new_items + index
                if new_item_ptr.used:
                    if item_match(new_item_ptr, item_ptr.key, item_ptr.key_len, item_ptr.hashed_key):
                        new_item_ptr.value = item_ptr.value
                        break
                else:
                    new_item_ptr.key = item_ptr.key
                    new_item_ptr.key_len = item_ptr.key_len
                    new_item_ptr.hashed_key = item_ptr.hashed_key
                    new_item_ptr.value = item_ptr.value
                    new_item_ptr.used = True
                    break

    free(hash_map.items.items)
    hash_map.items.items = <uint8_t *>new_items
    hash_map.items.max_items = new_max_items

cdef Error str_hash_map_extend(StrHashMapC *hash_map_a, StrHashMapC *hash_map_b, bint overwrite=True) nogil:
    cdef:
        size_t i, j
        size_t index
        StrHashMapItemC *item_ptr_a
        StrHashMapItemC *item_ptr_b
        char *key
        size_t key_len
        uint64_t hashed_key
        uint64_t value

    for i in range(hash_map_b.items.max_items):
        item_ptr_b = <StrHashMapItemC *>(hash_map_b.items.items + (hash_map_b.items.item_size * i))
        if item_ptr_b.used:
            key = item_ptr_b.key
            key_len = item_ptr_b.key_len
            hashed_key = item_ptr_b.hashed_key
            value = item_ptr_b.value

            for j in range(hash_map_a.items.max_items):
                str_hash_map_grow_if_needed(hash_map_a)
                index = (hashed_key + j) & (hash_map_a.items.max_items - 1)
                item_ptr_a = <StrHashMapItemC *>(hash_map_a.items.items + (hash_map_a.items.item_size * index))
                if item_ptr_a.used:
                    if item_match(item_ptr_a, key, key_len, hashed_key):
                        if overwrite:
                            item_ptr_a.value = value
                        break
                else:
                    item_set(item_ptr_a, key, key_len, hashed_key, value, True)
                    hash_map_a.num_items += 1
                    break