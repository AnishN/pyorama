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

cdef inline uint8_t c_random_get_range_u8(uint8_t min_, uint8_t max_) nogil:
    cdef:
        uint8_t value
    value = c_random_get_u8()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline uint16_t c_random_get_range_u16(uint16_t min_, uint16_t max_) nogil:
    cdef:
        uint16_t value
    value = c_random_get_u16()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline uint32_t c_random_get_range_u32(uint32_t min_, uint32_t max_) nogil:
    cdef:
        uint32_t value
    value = c_random_get_u32()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline uint64_t c_random_get_range_u64(uint64_t min_, uint64_t max_) nogil:
    cdef:
        uint64_t value
    value = c_random_get_u64()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline int8_t c_random_get_range_i8(int8_t min_, int8_t max_) nogil:
    cdef:
        int8_t value
    value = c_random_get_i8()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline int16_t c_random_get_range_i16(int16_t min_, int16_t max_) nogil:
    cdef:
        int16_t value
    value = c_random_get_i16()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline int32_t c_random_get_range_i32(int32_t min_, int32_t max_) nogil:
    cdef:
        int32_t value
    value = c_random_get_i32()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline int64_t c_random_get_range_i64(int64_t min_, int64_t max_) nogil:
    cdef:
        int64_t value
    value = c_random_get_i64()
    value = (value % (max_ - min_)) + min_
    return value

cdef inline float c_random_get_range_f32(float min_, float max_) nogil:
    return min_ + ((max_ - min_) * c_random_get_f32())

cdef inline void c_random_set_bytes(uint8_t *data, size_t num_bytes) nogil:
    cdef:
        size_t i
        uint8_t b
    
    for i in range(num_bytes):
        b = c_random_get_u8()
        data[i] = b