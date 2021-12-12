from pyorama.libs.c cimport *

cdef extern from "xxhash.h" nogil:
    cdef uint32_t XXH32(const void* input_, size_t length, uint32_t seed)
    cdef uint64_t XXH64(const void* input_, size_t length, uint64_t seed)
    cdef uint32_t XXH3_32bits(void* input_, size_t length)
    cdef uint64_t XXH3_64bits(void* input_, size_t length)