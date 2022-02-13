import random
import time
from pyorama.algs.radix_sort cimport *
from pyorama.core.vector cimport *
from pyorama.math.random cimport *
from pyorama.libs.c cimport *

cdef void print_vector(VectorC *vector, RadixSortType type_) except *:
    cdef:
        list data = []
        size_t i
        size_t j
        void *item
    
    for i in range(vector.num_items):
        vector_get_ptr(vector, i, &item)
        if type_ == RADIX_SORT_TYPE_U8:
            data.append((<uint8_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_I8:
            data.append((<int8_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_U16:
            data.append((<uint16_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_I16:
            data.append((<int16_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_U32:
            data.append((<uint32_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_I32:
            data.append((<int32_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_U64:
            data.append((<uint64_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_I64:
            data.append((<int64_t *>item)[0])
        elif type_ == RADIX_SORT_TYPE_F32:
            data.append((<float *>item)[0])
        elif type_ == RADIX_SORT_TYPE_F64:
            data.append((<double *>item)[0])
        elif type_ == RADIX_SORT_TYPE_STR:
            data.append((<char **>item)[0])
    print(data)

cdef void print_vector_u8(VectorC *vector) except *:
    cdef:
        list data = []
        size_t i
        size_t j
        void *item
        uint8_t b
    
    for i in range(vector.num_items):
        vector_get_ptr(vector, i, &item)
        b = (<uint16_t *>item)[0]
        for j in range(vector.item_size):
            b = (<uint8_t *>item + j)[0]
            data.append(b)
    
    print(data)

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

cdef void c_random_get_alpha_num_str(char *dst, size_t length):
    cdef:
        char *char_set = "0123456789" \
                "abcdefghijklmnopqrstuvwxyz" \
                "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        size_t num_chars = (10 + 26 + 26) / sizeof(char)
        uint8_t index
        size_t pos = 0
    
    while pos < length - 1:
        index = c_random_get_range_u8(0, num_chars)
        dst[pos] = char_set[index]
        pos += 1
    dst[pos] = b'\0'
    #print(length, pos, dst)

cdef void test_type(RadixSortType type_, size_t type_size, cmp_func_t cmp_func, bint print_vectors) except *:
    cdef:
        size_t i
        uint8_t *item
        VectorC data
        VectorC data_copy
        char *rand_str
        uint8_t rand_str_len
        uint8_t min_str_len = 20
        uint8_t max_str_len = 50
        float rand_f32
        double rand_f64
        uint8_t *a
        uint8_t *b
        char *a_str
        char *b_str
        void *a_void
        void *b_void
        bint matches = True
        double start, end
        double radix_time
        double qsort_time

    item = <uint8_t *>calloc(1, type_size)
    if item == NULL:
        raise MemoryError()

    vector_init(&data, type_size)
    vector_init(&data_copy, type_size)
    if type_ == RADIX_SORT_TYPE_F32:
        for i in range(n):
            rand_f32 = c_random_get_f32()
            item = <uint8_t *>&rand_f32
            vector_push(&data, item)
            vector_push(&data_copy, item)
    elif type_ == RADIX_SORT_TYPE_F64:
        for i in range(n):
            rand_f64 = c_random_get_f64()
            item = <uint8_t *>&rand_f64
            vector_push(&data, item)
            vector_push(&data_copy, item)
    elif type_ == RADIX_SORT_TYPE_STR:
        for i in range(n):
            rand_str_len = c_random_get_range_u8(min_str_len, max_str_len)
            #print(rand_str_len)
            rand_str = <char *>calloc(rand_str_len, sizeof(char))
            if rand_str == NULL:
                raise MemoryError()
            c_random_get_alpha_num_str(rand_str, rand_str_len)
            vector_push(&data, &rand_str)
            vector_push(&data_copy, &rand_str)
    else:
        for i in range(n):
            c_random_set_bytes(item, type_size)
            vector_push(&data, item)
            vector_push(&data_copy, item)
    if print_vectors:
        print_vector(&data, type_)
        #print_vector_u8(&data)

    #radix_sort
    start = time.time()
    c_radix_sort(data.items, data.item_size, 0, data.num_items, 0, type_)
    end = time.time()
    radix_time = end - start
    if print_vectors:
        print_vector(&data, type_)
        #print_vector_u8(&data)

    #qsort
    start = time.time()
    qsort(data_copy.items, n, type_size, cmp_func)
    end = time.time()
    qsort_time = end - start
    if print_vectors:
        print_vector(&data_copy, type_)
        #print_vector_u8(&data_copy)

    if type_ != RADIX_SORT_TYPE_STR:
        for i in range(n):
            vector_get_ptr(&data, i, <void **>&a)
            vector_get_ptr(&data_copy, i, <void **>&b)
            check = memcmp(a, b, type_size)
            if check != 0:
                matches = False
                break
    else:
        for i in range(n):
            vector_get_ptr(&data, i, &a_void)
            vector_get_ptr(&data_copy, i, &b_void)
            a_str = (<char **>a_void)[0]
            b_str = (<char **>b_void)[0]
            check = strcmp(a_str, b_str)
            #print(i, a_str, b_str, check)
            if check != 0:
                matches = False
                print_vector(&data, type_)
                print_vector(&data_copy, type_)
                import os; os._exit(-1)
                break
    
    vector_free(&data)
    vector_free(&data_copy)
    print(
        radix_time, qsort_time, qsort_time / radix_time, 
        (radix_time/n) * (10 ** 9), 
        (qsort_time/n) * (10 ** 9), 
        matches,
    )

cdef:
    size_t num_repeats = 1
    size_t num_steps = 24
    size_t i, j, n
    bint print_vectors = False

c_random_set_seed_from_time()
for i in range(num_steps):
    n = 2 ** (i + 1)
    for j in range(num_repeats):
        print("step:", i, "count:", n, "repeat:", j)
        test_type(RADIX_SORT_TYPE_U8, sizeof(uint8_t), cmp_func_u8, print_vectors)
        test_type(RADIX_SORT_TYPE_I8, sizeof(int8_t), cmp_func_i8, print_vectors)
        test_type(RADIX_SORT_TYPE_U16, sizeof(uint16_t), cmp_func_u16, print_vectors)
        test_type(RADIX_SORT_TYPE_I16, sizeof(int16_t), cmp_func_i16, print_vectors)
        test_type(RADIX_SORT_TYPE_U32, sizeof(uint32_t), cmp_func_u32, print_vectors)
        test_type(RADIX_SORT_TYPE_I32, sizeof(int32_t), cmp_func_i32, print_vectors)
        test_type(RADIX_SORT_TYPE_U64, sizeof(uint64_t), cmp_func_u64, print_vectors)
        test_type(RADIX_SORT_TYPE_I64, sizeof(int64_t), cmp_func_i64, print_vectors)
        test_type(RADIX_SORT_TYPE_F32, sizeof(float), cmp_func_f32, print_vectors)
        test_type(RADIX_SORT_TYPE_F64, sizeof(double), cmp_func_f64, print_vectors)
        test_type(RADIX_SORT_TYPE_STR, sizeof(char *), cmp_func_str, print_vectors)
        print("")