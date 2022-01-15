"""
#cglm_affine3d_h
    void glm_translate3d(Mat3C m, vec3 v)
    void glm_translate3d_to(Mat3C m, vec3 v, Mat3C dest)
    void glm_translate3d_x(Mat3C m, float x)
    void glm_translate3d_y(Mat3C m, float y)
    void glm_translate3d_make(Mat3C m, vec3 v)
    void glm_scale3d_to(Mat3C m, vec3 v, Mat3C dest)
    void glm_scale3d_make(Mat3C m, vec3 v)
    void glm_scale3d(Mat3C m, vec3 v)
    void glm_scale3d_uni(Mat3C m, float s)
    void glm_rotate3d_make(Mat3C m, float angle)
    void glm_rotate3d(Mat3C m, float angle)
    void glm_rotate3d_to(Mat3C m, float angle, Mat3C dest)

@staticmethod
void glm_quat_mat3(versor q, Mat3C dest)

@staticmethod
void glm_quat_mat3t(versor q, Mat3C dest)
"""

from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

cdef class Mat3:
    cdef:
        Mat3C data

    @staticmethod
    cdef Mat3 c_from_data(Mat3C m)
    @staticmethod
    cdef void c_copy(Mat3C out, Mat3C m) nogil
    @staticmethod
    cdef void c_identity(Mat3C out) nogil
    @staticmethod
    cdef void c_zero(Mat3C out) nogil
    @staticmethod
    cdef void c_mul(Mat3C out, Mat3C a, Mat3C b) nogil
    @staticmethod
    cdef void c_transpose_to(Mat3C out, Mat3C m) nogil
    @staticmethod
    cdef void c_transpose(Mat3C out) nogil
    @staticmethod
    cdef float c_trace(Mat3C m) nogil
    @staticmethod
    cdef void c_scale(Mat3C out, float scale) nogil
    @staticmethod
    cdef float c_det(Mat3C m) nogil
    @staticmethod
    cdef void c_inv(Mat3C out, Mat3C m) nogil
    @staticmethod
    cdef void c_swap_col(Mat3C m, size_t col_1, size_t col_2) nogil
    @staticmethod
    cdef void c_swap_row(Mat3C m, size_t row_1, size_t row_2) nogil
    @staticmethod
    cdef float c_row_mat_col(vec3 r, Mat3C m, vec3 c) nogil