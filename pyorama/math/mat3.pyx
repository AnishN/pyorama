from pyorama.math.quat cimport *
from pyorama.math.vec2 cimport *
from pyorama.math.vec3 cimport *

cdef class Mat3:

    def __init__(self, bint identity=True):
        if identity:
            Mat3.c_identity(&self.data)

    @staticmethod
    cdef Mat3 c_from_data(Mat3C *m):
        cdef Mat3 out = Mat3.__new__(Mat3)
        out.data = m[0]
        return out
    
    @staticmethod
    def set_data(Mat3 out, list data):
        cdef:
            size_t n = 3
            size_t i, j, k
            mat3 d = <mat3>&out.data
        
        for i in range(n):
            for j in range(n):
                k = n * i + j
                d[i][j] = <float>data[k]

    @staticmethod
    cdef void c_copy(Mat3C *out, Mat3C *m) nogil:
        glm_mat3_copy(<mat3>m, <mat3>out)
    
    @staticmethod
    def copy(Mat3 out, Mat3 m):
        Mat3.c_copy(&out.data, &m.data)

    @staticmethod
    cdef float c_det(Mat3C *m) nogil:
        return glm_mat3_det(<mat3>m)

    @staticmethod
    def det(Mat3 m):
        return Mat3.c_det(&m.data)

    @staticmethod
    cdef void c_from_quat(Mat3C *out, QuatC *q, bint transpose=False) nogil:
        if transpose: glm_quat_mat3t(<versor>q, <mat3>out)
        else:glm_quat_mat3(<versor>q, <mat3>out)

    @staticmethod
    def from_quat(Mat3 out, Quat q, bint transpose=False):
        Mat3.c_from_quat(&out.data, &q.data, transpose)

    @staticmethod
    cdef void c_from_rotation(Mat3C *out, float angle) nogil:
        glm_rotate2d_make(<mat3>out, angle)

    @staticmethod
    def from_rotation(Mat3 out, float angle):
        Mat3.c_from_rotation(&out.data, angle)

    @staticmethod
    cdef void c_from_scaling(Mat3C *out, Vec2C *v) nogil:
        glm_scale2d_make(<mat3>out, <vec2>v)

    @staticmethod
    def from_scaling(Mat3 out, Vec2 v):
        Mat3.c_from_scaling(&out.data, &v.data)

    @staticmethod
    cdef void c_from_translation(Mat3C *out, Vec2C *v) nogil:
        glm_translate2d_make(<mat3>out, <vec2>v)
    
    @staticmethod
    def from_translation(Mat3 out, Vec2 v):
        Mat3.c_from_translation(&out.data, &v.data)

    @staticmethod
    cdef void c_identity(Mat3C *out) nogil:
        glm_mat3_identity(<mat3>out)

    @staticmethod
    def identity(Mat3 out):
        Mat3.c_identity(&out.data)

    @staticmethod
    cdef void c_inv(Mat3C *out, Mat3C *m) nogil:
        glm_mat3_inv(<mat3>m, <mat3>out)

    @staticmethod
    def inv(Mat3 out, Mat3 m):
        Mat3.c_inv(&out.data, &m.data)

    @staticmethod
    cdef void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        glm_mat3_mul(<mat3>a, <mat3>b, <mat3>out)

    @staticmethod
    def mul(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul_scalar(Mat3C *out, float scalar) nogil:
        glm_mat3_scale(<mat3>out, scalar)
    
    @staticmethod
    def mul_scalar(Mat3 out, float scalar):
        Mat3.c_mul_scalar(&out.data, scalar)

    @staticmethod
    cdef void c_random(Mat3C *out) nogil:
        out.m00 = random_get_float()
        out.m01 = random_get_float()
        out.m02 = random_get_float()
        out.m10 = random_get_float()
        out.m11 = random_get_float()
        out.m12 = random_get_float()
        out.m20 = random_get_float()
        out.m21 = random_get_float()
        out.m22 = random_get_float()

    @staticmethod
    def random(Mat3 out):
        Mat3.c_random(&out.data)

    @staticmethod
    cdef void c_rotate(Mat3C *out, float angle) nogil:
        glm_rotate2d(<mat3>out, angle)
    
    @staticmethod
    def rotate(Mat3 out, float angle):
        Mat3.c_rotate(&out.data, angle)

    @staticmethod
    cdef void c_rotate_to(Mat3C *out, Mat3C *m, float angle) nogil:
        glm_rotate2d_to(<mat3>m, angle, <mat3>out)
    
    @staticmethod
    def rotate_to(Mat3 out, Mat3 m, float angle):
        Mat3.c_rotate_to(&out.data, &m.data, angle)

    @staticmethod
    cdef float c_row_mat_col(Vec3C *r, Mat3C *m, Vec3C *c) nogil:
        return glm_mat3_rmc(<vec3>r, <mat3>m, <vec3>c)
    
    @staticmethod
    def row_mat_col(Vec3 r, Mat3 m, Vec3 c):
        Mat3.c_row_mat_col(&r.data, &m.data, &c.data)

    @staticmethod
    cdef void c_scale(Mat3C *out, Vec2C *v) nogil:
        glm_scale2d(<mat3>out, <vec2>v)

    @staticmethod
    def scale(Mat3 out, Vec2 v):
        Mat3.c_scale(&out.data, &v.data)

    @staticmethod
    cdef void c_scale_to(Mat3C *out, Mat3C *m, Vec2C *v) nogil:
        glm_scale2d_to(<mat3>m, <vec2>v, <mat3>out)

    @staticmethod
    def scale_to(Mat3 out, Mat3 m, Vec2 v):
        Mat3.c_scale_to(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_scale_uniform(Mat3C *out, float s) nogil:
        glm_scale2d_uni(<mat3>out, s)
    
    @staticmethod
    def scale_uniform(Mat3 out, float s):
        Mat3.c_scale_uniform(&out.data, s)

    @staticmethod
    cdef void c_swap_col(Mat3C *m, size_t c1, size_t c2) nogil:
        glm_mat3_swap_col(<mat3>m, c1, c2)

    @staticmethod
    def swap_col(Mat3 m, size_t c1, size_t c2):
        Mat3.c_swap_col(&m.data, c1, c2)

    @staticmethod
    cdef void c_swap_row(Mat3C *m, size_t r1, size_t r2) nogil:
        glm_mat3_swap_row(<mat3>m, r1, r2)
    
    @staticmethod
    def swap_row(Mat3 m, size_t r1, size_t r2):
        Mat3.c_swap_row(&m.data, r1, r2)

    @staticmethod
    cdef float c_trace(Mat3C *m) nogil:
        return glm_mat3_trace(<mat3>m)

    @staticmethod
    def trace(Mat3 m):
        return Mat3.c_trace(&m.data)

    @staticmethod
    cdef void c_translate(Mat3C *out, Vec2C *v) nogil:
        glm_translate2d(<mat3>out, <vec2>v)

    @staticmethod
    def translate(Mat3 out, Vec2 v):
        Mat3.c_translate(&out.data, &v.data)

    @staticmethod
    cdef void c_translate_to(Mat3C *out, Mat3C *m, Vec2C *v) nogil:
        glm_translate2d_to(<mat3>m, <vec2>v, <mat3>out)

    @staticmethod
    def translate_to(Mat3 out, Mat3 m, Vec2 v):
        Mat3.c_translate_to(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_translate_x(Mat3C *out, float x) nogil:
        glm_translate2d_x(<mat3>out, x)

    @staticmethod
    def translate_x(Mat3 out, float x):
        Mat3.c_translate_x(&out.data, x)

    @staticmethod
    cdef void c_translate_y(Mat3C *out, float y) nogil:
        glm_translate2d_y(<mat3>out, y)

    @staticmethod
    def translate_y(Mat3 out, float y):
        Mat3.c_translate_y(&out.data, y)

    @staticmethod
    cdef void c_transpose(Mat3C *out) nogil:
        glm_mat3_transpose(<mat3>out)

    @staticmethod
    def transpose(Mat3 out):
        Mat3.c_transpose(&out.data)

    @staticmethod
    cdef void c_transpose_to(Mat3C *out, Mat3C *m) nogil:
        glm_mat3_transpose_to(<mat3>m, <mat3>out)
    
    @staticmethod
    def transpose_to(Mat3 out, Mat3 m):
        Mat3.c_transpose_to(&out.data, &m.data)

    @staticmethod
    cdef void c_zero(Mat3C *out) nogil:
        glm_mat3_zero(<mat3>out)

    @staticmethod
    def zero(Mat3 out):
        Mat3.c_zero(&out.data)