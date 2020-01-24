cdef class ItemHashMap:

    def __cinit__(self):
        self.hash_map = {}
    
    def __dealloc__(self):
        pass

    cdef void c_append(self, bytes key, uint64_t value) except *:
        self.hash_map[key] = value

    cdef void c_remove(self, bytes key) except *:
        self.hash_map.remove(key)

    cdef uint64_t c_get(self, bytes key) except *:
        return <uint64_t>self.hash_map[key]

    cdef bint c_contains(self, bytes key):
        return key in self.hash_map