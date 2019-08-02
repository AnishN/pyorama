from pyorama.math3d.common cimport *
from pyorama.math3d.mat4 cimport *
from pyorama.math3d.quat cimport *

cdef class Vec4:
    cdef Vec4C *ptr
    
    @staticmethod
    cdef inline void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline void c_ceil(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline void c_copy(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline float c_dist(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline float c_dot(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline bint c_equals(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline void c_floor(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline void c_inv(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline float c_length(Vec4C *a) nogil
    @staticmethod
    cdef inline void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil
    @staticmethod
    cdef inline void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(Vec4C *a, Vec4C *b, float epsilon=0.000001) nogil
    @staticmethod
    cdef inline void c_negate(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline void c_norm(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline void c_random(Vec4C *out) nogil
    @staticmethod
    cdef inline void c_round(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef inline void c_scale_add(Vec4C *out, Vec4C *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_data(Vec4C *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil
    @staticmethod
    cdef inline float c_sqr_dist(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline float c_sqr_length(Vec4C *a) nogil
    @staticmethod
    cdef inline void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef inline void c_transform_mat4(Vec4C *out, Vec4C *a, Mat4C *m) nogil
    @staticmethod
    cdef inline void c_transform_quat(Vec4C *out, Vec4C *a, QuatC *q) nogil