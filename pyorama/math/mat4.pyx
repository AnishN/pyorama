cdef class Mat4:

    @staticmethod
    cdef Mat4 c_from_data(mat4 m):
        cdef Mat4 out = Mat4.__new__(Mat4)
        out.data = m
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(mat4 out, mat4 m) nogil:
        glm_mat4_copy(m, out)
    
    @staticmethod
    cdef void c_identity(mat4 out) nogil:
        glm_mat4_identity(out)
    
    @staticmethod
    cdef void c_zero(mat4 out) nogil:
        glm_mat4_zero(out)
    
    @staticmethod
    cdef void c_mul(mat4 out, mat4 a, mat4 b) nogil:
        glm_mat4_mul(a, b, out)

    @staticmethod
    cdef void c_transpose_to(mat4 out, mat4 m) nogil:
        glm_mat4_transpose_to(m, out)

    @staticmethod
    cdef void c_transpose(mat4 out) nogil:
        glm_mat4_transpose(out)

    @staticmethod
    cdef float c_trace(mat4 m) nogil:
        return glm_mat4_trace(m)

    @staticmethod
    cdef float c_trace3(mat4 m) nogil:
        return glm_mat4_trace3(m)

    @staticmethod
    cdef void c_scale(mat4 out, float scale) nogil:
        glm_mat4_scale(out, scale)

    @staticmethod
    cdef float c_det(mat4 m) nogil:
        return glm_mat4_det(m)

    @staticmethod
    cdef void c_inv(mat4 out, mat4 m) nogil:
        glm_mat4_inv(m, out)

    @staticmethod
    cdef void c_inv_fast(mat4 out, mat4 m) nogil:
        glm_mat4_inv_fast(m, out)

    @staticmethod
    cdef void c_swap_col(mat4 m, size_t col_1, size_t col_2) nogil:
        glm_mat4_swap_col(m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(mat4 m, size_t row_1, size_t row_2) nogil:
        glm_mat4_swap_row(m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec4 r, mat4 m, vec4 c) nogil:
        return glm_mat4_rmc(r, m, c)

    #python wrappers
    @staticmethod
    def copy(Mat4 out, Mat4 m):
        Mat4.c_copy(out.data, m.data)

    @staticmethod
    def identity(Mat4 out):
        Mat4.c_identity(out.data)
    
    @staticmethod
    def zero(Mat4 out):
        Mat4.c_zero(out.data)
    
    @staticmethod
    def mul(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_mul(out.data, a.data, b.data)

    @staticmethod
    def transpose_to(Mat4 out, Mat4 m):
        Mat4.c_transpose_to(out.data, m.data)

    @staticmethod
    def transpose(Mat4 out):
        Mat4.c_transpose(out.data)

    @staticmethod
    def trace(Mat4 m):
        Mat4.c_trace(m.data)

    @staticmethod
    def trace3(Mat4 m):
        Mat4.c_trace3(m.data)

    @staticmethod
    def scale(Mat4 out, float scale):
        Mat4.c_scale(out.data, scale)

    @staticmethod
    def det(Mat4 m):
        return Mat4.c_det(m.data)

    @staticmethod
    def inv(Mat4 out, Mat4 m):
        Mat4.c_inv(out.data, m.data)

    @staticmethod
    def inv_fast(Mat4 out, Mat4 m):
        Mat4.c_inv_fast(out.data, m.data)

    @staticmethod
    def swap_col(Mat4 m, size_t col_1, size_t col_2):
        Mat4.c_swap_col(m.data, col_1, col_2)

    @staticmethod
    def swap_row(Mat4 m, size_t row_1, size_t row_2):
        Mat4.c_swap_row(m.data, row_1, row_2)

    #@staticmethod
    #def row_mat_col(vec4 r, Mat4 m, vec4 c):
    #    return Mat4.c_row_mat_col(r.data, m.data, c.data)