from pyorama.libs.c cimport *
from pyorama.math.common cimport *
from pyorama.math.quat cimport *
from pyorama.math.vec3 cimport *

cdef class Mat4:
    cdef:
        Mat4C *data
        readonly bint is_owner
    
    @staticmethod
    cdef Mat4 c_from_ptr(Mat4C *a)
    @staticmethod
    cdef void c_add(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef void c_copy(Mat4C *out, Mat4C *a) nogil
    @staticmethod
    cdef float c_det(Mat4C *a) nogil
    @staticmethod
    cdef void c_div(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef void c_dot(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef bint c_equals(Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef void c_from_quat(Mat4C *out, QuatC *a) nogil
    @staticmethod
    cdef void c_from_rotation(Mat4C *out, float radians, Vec3C *axis) nogil
    @staticmethod
    cdef void c_from_rotation_x(Mat4C *out, float radians) nogil
    @staticmethod
    cdef void c_from_rotation_y(Mat4C *out, float radians) nogil
    @staticmethod
    cdef void c_from_rotation_z(Mat4C *out, float radians) nogil
    @staticmethod
    cdef void c_from_scaling(Mat4C *out, Vec3C *scale) nogil
    @staticmethod
    cdef void c_from_translation(Mat4C *out, Vec3C *shift) nogil
    @staticmethod
    cdef void c_frustum(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil
    @staticmethod
    cdef void c_get_rotation(QuatC *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_get_scale(Vec3C *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_get_translation(Vec3C *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_identity(Mat4C *out) nogil
    @staticmethod
    cdef void c_inv(Mat4C *out, Mat4C *a) nogil
    @staticmethod
    cdef void c_look_at(Mat4C *out, Vec3C *eye, Vec3C *center, Vec3C *up) nogil
    @staticmethod
    cdef void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef bint c_nearly_equals(Mat4C *a, Mat4C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_ortho(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil
    @staticmethod
    cdef void c_perspective(Mat4C *out, float fovy, float aspect, float near, float far) nogil
    @staticmethod
    cdef void c_random(Mat4C *out) nogil
    @staticmethod
    cdef void c_rotate(Mat4C *out, Mat4C *a, float radians, Vec3C *axis) nogil
    @staticmethod
    cdef void c_rotate_quat(Mat4C *out, Mat4C *a, QuatC *quat) nogil
    @staticmethod
    cdef void c_rotate_x(Mat4C *out, Mat4C *a, float radians) nogil
    @staticmethod
    cdef void c_rotate_y(Mat4C *out, Mat4C *a, float radians) nogil
    @staticmethod
    cdef void c_rotate_z(Mat4C *out, Mat4C *a, float radians) nogil
    @staticmethod
    cdef void c_scale(Mat4C *out, Mat4C *a, Vec3C *factor) nogil
    @staticmethod
    cdef void c_scale_add(Mat4C *out, Mat4C *a, float scale=*, float add=*) nogil
    @staticmethod
    cdef void c_set_data(Mat4C *out, float m00=*, float m01=*, float m02=*, float m03=*,
            float m10=*, float m11=*, float m12=*, float m13=*,
            float m20=*, float m21=*, float m22=*, float m23=*,
            float m30=*, float m31=*, float m32=*, float m33=*) nogil
    @staticmethod
    cdef void c_sub(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef void c_translate(Mat4C *out, Mat4C *a, Vec3C *shift) nogil
    @staticmethod
    cdef void c_transpose(Mat4C *out, Mat4C *a) nogil