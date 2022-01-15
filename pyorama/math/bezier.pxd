from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Bezier:

    @staticmethod
    cdef float bezier(float s, float p_0, float c_0, float c_1, float p_1) nogil
    @staticmethod
    cdef float hermite(float s, float p_0, float t_0, float t_1, float p_1) nogil
    @staticmethod
    cdef float decasteljau(float prm, float p_0, float c_0, float c_1, float p_1) nogil