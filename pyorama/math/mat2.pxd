from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Mat2:
    cdef:
        float[2][2] data

    @staticmethod
    cdef Mat2 c_from_data(mat2 m)
    @staticmethod
    cdef void c_copy(mat2 out, mat2 m) nogil
    @staticmethod
    cdef void c_identity(mat2 out) nogil
    @staticmethod
    cdef void c_zero(mat2 out) nogil
    @staticmethod
    cdef void c_mul(mat2 out, mat2 a, mat2 b) nogil
    @staticmethod
    cdef void c_transpose_to(mat2 out, mat2 m) nogil
    @staticmethod
    cdef void c_transpose(mat2 out) nogil
    @staticmethod
    cdef float c_trace(mat2 m) nogil
    @staticmethod
    cdef void c_scale(mat2 out, float scale) nogil
    @staticmethod
    cdef float c_det(mat2 m) nogil
    @staticmethod
    cdef void c_inv(mat2 out, mat2 m) nogil
    @staticmethod
    cdef void c_swap_col(mat2 m, size_t col_1, size_t col_2) nogil
    @staticmethod
    cdef void c_swap_row(mat2 m, size_t row_1, size_t row_2) nogil
    @staticmethod
    cdef float c_row_mat_col(vec2 r, mat2 m, vec2 c) nogil