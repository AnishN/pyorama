from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Quat:
    cdef:
        float[4] data

    @staticmethod
    cdef Quat c_from_data(quat q)
    @staticmethod
    cdef void c_identity(quat out) nogil
    @staticmethod
    cdef void c_init(quat out, float x, float y, float z, float w) nogil
    @staticmethod
    cdef void c_from_angle_axis(quat out, float angle, vec3 axis) nogil
    @staticmethod
    cdef void c_copy(quat out, quat q) nogil
    @staticmethod
    cdef void c_from_vecs(quat out, vec3 a, vec3 b) nogil
    @staticmethod
    cdef float c_mag(quat q) nogil
    @staticmethod
    cdef void c_normalize(quat out) nogil
    @staticmethod
    cdef void c_normalize_to(quat out, quat q) nogil
    @staticmethod
    cdef float c_dot(quat a, quat b) nogil
    @staticmethod
    cdef void c_conjugate(quat out, quat q) nogil
    @staticmethod
    cdef void c_inv(quat out, quat q) nogil
    @staticmethod
    cdef void c_add(quat out, quat a, quat b) nogil
    @staticmethod
    cdef void c_sub(quat out, quat a, quat b) nogil
    @staticmethod
    cdef float c_real(quat q) nogil
    @staticmethod
    cdef void c_imag(quat q, vec3 imag) nogil
    @staticmethod
    cdef void c_imag_normalize(quat q, vec3 imag) nogil
    @staticmethod
    cdef float c_imag_mag(quat q) nogil
    @staticmethod
    cdef float c_angle(quat q) nogil
    @staticmethod
    cdef void c_axis(quat q, vec3 axis) nogil
    @staticmethod
    cdef void c_mul(quat out, quat a, quat b) nogil
    @staticmethod
    cdef void c_lerp(quat out, quat a, quat b, float t) nogil
    @staticmethod
    cdef void c_slerp(quat out, quat a, quat b, float t) nogil
    @staticmethod
    cdef void c_nlerp(quat out, quat a, quat b, float t) nogil
    @staticmethod
    cdef void c_look(quat out, vec3 dir_, vec3 up) nogil
    @staticmethod
    cdef void c_look_from_pos(quat out, vec3 a, vec3 b, vec3 up) nogil
    @staticmethod
    cdef void c_from_mat4(quat out, mat4 a) nogil