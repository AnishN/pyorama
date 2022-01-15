from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

cdef class Vec2:
    cdef:
        Vec2C data

    @staticmethod
    cdef Vec2 c_from_data(Vec2C v)
    @staticmethod
    cdef void c_set(Vec2C v, float x, float y) nogil
    @staticmethod
    cdef void c_copy(Vec2C out, Vec2C v) nogil
    @staticmethod
    cdef void c_zero(Vec2C out) nogil
    @staticmethod
    cdef void c_one(Vec2C out) nogil
    @staticmethod
    cdef float c_dot(Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef float c_cross(Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef float c_sqr_mag(Vec2C v) nogil
    @staticmethod
    cdef float c_mag(Vec2C v) nogil
    @staticmethod
    cdef void c_add(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_add_scalar(Vec2C out, Vec2C v, float scalar) nogil
    @staticmethod
    cdef void c_sub(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_sub_scalar(Vec2C out, Vec2C v, float scalar) nogil
    @staticmethod
    cdef void c_mul(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_mul_scalar(Vec2C out, Vec2C v, float scalar) nogil
    @staticmethod
    cdef void c_mul_unit_scalar(Vec2C out, Vec2C v, float scalar) nogil
    @staticmethod
    cdef void c_div(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_div_scalar(Vec2C out, Vec2C v, float scalar) nogil
    @staticmethod
    cdef void c_sum_add(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_sum_sub(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_sum_mul(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_sum_mul_scalar(Vec2C out, Vec2C v, float scalar) nogil
    @staticmethod
    cdef void c_max_add(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_min_add(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_negate_to(Vec2C out, Vec2C v) nogil
    @staticmethod
    cdef void c_negate(Vec2C out) nogil
    @staticmethod
    cdef void c_normalize(Vec2C out) nogil
    @staticmethod
    cdef void c_normalize_to(Vec2C out, Vec2C v) nogil
    @staticmethod
    cdef void c_rotate(Vec2C out, Vec2C v, float angle) nogil
    @staticmethod
    cdef float c_sqr_dist(Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef float c_dist(Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_max_comps(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_min_comps(Vec2C out, Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef void c_clamp(Vec2C out, float min_, float max_) nogil
    @staticmethod
    cdef void c_lerp(Vec2C out, Vec2C a, Vec2C b, float t) nogil
    @staticmethod
    cdef void c_fill(Vec2C out, float value) nogil
    @staticmethod
    cdef bint c_equal_value(Vec2C v, float value) nogil
    @staticmethod
    cdef bint c_nearly_equal_value(Vec2C v, float value) nogil
    @staticmethod
    cdef bint c_equal_comps(Vec2C v) nogil
    @staticmethod
    cdef bint c_equal(Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef bint c_nearly_equal(Vec2C a, Vec2C b) nogil
    @staticmethod
    cdef float c_max_comp(Vec2C v) nogil
    @staticmethod
    cdef float c_min_comp(Vec2C v) nogil
    @staticmethod
    cdef void c_sign(Vec2C out, Vec2C v) nogil
    @staticmethod
    cdef void c_sqrt(Vec2C out, Vec2C v) nogil
    @staticmethod
    cdef void c_transform_mat2(Vec2C out, Mat2C m, Vec2C v) nogil