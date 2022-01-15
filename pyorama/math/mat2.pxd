from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

cdef class Mat2:
    cdef:
        Mat2C data

    @staticmethod
    cdef Mat2 c_from_data(Mat2C m)
    @staticmethod
    cdef void c_copy(Mat2C out, Mat2C m) nogil
    @staticmethod
    cdef void c_identity(Mat2C out) nogil
    @staticmethod
    cdef void c_zero(Mat2C out) nogil
    @staticmethod
    cdef void c_mul(Mat2C out, Mat2C a, Mat2C b) nogil
    @staticmethod
    cdef void c_transpose_to(Mat2C out, Mat2C m) nogil
    @staticmethod
    cdef void c_transpose(Mat2C out) nogil
    @staticmethod
    cdef float c_trace(Mat2C m) nogil
    @staticmethod
    cdef void c_scale(Mat2C out, float scale) nogil
    @staticmethod
    cdef float c_det(Mat2C m) nogil
    @staticmethod
    cdef void c_inv(Mat2C out, Mat2C m) nogil
    @staticmethod
    cdef void c_swap_col(Mat2C m, size_t col_1, size_t col_2) nogil
    @staticmethod
    cdef void c_swap_row(Mat2C m, size_t row_1, size_t row_2) nogil
    @staticmethod
    cdef float c_row_mat_col(vec2 r, Mat2C m, vec2 c) nogil