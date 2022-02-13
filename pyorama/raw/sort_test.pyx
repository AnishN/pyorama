import random
import time
from pyorama.algs.radix_sort cimport *
from pyorama.core.vector cimport *
from pyorama.math.random cimport *
from pyorama.libs.c cimport *

cdef void print_vector(VectorC *vector) except *:
    cdef:
        list data = []
        size_t i
        size_t j
        void *item
        #uint8_t b
        uint32_t b
    
    for i in range(vector.num_items):
        vector_get_ptr(vector, i, &item)
        b = (<uint32_t *>item)[0]
        data.append(b)
    print(data)

cdef void print_vector_u16(VectorC *vector) except *:
    cdef:
        list data = []
        size_t i
        size_t j
        void *item
        #uint8_t b
        uint16_t b
    
    for i in range(vector.num_items):
        vector_get_ptr(vector, i, &item)
        b = (<uint16_t *>item)[0]
        data.append(b)
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

cdef void test_type(RadixSortType type_, size_t type_size, cmp_func_t cmp_func, bint print_vectors) except *:
    cdef:
        size_t i
        uint8_t *item
        VectorC data
        VectorC data_copy
        uint8_t *a
        uint8_t *b
        bint matches = True
        double start, end
        double radix_time
        double qsort_time

    item = <uint8_t *>calloc(1, type_size)
    if item == NULL:
        raise MemoryError()

    vector_init(&data, type_size)
    vector_init(&data_copy, type_size)
    for i in range(n):
        c_random_set_bytes(item, type_size)
        vector_push(&data, item)
        vector_push(&data_copy, item)
    if print_vectors:
        print_vector(&data)
        print_vector_u8(&data)

    #radix_sort
    start = time.time()
    c_radix_sort(data.items, data.item_size, 0, data.num_items, type_)
    end = time.time()
    radix_time = end - start
    if print_vectors:
        print_vector(&data)
        print_vector_u8(&data)

    #qsort
    start = time.time()
    qsort(data_copy.items, n, type_size, cmp_func)
    end = time.time()
    qsort_time = end - start
    if print_vectors:
        print_vector(&data_copy)
        print_vector_u8(&data_copy)

    for i in range(n):
        vector_get_ptr(&data, i, <void **>&a)
        vector_get_ptr(&data_copy, i, <void **>&b)
        check = memcmp(a, b, type_size)
        if check != 0:
            matches = False
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
        print("")

"""
cdef:
    char **data
    list words
    size_t n
    size_t i

words = [
    b"apple",
    b"papaya",
    b"mango",
    b"guava",
    b"banana",
    b"pineapple",
]
n = len(words)
data = <char **>calloc(n, sizeof(char *))
for i in range(n):
    data[i] = <bytes>words[i]
radixSort(n, data)
for i in range(n):
    print(i, <bytes>data[i])
"""