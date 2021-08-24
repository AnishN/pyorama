from pyorama.libs.c cimport *
from pyorama.math.common cimport *
from pyorama.math.mat4 cimport *
from pyorama.math.quat cimport *
from pyorama.math.vec2 cimport *

cdef class Mat3:
    cdef:
        Mat3C *data
        readonly bint is_owner
    
    @staticmethod
    cdef Mat3 c_from_ptr(Mat3C *a)
    @staticmethod
    cdef void c_add(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef void c_copy(Mat3C *out, Mat3C *a) nogil
    @staticmethod
    cdef float c_det(Mat3C *a) nogil
    @staticmethod
    cdef void c_div(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef void c_dot(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef bint c_equals(Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef void c_from_mat4(Mat3C *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_from_quat(Mat3C *out, QuatC *a) nogil
    @staticmethod
    cdef void c_from_rotation(Mat3C *out, float radians) nogil
    @staticmethod
    cdef void c_from_scaling(Mat3C *out, Vec2C *scale) nogil
    @staticmethod
    cdef void c_from_skewing(Mat3C *out, Vec2C *factor) nogil
    @staticmethod
    cdef void c_from_skewing_x(Mat3C *out, float radians) nogil
    @staticmethod
    cdef void c_from_skewing_y(Mat3C *out, float radians) nogil
    @staticmethod
    cdef void c_from_translation(Mat3C *out, Vec2C *shift) nogil
    @staticmethod
    cdef void c_identity(Mat3C *out) nogil
    @staticmethod
    cdef void c_inv(Mat3C *out, Mat3C *a) nogil
    @staticmethod
    cdef void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(Mat3C *a, Mat3C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_normal_from_mat4(Mat3C *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_random(Mat3C *out) nogil
    @staticmethod
    cdef void c_rotate(Mat3C *out, Mat3C *a, float radians) nogil
    @staticmethod
    cdef void c_scale(Mat3C *out, Mat3C *a, Vec2C *factor) nogil
    @staticmethod
    cdef void c_scale_add(Mat3C *out, Mat3C *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_data(Mat3C *out, float m00=*, float m01=*, float m02=*,
            float m10=*, float m11=*, float m12=*,
            float m20=*, float m21=*, float m22=*) nogil
    @staticmethod
    cdef void c_skew(Mat3C *out, Mat3C *a, Vec2C *factor) nogil
    @staticmethod
    cdef void c_skew_x(Mat3C *out, Mat3C *a, float radians) nogil
    @staticmethod
    cdef void c_skew_y(Mat3C *out, Mat3C *a, float radians) nogil
    @staticmethod
    cdef void c_sub(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef void c_transpose(Mat3C *out, Mat3C *a) nogil
    @staticmethod
    cdef void c_translate(Mat3C *out, Mat3C *a, Vec2C *shift) nogil