cdef Error array_init(ArrayC *array, size_t item_size, size_t max_items) nogil:
    array.max_items = max_items
    array.item_size = item_size
    array.items = <uint8_t *>calloc(array.max_items, array.item_size)
    if array.items == NULL:
        return MEMORY_ERROR

cdef void array_free(ArrayC *array) nogil:
    array.max_items = 0
    array.item_size = 0
    free(array.items)
    array.items = NULL

cdef void *array_get_ptr_unsafe(ArrayC *array, size_t index) nogil:
    return array.items + (array.item_size * index)

cdef Error array_get_ptr(ArrayC *array, size_t index, void **item_ptr) nogil:
    if 0 <= index < array.max_items: 
        item_ptr[0] = array.items + (array.item_size * index)
    else:
        return INVALID_INDEX_ERROR

cdef Error array_get(ArrayC *array, size_t index, void *item) nogil:
    cdef uint8_t *src
    if 0 <= index < array.max_items: 
        src = array.items + (array.item_size * index)
        memcpy(item, src, array.item_size)
    else:
        return INVALID_INDEX_ERROR

cdef Error array_set(ArrayC *array, size_t index, void *item) nogil:
    cdef uint8_t *dst
    if 0 <= index < array.max_items: 
        dst = array.items + (array.item_size * index)
        memcpy(dst, item, array.item_size)
    else:
        return INVALID_INDEX_ERROR

cdef Error array_clear(ArrayC *array, size_t index) nogil:
    cdef uint8_t *dst
    if 0 <= index < array.max_items:
        dst = array.items + (array.item_size * index)
        memset(dst, 0, array.item_size)
    else:
        return INVALID_INDEX_ERROR

cdef void array_clear_all(ArrayC *array) nogil:
    memset(array.items, 0, array.max_items * array.item_size)

cdef Error array_swap(ArrayC *array, size_t a, size_t b) nogil:
    cdef:
        uint8_t *a_ptr
        uint8_t *b_ptr
        size_t i
        Error error

    error = array_get_ptr(array, a, <void **>&a_ptr)
    if error == INVALID_INDEX_ERROR:
        return error
    error = array_get_ptr(array, b, <void **>&b_ptr)
    if error == INVALID_INDEX_ERROR:
        return error
    for i in range(array.item_size):
        a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]

cdef Error array_find(ArrayC *array, void *item, size_t *index) nogil:
    cdef:
        size_t i
        void *test_item
        int check
        Error error
    
    for i in range(array.max_items):
        test_item = array_get_ptr_unsafe(array, i)
        check = memcmp(test_item, item, array.item_size)
        if check == 0:
            index[0] = i
            return NO_ERROR
    return ITEM_NOT_FOUND_ERROR

cdef bint array_contains(ArrayC *array, void *item) nogil:
    cdef:
        size_t i
        void *test_item
        int check
    for i in range(array.max_items):
        test_item = array_get_ptr_unsafe(array, i)
        check = memcmp(test_item, item, array.item_size)
        if check == 0:
            return True
    return False