from pyorama.math3d.common cimport *
from pyorama.math3d.vec3 cimport *
from pyorama.math3d.mat2 cimport *

cdef class Mat2:
    cdef Mat2C *ptr
    
    @staticmethod
    cdef inline void c_add(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef inline void c_copy(Mat2C *out, Mat2C *a) nogil
    @staticmethod
    cdef inline float c_det(Mat2C *a) nogil
    @staticmethod
    cdef inline void c_div(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef inline void c_dot(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef inline bint c_equals(Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef inline void c_from_rotation(Mat2C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_scaling(Mat2C *out, Vec3C *scale) nogil
    @staticmethod
    cdef inline void c_identity(Mat2C *out) nogil
    @staticmethod
    cdef inline void c_inv(Mat2C *out, Mat2C *a) nogil
    @staticmethod
    cdef inline void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(Mat2C *a, Mat2C *b, float epsilon=epsilon) nogil
    @staticmethod
    cdef inline void c_random(Mat2C *out) nogil
    @staticmethod
    cdef inline void c_rotate(Mat2C *out, Mat2C *a, float radians) nogil
    @staticmethod
    cdef inline void c_scale(Mat2C *out, Mat2C *a, Vec3C *factor) nogil
    @staticmethod
    cdef inline void c_scale_add(Mat2C *out, Mat2C *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_data(Mat2C *out, float m00=0.0, float m01=0.0, float m10=0.0, float m11=0.0) nogil
    @staticmethod
    cdef inline void c_sub(Mat2C *out, Mat2C *a, Mat2C *b) nogil
    @staticmethod
    cdef inline void c_transpose(Mat2C *out, Mat2C *a) nogil