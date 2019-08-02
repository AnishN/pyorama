from pyorama.math3d.common cimport *
from pyorama.math3d.vec3 cimport *
from pyorama.math3d.mat2 cimport *
from pyorama.math3d.mat3 cimport *
from pyorama.math3d.mat4 cimport *

cdef class Vec2:
    cdef Vec2C *ptr
    
    @staticmethod
    cdef inline void c_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline void c_ceil(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline void c_copy(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline void c_cross(Vec3C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline float c_dist(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline void c_div(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline float c_dot(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline bint c_equals(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline void c_floor(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline void c_inv(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline float c_length(Vec2C *a) nogil
    @staticmethod
    cdef inline void c_lerp(Vec2C *out, Vec2C *a, Vec2C *b, float t) nogil
    @staticmethod
    cdef inline void c_max_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline void c_min_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline void c_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(Vec2C *a, Vec2C *b, float epsilon=epsilon) nogil
    @staticmethod
    cdef inline void c_negate(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline void c_norm(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline void c_random(Vec2C *out) nogil
    @staticmethod
    cdef inline void c_round(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef inline void c_scale_add(Vec2C *out, Vec2C *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_data(Vec2C *out, float x=0.0, float y=0.0) nogil
    @staticmethod
    cdef inline float c_sqr_dist(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline float c_sqr_length(Vec2C *a) nogil
    @staticmethod
    cdef inline void c_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef inline void c_transform_mat2(Vec2C *out, Vec2C *a, Mat2C *m) nogil
    @staticmethod
    cdef inline void c_transform_mat3(Vec2C *out, Vec2C *a, Mat3C *m) nogil
    @staticmethod
    cdef inline void c_transform_mat4(Vec2C *out, Vec2C *a, Mat4C *m) nogil