cdef class Mat3:

    @staticmethod
    cdef Mat3 c_from_data(Mat3C m):
        cdef Mat3 out = Mat3.__new__(Mat3)
        out.data = m
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(Mat3C out, Mat3C m) nogil:
        glm_mat3_copy(<mat3>&m, <mat3>&out)
    
    @staticmethod
    cdef void c_identity(Mat3C out) nogil:
        glm_mat3_identity(<mat3>&out)
    
    @staticmethod
    cdef void c_zero(Mat3C out) nogil:
        glm_mat3_zero(<mat3>&out)
    
    @staticmethod
    cdef void c_mul(Mat3C out, Mat3C a, Mat3C b) nogil:
        glm_mat3_mul(<mat3>&a, <mat3>&b, <mat3>&out)

    @staticmethod
    cdef void c_transpose_to(Mat3C out, Mat3C m) nogil:
        glm_mat3_transpose_to(<mat3>&m, <mat3>&out)

    @staticmethod
    cdef void c_transpose(Mat3C out) nogil:
        glm_mat3_transpose(<mat3>&out)

    @staticmethod
    cdef float c_trace(Mat3C m) nogil:
        return glm_mat3_trace(<mat3>&m)

    @staticmethod
    cdef void c_scale(Mat3C out, float scale) nogil:
        glm_mat3_scale(<mat3>&out, scale)

    @staticmethod
    cdef float c_det(Mat3C m) nogil:
        return glm_mat3_det(<mat3>&m)

    @staticmethod
    cdef void c_inv(Mat3C out, Mat3C m) nogil:
        glm_mat3_inv(<mat3>&m, <mat3>&out)

    @staticmethod
    cdef void c_swap_col(Mat3C m, size_t col_1, size_t col_2) nogil:
        glm_mat3_swap_col(<mat3>&m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(Mat3C m, size_t row_1, size_t row_2) nogil:
        glm_mat3_swap_row(<mat3>&m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec3 r, Mat3C m, vec3 c) nogil:
        return glm_mat3_rmc(r, <mat3>&m, c)

    #python wrappers
    @staticmethod
    def copy(Mat3 out, Mat3 m):
        Mat3.c_copy(out.data, m.data)

    @staticmethod
    def identity(Mat3 out):
        Mat3.c_identity(out.data)
    
    @staticmethod
    def zero(Mat3 out):
        Mat3.c_zero(out.data)
    
    @staticmethod
    def mul(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_mul(out.data, a.data, b.data)

    @staticmethod
    def transpose_to(Mat3 out, Mat3 m):
        Mat3.c_transpose_to(out.data, m.data)

    @staticmethod
    def transpose(Mat3 out):
        Mat3.c_transpose(out.data)

    @staticmethod
    def trace(Mat3 m):
        Mat3.c_trace(m.data)

    @staticmethod
    def scale(Mat3 out, float scale):
        Mat3.c_scale(out.data, scale)

    @staticmethod
    def det(Mat3 m):
        return Mat3.c_det(m.data)

    @staticmethod
    def inv(Mat3 out, Mat3 m):
        Mat3.c_inv(out.data, m.data)

    @staticmethod
    def swap_col(Mat3 m, size_t col_1, size_t col_2):
        Mat3.c_swap_col(m.data, col_1, col_2)

    @staticmethod
    def swap_row(Mat3 m, size_t row_1, size_t row_2):
        Mat3.c_swap_row(m.data, row_1, row_2)

    #@staticmethod
    #def row_mat_col(vec3 r, Mat3 m, vec3 c):
    #    return Mat3.c_row_mat_col(r.data, m.data, c.data)