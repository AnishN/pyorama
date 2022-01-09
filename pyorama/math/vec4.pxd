from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Vec4:
    cdef:
        float[3] data

    @staticmethod
    cdef Vec4 c_from_data(vec4 v)
    @staticmethod
    cdef void c_set(vec4 v, float x, float y, float z, float w) nogil
    @staticmethod
    cdef void c_copy(vec4 out, vec4 v) nogil
    @staticmethod
    cdef void c_zero(vec4 out) nogil
    @staticmethod
    cdef void c_one(vec4 out) nogil
    @staticmethod
    cdef float c_dot(vec4 a, vec4 b) nogil
    @staticmethod
    cdef float c_sqr_mag(vec4 v) nogil
    @staticmethod
    cdef float c_mag(vec4 v) nogil
    @staticmethod
    cdef void c_add(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_add_scalar(vec4 out, vec4 v, float scalar) nogil
    @staticmethod
    cdef void c_sub(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_sub_scalar(vec4 out, vec4 v, float scalar) nogil
    @staticmethod
    cdef void c_mul(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_mul_scalar(vec4 out, vec4 v, float scalar) nogil
    @staticmethod
    cdef void c_mul_unit_scalar(vec4 out, vec4 v, float scalar) nogil
    @staticmethod
    cdef void c_div(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_div_scalar(vec4 out, vec4 v, float scalar) nogil
    @staticmethod
    cdef void c_sum_add(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_sum_sub(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_sum_mul(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_sum_mul_scalar(vec4 out, vec4 v, float scalar) nogil
    @staticmethod
    cdef void c_max_add(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_min_add(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_negate(vec4 out) nogil
    @staticmethod
    cdef void c_inv(vec4 out) nogil
    @staticmethod
    cdef void c_inv_to(vec4 out, vec4 v) nogil
    @staticmethod
    cdef void c_normalize(vec4 out) nogil
    @staticmethod
    cdef void c_normalize_to(vec4 out, vec4 v) nogil
    @staticmethod
    cdef float c_sqr_dist(vec4 a, vec4 b) nogil
    @staticmethod
    cdef float c_dist(vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_max_comps(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_min_comps(vec4 out, vec4 a, vec4 b) nogil
    @staticmethod
    cdef void c_clamp(vec4 out, float min_, float max_) nogil
    @staticmethod
    cdef void c_lerp(vec4 out, vec4 a, vec4 b, float t) nogil
    @staticmethod
    cdef void c_fill(vec4 out, float value) nogil
    @staticmethod
    cdef bint c_equal_value(vec4 v, float value) nogil
    @staticmethod
    cdef bint c_nearly_equal_value(vec4 v, float value) nogil
    @staticmethod
    cdef bint c_equal_comps(vec4 v) nogil
    @staticmethod
    cdef bint c_equal(vec4 a, vec4 b) nogil
    @staticmethod
    cdef bint c_nearly_equal(vec4 a, vec4 b) nogil
    @staticmethod
    cdef float c_max_comp(vec4 v) nogil
    @staticmethod
    cdef float c_min_comp(vec4 v) nogil
    @staticmethod
    cdef void c_sign(vec4 out, vec4 v) nogil
    @staticmethod
    cdef void c_sqrt(vec4 out, vec4 v) nogil
    @staticmethod
    cdef void c_transform_mat4(vec4 out, mat4 m, vec4 v) nogil