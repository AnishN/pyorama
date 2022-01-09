from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Vec2:
    cdef:
        float[2] data

    @staticmethod
    cdef Vec2 c_from_data(vec2 v)
    @staticmethod
    cdef void c_set(vec2 v, float x, float y) nogil
    @staticmethod
    cdef void c_copy(vec2 out, vec2 v) nogil
    @staticmethod
    cdef void c_zero(vec2 out) nogil
    @staticmethod
    cdef void c_one(vec2 out) nogil
    @staticmethod
    cdef float c_dot(vec2 a, vec2 b) nogil
    @staticmethod
    cdef float c_cross(vec2 a, vec2 b) nogil
    @staticmethod
    cdef float c_sqr_mag(vec2 v) nogil
    @staticmethod
    cdef float c_mag(vec2 v) nogil
    @staticmethod
    cdef void c_add(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_add_scalar(vec2 out, vec2 v, float scalar) nogil
    @staticmethod
    cdef void c_sub(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_sub_scalar(vec2 out, vec2 v, float scalar) nogil
    @staticmethod
    cdef void c_mul(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_mul_scalar(vec2 out, vec2 v, float scalar) nogil
    @staticmethod
    cdef void c_mul_unit_scalar(vec2 out, vec2 v, float scalar) nogil
    @staticmethod
    cdef void c_div(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_div_scalar(vec2 out, vec2 v, float scalar) nogil
    @staticmethod
    cdef void c_sum_add(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_sum_sub(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_sum_mul(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_sum_mul_scalar(vec2 out, vec2 v, float scalar) nogil
    @staticmethod
    cdef void c_max_add(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_min_add(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_negate_to(vec2 out, vec2 v) nogil
    @staticmethod
    cdef void c_negate(vec2 out) nogil
    @staticmethod
    cdef void c_normalize(vec2 out) nogil
    @staticmethod
    cdef void c_normalize_to(vec2 out, vec2 v) nogil
    @staticmethod
    cdef void c_rotate(vec2 out, vec2 v, float angle) nogil
    @staticmethod
    cdef float c_sqr_dist(vec2 a, vec2 b) nogil
    @staticmethod
    cdef float c_dist(vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_max_comps(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_min_comps(vec2 out, vec2 a, vec2 b) nogil
    @staticmethod
    cdef void c_clamp(vec2 out, float min_, float max_) nogil
    @staticmethod
    cdef void c_lerp(vec2 out, vec2 a, vec2 b, float t) nogil
    @staticmethod
    cdef void c_fill(vec2 out, float value) nogil
    @staticmethod
    cdef bint c_equal_value(vec2 v, float value) nogil
    @staticmethod
    cdef bint c_nearly_equal_value(vec2 v, float value) nogil
    @staticmethod
    cdef bint c_equal_comps(vec2 v) nogil
    @staticmethod
    cdef bint c_equal(vec2 a, vec2 b) nogil
    @staticmethod
    cdef bint c_nearly_equal(vec2 a, vec2 b) nogil
    @staticmethod
    cdef float c_max_comp(vec2 v) nogil
    @staticmethod
    cdef float c_min_comp(vec2 v) nogil
    @staticmethod
    cdef void c_sign(vec2 out, vec2 v) nogil
    @staticmethod
    cdef void c_sqrt(vec2 out, vec2 v) nogil
    @staticmethod
    cdef void c_transform_mat2(vec2 out, mat2 m, vec2 v) nogil