from pyorama.math3d.common cimport *
from pyorama.math3d.vec2 cimport *
from pyorama.math3d.mat4 cimport *

cdef class Mat3:
    cdef Mat3C *ptr
    
    @staticmethod
    cdef inline void c_add(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef inline void c_copy(Mat3C *out, Mat3C *a) nogil
    @staticmethod
    cdef inline float c_det(Mat3C *a) nogil
    @staticmethod
    cdef inline void c_div(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef inline void c_dot(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef inline bint c_equals(Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef inline void c_from_mat4(Mat3C *out, Mat4C *a) nogil
    @staticmethod
    cdef inline void c_from_quat(Mat3C *out, QuatC *a) nogil
    @staticmethod
    cdef inline void c_from_rotation(Mat3C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_scaling(Mat3C *out, Vec2C *scale) nogil
    @staticmethod
    cdef inline void c_from_skewing(Mat3C *out, Vec2C *factor) nogil
    @staticmethod
    cdef inline void c_from_skewing_x(Mat3C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_skewing_y(Mat3C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_translation(Mat3C *out, Vec2C *shift) nogil
    @staticmethod
    cdef inline void c_identity(Mat3C *out) nogil
    @staticmethod
    cdef inline void c_inv(Mat3C *out, Mat3C *a) nogil
    @staticmethod
    cdef inline void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(Mat3C *a, Mat3C *b, float epsilon=epsilon) nogil
    @staticmethod
    cdef inline void c_normal_from_mat4(Mat3C *out, Mat4C *a) nogil
    @staticmethod
    cdef inline void c_random(Mat3C *out) nogil
    @staticmethod
    cdef inline void c_rotate(Mat3C *out, Mat3C *a, float radians) nogil
    @staticmethod
    cdef inline void c_scale(Mat3C *out, Mat3C *a, Vec2C *factor) nogil
    @staticmethod
    cdef inline void c_scale_add(Mat3C *out, Mat3C *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_data(Mat3C *out, float m00=0.0, float m01=0.0, float m02=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0) nogil
    @staticmethod
    cdef inline void c_skew(Mat3C *out, Mat3C *a, Vec2C *factor) nogil
    @staticmethod
    cdef inline void c_skew_x(Mat3C *out, Mat3C *a, float radians) nogil
    @staticmethod
    cdef inline void c_skew_y(Mat3C *out, Mat3C *a, float radians) nogil
    @staticmethod
    cdef inline void c_sub(Mat3C *out, Mat3C *a, Mat3C *b) nogil
    @staticmethod
    cdef inline void c_transpose(Mat3C *out, Mat3C *a) nogil
    @staticmethod
    cdef inline void c_translate(Mat3C *out, Mat3C *a, Vec2C *shift) nogil