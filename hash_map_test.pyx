from pyorama.core.item_hash_map cimport *
from old_hash_map cimport ItemHashMap as OldHashMap
import time
import numpy as np

cdef:
    ItemHashMap hash_map
    OldHashMap old_map
    dict d
    uint64_t k
    uint64_t v
    uint64_t out_sum = 0
    size_t i
    size_t j
    ItemC *item_ptr
    size_t n = 1000000
    uint64_t[:] test

test = np.random.randint(2**64, size=n, dtype=np.uint64)
d = {}
hash_map = ItemHashMap()
old_map = OldHashMap()

start = time.time()
for i in range(n):
    k = test[i]
    v = test[i]
    d[k] = v
end = time.time()
print(end - start)

out_sum = 0
start = time.time()
for i in range(n):
    k = test[i]
    out_sum += <uint64_t>d[k]
end = time.time()
print(end - start, out_sum)

start = time.time()
for i in range(n):
    k = test[i]
    del d[k]
end = time.time()
print(end - start)


start = time.time()
for i in range(n):
    k = test[i]
    v = test[i]
    hash_map.c_insert(k, v)
end = time.time()
print(end - start)

out_sum = 0
start = time.time()
for i in range(n):
    k = test[i]
    out_sum += hash_map.c_get(k)
end = time.time()
print(end - start, out_sum)

start = time.time()
for i in range(n):
    k = test[i]
    hash_map.c_remove(k)
end = time.time()
print(end - start)


start = time.time()
for i in range(n):
    k = test[i]
    v = test[i]
    old_map.c_insert(k, v)
end = time.time()
print(end - start)

out_sum = 0
start = time.time()
for i in range(n):
    k = test[i]
    out_sum += old_map.c_get(k)
end = time.time()
print(end - start, out_sum)

start = time.time()
for i in range(n):
    k = test[i]
    old_map.c_remove(k)
end = time.time()
print(end - start)