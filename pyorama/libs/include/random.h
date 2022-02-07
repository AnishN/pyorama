#include <inttypes.h>
#include <stdlib.h>

#define IMAX_BITS(m) ((m)/((m)%255+1) / 255%255*8 + 7-86/((m)%255+12))
#define RAND_MAX_WIDTH IMAX_BITS(RAND_MAX)
//assumes RAND_MAX is a Mersenne number of form 2**n - 1

inline uint8_t c_random_get_u8(void)
{
    uint8_t r = 0;
    for (int i = 0; i < 8; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline uint16_t c_random_get_u16(void)
{
    uint16_t r = 0;
    for (int i = 0; i < 16; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline uint32_t c_random_get_u32(void)
{
    uint32_t r = 0;
    for (int i = 0; i < 32; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline uint64_t c_random_get_u64(void) 
{
    uint64_t r = 0;
    for (int i = 0; i < 64; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline int8_t c_random_get_i8(void)
{
    int8_t r = 0;
    for (int i = 0; i < 8; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline int16_t c_random_get_i16(void)
{
    int16_t r = 0;
    for (int i = 0; i < 16; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline int32_t c_random_get_i32(void)
{
    int32_t r = 0;
    for (int i = 0; i < 32; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline int64_t c_random_get_i64(void) 
{
    int64_t r = 0;
    for (int i = 0; i < 64; i += RAND_MAX_WIDTH) 
    {
        r <<= RAND_MAX_WIDTH;
        r ^= (unsigned) rand();
    }
    return r;
}

inline float c_random_get_f32(void)
{
    return (float)c_random_get_u32();
}

inline double c_random_get_f64(void)
{
    return (double)c_random_get_u64();
}