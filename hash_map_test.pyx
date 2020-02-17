# distutils: language = c++
from pyorama.core.item_hash_map cimport *
import time
import numpy as np
from libcpp.unordered_map cimport unordered_map

cdef:
    dict d
    unordered_map[uint64_t, uint64_t] c_map
    ItemHashMap hash_map
    uint64_t k
    uint64_t v
    uint64_t out_sum = 0
    size_t i
    size_t n = 1000000
    uint64_t[:] test

test = np.random.randint(2**64, size=n, dtype=np.uint64)
d = {}
c_map 
hash_map = ItemHashMap()

print("dict")
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

print("c++ map")
start = time.time()
for i in range(n):
    k = test[i]
    v = test[i]
    c_map[k] = v
end = time.time()
print(end - start)
out_sum = 0
start = time.time()
for i in range(n):
    k = test[i]
    out_sum += c_map[k]
end = time.time()
print(end - start, out_sum)
start = time.time()
for i in range(n):
    k = test[i]
    c_map.erase(k)
end = time.time()
print(end - start)

print("ItemHashMap")
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