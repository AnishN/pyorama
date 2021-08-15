from pyorama.libs.c cimport *
from pyorama.math.common cimport *
from pyorama.math.mat3 cimport *
from pyorama.math.mat4 cimport *
from pyorama.math.quat cimport *

cdef class Vec3:
    cdef Vec3C data
    
    @staticmethod
    cdef void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_angle(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_ceil(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef void c_copy(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_dist(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_dot(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef bint c_equals(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_floor(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef void c_inv(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef float c_length(Vec3C *a) nogil
    @staticmethod
    cdef void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil
    @staticmethod
    cdef void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(Vec3C *a, Vec3C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_negate(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef void c_norm(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef void c_random(Vec3C *out) nogil
    @staticmethod
    cdef void c_round(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef void c_scale_add(Vec3C *out, Vec3C *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_data(Vec3C *out, float x=*, float y=*, float z=*) nogil
    @staticmethod
    cdef float c_sqr_dist(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef float c_sqr_length(Vec3C *a) nogil
    @staticmethod
    cdef void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_transform_mat3(Vec3C *out, Vec3C *a, Mat3C *m) nogil
    @staticmethod
    cdef void c_transform_mat4(Vec3C *out, Vec3C *a, Mat4C *m) nogil
    @staticmethod
    cdef void c_transform_quat(Vec3C *out, Vec3C *a, QuatC *q) nogil