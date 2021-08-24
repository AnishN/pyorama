from pyorama.libs.c cimport *
from pyorama.math.common cimport *
from pyorama.math.vec3 cimport *

cdef class Mat2:
    cdef:
        Mat2C *data
        readonly bint is_owner
    
    @staticmethod
    cdef Mat2 c_from_ptr(Mat2C *a)
    @staticmethod
    cdef void c_add(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef void c_copy(Mat2C *out, Mat2C *a) nogil
    @staticmethod
    cdef float c_det(Mat2C *a) nogil
    @staticmethod
    cdef void c_div(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef void c_dot(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef bint c_equals(Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef void c_from_rotation(Mat2C *out, float radians) nogil
    @staticmethod
    cdef void c_from_scaling(Mat2C *out, Vec3C *scale) nogil
    @staticmethod
    cdef void c_identity(Mat2C *out) nogil
    @staticmethod
    cdef void c_inv(Mat2C *out, Mat2C *a) nogil
    @staticmethod
    cdef void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(Mat2C *a, Mat2C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_random(Mat2C *out) nogil
    @staticmethod
    cdef void c_rotate(Mat2C *out, Mat2C *a, float radians) nogil
    @staticmethod
    cdef void c_scale(Mat2C *out, Mat2C *a, Vec3C *factor) nogil
    @staticmethod
    cdef void c_scale_add(Mat2C *out, Mat2C *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_data(Mat2C *out, float m00=*, float m01=*, float m10=*, float m11=*) nogil
    @staticmethod
    cdef void c_sub(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef void c_transpose(Mat2C *out, Mat2C *a) nogil