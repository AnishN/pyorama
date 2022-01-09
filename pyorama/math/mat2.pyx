cdef class Mat2:

    @staticmethod
    cdef Mat2 c_from_data(mat2 m):
        cdef Mat2 out = Mat2.__new__(Mat2)
        out.data = m
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(mat2 out, mat2 m) nogil:
        glm_mat2_copy(m, out)
    
    @staticmethod
    cdef void c_identity(mat2 out) nogil:
        glm_mat2_identity(out)
    
    @staticmethod
    cdef void c_zero(mat2 out) nogil:
        glm_mat2_zero(out)
    
    @staticmethod
    cdef void c_mul(mat2 out, mat2 a, mat2 b) nogil:
        glm_mat2_mul(a, b, out)

    @staticmethod
    cdef void c_transpose_to(mat2 out, mat2 m) nogil:
        glm_mat2_transpose_to(m, out)

    @staticmethod
    cdef void c_transpose(mat2 out) nogil:
        glm_mat2_transpose(out)

    @staticmethod
    cdef float c_trace(mat2 m) nogil:
        return glm_mat2_trace(m)

    @staticmethod
    cdef void c_scale(mat2 out, float scale) nogil:
        glm_mat2_scale(out, scale)

    @staticmethod
    cdef float c_det(mat2 m) nogil:
        return glm_mat2_det(m)

    @staticmethod
    cdef void c_inv(mat2 out, mat2 m) nogil:
        glm_mat2_inv(m, out)

    @staticmethod
    cdef void c_swap_col(mat2 m, size_t col_1, size_t col_2) nogil:
        glm_mat2_swap_col(m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(mat2 m, size_t row_1, size_t row_2) nogil:
        glm_mat2_swap_row(m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec2 r, mat2 m, vec2 c) nogil:
        return glm_mat2_rmc(r, m, c)

    #python wrappers
    @staticmethod
    def copy(Mat2 out, Mat2 m):
        Mat2.c_copy(out.data, m.data)

    @staticmethod
    def identity(Mat2 out):
        Mat2.c_identity(out.data)
    
    @staticmethod
    def zero(Mat2 out):
        Mat2.c_zero(out.data)
    
    @staticmethod
    def mul(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_mul(out.data, a.data, b.data)

    @staticmethod
    def transpose_to(Mat2 out, Mat2 m):
        Mat2.c_transpose_to(out.data, m.data)

    @staticmethod
    def transpose(Mat2 out):
        Mat2.c_transpose(out.data)

    @staticmethod
    def trace(Mat2 m):
        Mat2.c_trace(m.data)

    @staticmethod
    def scale(Mat2 out, float scale):
        Mat2.c_scale(out.data, scale)

    @staticmethod
    def det(Mat2 m):
        return Mat2.c_det(m.data)

    @staticmethod
    def inv(Mat2 out, Mat2 m):
        Mat2.c_inv(out.data, m.data)

    @staticmethod
    def swap_col(Mat2 m, size_t col_1, size_t col_2):
        Mat2.c_swap_col(m.data, col_1, col_2)

    @staticmethod
    def swap_row(Mat2 m, size_t row_1, size_t row_2):
        Mat2.c_swap_row(m.data, row_1, row_2)

    #@staticmethod
    #def row_mat_col(vec2 r, Mat2 m, vec2 c):
    #    return Mat2.c_row_mat_col(r.data, m.data, c.data)