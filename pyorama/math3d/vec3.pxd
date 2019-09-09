from pyorama.math3d.common cimport *
from pyorama.math3d.mat3 cimport *
from pyorama.math3d.mat4 cimport *
from pyorama.math3d.quat cimport *

cdef class Vec3:
    cdef Vec3C *ptr
    
    @staticmethod
    cdef inline void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline float c_angle(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_ceil(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline void c_copy(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline float c_dist(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline float c_dot(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline bint c_equals(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_floor(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline void c_inv(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline float c_length(Vec3C *a) nogil
    @staticmethod
    cdef inline void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil
    @staticmethod
    cdef inline void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(Vec3C *a, Vec3C *b, float epsilon=epsilon) nogil
    @staticmethod
    cdef inline void c_negate(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline void c_norm(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline void c_random(Vec3C *out) nogil
    @staticmethod
    cdef inline void c_round(Vec3C *out, Vec3C *a) nogil
    @staticmethod
    cdef inline void c_scale_add(Vec3C *out, Vec3C *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_data(Vec3C *out, float x=0.0, float y=0.0, float z=0.0) nogil
    @staticmethod
    cdef inline float c_sqr_dist(Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline float c_sqr_length(Vec3C *a) nogil
    @staticmethod
    cdef inline void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_transform_mat3(Vec3C *out, Vec3C *a, Mat3C *m) nogil
    @staticmethod
    cdef inline void c_transform_mat4(Vec3C *out, Vec3C *a, Mat4C *m) nogil
    @staticmethod
    cdef inline void c_transform_quat(Vec3C *out, Vec3C *a, QuatC *q) nogil