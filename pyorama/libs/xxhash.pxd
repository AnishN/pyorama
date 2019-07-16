from libc.stdint cimport uint32_t

cdef extern from "xxhash.h" nogil:
    cdef uint32_t XXH32(const void* input_, size_t length, uint32_t seed)
