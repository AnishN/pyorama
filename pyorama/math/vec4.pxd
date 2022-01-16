cimport cython
from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

@cython.final
cdef class Vec4:
    cdef:
        Vec4C data

    @staticmethod
    cdef Vec4 c_from_data(Vec4C *v)
    @staticmethod
    cdef void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_add_scalar(Vec4C *out, Vec4C *v, float scalar) nogil
    @staticmethod
    cdef void c_clamp(Vec4C *out, float min_, float max_) nogil
    @staticmethod
    cdef void c_copy(Vec4C *out, Vec4C *v) nogil
    @staticmethod
    cdef float c_dist(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_div_scalar(Vec4C *out, Vec4C *v, float scalar) nogil
    @staticmethod
    cdef float c_dot(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef bint c_equal(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef bint c_equal_comps(Vec4C *v) nogil
    @staticmethod
    cdef bint c_equal_value(Vec4C *v, float value) nogil
    @staticmethod
    cdef void c_fill(Vec4C *out, float value) nogil
    @staticmethod
    cdef void c_inv(Vec4C *out) nogil
    @staticmethod
    cdef void c_inv_to(Vec4C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil
    @staticmethod
    cdef float c_mag(Vec4C *v) nogil
    @staticmethod
    cdef void c_max_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef float c_max_comp(Vec4C *v) nogil
    @staticmethod
    cdef void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_min_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef float c_min_comp(Vec4C *v) nogil
    @staticmethod
    cdef void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_mul_scalar(Vec4C *out, Vec4C *v, float scalar) nogil
    @staticmethod
    cdef void c_mul_unit_scalar(Vec4C *out, Vec4C *v, float scalar) nogil
    @staticmethod
    cdef bint c_nearly_equal(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef bint c_nearly_equal_value(Vec4C *v, float value) nogil
    @staticmethod
    cdef void c_negate(Vec4C *out) nogil
    @staticmethod
    cdef void c_norm(Vec4C *out) nogil
    @staticmethod
    cdef void c_norm_to(Vec4C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_one(Vec4C *out) nogil
    @staticmethod
    cdef void c_sign(Vec4C *out, Vec4C *v) nogil
    @staticmethod
    cdef float c_sqr_dist(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef float c_sqr_mag(Vec4C *v) nogil
    @staticmethod
    cdef void c_sqrt(Vec4C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_sub_scalar(Vec4C *out, Vec4C *v, float scalar) nogil
    @staticmethod
    cdef void c_sum_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_sum_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_sum_mul_scalar(Vec4C *out, Vec4C *v, float scalar) nogil
    @staticmethod
    cdef void c_sum_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_transform_mat4(Vec4C *out, Mat4C *m, Vec4C *v) nogil
    @staticmethod
    cdef void c_zero(Vec4C *out) nogil