"""
#cglm_affine_h
    void glm_translate_to(Mat4C *m, vec4 v, Mat4C *dest)
    void glm_translate(Mat4C *m, vec4 v)
    void glm_translate_x(Mat4C *m, float to)
    void glm_translate_y(Mat4C *m, float to)
    void glm_translate_z(Mat4C *m, float to)
    void glm_translate_make(Mat4C *m, vec4 v)
    void glm_scale_to(Mat4C *m, vec4 v, Mat4C *dest)
    void glm_scale_make(Mat4C *m, vec4 v)
    void glm_scale(Mat4C *m, vec4 v)
    void glm_scale_uni(Mat4C *m, float s)
    void glm_rotate_x(Mat4C *m, float angle, Mat4C *dest)
    void glm_rotate_y(Mat4C *m, float angle, Mat4C *dest)
    void glm_rotate_z(Mat4C *m, float angle, Mat4C *dest)
    void glm_rotate_make(Mat4C *m, float angle, vec4 axis)
    void glm_rotate(Mat4C *m, float angle, vec4 axis)
    void glm_rotate_at(Mat4C *m, vec4 pivot, float angle, vec4 axis)
    void glm_rotate_atm(Mat4C *m, vec4 pivot, float angle, vec4 axis)
    void glm_decompose_scalev(Mat4C *m, vec4 s)
    bint glm_uniscaled(Mat4C *m)
    void glm_decompose_rs(Mat4C *m, Mat4C *r, vec4 s)
    void glm_decompose(Mat4C *m, vec4 t, Mat4C *r, vec4 s)

#cglm_cam_h
    void glm_frustum(float left, float right, float bottom, float top, float nearZ, float farZ, Mat4C *dest)
    void glm_ortho(float left, float right, float bottom, float top, float nearZ, float farZ, Mat4C *dest)
    void glm_ortho_aabb(vec4 box[2], Mat4C *dest)
    void glm_ortho_aabb_p(vec4 box[2], float padding, Mat4C *dest)
    void glm_ortho_aabb_pz(vec4 box[2], float padding, Mat4C *dest)
    void glm_ortho_default(float aspect, Mat4C *dest)
    void glm_ortho_default_s(float aspect, float size, Mat4C *dest)
    void glm_perspective(float fovy, float aspect, float nearZ, float farZ, Mat4C *dest)
    void glm_perspective_default(float aspect, Mat4C *dest)
    void glm_perspective_resize(float aspect, Mat4C *proj)
    void glm_lookat(vec4 eye, vec4 center, vec4 up, Mat4C *dest)
    void glm_look(vec4 eye, vec4 dir, vec4 up, Mat4C *dest)
    void glm_look_anyup(vec4 eye, vec4 dir, Mat4C *dest)
    void glm_persp_decomp(Mat4C *proj, float *nearZ, float *farZ, float *top, float *bottom, float *left, float *right)
    void glm_persp_decompv(Mat4C *proj, float dest[6])
    void glm_persp_decomp_x(Mat4C *proj, float *left, float *right)
    void glm_persp_decomp_y(Mat4C *proj, float *top, float *bottom)
    void glm_persp_decomp_z(Mat4C *proj, float *nearv, float *farv)
    void glm_persp_decomp_far(Mat4C *proj, float *farZ)
    void glm_persp_decomp_near(Mat4C *proj, float *nearZ)
    float glm_persp_fovy(Mat4C *proj)
    float glm_persp_aspect(Mat4C *proj)
    void glm_persp_sizes(Mat4C *proj, float fovy, vec4 dest)

#glm_euler_h
    ctypedef enum glm_euler_seq:
        GLM_EULER_XYZ
        GLM_EULER_XZY
        GLM_EULER_YZX
        GLM_EULER_YXZ
        GLM_EULER_ZXY
        GLM_EULER_ZYX
    glm_euler_seq glm_euler_order(int newOrder[4])
    void glm_euler_angles(Mat4C *m, vec4 dest)
    void glm_euler(vec4 angles, Mat4C *dest)
    void glm_euler_xyz(vec4 angles, Mat4C *dest)
    void glm_euler_zyx(vec4 angles, Mat4C *dest)
    void glm_euler_zxy(vec4 angles, Mat4C *dest)
    void glm_euler_xzy(vec4 angles, Mat4C *dest)
    void glm_euler_yzx(vec4 angles, Mat4C *dest)
    void glm_euler_yxz(vec4 angles, Mat4C *dest)
    void glm_euler_by_order(vec4 angles, glm_euler_seq ord, Mat4C *dest)

@staticmethod
void glm_quat_mat4(versor q, Mat4C *dest)

@staticmethod
void glm_quat_mat4t(versor q, Mat4C *dest)

@staticmethod
void glm_quat_look(vec3 eye, versor ori, Mat4C *dest)

    @staticmethod
    void glm_quat_rotate(Mat4C *m, versor q, Mat4C *dest)
"""

from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

cdef class Mat4:
    cdef:
        Mat4C data

    @staticmethod
    cdef Mat4 c_from_data(Mat4C *m)
    @staticmethod
    cdef void c_copy(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_identity(Mat4C *out) nogil
    @staticmethod
    cdef void c_zero(Mat4C *out) nogil
    @staticmethod
    cdef void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil
    @staticmethod
    cdef void c_transpose_to(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_transpose(Mat4C *out) nogil
    @staticmethod
    cdef float c_trace(Mat4C *m) nogil
    @staticmethod
    cdef float c_trace3(Mat4C *m) nogil
    @staticmethod
    cdef void c_scale(Mat4C *out, float scale) nogil
    @staticmethod
    cdef float c_det(Mat4C *m) nogil
    @staticmethod
    cdef void c_inv(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_inv_fast(Mat4C *out, Mat4C *m) nogil
    @staticmethod
    cdef void c_swap_col(Mat4C *m, size_t col_1, size_t col_2) nogil
    @staticmethod
    cdef void c_swap_row(Mat4C *m, size_t row_1, size_t row_2) nogil
    @staticmethod
    cdef float c_row_mat_col(vec4 r, Mat4C *m, vec4 c) nogil
