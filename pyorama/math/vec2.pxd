from pyorama.libs.c cimport *
from pyorama.math.common cimport *
from pyorama.math.mat2 cimport *
from pyorama.math.mat3 cimport *
from pyorama.math.mat4 cimport *
from pyorama.math.vec3 cimport *

cdef class Vec2:
    cdef:
        Vec2C *data
        readonly bint is_owner
    
    @staticmethod
    cdef Vec2 c_from_ptr(Vec2C *a)
    
    @staticmethod
    cdef void c_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef void c_ceil(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef void c_copy(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef void c_cross(Vec3C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef float c_dist(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef void c_div(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef float c_dot(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef bint c_equals(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef void c_floor(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef void c_inv(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef float c_length(Vec2C *a) nogil
    @staticmethod
    cdef void c_lerp(Vec2C *out, Vec2C *a, Vec2C *b, float t) nogil
    @staticmethod
    cdef void c_max_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef void c_min_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef void c_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(Vec2C *a, Vec2C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_negate(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef void c_norm(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef void c_random(Vec2C *out) nogil
    @staticmethod
    cdef void c_rotate(Vec2C *out, Vec2C *a, Vec2C *b, float radians) nogil
    @staticmethod
    cdef void c_round(Vec2C *out, Vec2C *a) nogil
    @staticmethod
    cdef void c_scale_add(Vec2C *out, Vec2C *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_data(Vec2C *out, float x=*, float y=*) nogil
    @staticmethod
    cdef float c_sqr_dist(Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef float c_sqr_length(Vec2C *a) nogil
    @staticmethod
    cdef void c_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil
    @staticmethod
    cdef void c_transform_mat2(Vec2C *out, Vec2C *a, Mat2C *m) nogil
    @staticmethod
    cdef void c_transform_mat3(Vec2C *out, Vec2C *a, Mat3C *m) nogil
    @staticmethod
    cdef void c_transform_mat4(Vec2C *out, Vec2C *a, Mat4C *m) nogil