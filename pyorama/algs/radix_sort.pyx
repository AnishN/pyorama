DEF RADIX = 256
DEF RADIX_THRESHOLD = 128

ctypedef struct RadixPartitionTableC:
    size_t[RADIX] counts
    size_t[RADIX + 1] prefix_sums
    size_t[RADIX + 1] shifted_sums

cdef void table_clear(RadixPartitionTableC *table) nogil:
    memset(table.counts, 0, sizeof(size_t) * RADIX)
    memset(table.prefix_sums, 0, sizeof(size_t) * (RADIX + 1))
    memset(table.shifted_sums, 0, sizeof(size_t) * (RADIX + 1))

cdef int cmp_func_u8(void *a, void *b) nogil:
    return (<uint8_t *>a)[0] - (<uint8_t *>b)[0]

cdef int cmp_func_i8(void *a, void *b) nogil:
    return (<int8_t *>a)[0] - (<int8_t *>b)[0]

cdef int cmp_func_u16(void *a, void *b) nogil:
    return (<uint16_t *>a)[0] - (<uint16_t *>b)[0]

cdef int cmp_func_i16(void *a, void *b) nogil:
    return (<int16_t *>a)[0] - (<int16_t *>b)[0]

cdef void item_swap(void *a, void *b, size_t size) nogil:
    cdef:
        size_t i
        uint8_t *a_u8 = <uint8_t *>a
        uint8_t *b_u8 = <uint8_t *>b
    for i in range(size):
        a_u8[i], b_u8[i] = b_u8[i], a_u8[i]

cdef void radix_key_func_u8(void *item, void *key_item) nogil:
    cdef:
        uint8_t value
    
    value = (<uint8_t *>item)[0]
    memcpy(key_item, &value, sizeof(uint8_t))

cdef void radix_key_func_i8(void *item, void *key_item) nogil:
    cdef:
        uint8_t value
    
    value = (<uint8_t *>item)[0] + 128
    memcpy(key_item, &value, sizeof(int8_t))

cdef void radix_key_func_u16(void *item, void *key_item) nogil:
    cdef:
        uint16_t value
    
    value = (<uint16_t *>item)[0]
    memcpy(key_item, &value, sizeof(uint16_t))

cdef void radix_key_func_i16(void *item, void *key_item) nogil:
    cdef:
        uint16_t value
    
    value = (<uint16_t *>item)[0] + 32768
    memcpy(key_item, &value, sizeof(uint16_t))

cdef void c_radix_sort(void *items, size_t start, size_t end, RadixSortType type_, RadixKeyFuncC key_func=NULL) nogil:
    cdef:
        size_t i
        uint8_t item
        size_t count
        size_t offset = 0
        RadixPartitionTableC table
        size_t[RADIX] counts
        size_t part_start
        size_t part_end
    
    if type_ == RADIX_SORT_TYPE_U8:
        c_radix_sort_byte(items, start, end, sizeof(uint8_t), 0, &table, radix_key_func_u8)
    elif type_ == RADIX_SORT_TYPE_I8:
        c_radix_sort_byte(items, start, end, sizeof(int8_t), 0, &table, radix_key_func_i8)
    elif type_ == RADIX_SORT_TYPE_U16:#LSB comes first, MSB comes last
        c_radix_sort_byte(items, start, end, sizeof(uint16_t), 1, &table, radix_key_func_u16)
        memcpy(&counts, &table.counts, sizeof(size_t) * RADIX)
        for i in range(RADIX):
            count = counts[i]
            if count > 1:
                part_start = start + offset
                part_end = start + offset + count
                c_radix_sort_byte(items, part_start, part_end, sizeof(uint16_t), 0, &table, radix_key_func_u16)
            offset += count
    elif type_ == RADIX_SORT_TYPE_I16:
        c_radix_sort_byte(items, start, end, sizeof(int16_t), 1, &table, radix_key_func_i16)
        memcpy(&counts, &table.counts, sizeof(size_t) * RADIX)
        for i in range(RADIX):
            count = counts[i]
            if count > 1:
                part_start = start + offset
                part_end = start + offset + count
                c_radix_sort_byte(items, part_start, part_end, sizeof(int16_t), 0, &table, radix_key_func_i16)
            offset += count

cdef void c_radix_sort_byte(void *items, size_t start, size_t end, size_t item_size, size_t offset, RadixPartitionTableC *table, RadixKeyFuncC key_func) nogil:
    cdef:
        size_t i
        void *item_ptr
        uint8_t item
        size_t total
        size_t prefix_sum
        size_t shifted_sum
        uint8_t[65536] key_item
        void *a
        void *b
    
    table_clear(table)
    for i in range(start, end):
        item_ptr = (<uint8_t *>items) + (i * item_size)
        key_func(item_ptr, &key_item)
        item = key_item[offset]
        #print(i, start, end, item, (<uint16_t *>item_ptr)[0])
        table.counts[item] += 1
        #print(i, start, end, i * item_size, item)

    #cumulative sum calculation to make offsets and shifted offsets
    total = 0
    for i in range(RADIX):
        total += table.counts[i]
        table.prefix_sums[i + 1] += total
        table.shifted_sums[i] = table.prefix_sums[i + 1]
    #print(table.counts)
    #print(table.prefix_sums)
    #print(table.shifted_sums)

    for i in range(start, end):
        while True:
            item_ptr = (<uint8_t *>items) + (i * item_size)
            key_func(item_ptr, &key_item)
            item = key_item[offset]
            prefix_sum = table.prefix_sums[item]
            shifted_sum = table.shifted_sums[item]
            #print(i, start, end, (<uint16_t *>item_ptr)[0], item, prefix_sum, shifted_sum)
            if prefix_sum == shifted_sum:
                break
            a = items + (i * item_size)
            b = items + ((start + prefix_sum)  * item_size)
            item_swap(a, b, item_size)
            table.prefix_sums[item] += 1