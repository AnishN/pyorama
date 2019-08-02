from libc.stdlib cimport malloc, calloc, realloc, free
from libc.string cimport memcpy, memset
from libc.stdlib cimport rand, srand, RAND_MAX
cimport libc.math as c_math

ctypedef float[2] Vec2C
ctypedef float[3] Vec3C
ctypedef float[4] Vec4C
ctypedef float[4] QuatC
ctypedef float[4] Mat2C
ctypedef float[9] Mat3C
ctypedef float[16] Mat4C

cdef float epsilon = 0.000001