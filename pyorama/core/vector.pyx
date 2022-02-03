DEF VECTOR_GROWTH_RATE = 2.0
DEF VECTOR_SHRINK_RATE = 0.5
DEF VECTOR_SHRINK_THRESHOLD = 0.25
DEF VECTOR_INITIAL_MAX_ITEMS = 4

cdef Error vector_init(VectorC *vector, size_t item_size) nogil:
    vector.max_items = VECTOR_INITIAL_MAX_ITEMS
    vector.item_size = item_size
    vector.num_items = 0
    vector.items = <uint8_t *>calloc(vector.max_items, vector.item_size)
    if vector.items == NULL:
        return MEMORY_ERROR

cdef void vector_free(VectorC *vector) nogil:
    vector.max_items = 0
    vector.item_size = 0
    vector.num_items = 0
    free(vector.items)
    vector.items = NULL

cdef Error vector_push_empty(VectorC *vector) nogil:
    cdef:
        uint8_t *item
        Error error
    
    error = vector_grow_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    item = vector.items + (vector.item_size * vector.num_items)
    memset(item, 0, vector.item_size)
    vector.num_items += 1

cdef Error vector_pop_empty(VectorC *vector) nogil:
    cdef:
        Error error
    
    if vector.num_items <= 0:
        return POP_EMPTY_ERROR
    error = vector_shrink_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    vector.num_items -= 1

cdef Error vector_push(VectorC *vector, void *item) nogil:
    cdef:
        Error error
    
    error = vector_grow_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    vector_set(vector, vector.num_items, item)
    vector.num_items += 1

cdef Error vector_pop(VectorC *vector, void *item) nogil:
    if vector.num_items <= 0:
        return POP_EMPTY_ERROR
    error = vector_shrink_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    vector_get(vector, vector.num_items - 1, item)
    vector.num_items -= 1

cdef void *vector_get_ptr_unsafe(VectorC *vector, size_t index) nogil:
    return vector.items + (vector.item_size * index)

cdef Error vector_get_ptr(VectorC *vector, size_t index, void **item_ptr) nogil:
    if 0 <= index < vector.max_items: 
        item_ptr[0] = vector.items + (vector.item_size * index)
    else:
        return INVALID_INDEX_ERROR

cdef Error vector_get(VectorC *vector, size_t index, void *item) nogil:
    cdef:
        uint8_t *src
    
    if 0 <= index < vector.max_items: 
        src = vector.items + (vector.item_size * index)
        memcpy(item, src, vector.item_size)
    else:
        return INVALID_INDEX_ERROR

cdef Error vector_set(VectorC *vector, size_t index, void *item) nogil:
    cdef:
        uint8_t *dst
    
    if 0 <= index < vector.max_items: 
        dst = vector.items + (vector.item_size * index)
        memcpy(dst, item, vector.item_size)
    else:
        return INVALID_INDEX_ERROR

cdef Error vector_clear(VectorC *vector, size_t index) nogil:
    cdef:
        uint8_t *dst
    
    if 0 <= index < vector.max_items:
        dst = vector.items + (vector.item_size * index)
        memset(dst, 0, vector.item_size)
    else:
        return INVALID_INDEX_ERROR

cdef void vector_clear_all(VectorC *vector) nogil:
    memset(vector.items, 0, vector.max_items * vector.item_size)

cdef Error vector_swap(VectorC *vector, size_t a, size_t b) nogil:
    cdef:
        uint8_t *a_ptr
        uint8_t *b_ptr
        size_t i
        Error error

    error = vector_get_ptr(vector, a, <void **>&a_ptr)
    if error == INVALID_INDEX_ERROR:
        return error
    error = vector_get_ptr(vector, b, <void **>&b_ptr)
    if error == INVALID_INDEX_ERROR:
        return error
    for i in range(vector.item_size):
        a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]

cdef Error vector_resize(VectorC *vector, size_t new_max_items) nogil:
    cdef:
        uint8_t *new_items
        uint8_t *clear_start
        size_t clear_size
    
    new_items = <uint8_t *>realloc(vector.items, new_max_items * vector.item_size)
    if new_items == NULL:
        return MEMORY_ERROR
    if new_max_items > vector.max_items:
        clear_start = new_items + (vector.item_size * vector.max_items)
        clear_size = (new_max_items - vector.max_items) * vector.item_size
        memset(clear_start, 0, clear_size)
    vector.items = new_items
    vector.max_items = new_max_items

