import random
import time
from pyorama.algs.radix_sort cimport *
from pyorama.core.vector cimport *
from pyorama.math.random cimport *
from pyorama.libs.c cimport *

cdef int cmp_func_u8(void *a, void *b) nogil:
    return (<uint8_t *>a)[0] - (<uint8_t *>b)[0]

cdef int cmp_func_i8(void *a, void *b) nogil:
    return (<int8_t *>a)[0] - (<int8_t *>b)[0]

cdef void test_type(RadixSortType type_, size_t type_size, cmp_func_t cmp_func) except *:
    cdef:
        size_t i
        uint8_t *item
        VectorC data
        VectorC data_copy
        uint8_t *a
        uint8_t *b
        int check
    
    print("test", type_, type_size)
    #int random numbers
    item = <uint8_t *>calloc(1, type_size)
    if item == NULL:
        raise MemoryError()

    vector_init(&data, type_size)
    vector_init(&data_copy, type_size)
    for i in range(n):
        c_random_set_bytes(item, type_size)
        vector_push(&data, item)
        vector_push(&data_copy, item)
    
    #radix_sort
    start = time.time()
    c_radix_sort(data.items, data.num_items, type_)
    end = time.time()
    print("radix_sort", end - start)

    #c_sort
    start = time.time()
    qsort(data_copy.items, n, type_size, cmp_func)
    end = time.time()
    print("c_sort", end - start)

    for i in range(n):
        vector_get_ptr(&data, i, <void **>&a)
        vector_get_ptr(&data_copy, i, <void **>&b)
        check = memcmp(a, b, type_size)
        if check != 0:
            print(i, n, <uint8_t>a[0], <uint8_t>b[0], check)
            print("fail")
            break
    print("")
    #free random numbers
    vector_free(&data)
    vector_free(&data_copy)

cdef:
    size_t n = 1_000_000
    #size_t n = 10

c_random_set_seed_from_time()
while True:
    test_type(RADIX_SORT_TYPE_U8, sizeof(uint8_t), cmp_func_u8)
    test_type(RADIX_SORT_TYPE_I8, sizeof(int8_t), cmp_func_i8)