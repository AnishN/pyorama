from pyorama.math3d.common cimport *
from pyorama.math3d.vec3 cimport *

cdef class Quat:
    cdef QuatC *ptr
    
    @staticmethod
    cdef inline void c_add(QuatC *out, QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef inline void c_calculate_w(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef inline void c_conjugate(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef inline void c_copy(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef inline float c_dot(QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef inline bint c_equals(QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef inline void c_from_euler(QuatC *out, float x, float y, float z) nogil
    @staticmethod
    cdef inline void c_from_mat3(QuatC *out, Mat3C *a) nogil
    @staticmethod
    cdef inline float c_get_axis_angle(Vec3C *out, QuatC *a) nogil
    @staticmethod
    cdef inline void c_identity(QuatC *out) nogil
    @staticmethod
    cdef inline void c_inv(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef inline float c_length(QuatC *a) nogil
    @staticmethod
    cdef inline void c_lerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef inline void c_mul(QuatC *out, QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(QuatC *a, QuatC *b, float epsilon=0.000001) nogil
    @staticmethod
    cdef inline void c_norm(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef inline void c_rotate_x(QuatC *out, QuatC *a, float radians) nogil
    @staticmethod
    cdef inline void c_rotate_y(QuatC *out, QuatC *a, float radians) nogil
    @staticmethod
    cdef inline void c_rotate_z(QuatC *out, QuatC *a, float radians) nogil
    @staticmethod
    cdef inline void c_rotation_to(QuatC *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef inline void c_scale_add(QuatC *out, QuatC *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_axes(QuatC *out, Vec3C *view, Vec3C *right, Vec3C *up) nogil
    @staticmethod
    cdef inline void c_set_axis_angle(QuatC *out, Vec3C *axis, float radians) nogil
    @staticmethod
    cdef inline void c_set_data(QuatC *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil
    @staticmethod
    cdef inline void c_slerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef inline float c_sqr_length(QuatC *a) nogil