cdef Error vector_grow_if_needed(VectorC *vector) nogil:
    cdef:
        size_t new_max_items
        Error error
    
    if vector.num_items >= vector.max_items:
        new_max_items = <size_t>(vector.max_items * VECTOR_GROWTH_RATE)
        error = vector_resize(vector, new_max_items)
        if error == MEMORY_ERROR:
            return error

cdef Error vector_shrink_if_needed(VectorC *vector) nogil:
    cdef:
        size_t new_max_items
        Error error
    
    if vector.num_items < vector.max_items * VECTOR_SHRINK_THRESHOLD:
        new_max_items = <size_t>(vector.max_items * VECTOR_SHRINK_RATE)
        error = vector_resize(vector, new_max_items)
        if error == MEMORY_ERROR:
            return error

cdef Error vector_insert_empty(VectorC *vector, size_t index) nogil:
    cdef:
        void *dst
        void *src
        size_t size
        Error error

    error = vector_grow_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    error = vector_get_ptr(vector, index + 1, &dst)
    if error == INVALID_INDEX_ERROR:
        return error
    error = vector_get_ptr(vector, index, &src)
    if error == INVALID_INDEX_ERROR:
        return error
    size = (vector.num_items - index) * vector.item_size
    memmove(dst, src, size)
    memset(src, 0, vector.item_size)
    vector.num_items += 1

cdef Error vector_insert(VectorC *vector, size_t index, void *item) nogil:
    cdef:
        void *dst
        void *src
        size_t size
        Error error
        
    error = vector_grow_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    error = vector_get_ptr(vector, index + 1, &dst)
    if error == INVALID_INDEX_ERROR:
        return error
    error = vector_get_ptr(vector, index, &src)
    if error == INVALID_INDEX_ERROR:
        return error
    size = (vector.num_items - index) * vector.item_size
    memmove(dst, src, size)
    memcpy(src, item, vector.item_size)
    vector.num_items += 1

cdef Error vector_remove_empty(VectorC *vector, size_t index) nogil:
    cdef:
        void *dst
        void *src
        size_t size
        Error error
    
    if vector.num_items <= 0:
        return POP_EMPTY_ERROR
    error = vector_shrink_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    if error == MEMORY_ERROR:
        return error
    error = vector_get_ptr(vector, index, &dst)
    if error == INVALID_INDEX_ERROR:
        return error
    error = vector_get_ptr(vector, index + 1, &src)
    if error == INVALID_INDEX_ERROR:
        return error
    size = (vector.num_items - index - 1) * vector.item_size
    memmove(dst, src, size)
    vector.num_items -= 1

cdef Error vector_remove(VectorC *vector, size_t index, void *item) nogil:
    cdef:
        void *dst
        void *src
        size_t size
        Error error
    
    if vector.num_items <= 0:
        return POP_EMPTY_ERROR
    error = vector_shrink_if_needed(vector)
    if error == MEMORY_ERROR:
        return error
    error = vector_get(vector, index, item)
    if error == INVALID_INDEX_ERROR:
        return error
    error = vector_get_ptr(vector, index, &dst)
    if error == INVALID_INDEX_ERROR:
        return error
    error = vector_get_ptr(vector, index + 1, &src)
    if error == INVALID_INDEX_ERROR:
        return error
    size = (vector.num_items - index - 1) * vector.item_size
    memmove(dst, src, size)
    vector.num_items -= 1

cdef Error vector_find(VectorC *vector, void *item, size_t *index) nogil:
    cdef:
        size_t i
        void *test_item
        int check
        Error error
    
    for i in range(vector.num_items):
        test_item = vector_get_ptr_unsafe(vector, i)
        check = memcmp(test_item, item, vector.item_size)
        if check == 0:
            index[0] = i
            return NO_ERROR
    return ITEM_NOT_FOUND_ERROR

cdef bint vector_contains(VectorC *vector, void *item) nogil:
    cdef:
        size_t i
        void *test_item
        int check
    for i in range(vector.num_items):
        test_item = vector_get_ptr_unsafe(vector, i)
        check = memcmp(test_item, item, vector.item_size)
        if check == 0:
            return True
    return False