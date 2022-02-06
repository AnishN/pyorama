import random
import time
from pyorama.algs.radix_sort cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *

cdef list get_data(uint8_t *data, size_t num_items):
    items_list = []
    for i in range(num_items):
        items_list.append(data[i])
    return items_list

cdef:
    size_t i
    size_t n = 10_000_000
    VectorC data
    VectorC data_copy
    uint8_t v

cdef int cmp_func(void *a, void *b) nogil:
    return (<uint8_t *>a)[0] - (<uint8_t *>b)[0]

while True:
    #int random numbers
    vector_init(&data, sizeof(uint8_t))
    vector_init(&data_copy, sizeof(uint8_t))
    for i in range(n):
        v = <uint8_t>random.randint(0, 255)
        vector_push(&data, &v)
        vector_push(&data_copy, &v)
    initial_data = get_data(data.items, n)
    #print(initial_data)
    
    #radix_sort
    start = time.time()
    c_radix_sort_u8(data.items, data.num_items)
    end = time.time()
    print("radix_sort", end - start)
    radix_sorted_data = get_data(data.items, n)
    #print(radix_sorted_data)

    #py_sort
    start = time.time()
    py_sorted_data = sorted(initial_data)
    end = time.time()
    print("py_sort", end - start)
    #print(py_sorted_data)

    #c_sort
    start = time.time()
    qsort(data_copy.items, n, sizeof(uint8_t), cmp_func)
    end = time.time()
    print("c_sort", end - start)
    c_sorted_data = get_data(data_copy.items, n)
    #print(c_sorted_data)
    print(radix_sorted_data == py_sorted_data == c_sorted_data)
    print("")

    #free random numbers
    vector_free(&data)
    vector_free(&data_copy)