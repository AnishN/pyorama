cimport cython
from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *
from pyorama.math.random cimport *

@cython.final
cdef class Mat2:
    cdef:
        readonly Mat2C data

    @staticmethod
    cdef Mat2 c_from_data(Mat2C *m)

    @staticmethod
    cdef void c_copy(Mat2C *out, Mat2C *m) nogil
    @staticmethod
    cdef float c_det(Mat2C *m) nogil
    @staticmethod
    cdef void c_identity(Mat2C *out) nogil
    @staticmethod
    cdef void c_inv(Mat2C *out, Mat2C *m) nogil
    @staticmethod
    cdef void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef void c_mul_scalar(Mat2C *out, float scalar) nogil
    @staticmethod
    cdef void c_random(Mat2C *out) nogil
    @staticmethod
    cdef float c_row_mat_col(Vec2C *r, Mat2C *m, Vec2C *c) nogil
    @staticmethod
    cdef void c_swap_col(Mat2C *m, size_t c1, size_t c2) nogil
    @staticmethod
    cdef void c_swap_row(Mat2C *m, size_t r1, size_t r2) nogil
    @staticmethod
    cdef float c_trace(Mat2C *m) nogil
    @staticmethod
    cdef void c_transpose(Mat2C *out) nogil
    @staticmethod
    cdef void c_transpose_to(Mat2C *out, Mat2C *m) nogil
    @staticmethod
    cdef void c_zero(Mat2C *out) nogil