from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Vec3:
    cdef:
        float[3] data

    @staticmethod
    cdef Vec3 c_from_data(vec3 v)
    @staticmethod
    cdef void c_set(vec3 v, float x, float y, float z) nogil
    @staticmethod
    cdef void c_copy(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_zero(vec3 out) nogil
    @staticmethod
    cdef void c_one(vec3 out) nogil
    @staticmethod
    cdef float c_dot(vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_cross(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_cross_norm(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef float c_angle(vec3 a, vec3 b) nogil
    @staticmethod
    cdef float c_sqr_mag(vec3 v) nogil
    @staticmethod
    cdef float c_mag(vec3 v) nogil
    @staticmethod
    cdef void c_add(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_add_scalar(vec3 out, vec3 v, float scalar) nogil
    @staticmethod
    cdef void c_sub(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_sub_scalar(vec3 out, vec3 v, float scalar) nogil
    @staticmethod
    cdef void c_mul(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_mul_scalar(vec3 out, vec3 v, float scalar) nogil
    @staticmethod
    cdef void c_mul_unit_scalar(vec3 out, vec3 v, float scalar) nogil
    @staticmethod
    cdef void c_div(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_div_scalar(vec3 out, vec3 v, float scalar) nogil
    @staticmethod
    cdef void c_sum_add(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_sum_sub(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_sum_mul(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_sum_mul_scalar(vec3 out, vec3 v, float scalar) nogil
    @staticmethod
    cdef void c_max_add(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_min_add(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_flip_sign(vec3 out) nogil
    @staticmethod
    cdef void c_flip_sign_to(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_negate_to(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_negate(vec3 out) nogil
    @staticmethod
    cdef void c_inv(vec3 out) nogil
    @staticmethod
    cdef void c_inv_to(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_normalize(vec3 out) nogil
    @staticmethod
    cdef void c_normalize_to(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_rotate_angle_axis(vec3 out, float angle, vec3 axis) nogil
    @staticmethod
    cdef void c_rotate_mat4(vec3 out, mat4 m, vec3 v) nogil
    @staticmethod
    cdef void c_rotate_mat3(vec3 out, mat3 m, vec3 v) nogil
    @staticmethod
    cdef void c_proj(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_center(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef float c_sqr_dist(vec3 a, vec3 b) nogil
    @staticmethod
    cdef float c_dist(vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_max_comps(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_min_comps(vec3 out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef void c_ortho(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_clamp(vec3 out, float min_, float max_) nogil
    @staticmethod
    cdef void c_lerp(vec3 out, vec3 a, vec3 b, float t) nogil
    @staticmethod
    cdef void c_fill(vec3 out, float value) nogil
    @staticmethod
    cdef bint c_equal_value(vec3 v, float value) nogil
    @staticmethod
    cdef bint c_nearly_equal_value(vec3 v, float value) nogil
    @staticmethod
    cdef bint c_equal_comps(vec3 v) nogil
    @staticmethod
    cdef bint c_equal(vec3 a, vec3 b) nogil
    @staticmethod
    cdef bint c_nearly_equal(vec3 a, vec3 b) nogil
    @staticmethod
    cdef float c_max_comp(vec3 v) nogil
    @staticmethod
    cdef float c_min_comp(vec3 v) nogil
    @staticmethod
    cdef void c_sign(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_sqrt(vec3 out, vec3 v) nogil
    @staticmethod
    cdef void c_transform_mat3(vec3 out, mat3 m, vec3 v) nogil
    @staticmethod
    cdef void c_transform_mat4(vec3 out, mat4 m, vec3 v, float w) nogil
    @staticmethod
    cdef void c_transform_quat(vec3 out, quat q, vec3 v) nogil
    @staticmethod
    cdef float c_luminance(vec3 rgb) nogil
    @staticmethod
    cdef void c_from_vec4(vec3 out, vec4 v) nogil