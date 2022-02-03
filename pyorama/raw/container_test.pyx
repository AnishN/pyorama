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
        size_t n
        uint8_t v

    vector_init(&data, sizeof(uint8_t))
    v = 5; vector_push(&data, &v)
    v = 10; vector_push(&data, &v)

    n = data.num_items
    for i in range(n):
        vector_get(&data, i, &v)
        print(i, n, v)
    
    vector_free(&data)

def slot_map_test():
    cdef:
        SlotMapC data
        uint8_t type_ = 123
        uint8_t v
        Handle h1
        Handle h2
    
    slot_map_init(&data, type_, sizeof(uint8_t))
    slot_map_create(&data, &h1)
    slot_map_create(&data, &h2)
    print(h1, h2)
    slot_map_free(&data)

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
vector_test()
slot_map_test()
int_hash_map_test()
str_hash_map_test()