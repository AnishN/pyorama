from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

cdef class Quat:
    cdef:
        QuatC data

    @staticmethod
    cdef Quat c_from_data(QuatC *q)
    @staticmethod
    cdef void c_init(QuatC *out, float x, float y, float z, float w) nogil
    @staticmethod
    cdef void c_add(QuatC *out, QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef void c_axis(QuatC *q, Vec3C *axis) nogil
    @staticmethod
    cdef float c_angle(QuatC *q) nogil
    @staticmethod
    cdef void c_conjugate(QuatC *out, QuatC *q) nogil
    @staticmethod
    cdef void c_copy(QuatC *out, QuatC *q) nogil
    @staticmethod
    cdef float c_dot(QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef void c_from_angle_axis(QuatC *out, float angle, Vec3C *axis) nogil
    @staticmethod
    cdef void c_from_mat4(QuatC *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_from_vecs(QuatC *out, Vec3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_identity(QuatC *out) nogil
    @staticmethod
    cdef void c_imag(QuatC *q, Vec3C *imag) nogil
    @staticmethod
    cdef float c_imag_mag(QuatC *q) nogil
    @staticmethod
    cdef void c_imag_normalize(QuatC *q, Vec3C *imag) nogil
    @staticmethod
    cdef void c_inv(QuatC *out, QuatC *q) nogil
    @staticmethod
    cdef void c_lerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef float c_mag(QuatC *q) nogil
    @staticmethod
    cdef void c_mul(QuatC *out, QuatC *a, QuatC *b) nogil
    @staticmethod
    cdef void c_nlerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef void c_normalize(QuatC *out) nogil
    @staticmethod
    cdef void c_normalize_to(QuatC *out, QuatC *q) nogil
    @staticmethod
    cdef float c_real(QuatC *q) nogil
    @staticmethod
    cdef void c_slerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil
    @staticmethod
    cdef void c_sub(QuatC *out, QuatC *a, QuatC *b) nogil