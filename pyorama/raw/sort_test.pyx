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
        uint16_t b
    
    for i in range(vector.num_items):
        vector_get_ptr(vector, i, &item)
        b = (<uint16_t *>item)[0]
        data.append(b)
        #for j in range(vector.item_size):
        #    b = (<uint8_t *>item + j)[0]
        #    data.append(b)
    
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
    return (<uint8_t *>a)[0] - (<uint8_t *>b)[0]

cdef int cmp_func_i8(void *a, void *b) nogil:
    return (<int8_t *>a)[0] - (<int8_t *>b)[0]

cdef int cmp_func_u16(void *a, void *b) nogil:
    return (<uint16_t *>a)[0] - (<uint16_t *>b)[0]

cdef int cmp_func_i16(void *a, void *b) nogil:
    return (<int16_t *>a)[0] - (<int16_t *>b)[0]

cdef void test_type(RadixSortType type_, size_t type_size, cmp_func_t cmp_func) except *:
    cdef:
        size_t i
        uint8_t *item
        VectorC data
        VectorC data_copy
        uint8_t *a
        uint8_t *b
        int matches = True
        double start, end
        double radix_time
        double qsort_time
    
    #print("test", type_, type_size)
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
    c_radix_sort(data.items, 0, data.num_items, type_)
    end = time.time()
    radix_time = end - start

    #c_sort
    start = time.time()
    qsort(data_copy.items, n, type_size, cmp_func)
    end = time.time()
    qsort_time = end - start

    """
    for i in range(n):
        vector_get_ptr(&data, i, <void **>&a)
        vector_get_ptr(&data_copy, i, <void **>&b)
        check = memcmp(a, b, type_size)
        if check != 0:
            print("failed", i, n, <uint8_t>a[0], <uint8_t>b[0], check)
            matches = False
            break
    if matches:
        print("radix and python sorts match")
    else:
        print("radix and python sorts did not match")
    """
    #free random numbers
    vector_free(&data)
    vector_free(&data_copy)
    print(radix_time, qsort_time, qsort_time / radix_time)

cdef:
    size_t num_repeats = 3
    size_t num_steps = 6
    size_t i, j, n

c_random_set_seed_from_time()
for i in range(num_steps):
    n = 10 ** (i + 1)
    for j in range(num_repeats):
        print("step:", i, "count:", n, "repeat:", j)
        test_type(RADIX_SORT_TYPE_U8, sizeof(uint8_t), cmp_func_u8)
        test_type(RADIX_SORT_TYPE_I8, sizeof(int8_t), cmp_func_i8)
        test_type(RADIX_SORT_TYPE_U16, sizeof(uint16_t), cmp_func_u16)
        test_type(RADIX_SORT_TYPE_I16, sizeof(int16_t), cmp_func_i16)
        print("")