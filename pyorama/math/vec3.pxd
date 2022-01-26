cimport cython
from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *
from pyorama.math.utils cimport *

@cython.final
cdef class Vec3:
    cdef:
        readonly Vec3C data

    @staticmethod
    cdef Vec3 c_from_data(Vec3C *v)
    
    @staticmethod
    cdef void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_add_scalar(Vec3C *out, Vec3C *v, float scalar) nogil
    @staticmethod
    cdef float c_angle(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_center(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_clamp(Vec3C *out, float min_, float max_) nogil
    @staticmethod
    cdef void c_copy(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_cross_norm(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_dist(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_div_scalar(Vec3C *out, Vec3C *v, float scalar) nogil
    @staticmethod
    cdef float c_dot(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef bint c_equal(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef bint c_equal_comps(Vec3C *v) nogil
    @staticmethod
    cdef bint c_equal_value(Vec3C *v, float value) nogil
    @staticmethod
    cdef void c_fill(Vec3C *out, float value) nogil
    @staticmethod
    cdef void c_flip_sign(Vec3C *out) nogil
    @staticmethod
    cdef void c_flip_sign_to(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_from_vec4(Vec3C *out, Vec4C *v) nogil
    @staticmethod
    cdef void c_inv(Vec3C *out) nogil
    @staticmethod
    cdef void c_inv_to(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil
    @staticmethod
    cdef float c_luminance(Vec3C *rgb) nogil
    @staticmethod
    cdef float c_mag(Vec3C *v) nogil
    @staticmethod
    cdef void c_max_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_max_comp(Vec3C *v) nogil
    @staticmethod
    cdef void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_min_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_min_comp(Vec3C *v) nogil
    @staticmethod
    cdef void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_mul_scalar(Vec3C *out, Vec3C *v, float scalar) nogil
    @staticmethod
    cdef void c_mul_unit_scalar(Vec3C *out, Vec3C *v, float scalar) nogil
    @staticmethod
    cdef bint c_nearly_equal(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef bint c_nearly_equal_value(Vec3C *v, float value) nogil
    @staticmethod
    cdef void c_negate(Vec3C *out) nogil
    @staticmethod
    cdef void c_negate_to(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_norm(Vec3C *out) nogil
    @staticmethod
    cdef void c_norm_to(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_one(Vec3C *out) nogil
    @staticmethod
    cdef void c_orthogonal(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_project(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_random(Vec3C *out) nogil
    @staticmethod
    cdef void c_rotate_angle_axis(Vec3C *out, float angle, Vec3C *axis) nogil
    @staticmethod
    cdef void c_rotate_mat3(Vec3C *out, Mat3C *m, Vec3C *v) nogil
    @staticmethod
    cdef void c_rotate_mat4(Vec3C *out, Mat4C *m, Vec3C *v) nogil
    @staticmethod
    cdef void c_sign(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef float c_sqr_dist(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_sqr_mag(Vec3C *v) nogil
    @staticmethod
    cdef void c_sqrt(Vec3C *out, Vec3C *v) nogil
    @staticmethod
    cdef void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_sub_scalar(Vec3C *out, Vec3C *v, float scalar) nogil
    @staticmethod
    cdef void c_sum_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_sum_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_sum_mul_scalar(Vec3C *out, Vec3C *v, float scalar) nogil
    @staticmethod
    cdef void c_sum_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_transform_mat3(Vec3C *out, Mat3C *m, Vec3C *v) nogil
    @staticmethod
    cdef void c_transform_mat4(Vec3C *out, Mat4C *m, Vec3C *v, float w=*) nogil
    @staticmethod
    cdef void c_transform_quat(Vec3C *out, QuatC *q, Vec3C *v) nogil
    @staticmethod
    cdef void c_zero(Vec3C *out) nogil