DEF RADIX = 256
DEF RADIX_THRESHOLD = 128

ctypedef struct RadixPartitionTableC:
    size_t[RADIX] counts
    size_t[RADIX + 1] prefix_sums
    size_t[RADIX + 1] shifted_sums

cdef void table_clear(RadixPartitionTableC *table) except *:
    memset(table.counts, 0, sizeof(size_t) * RADIX)
    memset(table.prefix_sums, 0, sizeof(size_t) * (RADIX + 1))
    memset(table.shifted_sums, 0, sizeof(size_t) * (RADIX + 1))

cdef void item_swap(void *items, size_t a, size_t b, size_t size) except *:
    cdef:
        size_t i
        uint8_t *a_ptr = <uint8_t *>items + (a * size)
        uint8_t *b_ptr = <uint8_t *>items + (b * size)
    for i in range(size):
        a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]

cdef int cmp_func_u8(void *a, void *b) nogil:
    cdef:
        uint8_t a_i = (<uint8_t *>a)[0]
        uint8_t b_i = (<uint8_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_i8(void *a, void *b) nogil:
    cdef:
        int8_t a_i = (<int8_t *>a)[0]
        int8_t b_i = (<int8_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_u16(void *a, void *b) nogil:
    cdef:
        uint16_t a_i = (<uint16_t *>a)[0]
        uint16_t b_i = (<uint16_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_i16(void *a, void *b) nogil:
    cdef:
        int16_t a_i = (<int16_t *>a)[0]
        int16_t b_i = (<int16_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_u32(void *a, void *b) nogil:
    cdef:
        uint32_t a_i = (<uint32_t *>a)[0]
        uint32_t b_i = (<uint32_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_i32(void *a, void *b) nogil:
    cdef:
        int32_t a_i = (<int32_t *>a)[0]
        int32_t b_i = (<int32_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_u64(void *a, void *b) nogil:
    cdef:
        uint64_t a_i = (<uint64_t *>a)[0]
        uint64_t b_i = (<uint64_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_i64(void *a, void *b) nogil:
    cdef:
        int64_t a_i = (<int64_t *>a)[0]
        int64_t b_i = (<int64_t *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_f32(void *a, void *b) nogil:
    cdef:
        float a_i = (<float *>a)[0]
        float b_i = (<float *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_f64(void *a, void *b) nogil:
    cdef:
        double a_i = (<double *>a)[0]
        double b_i = (<double *>b)[0]
    if a_i < b_i: return -1
    elif a_i > b_i: return 1
    else: return 0

cdef int cmp_func_str(void *a, void *b) nogil:
    cdef:
        char *a_i = (<char **>a)[0]
        char *b_i = (<char **>b)[0]
    return strcmp(a_i, b_i)

cdef uint8_t radix_key_func_u8(void *item, size_t byte_offset) except *:
    return (<uint8_t *>item + byte_offset)[0]

cdef uint8_t radix_key_func_i8(void *item, size_t byte_offset) except *:
    return (<uint8_t *>item + byte_offset)[0] + 128

cdef uint8_t radix_key_func_u16(void *item, size_t byte_offset) except *:
    return (<uint8_t *>item + byte_offset)[0]

cdef uint8_t radix_key_func_i16(void *item, size_t byte_offset) except *:
    cdef:
        uint16_t value
    value = (<uint16_t *>item)[0] + 32768
    return (<uint8_t *>&value + byte_offset)[0]

cdef uint8_t radix_key_func_u32(void *item, size_t byte_offset) except *:
    return (<uint8_t *>item + byte_offset)[0]

cdef uint8_t radix_key_func_i32(void *item, size_t byte_offset) except *:
    cdef:
        uint32_t value
    value = (<int32_t *>item)[0] + <int32_t>2147483648
    return (<uint8_t *>&value + byte_offset)[0]

cdef uint8_t radix_key_func_u64(void *item, size_t byte_offset) except *:
    return (<uint8_t *>item + byte_offset)[0]

cdef uint8_t radix_key_func_i64(void *item, size_t byte_offset) except *:
    cdef:
        uint64_t value
    value = (<int64_t *>item)[0] + <int64_t>9223372036854775808
    return (<uint8_t *>&value + byte_offset)[0]

cdef uint8_t radix_key_func_f32(void *item, size_t byte_offset) except *:
    cdef:
        uint32_t value#should be same width as float
        uint32_t mask
        uint32_t shifted_value
    value = (<uint32_t *>item)[0]
    mask = -<int32_t>(value >> <uint32_t>31) | <uint32_t>2147483648
    shifted_value = value ^ mask
    return (<uint8_t *>(&shifted_value) + byte_offset)[0]
    #return (<uint8_t *>item + byte_offset)[0]

cdef uint8_t radix_key_func_f64(void *item, size_t byte_offset) except *:
    cdef:
        uint64_t value#should be same width as float
        uint64_t mask
        uint64_t shifted_value
    value = (<uint64_t *>item)[0]
    mask = -<int64_t>(value >> <uint64_t>63) | <uint64_t>9223372036854775808
    shifted_value = value ^ mask
    return (<uint8_t *>(&shifted_value) + byte_offset)[0]
    #return (<uint8_t *>item + byte_offset)[0]

cdef uint8_t radix_key_func_str(void *item, size_t byte_offset) except *:
    return ((<uint8_t **>item)[0] + byte_offset)[0]


cdef void c_radix_sort(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, RadixSortType type_, RadixKeyFuncC key_func=NULL) except *:
    cdef:
        size_t i, j, k, m
        uint8_t item
        size_t count
        size_t offset = 0
        RadixPartitionTableC table
        size_t[RADIX] counts
        size_t part_start
        size_t part_end
    
    if type_ == RADIX_SORT_TYPE_U8:
        c_radix_sort_u8(items, item_size, start, end, start_offset, 0)
    elif type_ == RADIX_SORT_TYPE_I8:
        c_radix_sort_i8(items, item_size, start, end, start_offset, 0)
    elif type_ == RADIX_SORT_TYPE_U16:
        c_radix_sort_u16(items, item_size, start, end, start_offset, 1)#LSB comes first, MSB comes last
    elif type_ == RADIX_SORT_TYPE_I16:
        c_radix_sort_i16(items, item_size, start, end, start_offset, 1)
    elif type_ == RADIX_SORT_TYPE_U32:
        c_radix_sort_u32(items, item_size, start, end, start_offset, 3)
    elif type_ == RADIX_SORT_TYPE_I32:
        c_radix_sort_i32(items, item_size, start, end, start_offset, 3)
    elif type_ == RADIX_SORT_TYPE_U64:
        c_radix_sort_u64(items, item_size, start, end, start_offset, 7)
    elif type_ == RADIX_SORT_TYPE_I64:
        c_radix_sort_i64(items, item_size, start, end, start_offset, 7)
    elif type_ == RADIX_SORT_TYPE_F32:
        c_radix_sort_f32(items, item_size, start, end, start_offset, 3)
    elif type_ == RADIX_SORT_TYPE_F64:
        c_radix_sort_f64(items, item_size, start, end, start_offset, 7)
    elif type_ == RADIX_SORT_TYPE_STR:
        c_radix_sort_str(items, item_size, start, end, start_offset, 0)

cdef void c_radix_sort_u8(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(uint8_t), True, False,
        radix_key_func_u8, cmp_func_u8,
    )

cdef void c_radix_sort_i8(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(int8_t), True, False,
        radix_key_func_i8, cmp_func_i8,
    )

cdef void c_radix_sort_u16(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(uint16_t), True, False,
        radix_key_func_u16, cmp_func_u16,
    )

cdef void c_radix_sort_i16(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(int16_t), True, False,
        radix_key_func_i16, cmp_func_i16,
    )

cdef void c_radix_sort_u32(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(uint32_t), True, False,
        radix_key_func_u32,  cmp_func_u32,
    )

cdef void c_radix_sort_i32(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(int32_t), True, False,
        radix_key_func_i32, cmp_func_i32,
    )

cdef void c_radix_sort_u64(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(uint64_t), True, False,
        radix_key_func_u64, cmp_func_u64,
    )

cdef void c_radix_sort_i64(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(int64_t), True, False,
        radix_key_func_i64, cmp_func_i64,
    )

cdef void c_radix_sort_f32(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(float), True, False,
        radix_key_func_f32, cmp_func_f32,
    )

cdef void c_radix_sort_f64(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(double), True, False,
        radix_key_func_f64, cmp_func_f64,
    )

cdef void c_radix_sort_str(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset) except *:
    c_radix_sort_byte(
        items, item_size, start, end, start_offset,
        byte_offset, sizeof(char *), False, True,
        radix_key_func_str, cmp_func_str,
    )

cdef void c_radix_sort_byte(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, size_t byte_offset, size_t num_bytes, bint flip_byte_order, bint use_null_term, RadixKeyFuncC key_func, BackupCmpFuncC cmp_func) except *:
    cdef:
        size_t i
        void *item_ptr
        uint8_t item
        size_t total
        size_t prefix_sum
        size_t shifted_sum
        size_t a, b
        RadixPartitionTableC table
        size_t count
        size_t table_start
        size_t table_end
        int8_t byte_order = -1 if flip_byte_order else 1
    
    table_clear(&table)
    for i in range(start, end):
        item_ptr = (<uint8_t *>items) + (i * item_size)
        item = key_func(item_ptr, byte_offset)
        table.counts[item] += 1
    
    if use_null_term:
        table.counts[0] = 0
    
    total = 0
    for i in range(RADIX):
        total += table.counts[i]
        table.prefix_sums[i + 1] += total
        table.shifted_sums[i] = table.prefix_sums[i + 1]
    
    for i in range(start, end):
        while True:
            item_ptr = (<uint8_t *>items) + (i * item_size)
            item = key_func(item_ptr, byte_offset)
            #print(<char *>item_ptr, i, start, end, chr(item))
            prefix_sum = table.prefix_sums[item]
            shifted_sum = table.shifted_sums[item]
            if prefix_sum == shifted_sum:
                break
            a = i
            b = start + prefix_sum
            #print(i, item, prefix_sum, shifted_sum, a, b)
            #print("swapping", (<char **>items)[a], (<char **>items)[b])
            item_swap(items, a, b, item_size)
            table.prefix_sums[item] += 1

    if not flip_byte_order and byte_offset == num_bytes and not use_null_term:
        return
    elif flip_byte_order and byte_offset == 0 and not use_null_term:
        return
    else:
        total = 0
        for i in range(RADIX):
            count = table.counts[i]
            table_start = start + total
            table_end = start + total + count
            total += count
            if count >= RADIX_THRESHOLD:
                c_radix_sort_byte(items, item_size, table_start, table_end, start_offset, byte_offset + byte_order, num_bytes, flip_byte_order, use_null_term, key_func, cmp_func)
            elif count > 1:
                qsort(items + (item_size * table_start) + start_offset, table_end - table_start, item_size, cmp_func)