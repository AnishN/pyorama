cdef class Mat2:

    @staticmethod
    cdef Mat2 c_from_data(Mat2C *m):
        cdef Mat2 out = Mat2.__new__(Mat2)
        out.data = m[0]
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(Mat2C *out, Mat2C *m) nogil:
        glm_mat2_copy(<mat2>m, <mat2>out)
    
    @staticmethod
    cdef void c_identity(Mat2C *out) nogil:
        glm_mat2_identity(<mat2>out)
    
    @staticmethod
    cdef void c_zero(Mat2C *out) nogil:
        glm_mat2_zero(<mat2>out)
    
    @staticmethod
    cdef void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        glm_mat2_mul(<mat2>a, <mat2>b, <mat2>out)

    @staticmethod
    cdef void c_transpose_to(Mat2C *out, Mat2C *m) nogil:
        glm_mat2_transpose_to(<mat2>m, <mat2>out)

    @staticmethod
    cdef void c_transpose(Mat2C *out) nogil:
        glm_mat2_transpose(<mat2>out)

    @staticmethod
    cdef float c_trace(Mat2C *m) nogil:
        return glm_mat2_trace(<mat2>m)

    @staticmethod
    cdef void c_scale(Mat2C *out, float scale) nogil:
        glm_mat2_scale(<mat2>out, scale)

    @staticmethod
    cdef float c_det(Mat2C *m) nogil:
        return glm_mat2_det(<mat2>m)

    @staticmethod
    cdef void c_inv(Mat2C *out, Mat2C *m) nogil:
        glm_mat2_inv(<mat2>m, <mat2>out)

    @staticmethod
    cdef void c_swap_col(Mat2C *m, size_t col_1, size_t col_2) nogil:
        glm_mat2_swap_col(<mat2>m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(Mat2C *m, size_t row_1, size_t row_2) nogil:
        glm_mat2_swap_row(<mat2>m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec2 r, Mat2C *m, vec2 c) nogil:
        return glm_mat2_rmc(r, <mat2>m, c)