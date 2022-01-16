from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Bezier:

    @staticmethod
    cdef float c_bezier(float s, float p0, float c0, float c1, float p1) nogil
    @staticmethod
    cdef float c_decasteljau(float prm, float p0, float c0, float c1, float p1) nogil
    @staticmethod
    cdef float c_hermite(float s, float p0, float t0, float t1, float p1) nogil