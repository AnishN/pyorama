from pyorama.libs.c cimport *
from pyorama.math3d.common cimport *
from pyorama.math3d.mat4 cimport *
from pyorama.math3d.quat cimport *

cdef class Vec4:
    cdef Vec4C data
    
    @staticmethod
    cdef void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_ceil(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef void c_copy(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef float c_dist(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef float c_dot(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef bint c_equals(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_floor(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef void c_inv(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef float c_length(Vec4C *a) nogil
    @staticmethod
    cdef void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil
    @staticmethod
    cdef void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(Vec4C *a, Vec4C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_negate(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef void c_norm(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef void c_random(Vec4C *out) nogil
    @staticmethod
    cdef void c_round(Vec4C *out, Vec4C *a) nogil
    @staticmethod
    cdef void c_scale_add(Vec4C *out, Vec4C *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_data(Vec4C *out, float x=*, float y=*, float z=*, float w=*) nogil
    @staticmethod
    cdef float c_sqr_dist(Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef float c_sqr_length(Vec4C *a) nogil
    @staticmethod
    cdef void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil
    @staticmethod
    cdef void c_transform_mat4(Vec4C *out, Vec4C *a, Mat4C *m) nogil
    @staticmethod
    cdef void c_transform_quat(Vec4C *out, Vec4C *a, QuatC *q) nogil