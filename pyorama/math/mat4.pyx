cdef class Mat4:

    @staticmethod
    cdef Mat4 c_from_data(Mat4C *m):
        cdef Mat4 out = Mat4.__new__(Mat4)
        out.data = m[0]
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_copy(<mat4>m, <mat4>out)
    
    @staticmethod
    cdef void c_identity(Mat4C *out) nogil:
        glm_mat4_identity(<mat4>out)
    
    @staticmethod
    cdef void c_zero(Mat4C *out) nogil:
        glm_mat4_zero(<mat4>out)
    
    @staticmethod
    cdef void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        glm_mat4_mul(<mat4>a, <mat4>b, <mat4>out)

    @staticmethod
    cdef void c_transpose_to(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_transpose_to(<mat4>m, <mat4>out)

    @staticmethod
    cdef void c_transpose(Mat4C *out) nogil:
        glm_mat4_transpose(<mat4>out)

    @staticmethod
    cdef float c_trace(Mat4C *m) nogil:
        return glm_mat4_trace(<mat4>m)

    @staticmethod
    cdef float c_trace3(Mat4C *m) nogil:
        return glm_mat4_trace3(<mat4>m)

    @staticmethod
    cdef void c_scale(Mat4C *out, float scale) nogil:
        glm_mat4_scale(<mat4>out, scale)

    @staticmethod
    cdef float c_det(Mat4C *m) nogil:
        return glm_mat4_det(<mat4>m)

    @staticmethod
    cdef void c_inv(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_inv(<mat4>m, <mat4>out)

    @staticmethod
    cdef void c_inv_fast(Mat4C *out, Mat4C *m) nogil:
        glm_mat4_inv_fast(<mat4>m, <mat4>out)

    @staticmethod
    cdef void c_swap_col(Mat4C *m, size_t col_1, size_t col_2) nogil:
        glm_mat4_swap_col(<mat4>m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(Mat4C *m, size_t row_1, size_t row_2) nogil:
        glm_mat4_swap_row(<mat4>m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec4 r, Mat4C *m, vec4 c) nogil:
        return glm_mat4_rmc(r, <mat4>m, c)