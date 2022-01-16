from pyorama.math.quat cimport *
from pyorama.math.vec4 cimport *

cdef class Mat4:

    def __init__(self, bint identity=True):
        if identity:
            Mat4.c_identity(&self.data)

    @staticmethod
    cdef Mat4 c_from_data(Mat4C *m):
        cdef Mat4 out = Mat4.__new__(Mat4)
        out.data = m[0]
        return out
    
    @staticmethod
    def set_data(Mat4 out, list data):
        cdef:
            size_t n = 4
            size_t i, j, k
            mat4 d = <mat4>&out.data
        
        for i in range(n):
            for j in range(n):
                k = n * i + j
                d[i][j] = <float>data[k]

    @staticmethod
    cdef void c_copy(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_copy(<mat4>m, <mat4>out)
    
    @staticmethod
    def copy(Mat4 out, Mat4 m):
        Mat4.c_copy(&out.data, &m.data)
    
    @staticmethod
    cdef void c_decompose(Mat4C *m, Vec4C *t, Mat4C *r, Vec4C *s) nogil:
        glm_decompose(<mat4>m, <vec4>t, <mat4>r, <vec4>s)

    @staticmethod
    def decompose(Mat4 m, Vec4 t, Mat4 r, Vec4 s):
        Mat4.c_decompose(&m.data, &t.data, &r.data, &s.data)

    @staticmethod
    cdef void c_decompose_rot_scale(Mat4C *m, Mat4C *r, Vec4C *s) nogil:
        glm_decompose_rs(<mat4>m, <mat4>r, <vec4>s)

    @staticmethod
    def decompose_rot_scale(Mat4 m, Mat4 r, Vec4 s):
        Mat4.c_decompose_rot_scale(&m.data, &r.data, &s.data)

    @staticmethod
    cdef void c_decompose_scale(Mat4C *m, Vec4C *s) nogil:
        glm_decompose_scalev(<mat4>m, <vec4>s)

    @staticmethod
    def decompose_scale(Mat4 m, Vec4 s):
        Mat4.c_decompose_scale(&m.data, &s.data)

    @staticmethod
    cdef float c_det(Mat4C *m) nogil:
        return glm_mat4_det(<mat4>m)

    @staticmethod
    def det(Mat4 m):
        return Mat4.c_det(&m.data)
    
    @staticmethod
    cdef void c_from_quat(Mat4C *out, QuatC *q, bint transpose=False) nogil:
        if transpose: glm_quat_mat4t(<versor>q, <mat4>out)
        else: glm_quat_mat4(<versor>q, <mat4>out)

    @staticmethod
    def from_quat(Mat4 out, Quat q, bint transpose=False):
        Mat4.c_from_quat(&out.data, &q.data, transpose)

    @staticmethod
    cdef void c_from_rotation(Mat4C *out, float angle, Vec4C *axis) nogil:
        glm_rotate_make(<mat4>out, angle, <vec4>axis)

    @staticmethod
    def from_rotation(Mat4 out, float angle, Vec4 axis):
        Mat4.c_from_rotation(&out.data, angle, &axis.data)

    @staticmethod
    cdef void c_from_rotation_at(Mat4C *out, Vec4C *pivot, float angle, Vec4C *axis) nogil:
        glm_rotate_atm(<mat4>out, <vec4>pivot, angle, <vec4>axis)

    @staticmethod
    def from_rotation_at(Mat4 out, Vec4 pivot, float angle, Vec4 axis):
        Mat4.c_from_rotation_at(&out.data, &pivot.data, angle, &axis.data)

    @staticmethod
    cdef void c_from_scaling(Mat4C *out, Vec4C *v) nogil:
        glm_scale_make(<mat4>out, <vec4>v)

    @staticmethod
    def from_scaling(Mat4 out, Vec4 v):
        Mat4.c_from_scaling(&out.data, &v.data)

    @staticmethod
    cdef void c_from_translation(Mat4C *out, Vec4C *v) nogil:
        glm_translate_make(<mat4>out, <vec4>v)

    @staticmethod
    def from_translation(Mat4 out, Vec4 v):
        Mat4.c_from_translation(&out.data, &v.data)

    @staticmethod
    cdef bint c_is_uniform_scaled(Mat4C *m) nogil:
        return glm_uniscaled(<mat4>m)

    @staticmethod
    def is_uniform_scaled(Mat4 m):
        return Mat4.c_is_uniform_scaled(&m.data)

    @staticmethod
    cdef void c_identity(Mat4C *out) nogil:
        glm_mat4_identity(<mat4>out)

    @staticmethod
    def identity(Mat4 out):
        Mat4.c_identity(&out.data)
    
    @staticmethod
    cdef void c_inv(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_inv(<mat4>m, <mat4>out)

    @staticmethod
    def inv(Mat4 out, Mat4 m):
        Mat4.c_inv(&out.data, &m.data)

    @staticmethod
    cdef void c_inv_fast(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_inv_fast(<mat4>m, <mat4>out)

    @staticmethod
    def inv_fast(Mat4 out, Mat4 m):
        Mat4.c_inv_fast(&out.data, &m.data)
    
    @staticmethod
    cdef void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        glm_mat4_mul(<mat4>a, <mat4>b, <mat4>out)
    
    @staticmethod
    def mul(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul_scalar(Mat4C *out, float scalar) nogil:
        glm_mat4_scale(<mat4>out, scalar)

    @staticmethod
    def mul_scalar(Mat4 out, float scalar):
        Mat4.c_mul_scalar(&out.data, scalar)

    @staticmethod
    cdef void c_rotate(Mat4C *out, float angle, Vec4C *axis) nogil:
        glm_rotate(<mat4>out, angle, <vec4>axis)

    @staticmethod
    def rotate(Mat4 out, float angle, Vec4 axis):
        Mat4.c_rotate(&out.data, angle, &axis.data)

    @staticmethod
    cdef void c_rotate_at(Mat4C *out, Vec4C *pivot, float angle, Vec4C *axis) nogil:
        glm_rotate_at(<mat4>out, <vec4>pivot, angle, <vec4>axis)

    @staticmethod
    def rotate_at(Mat4 out, Vec4 pivot, float angle, Vec4 axis):
        Mat4.c_rotate_at(&out.data, &pivot.data, angle, &axis.data)

    @staticmethod
    cdef void c_rotate_x(Mat4C *out, Mat4C *m, float angle) nogil:
        glm_rotate_x(<mat4>m, angle, <mat4>out)

    @staticmethod
    def rotate_x(Mat4 out, Mat4 m, float angle):
        Mat4.c_rotate_x(&out.data, &m.data, angle)

    @staticmethod
    cdef void c_rotate_y(Mat4C *out, Mat4C *m, float angle) nogil:
        glm_rotate_y(<mat4>m, angle, <mat4>out)

    @staticmethod
    def rotate_y(Mat4 out, Mat4 m, float angle):
        Mat4.c_rotate_y(&out.data, &m.data, angle)
        
    @staticmethod
    cdef void c_rotate_z(Mat4C *out, Mat4C *m, float angle) nogil:
        glm_rotate_z(<mat4>m, angle, <mat4>out)

    @staticmethod
    def rotate_z(Mat4 out, Mat4 m, float angle):
        Mat4.c_rotate_z(&out.data, &m.data, angle)

    @staticmethod
    cdef float c_row_mat_col(Vec4C *r, Mat4C *m, Vec4C *c) nogil:
        return glm_mat4_rmc(<vec4>r, <mat4>m, <vec4>c)

    @staticmethod
    def row_mat_col(Vec4 r, Mat4 m, Vec4 c):
        return Mat4.c_row_mat_col(&r.data, &m.data, &c.data)

    @staticmethod
    cdef void c_scale(Mat4C *out, Vec4C *v) nogil:
        glm_scale(<mat4>out, <vec4>v)

    @staticmethod
    def scale(Mat4 out, Vec4 v):
        Mat4.c_scale(&out.data, &v.data)

    @staticmethod
    cdef void c_scale_to(Mat4C *out, Mat4C *m, Vec4C *v) nogil:
        glm_scale_to(<mat4>m, <vec4>v, <mat4>out)

    @staticmethod
    def scale_to(Mat4 out, Mat4 m, Vec4 v):
        Mat4.c_scale_to(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_scale_uniform(Mat4C *out, float s) nogil:
        glm_scale_uni(<mat4>out, s)

    @staticmethod
    def scale_uniform(Mat4 out, float s):
        Mat4.c_scale_uniform(&out.data, s)

    @staticmethod
    cdef void c_swap_col(Mat4C *m, size_t c1, size_t c2) nogil:
        glm_mat4_swap_col(<mat4>m, c1, c2)

    @staticmethod
    def swap_col(Mat4 m, size_t c1, size_t c2):
        Mat4.c_swap_col(&m.data, c1, c2)

    @staticmethod
    cdef void c_swap_row(Mat4C *m, size_t r1, size_t r2) nogil:
        glm_mat4_swap_row(<mat4>m, r1, r2)

    @staticmethod
    def swap_row(Mat4 m, size_t r1, size_t r2):
        Mat4.c_swap_row(&m.data, r1, r2)
    
    @staticmethod
    cdef float c_trace(Mat4C *m) nogil:
        return glm_mat4_trace(<mat4>m)

    @staticmethod
    def trace(Mat4 m):
        return Mat4.c_trace(&m.data)

    @staticmethod
    cdef float c_trace_rot(Mat4C *m) nogil:
        return glm_mat4_trace3(<mat4>m)

    @staticmethod
    def trace_rot(Mat4 m):
        return Mat4.c_trace_rot(&m.data)

    @staticmethod
    cdef void c_translate(Mat4C *out, Vec4C *v) nogil:
        glm_translate(<mat4>out, <vec4>v)

    @staticmethod
    cdef void c_translate_to(Mat4C *out, Mat4C *m, Vec4C *v) nogil:
        glm_translate_to(<mat4>m, <vec4>v, <mat4>out)

    @staticmethod
    def translate_to(Mat4 out, Mat4 m, Vec4 v):
        Mat4.c_translate_to(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_translate_x(Mat4C *out, float x) nogil:
        glm_translate_x(<mat4>out, x)

    @staticmethod
    def translate_x(Mat4 out, float x):
        Mat4.c_translate_x(&out.data, x)

    @staticmethod
    cdef void c_translate_y(Mat4C *out, float y) nogil:
        glm_translate_y(<mat4>out, y)

    @staticmethod
    def translate_y(Mat4 out, float y):
        Mat4.c_translate_y(&out.data, y)

    @staticmethod
    cdef void c_translate_z(Mat4C *out, float z) nogil:
        glm_translate_z(<mat4>out, z)

    @staticmethod
    def translate_z(Mat4 out, float z):
        Mat4.c_translate_z(&out.data, z)
    
    @staticmethod
    cdef void c_transpose(Mat4C *out) nogil:
        glm_mat4_transpose(<mat4>out)

    @staticmethod
    def transpose(Mat4 out):
        Mat4.c_transpose(&out.data)

    @staticmethod
    cdef void c_transpose_to(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_transpose_to(<mat4>m, <mat4>out)
    
    @staticmethod
    def transpose_to(Mat4 out, Mat4 m):
        Mat4.c_transpose_to(&out.data, &m.data)

    @staticmethod
    cdef void c_zero(Mat4C *out) nogil:
        glm_mat4_zero(<mat4>out)

    @staticmethod
    def zero(Mat4 out):
        Mat4.c_zero(&out.data)