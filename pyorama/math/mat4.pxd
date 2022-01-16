cimport cython
from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

@cython.final
cdef class Mat4:
    cdef:
        readonly Mat4C data

    @staticmethod
    cdef Mat4 c_from_data(Mat4C *m)
    @staticmethod
    cdef void c_copy(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_decompose(Mat4C *m, Vec4C *t, Mat4C *r, Vec4C *s) nogil
    @staticmethod
    cdef void c_decompose_rot_scale(Mat4C *m, Mat4C *r, Vec4C *s) nogil
    @staticmethod
    cdef void c_decompose_scale(Mat4C *m, Vec4C *s) nogil
    @staticmethod
    cdef float c_det(Mat4C *m) nogil
    @staticmethod
    cdef void c_from_quat(Mat4C *out, QuatC *q, bint transpose=*) nogil
    @staticmethod
    cdef void c_from_rotation(Mat4C *out, float angle, Vec4C *axis) nogil
    @staticmethod
    cdef void c_from_rotation_at(Mat4C *out, Vec4C *pivot, float angle, Vec4C *axis) nogil
    @staticmethod
    cdef void c_from_scaling(Mat4C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_from_translation(Mat4C *out, Vec4C *v) nogil
    @staticmethod
    cdef bint c_is_uniform_scaled(Mat4C *m) nogil
    @staticmethod
    cdef void c_identity(Mat4C *out) nogil
    @staticmethod
    cdef void c_inv(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_inv_fast(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef void c_mul_scalar(Mat4C *out, float scalar) nogil
    @staticmethod
    cdef void c_rotate(Mat4C *out, float angle, Vec4C *axis) nogil
    @staticmethod
    cdef void c_rotate_at(Mat4C *out, Vec4C *pivot, float angle, Vec4C *axis) nogil
    @staticmethod
    cdef void c_rotate_x(Mat4C *out, Mat4C *m, float angle) nogil
    @staticmethod
    cdef void c_rotate_y(Mat4C *out, Mat4C *m, float angle) nogil
    @staticmethod
    cdef void c_rotate_z(Mat4C *out, Mat4C *m, float angle) nogil
    @staticmethod
    cdef float c_row_mat_col(Vec4C *r, Mat4C *m, Vec4C *c) nogil
    @staticmethod
    cdef void c_scale(Mat4C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_scale_to(Mat4C *out, Mat4C *m, Vec4C *v) nogil
    @staticmethod
    cdef void c_scale_uniform(Mat4C *out, float s) nogil
    @staticmethod
    cdef void c_swap_col(Mat4C *m, size_t c1, size_t c2) nogil
    @staticmethod
    cdef void c_swap_row(Mat4C *m, size_t r1, size_t r2) nogil
    @staticmethod
    cdef float c_trace(Mat4C *m) nogil
    @staticmethod
    cdef float c_trace_rot(Mat4C *m) nogil
    @staticmethod
    cdef void c_translate(Mat4C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_translate_to(Mat4C *out, Mat4C *m, Vec4C *v) nogil
    @staticmethod
    cdef void c_translate_x(Mat4C *out, float x) nogil
    @staticmethod
    cdef void c_translate_y(Mat4C *out, float y) nogil
    @staticmethod
    cdef void c_translate_z(Mat4C *out, float z) nogil
    @staticmethod
    cdef void c_transpose(Mat4C *out) nogil
    @staticmethod
    cdef void c_transpose_to(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_zero(Mat4C *out) nogil