from pyorama.math.vec2 cimport *

cdef class Mat2:

    def __init__(self, bint identity=True):
        if identity:
            Mat2.c_identity(&self.data)

    @staticmethod
    cdef Mat2 c_from_data(Mat2C *m):
        cdef Mat2 out = Mat2.__new__(Mat2)
        out.data = m[0]
        return out
    
    @staticmethod
    def set_data(Mat2 out, list data):
        cdef:
            size_t n = 2
            size_t i, j, k
            mat2 d = <mat2>&out.data
        
        for i in range(n):
            for j in range(n):
                k = n * i + j
                d[i][j] = <float>data[k]

    @staticmethod
    cdef void c_copy(Mat2C *out, Mat2C *m) nogil:
        glm_mat2_copy(<mat2>m, <mat2>out)
    
    @staticmethod
    def copy(Mat2 out, Mat2 m):
        Mat2.c_copy(&out.data, &m.data)

    @staticmethod
    cdef float c_det(Mat2C *m) nogil:
        return glm_mat2_det(<mat2>m)
    
    @staticmethod
    def det(Mat2 m):
        return Mat2.c_det(&m.data)
    
    @staticmethod
    cdef void c_identity(Mat2C *out) nogil:
        glm_mat2_identity(<mat2>out)
    
    @staticmethod
    def identity(Mat2 out):
        Mat2.c_identity(&out.data)

    @staticmethod
    cdef void c_inv(Mat2C *out, Mat2C *m) nogil:
        glm_mat2_inv(<mat2>m, <mat2>out)
    
    @staticmethod
    def inv(Mat2 out, Mat2 m):
        Mat2.c_inv(&out.data, &m.data)

    @staticmethod
    cdef void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        glm_mat2_mul(<mat2>a, <mat2>b, <mat2>out)
    
    @staticmethod
    def mul(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul_scalar(Mat2C *out, float scalar) nogil:
        glm_mat2_scale(<mat2>out, scalar)
    
    @staticmethod
    def mul_scalar(Mat2 out, float scalar):
        Mat2.c_mul_scalar(&out.data, scalar)

    @staticmethod
    cdef void c_random(Mat2C *out) nogil:
        out.m00 = random_get_float()
        out.m01 = random_get_float()
        out.m10 = random_get_float()
        out.m11 = random_get_float()

    @staticmethod
    def random(Mat2 out):
        Mat2.c_random(&out.data)

    @staticmethod
    cdef float c_row_mat_col(Vec2C *r, Mat2C *m, Vec2C *c) nogil:
        return glm_mat2_rmc(<vec2>r, <mat2>m, <vec2>c)
    
    @staticmethod
    def row_mat_col(Vec2 r, Mat2 m, Vec2 c):
        Mat2.c_row_mat_col(&r.data, &m.data, &c.data)

    @staticmethod
    cdef void c_swap_col(Mat2C *m, size_t c1, size_t c2) nogil:
        glm_mat2_swap_col(<mat2>m, c1, c2)

    @staticmethod
    def swap_col(Mat2 m, size_t c1, size_t c2):
        Mat2.c_swap_col(&m.data, c1, c2)

    @staticmethod
    cdef void c_swap_row(Mat2C *m, size_t r1, size_t r2) nogil:
        glm_mat2_swap_row(<mat2>m, r1, r2)

    @staticmethod
    def swap_row(Mat2 m, size_t r1, size_t r2):
        Mat2.c_swap_row(&m.data, r1, r2)
    
    @staticmethod
    cdef float c_trace(Mat2C *m) nogil:
        return glm_mat2_trace(<mat2>m)

    @staticmethod
    def trace(Mat2 m):
        return Mat2.c_trace(&m.data)
    
    @staticmethod
    cdef void c_transpose(Mat2C *out) nogil:
        glm_mat2_transpose(<mat2>out)

    @staticmethod
    def transpose(Mat2 out):
        Mat2.c_transpose(&out.data)

    @staticmethod
    cdef void c_transpose_to(Mat2C *out, Mat2C *m) nogil:
        glm_mat2_transpose_to(<mat2>m, <mat2>out)

    @staticmethod
    def transpose_to(Mat2 out, Mat2 m):
        Mat2.c_transpose_to(&out.data, &m.data)

    @staticmethod
    cdef void c_zero(Mat2C *out) nogil:
        glm_mat2_zero(<mat2>out)

    @staticmethod
    def zero(Mat2 out):
        Mat2.c_zero(&out.data)