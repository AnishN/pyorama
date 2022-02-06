import time
from pyorama.core.array cimport *
from pyorama.core.handle cimport *
from pyorama.core.int_hash_map cimport *
from pyorama.core.slot_map cimport *
from pyorama.core.str_hash_map cimport *
from pyorama.core.vector cimport *

print("container_test")

def handle_test():
    cdef:
        uint32_t h_index = 123
        uint32_t h_version = 5
        uint8_t h_type = 10
        bint h_free = False
        uint32_t 
        Handle h

    handle_set(&h, h_index, h_version, h_type, h_free)
    print(h, h_index, h_version, h_type, h_free)
    print("index", handle_get_index(&h))
    print("version", handle_get_version(&h))
    print("type", handle_get_type(&h))
    print("free", handle_get_free(&h))

def vector_test():
    cdef:
        VectorC data
        size_t i
        size_t n = 10000000
        uint64_t s = 0
        uint64_t v

    vector_init(&data, sizeof(uint64_t))

    for i in range(n):
        v = 5; vector_push(&data, &v)

    start = time.time()
    n = data.num_items
    for i in range(n):
        vector_get(&data, i, &v)
        s += v
        #print(i, n, v)
    end = time.time()
    print(end - start, s)
    vector_free(&data)

def slot_map_test():
    cdef:
        SlotMapC data
        uint8_t type_ = 123
        uint64_t v
        size_t n = 10000000
        uint64_t s = 0
        Handle *h
        VectorC *items_ptr
    
    h = <Handle *>calloc(n, sizeof(Handle))
    if h == NULL:
        raise MemoryError()
    slot_map_init(&data, type_, sizeof(uint64_t))

    start = time.time()
    for i in range(n):
        slot_map_create(&data, &h[i])
    end = time.time()
    print(end - start)

    start = time.time()
    for i in range(n):
        slot_map_get_ptr(&data, h[i], <void **>&v)
        s += v
    end = time.time()
    print(end - start)

    start = time.time()
    for i in range(n):
        v = (<uint64_t *>slot_map_get_ptr_unsafe(&data, h[i]))[0]
        s += v
    end = time.time()
    print(end - start)

    start = time.time()
    items_ptr = &data.items
    for i in range(n):
        vector_get(items_ptr, i, &v)
        s += v
    end = time.time()
    print(end - start, s)

    slot_map_free(&data)
    free(h)

def int_hash_map_test():
    cdef:
        IntHashMapC data
        uint64_t k = 1234
        uint64_t v = 456
        uint64_t a
        size_t i
        ItemC item

    CHECK_ERROR(int_hash_map_init(&data))
    CHECK_ERROR(int_hash_map_insert(&data, k, v))
    CHECK_ERROR(int_hash_map_get_index(&data, k, &i))
    CHECK_ERROR(vector_get(&data.items, i, &item))
    CHECK_ERROR(int_hash_map_get(&data, k, &a))
    print(k, v, a, int_hash_map_hash(k), i, item)
    int_hash_map_free(&data)

def str_hash_map_test():
    pass

handle_test()
slot_map_test()
vector_test()
int_hash_map_test()
str_hash_map_test()