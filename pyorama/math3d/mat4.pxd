from pyorama.math3d.common cimport *
from pyorama.math3d.vec3 cimport *

cdef class Mat4:
    cdef Mat4C *ptr
    
    @staticmethod
    cdef inline void c_add(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef inline void c_copy(Mat4C *out, Mat4C *a) nogil
    @staticmethod
    cdef inline float c_det(Mat4C *a) nogil
    @staticmethod
    cdef inline void c_div(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef inline void c_dot(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef inline bint c_equals(Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef inline void c_from_quat(Mat4C *out, QuatC *a) nogil
    @staticmethod
    cdef inline void c_from_rotation(Mat4C *out, float radians, Vec3C *axis) nogil
    @staticmethod
    cdef inline void c_from_rotation_x(Mat4C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_rotation_y(Mat4C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_rotation_z(Mat4C *out, float radians) nogil
    @staticmethod
    cdef inline void c_from_scaling(Mat4C *out, Vec3C *scale) nogil
    @staticmethod
    cdef inline void c_from_translation(Mat4C *out, Vec3C *shift) nogil
    @staticmethod
    cdef inline void c_frustum(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil
    @staticmethod
    cdef inline void c_identity(Mat4C *out) nogil
    @staticmethod
    cdef inline void c_inv(Mat4C *out, Mat4C *a) nogil
    @staticmethod
    cdef inline void c_look_at(Mat4C *out, Vec3C *eye, Vec3C *center, Vec3C *up) nogil
    @staticmethod
    cdef inline void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef inline bint c_nearly_equals(Mat4C *a, Mat4C *b, float epsilon=epsilon) nogil
    @staticmethod
    cdef inline void c_ortho(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil
    @staticmethod
    cdef inline void c_perspective(Mat4C *out, float fovy, float aspect, float near, float far) nogil
    @staticmethod
    cdef inline void c_random(Mat4C *out) nogil
    @staticmethod
    cdef inline void c_rotate(Mat4C *out, Mat4C *a, float radians, Vec3C *axis) nogil
    @staticmethod
    cdef inline void c_rotate_x(Mat4C *out, Mat4C *a, float radians) nogil
    @staticmethod
    cdef inline void c_rotate_y(Mat4C *out, Mat4C *a, float radians) nogil
    @staticmethod
    cdef inline void c_rotate_z(Mat4C *out, Mat4C *a, float radians) nogil
    @staticmethod
    cdef inline void c_scale(Mat4C *out, Mat4C *a, Vec3C *factor) nogil
    @staticmethod
    cdef inline void c_scale_add(Mat4C *out, Mat4C *a, float scale=1.0, float add=0.0) nogil
    @staticmethod
    cdef inline void c_set_data(Mat4C *out, float m00=0.0, float m01=0.0, float m02=0.0, float m03=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0, float m13=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0, float m23=0.0,
            float m30=0.0, float m31=0.0, float m32=0.0, float m33=0.0) nogil
    @staticmethod
    cdef inline void c_sub(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef inline void c_translate(Mat4C *out, Mat4C *a, Vec3C *shift) nogil
    @staticmethod
    cdef inline void c_transpose(Mat4C *out, Mat4C *a) nogil