from pyorama.libs.c cimport *

cdef extern from "random.h" nogil:
    cdef uint8_t c_random_get_u8()
    cdef uint16_t c_random_get_u16()
    cdef uint32_t c_random_get_u32()
    cdef uint64_t c_random_get_u64()
    cdef int8_t c_random_get_i8()
    cdef int16_t c_random_get_i16()
    cdef int32_t c_random_get_i32()
    cdef int64_t c_random_get_i64()
    cdef float c_random_get_f32()
    cdef double c_random_get_f64()

cdef inline void c_random_set_seed_from_time() nogil:
    srand(c_time(NULL))

cdef inline void c_random_set_seed(uint64_t seed) nogil:
    srand(seed)

cdef inline float c_random_get_range_f32(float min_, float max_) nogil:
    return min_ + ((max_ - min_) * c_random_get_f32())

cdef inline void c_random_set_bytes(uint8_t *data, size_t num_bytes) nogil:
    cdef:
        size_t i
        uint8_t b
    
    for i in range(num_bytes):
        b = c_random_get_u8()
        data[i] = b