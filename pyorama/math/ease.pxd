from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Ease:

    @staticmethod
    cdef float c_linear(float t) nogil
    @staticmethod
    cdef float c_sine_in(float t) nogil
    @staticmethod
    cdef float c_sine_out(float t) nogil
    @staticmethod
    cdef float c_sine_in_out(float t) nogil
    @staticmethod
    cdef float c_quad_in(float t) nogil
    @staticmethod
    cdef float c_quad_out(float t) nogil
    @staticmethod
    cdef float c_quad_in_out(float t) nogil
    @staticmethod
    cdef float c_cubic_in(float t) nogil
    @staticmethod
    cdef float c_cubic_out(float t) nogil
    @staticmethod
    cdef float c_cubic_in_out(float t) nogil
    @staticmethod
    cdef float c_quart_in(float t) nogil
    @staticmethod
    cdef float c_quart_out(float t) nogil
    @staticmethod
    cdef float c_quart_in_out(float t) nogil
    @staticmethod
    cdef float c_quint_in(float t) nogil
    @staticmethod
    cdef float c_quint_out(float t) nogil
    @staticmethod
    cdef float c_quint_in_out(float t) nogil
    @staticmethod
    cdef float c_exp_in(float t) nogil
    @staticmethod
    cdef float c_exp_out(float t) nogil
    @staticmethod
    cdef float c_exp_in_out(float t) nogil
    @staticmethod
    cdef float c_circ_in(float t) nogil
    @staticmethod
    cdef float c_circ_out(float t) nogil
    @staticmethod
    cdef float c_circ_in_out(float t) nogil
    @staticmethod
    cdef float c_back_in(float t) nogil
    @staticmethod
    cdef float c_back_out(float t) nogil
    @staticmethod
    cdef float c_back_in_out(float t) nogil
    @staticmethod
    cdef float c_elast_in(float t) nogil
    @staticmethod
    cdef float c_elast_out(float t) nogil
    @staticmethod
    cdef float c_elast_in_out(float t) nogil
    @staticmethod
    cdef float c_bounce_in(float t) nogil
    @staticmethod
    cdef float c_bounce_out(float t) nogil
    @staticmethod
    cdef float c_bounce_in_out(float t) nogil