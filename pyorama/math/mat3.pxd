"""
#cglm_affine3d_h
    void glm_translate3d(mat3 m, vec3 v)
    void glm_translate3d_to(mat3 m, vec3 v, mat3 dest)
    void glm_translate3d_x(mat3 m, float x)
    void glm_translate3d_y(mat3 m, float y)
    void glm_translate3d_make(mat3 m, vec3 v)
    void glm_scale3d_to(mat3 m, vec3 v, mat3 dest)
    void glm_scale3d_make(mat3 m, vec3 v)
    void glm_scale3d(mat3 m, vec3 v)
    void glm_scale3d_uni(mat3 m, float s)
    void glm_rotate3d_make(mat3 m, float angle)
    void glm_rotate3d(mat3 m, float angle)
    void glm_rotate3d_to(mat3 m, float angle, mat3 dest)

@staticmethod
void glm_quat_mat3(versor q, mat3 dest)

@staticmethod
void glm_quat_mat3t(versor q, mat3 dest)
"""

from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Mat3:
    cdef:
        float[3][3] data

    @staticmethod
    cdef Mat3 c_from_data(mat3 m)
    @staticmethod
    cdef void c_copy(mat3 out, mat3 m) nogil
    @staticmethod
    cdef void c_identity(mat3 out) nogil
    @staticmethod
    cdef void c_zero(mat3 out) nogil
    @staticmethod
    cdef void c_mul(mat3 out, mat3 a, mat3 b) nogil
    @staticmethod
    cdef void c_transpose_to(mat3 out, mat3 m) nogil
    @staticmethod
    cdef void c_transpose(mat3 out) nogil
    @staticmethod
    cdef float c_trace(mat3 m) nogil
    @staticmethod
    cdef void c_scale(mat3 out, float scale) nogil
    @staticmethod
    cdef float c_det(mat3 m) nogil
    @staticmethod
    cdef void c_inv(mat3 out, mat3 m) nogil
    @staticmethod
    cdef void c_swap_col(mat3 m, size_t col_1, size_t col_2) nogil
    @staticmethod
    cdef void c_swap_row(mat3 m, size_t row_1, size_t row_2) nogil
    @staticmethod
    cdef float c_row_mat_col(vec3 r, mat3 m, vec3 c) nogil