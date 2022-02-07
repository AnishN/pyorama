cimport cython
from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *
from pyorama.math.random cimport *

@cython.final
cdef class Mat3:
    cdef:
        readonly Mat3C data

    @staticmethod
    cdef Mat3 c_from_data(Mat3C *m)
    @staticmethod
    cdef void c_copy(Mat3C *out, Mat3C *m) nogil
    @staticmethod
    cdef float c_det(Mat3C *m) nogil
    @staticmethod
    cdef void c_from_quat(Mat3C *out, QuatC *q, bint transpose=*) nogil
    @staticmethod
    cdef void c_from_rotation(Mat3C *out, float angle) nogil
    @staticmethod
    cdef void c_from_scaling(Mat3C *out, Vec2C *v) nogil
    @staticmethod
    cdef void c_from_translation(Mat3C *out, Vec2C *v) nogil
    @staticmethod
    cdef void c_identity(Mat3C *out) nogil
    @staticmethod
    cdef void c_inv(Mat3C *out, Mat3C *m) nogil
    @staticmethod
    cdef void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef void c_mul_scalar(Mat3C *out, float scalar) nogil
    @staticmethod
    cdef void c_random(Mat3C *out) nogil
    @staticmethod
    cdef void c_rotate(Mat3C *out, float angle) nogil
    @staticmethod
    cdef void c_rotate_to(Mat3C *out, Mat3C *m, float angle) nogil
    @staticmethod
    cdef float c_row_mat_col(Vec3C *r, Mat3C *m, Vec3C *c) nogil
    @staticmethod
    cdef void c_scale(Mat3C *out, Vec2C *v) nogil
    @staticmethod
    cdef void c_scale_to(Mat3C *out, Mat3C *m, Vec2C *v) nogil
    @staticmethod
    cdef void c_scale_uniform(Mat3C *out, float s) nogil
    @staticmethod
    cdef void c_swap_col(Mat3C *m, size_t c1, size_t c2) nogil
    @staticmethod
    cdef void c_swap_row(Mat3C *m, size_t r1, size_t r2) nogil
    @staticmethod
    cdef float c_trace(Mat3C *m) nogil
    @staticmethod
    cdef void c_translate(Mat3C *out, Vec2C *v) nogil
    @staticmethod
    cdef void c_translate_to(Mat3C *out, Mat3C *m, Vec2C *v) nogil
    @staticmethod
    cdef void c_translate_x(Mat3C *out, float x) nogil
    @staticmethod
    cdef void c_translate_y(Mat3C *out, float y) nogil
    @staticmethod
    cdef void c_transpose(Mat3C *out) nogil
    @staticmethod
    cdef void c_transpose_to(Mat3C *out, Mat3C *m) nogil
    @staticmethod
    cdef void c_zero(Mat3C *out) nogil