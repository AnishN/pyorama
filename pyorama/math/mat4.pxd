"""
#cglm_affine_h
    void glm_translate_to(mat4 m, vec4 v, mat4 dest)
    void glm_translate(mat4 m, vec4 v)
    void glm_translate_x(mat4 m, float to)
    void glm_translate_y(mat4 m, float to)
    void glm_translate_z(mat4 m, float to)
    void glm_translate_make(mat4 m, vec4 v)
    void glm_scale_to(mat4 m, vec4 v, mat4 dest)
    void glm_scale_make(mat4 m, vec4 v)
    void glm_scale(mat4 m, vec4 v)
    void glm_scale_uni(mat4 m, float s)
    void glm_rotate_x(mat4 m, float angle, mat4 dest)
    void glm_rotate_y(mat4 m, float angle, mat4 dest)
    void glm_rotate_z(mat4 m, float angle, mat4 dest)
    void glm_rotate_make(mat4 m, float angle, vec4 axis)
    void glm_rotate(mat4 m, float angle, vec4 axis)
    void glm_rotate_at(mat4 m, vec4 pivot, float angle, vec4 axis)
    void glm_rotate_atm(mat4 m, vec4 pivot, float angle, vec4 axis)
    void glm_decompose_scalev(mat4 m, vec4 s)
    bint glm_uniscaled(mat4 m)
    void glm_decompose_rs(mat4 m, mat4 r, vec4 s)
    void glm_decompose(mat4 m, vec4 t, mat4 r, vec4 s)

#cglm_cam_h
    void glm_frustum(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho_aabb(vec4 box[2], mat4 dest)
    void glm_ortho_aabb_p(vec4 box[2], float padding, mat4 dest)
    void glm_ortho_aabb_pz(vec4 box[2], float padding, mat4 dest)
    void glm_ortho_default(float aspect, mat4 dest)
    void glm_ortho_default_s(float aspect, float size, mat4 dest)
    void glm_perspective(float fovy, float aspect, float nearZ, float farZ, mat4 dest)
    void glm_perspective_default(float aspect, mat4 dest)
    void glm_perspective_resize(float aspect, mat4 proj)
    void glm_lookat(vec4 eye, vec4 center, vec4 up, mat4 dest)
    void glm_look(vec4 eye, vec4 dir, vec4 up, mat4 dest)
    void glm_look_anyup(vec4 eye, vec4 dir, mat4 dest)
    void glm_persp_decomp(mat4 proj, float *nearZ, float *farZ, float *top, float *bottom, float *left, float *right)
    void glm_persp_decompv(mat4 proj, float dest[6])
    void glm_persp_decomp_x(mat4 proj, float *left, float *right)
    void glm_persp_decomp_y(mat4 proj, float *top, float *bottom)
    void glm_persp_decomp_z(mat4 proj, float *nearv, float *farv)
    void glm_persp_decomp_far(mat4 proj, float *farZ)
    void glm_persp_decomp_near(mat4 proj, float *nearZ)
    float glm_persp_fovy(mat4 proj)
    float glm_persp_aspect(mat4 proj)
    void glm_persp_sizes(mat4 proj, float fovy, vec4 dest)

#glm_euler_h
    ctypedef enum glm_euler_seq:
        GLM_EULER_XYZ
        GLM_EULER_XZY
        GLM_EULER_YZX
        GLM_EULER_YXZ
        GLM_EULER_ZXY
        GLM_EULER_ZYX
    glm_euler_seq glm_euler_order(int newOrder[4])
    void glm_euler_angles(mat4 m, vec4 dest)
    void glm_euler(vec4 angles, mat4 dest)
    void glm_euler_xyz(vec4 angles, mat4 dest)
    void glm_euler_zyx(vec4 angles, mat4 dest)
    void glm_euler_zxy(vec4 angles, mat4 dest)
    void glm_euler_xzy(vec4 angles, mat4 dest)
    void glm_euler_yzx(vec4 angles, mat4 dest)
    void glm_euler_yxz(vec4 angles, mat4 dest)
    void glm_euler_by_order(vec4 angles, glm_euler_seq ord, mat4 dest)

@staticmethod
void glm_quat_mat4(versor q, mat4 dest)

@staticmethod
void glm_quat_mat4t(versor q, mat4 dest)

@staticmethod
void glm_quat_look(vec3 eye, versor ori, mat4 dest)

    @staticmethod
    void glm_quat_rotate(mat4 m, versor q, mat4 dest)
"""

from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *

cdef class Mat4:
    cdef:
        float[4][4] data

    @staticmethod
    cdef Mat4 c_from_data(mat4 m)
    @staticmethod
    cdef void c_copy(mat4 out, mat4 m) nogil
    @staticmethod
    cdef void c_identity(mat4 out) nogil
    @staticmethod
    cdef void c_zero(mat4 out) nogil
    @staticmethod
    cdef void c_mul(mat4 out, mat4 a, mat4 b) nogil
    @staticmethod
    cdef void c_transpose_to(mat4 out, mat4 m) nogil
    @staticmethod
    cdef void c_transpose(mat4 out) nogil
    @staticmethod
    cdef float c_trace(mat4 m) nogil
    @staticmethod
    cdef float c_trace3(mat4 m) nogil
    @staticmethod
    cdef void c_scale(mat4 out, float scale) nogil
    @staticmethod
    cdef float c_det(mat4 m) nogil
    @staticmethod
    cdef void c_inv(mat4 out, mat4 m) nogil
    @staticmethod
    cdef void c_inv_fast(mat4 out, mat4 m) nogil
    @staticmethod
    cdef void c_swap_col(mat4 m, size_t col_1, size_t col_2) nogil
    @staticmethod
    cdef void c_swap_row(mat4 m, size_t row_1, size_t row_2) nogil
    @staticmethod
    cdef float c_row_mat_col(vec4 r, mat4 m, vec4 c) nogil