cdef class Mat3:

    @staticmethod
    cdef Mat3 c_from_data(Mat3C *m):
        cdef Mat3 out = Mat3.__new__(Mat3)
        out.data = m[0]
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(Mat3C *out, Mat3C *m) nogil:
        glm_mat3_copy(<mat3>m, <mat3>out)
    
    @staticmethod
    cdef void c_identity(Mat3C *out) nogil:
        glm_mat3_identity(<mat3>out)
    
    @staticmethod
    cdef void c_zero(Mat3C *out) nogil:
        glm_mat3_zero(<mat3>out)
    
    @staticmethod
    cdef void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        glm_mat3_mul(<mat3>a, <mat3>b, <mat3>out)

    @staticmethod
    cdef void c_transpose_to(Mat3C *out, Mat3C *m) nogil:
        glm_mat3_transpose_to(<mat3>m, <mat3>out)

    @staticmethod
    cdef void c_transpose(Mat3C *out) nogil:
        glm_mat3_transpose(<mat3>out)

    @staticmethod
    cdef float c_trace(Mat3C *m) nogil:
        return glm_mat3_trace(<mat3>m)

    @staticmethod
    cdef void c_scale(Mat3C *out, float scale) nogil:
        glm_mat3_scale(<mat3>out, scale)

    @staticmethod
    cdef float c_det(Mat3C *m) nogil:
        return glm_mat3_det(<mat3>m)

    @staticmethod
    cdef void c_inv(Mat3C *out, Mat3C *m) nogil:
        glm_mat3_inv(<mat3>m, <mat3>out)

    @staticmethod
    cdef void c_swap_col(Mat3C *m, size_t col_1, size_t col_2) nogil:
        glm_mat3_swap_col(<mat3>m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(Mat3C *m, size_t row_1, size_t row_2) nogil:
        glm_mat3_swap_row(<mat3>m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec3 r, Mat3C *m, vec3 c) nogil:
        return glm_mat3_rmc(r, <mat3>m, c)