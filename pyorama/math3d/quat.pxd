from pyorama.libs.c cimport *
from pyorama.math3d.common cimport *
from pyorama.math3d.mat3 cimport *
from pyorama.math3d.vec3 cimport *

cdef class Quat:
    cdef QuatC data
    
    @staticmethod
    cdef void c_add(QuatC *out, QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef void c_calculate_w(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef void c_conjugate(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef void c_copy(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef float c_dot(QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef bint c_equals(QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef void c_from_euler(QuatC *out, float x, float y, float z) nogil
    @staticmethod
    cdef void c_from_mat3(QuatC *out, Mat3C *a) nogil
    @staticmethod
    cdef float c_get_axis_angle(Vec3C *out, QuatC *a) nogil
    @staticmethod
    cdef void c_identity(QuatC *out) nogil
    @staticmethod
    cdef void c_inv(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef float c_length(QuatC *a) nogil
    @staticmethod
    cdef void c_lerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef void c_mul(QuatC *out, QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(QuatC *a, QuatC *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_norm(QuatC *out, QuatC *a) nogil
    @staticmethod
    cdef void c_rotate_x(QuatC *out, QuatC *a, float radians) nogil
    @staticmethod
    cdef void c_rotate_y(QuatC *out, QuatC *a, float radians) nogil
    @staticmethod
    cdef void c_rotate_z(QuatC *out, QuatC *a, float radians) nogil
    @staticmethod
    cdef void c_rotation_to(QuatC *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_scale_add(QuatC *out, QuatC *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_axes(QuatC *out, Vec3C *view, Vec3C *right, Vec3C *up) nogil
    @staticmethod
    cdef void c_set_axis_angle(QuatC *out, Vec3C *axis, float radians) nogil
    @staticmethod
    cdef void c_set_data(QuatC *out, float x=*, float y=*, float z=*, float w=*) nogil
    @staticmethod
    cdef void c_slerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef float c_sqr_length(QuatC *a) nogil