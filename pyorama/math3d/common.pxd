from pyorama.libs.c cimport *

ctypedef float[2] Vec2C
ctypedef float[3] Vec3C
ctypedef float[4] Vec4C
ctypedef float[4] QuatC
ctypedef float[4] Mat2C
ctypedef float[9] Mat3C
ctypedef float[16] Mat4C
ctypedef struct ColorC:
    uint8_t r
    uint8_t g
    uint8_t b
    uint8_t a
ctypedef struct FloatColorC:
    float r
    float b
    float g
    float a

cdef float epsilon = 0.000001