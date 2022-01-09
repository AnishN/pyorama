from pyorama.libs.cglm cimport *

cdef:
    float C_MATH_F_E
    float C_MATH_F_LOG2E
    float C_MATH_F_LOG10E
    float C_MATH_F_LN2
    float C_MATH_F_LN10
    float C_MATH_F_PI
    float C_MATH_F_PI_2
    float C_MATH_F_PI_4
    float C_MATH_F_1_PI
    float C_MATH_F_2_PI
    float C_MATH_F_2_SQRTPI
    float C_MATH_F_SQRT2
    float C_MATH_F_SQRT1_2

    double C_MATH_D_E
    double C_MATH_D_LOG2E
    double C_MATH_D_LOG10E
    double C_MATH_D_LN2
    double C_MATH_D_LN10
    double C_MATH_D_PI
    double C_MATH_D_PI_2
    double C_MATH_D_PI_4
    double C_MATH_D_1_PI
    double C_MATH_D_2_PI
    double C_MATH_D_2_SQRTPI
    double C_MATH_D_SQRT2
    double C_MATH_D_SQRT1_2

"""
    #cglm_project_h
    void glm_unprojecti(vec3 pos, mat4 invMat, vec4 vp, vec3 dest)
    void glm_unproject(vec3 pos, mat4 m, vec4 vp, vec3 dest)
    void glm_project(vec3 pos, mat4 m, vec4 vp, vec3 dest)
    void glm_pickmatrix(vec3 center, vec2 size, vec4 vp, mat4 dest)

    #CLIPSPACE STUFF STARTS HERE
    #cglm_ortho_lh_no_h
    void glm_ortho_lh_no(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho_aabb_lh_no(vec3 box[2], mat4 dest)
    void glm_ortho_aabb_p_lh_no(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_aabb_pz_lh_no(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_default_lh_no(float aspect, mat4 dest)
    void glm_ortho_default_s_lh_no(float aspect, float size, mat4 dest)

    #cglm_ortho_lh_zo_h
    void glm_ortho_lh_zo(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho_aabb_lh_zo(vec3 box[2], mat4 dest)
    void glm_ortho_aabb_p_lh_zo(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_aabb_pz_lh_zo(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_default_lh_zo(float aspect, mat4 dest)
    void glm_ortho_default_s_lh_zo(float aspect, float size, mat4 dest)

    #cglm_ortho_rh_no_h
    void glm_ortho_rh_no(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho_aabb_rh_no(vec3 box[2], mat4 dest)
    void glm_ortho_aabb_p_rh_no(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_aabb_pz_rh_no(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_default_rh_no(float aspect, mat4 dest)
    void glm_ortho_default_s_rh_no(float aspect, float size, mat4 dest)

    #cglm_ortho_rh_zo_h
    void glm_ortho_rh_zo(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho_aabb_rh_zo(vec3 box[2], mat4 dest)
    void glm_ortho_aabb_p_rh_zo(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_aabb_pz_rh_zo(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_default_rh_zo(float aspect, mat4 dest)
    void glm_ortho_default_s_rh_zo(float aspect, float size, mat4 dest)

    #cglm_persp_lh_no_h
    void glm_frustum_lh_no(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_perspective_lh_no(float fovy, float aspect, float nearZ, float farZ, mat4 dest)
    void glm_perspective_default_lh_no(float aspect, mat4 dest)
    void glm_perspective_resize_lh_no(float aspect, mat4 proj)
    void glm_persp_move_far_lh_no(mat4 proj, float deltaFar)
    void glm_persp_decomp_lh_no(mat4 proj, float * nearZ, float *farZ, float *top, float *bottom, float *left, float *right)
    void glm_persp_decompv_lh_no(mat4 proj, float dest[6])
    void glm_persp_decomp_x_lh_no(mat4 proj, float *left, float *right)
    void glm_persp_decomp_y_lh_no(mat4 proj, float *top, float *bottom)
    void glm_persp_decomp_z_lh_no(mat4 proj, float *nearZ, float *farZ)
    void glm_persp_decomp_far_lh_no(mat4 proj, float *farZ)
    void glm_persp_decomp_near_lh_no(mat4 proj, float *nearZ)
    void glm_persp_sizes_lh_no(mat4 proj, float fovy, vec4 dest)

    #cglm_persp_lh_zo_h
    void glm_frustum_lh_zo(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_perspective_lh_zo(float fovy, float aspect, float nearZ, float farZ, mat4 dest)
    void glm_perspective_default_lh_zo(float aspect, mat4 dest)
    void glm_perspective_resize_lh_zo(float aspect, mat4 proj)
    void glm_persp_move_far_lh_zo(mat4 proj, float deltaFar)
    void glm_persp_decomp_lh_zo(mat4 proj, float * nearZ, float *farZ, float *top, float *bottom, float *left, float *right)
    void glm_persp_decompv_lh_zo(mat4 proj, float dest[6])
    void glm_persp_decomp_x_lh_zo(mat4 proj, float *left, float *right)
    void glm_persp_decomp_y_lh_zo(mat4 proj, float *top, float *bottom)
    void glm_persp_decomp_z_lh_zo(mat4 proj, float *nearZ, float *farZ)
    void glm_persp_decomp_far_lh_zo(mat4 proj, float *farZ)
    void glm_persp_decomp_near_lh_zo(mat4 proj, float *nearZ)
    void glm_persp_sizes_lh_zo(mat4 proj, float fovy, vec4 dest)

    #cglm_persp_rh_no_h
    void glm_frustum_rh_no(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_perspective_rh_no(float fovy, float aspect, float nearZ, float farZ, mat4 dest)
    void glm_perspective_default_rh_no(float aspect, mat4 dest)
    void glm_perspective_resize_rh_no(float aspect, mat4 proj)
    void glm_persp_move_far_rh_no(mat4 proj, float deltaFar)
    void glm_persp_decomp_rh_no(mat4 proj, float * nearZ, float *farZ, float *top, float *bottom, float *left, float *right)
    void glm_persp_decompv_rh_no(mat4 proj, float dest[6])
    void glm_persp_decomp_x_rh_no(mat4 proj, float *left, float *right)
    void glm_persp_decomp_y_rh_no(mat4 proj, float *top, float *bottom)
    void glm_persp_decomp_z_rh_no(mat4 proj, float *nearZ, float *farZ)
    void glm_persp_decomp_far_rh_no(mat4 proj, float *farZ)
    void glm_persp_decomp_near_rh_no(mat4 proj, float *nearZ)
    void glm_persp_sizes_rh_no(mat4 proj, float fovy, vec4 dest)

    #cglm_persp_rh_zo_h
    void glm_frustum_rh_zo(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_perspective_rh_zo(float fovy, float aspect, float nearZ, float farZ, mat4 dest)
    void glm_perspective_default_rh_zo(float aspect, mat4 dest)
    void glm_perspective_resize_rh_zo(float aspect, mat4 proj)
    void glm_persp_move_far_rh_zo(mat4 proj, float deltaFar)
    void glm_persp_decomp_rh_zo(mat4 proj, float * nearZ, float *farZ, float *top, float *bottom, float *left, float *right)
    void glm_persp_decompv_rh_zo(mat4 proj, float dest[6])
    void glm_persp_decomp_x_rh_zo(mat4 proj, float *left, float *right)
    void glm_persp_decomp_y_rh_zo(mat4 proj, float *top, float *bottom)
    void glm_persp_decomp_z_rh_zo(mat4 proj, float *nearZ, float *farZ)
    void glm_persp_decomp_far_rh_zo(mat4 proj, float *farZ)
    void glm_persp_decomp_near_rh_zo(mat4 proj, float *nearZ)
    void glm_persp_sizes_rh_zo(mat4 proj, float fovy, vec4 dest)

    #cglm_persp_h
    void glm_persp_decomp_far(mat4 proj, float *farZ)
    float glm_persp_fovy(mat4 proj)
    float glm_persp_aspect(mat4 proj)
    void glm_persp_sizes(mat4 proj, float fovy, vec4 dest)

    #cglm_project_no_h
    void glm_unprojecti_no(vec3 pos, mat4 invMat, vec4 vp, vec3 dest)
    void glm_project_no(vec3 pos, mat4 m, vec4 vp, vec3 dest)

    #cglm_project_zo_h
    void glm_unprojecti_zo(vec3 pos, mat4 invMat, vec4 vp, vec3 dest)
    void glm_project_zo(vec3 pos, mat4 m, vec4 vp, vec3 dest)

    #cglm_view_lh_no_h
    void glm_lookat_lh_no(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look_lh_no(vec3 eye, vec3 dir_, vec3 up, mat4 dest)
    void glm_look_anyup_lh_no(vec3 eye, vec3 dir_, mat4 dest)

    #cglm_view_lh_zo_h
    void glm_lookat_lh_zo(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look_lh_zo(vec3 eye, vec3 dir_, vec3 up, mat4 dest)
    void glm_look_anyup_lh_zo(vec3 eye, vec3 dir_, mat4 dest)

    #cglm_view_rh_no_h
    void glm_lookat_rh_no(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look_rh_no(vec3 eye, vec3 dir_, vec3 up, mat4 dest)
    void glm_look_anyup_rh_no(vec3 eye, vec3 dir_, mat4 dest)

    #cglm_view_rh_zo_h
    void glm_lookat_rh_zo(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look_rh_zo(vec3 eye, vec3 dir_, vec3 up, mat4 dest)
    void glm_look_anyup_rh_zo(vec3 eye, vec3 dir_, mat4 dest)

    #cglm_view_lh_h
    void glm_lookat_lh(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look_lh(vec3 eye, vec3 dir_, vec3 up, mat4 dest)
    void glm_look_anyup_lh(vec3 eye, vec3 dir_, mat4 dest)

    #cglm_view_rh_h
    void glm_lookat_rh(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look_rh(vec3 eye, vec3 dir_, vec3 up, mat4 dest)
    void glm_look_anyup_rh(vec3 eye, vec3 dir_, mat4 dest)
"""

ctypedef struct Vec2C:
    float x
    float y

ctypedef struct Vec3C:
    float x
    float y
    float z

ctypedef struct Vec4C:
    float x
    float y
    float z
    float w

ctypedef struct Mat2C:
    float m00, m01
    float m10, m11

ctypedef struct Mat3C:
    float m00, m01, m02
    float m10, m11, m12
    float m20, m21, m22

ctypedef struct Mat4C:
    float m00, m01, m02, m03
    float m10, m11, m12, m13
    float m20, m21, m22, m23
    float m30, m31, m32, m33

ctypedef struct QuatC:
    float x
    float y
    float z
    float w

ctypedef struct Box2C:
    Vec2C min
    Vec2C max

ctypedef struct Box3C:
    Vec3C min
    Vec3C max