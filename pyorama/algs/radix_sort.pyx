DEF RADIX = 256

cdef void memswap(void *a, void *b, size_t size) nogil:
    cdef:
        size_t i
        uint8_t *a_u8 = <uint8_t *>a
        uint8_t *b_u8 = <uint8_t *>b
    for i in range(size):
        a_u8[i], b_u8[i] = b_u8[i], a_u8[i]

cdef uint8_t radix_key_func_u8(void *item) nogil:
    return (<uint8_t *>item)[0]

cdef uint8_t radix_key_func_i8(void *item) nogil:
    return (<uint8_t *>item)[0] + 128

cdef void c_radix_sort(void *items, size_t num_items, RadixSortType type_, size_t item_size=0, RadixKeyFuncC key_func=NULL) nogil:
    cdef:
        size_t i
        uint8_t item
        size_t[RADIX + 1] offsets
        size_t[RADIX + 1] shift_offsets
        size_t offset
        size_t shift_offset
    
    if type_ == RADIX_SORT_TYPE_U8:
        key_func = radix_key_func_u8
        item_size = sizeof(uint8_t)
    elif type_ == RADIX_SORT_TYPE_I8:
        key_func = radix_key_func_i8
        item_size = sizeof(int8_t)
    elif type_ == RADIX_SORT_TYPE_U16:
        pass

    #offsets are only counts at this point
    memset(offsets, 0, sizeof(size_t) * (RADIX + 1))
    for i in range(num_items):
        item = key_func(items + i)
        offsets[item + 1] += 1

    #cumulative sum calculation to make offsets and shifted offsets
    for i in range(RADIX):
        offsets[i + 1] += offsets[i]
        shift_offsets[i] = offsets[i + 1]
    
    for i in range(num_items):
        while True:
            item = key_func(items + i)
            offset = offsets[item]
            shift_offset = shift_offsets[item]
            if offset == shift_offset:
                break
            memswap(items + i, items + offset, item_size)
            offsets[item] += 1