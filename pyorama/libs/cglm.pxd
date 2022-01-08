from pyorama.libs.c cimport *

cdef extern from "cglm/cglm.h" nogil:
    #cglm_types_h
    ctypedef float vec2[2]
    ctypedef float vec3[3]
    ctypedef int ivec3[3]
    ctypedef float vec4[4]
    ctypedef vec4 versor
    ctypedef vec3 mat3[3]
    ctypedef vec2 mat2[2]
    ctypedef vec4 mat4[4]
    float GLM_E
    float GLM_LOG2E
    float GLM_LOG10E
    float GLM_LN2
    float GLM_LN10
    float GLM_PI
    float GLM_PI_2
    float GLM_PI_4
    float GLM_1_PI
    float GLM_2_PI
    float GLM_2_SQRTPI
    float GLM_SQRT2
    float GLM_SQRT1_2
    
    #cglm_affine_mat_h
    void glm_mul(mat4 m1, mat4 m2, mat4 dest)
    void glm_inv_tr(mat4 mat)

    #cglm_affine_h
    void glm_translate_to(mat4 m, vec3 v, mat4 dest)
    void glm_translate(mat4 m, vec3 v)
    void glm_translate_x(mat4 m, float to)
    void glm_translate_y(mat4 m, float to)
    void glm_translate_z(mat4 m, float to)
    void glm_translate_make(mat4 m, vec3 v)
    void glm_scale_to(mat4 m, vec3 v, mat4 dest)
    void glm_scale_make(mat4 m, vec3 v)
    void glm_scale(mat4 m, vec3 v)
    void glm_scale_uni(mat4 m, float s)
    void glm_rotate_x(mat4 m, float angle, mat4 dest)
    void glm_rotate_y(mat4 m, float angle, mat4 dest)
    void glm_rotate_z(mat4 m, float angle, mat4 dest)
    void glm_rotate_make(mat4 m, float angle, vec3 axis)
    void glm_rotate(mat4 m, float angle, vec3 axis)
    void glm_rotate_at(mat4 m, vec3 pivot, float angle, vec3 axis)
    void glm_rotate_atm(mat4 m, vec3 pivot, float angle, vec3 axis)
    void glm_decompose_scalev(mat4 m, vec3 s)
    bint glm_uniscaled(mat4 m)
    void glm_decompose_rs(mat4 m, mat4 r, vec3 s)
    void glm_decompose(mat4 m, vec4 t, mat4 r, vec3 s)

    #cglm_affine2d_h
    void glm_translate2d(mat3 m, vec2 v)
    void glm_translate2d_to(mat3 m, vec2 v, mat3 dest)
    void glm_translate2d_x(mat3 m, float x)
    void glm_translate2d_y(mat3 m, float y)
    void glm_translate2d_make(mat3 m, vec2 v)
    void glm_scale2d_to(mat3 m, vec2 v, mat3 dest)
    void glm_scale2d_make(mat3 m, vec2 v)
    void glm_scale2d(mat3 m, vec2 v)
    void glm_scale2d_uni(mat3 m, float s)
    void glm_rotate2d_make(mat3 m, float angle)
    void glm_rotate2d(mat3 m, float angle)
    void glm_rotate2d_to(mat3 m, float angle, mat3 dest)

    #cglm_bezier_h
    mat4 GLM_BEZIER_MAT
    mat4 GLM_HERMITE_MAT
    float CGLM_DECASTEL_EPS
    float CGLM_DECASTEL_MAX
    float CGLM_DECASTEL_SMALL
    float glm_bezier(float s, float p0, float c0, float c1, float p1)
    float glm_hermite(float s, float p0, float t0, float t1, float p1)
    float glm_decasteljau(float prm, float p0, float c0, float c1, float p1)

    #cglm_box_h
    void glm_aabb_transform(vec3 box[2], mat4 m, vec3 dest[2])
    void glm_aabb_merge(vec3 box1[2], vec3 box2[2], vec3 dest[2])
    void glm_aabb_crop(vec3 box[2], vec3 cropBox[2], vec3 dest[2])
    void glm_aabb_crop_until(vec3 box[2], vec3 cropBox[2], vec3 clampBox[2], vec3 dest[2])
    bint glm_aabb_frustum(vec3 box[2], vec4 planes[6])
    void glm_aabb_invalidate(vec3 box[2])
    bint glm_aabb_isvalid(vec3 box[2])
    float glm_aabb_size(vec3 box[2])
    float glm_aabb_radius(vec3 box[2])
    void glm_aabb_center(vec3 box[2], vec3 dest)
    bint glm_aabb_aabb(vec3 box[2], vec3 other[2])
    bint glm_aabb_sphere(vec3 box[2], vec4 s)
    bint glm_aabb_point(vec3 box[2], vec3 point)
    bint glm_aabb_contains(vec3 box[2], vec3 other[2])

    #cglm_cam_h
    void glm_frustum(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho(float left, float right, float bottom, float top, float nearZ, float farZ, mat4 dest)
    void glm_ortho_aabb(vec3 box[2], mat4 dest)
    void glm_ortho_aabb_p(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_aabb_pz(vec3 box[2], float padding, mat4 dest)
    void glm_ortho_default(float aspect, mat4 dest)
    void glm_ortho_default_s(float aspect, float size, mat4 dest)
    void glm_perspective(float fovy, float aspect, float nearZ, float farZ, mat4 dest)
    void glm_perspective_default(float aspect, mat4 dest)
    void glm_perspective_resize(float aspect, mat4 proj)
    void glm_lookat(vec3 eye, vec3 center, vec3 up, mat4 dest)
    void glm_look(vec3 eye, vec3 dir, vec3 up, mat4 dest)
    void glm_look_anyup(vec3 eye, vec3 dir, mat4 dest)
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

    #cglm_color_h
    float glm_luminance(vec3 rgb)

    #cglm_common_h
    enum:
        CGLM_CLIP_CONTROL_ZO_BIT
        CGLM_CLIP_CONTROL_NO_BIT
        CGLM_CLIP_CONTROL_LH_BIT
        CGLM_CLIP_CONTROL_RH_BIT
    enum:
        CGLM_CLIP_CONTROL_LH_ZO
        CGLM_CLIP_CONTROL_LH_NO
        CGLM_CLIP_CONTROL_RH_ZO
        CGLM_CLIP_CONTROL_RH_NO

    #cglm_curve_h
    float glm_smc(float s, mat4 m, vec4 c)

    #cglm_ease_h
    float glm_ease_linear(float t)
    float glm_ease_sine_in(float t)
    float glm_ease_sine_out(float t)
    float glm_ease_sine_inout(float t)
    float glm_ease_quad_in(float t)
    float glm_ease_quad_out(float t)
    float glm_ease_quad_inout(float t)
    float glm_ease_cubic_in(float t)
    float glm_ease_cubic_out(float t)
    float glm_ease_cubic_inout(float t)
    float glm_ease_quart_in(float t)
    float glm_ease_quart_out(float t)
    float glm_ease_quart_inout(float t)
    float glm_ease_quint_in(float t)
    float glm_ease_quint_out(float t)
    float glm_ease_quint_inout(float t)
    float glm_ease_exp_in(float t)
    float glm_ease_exp_out(float t)
    float glm_ease_exp_inout(float t)
    float glm_ease_circ_in(float t)
    float glm_ease_circ_out(float t)
    float glm_ease_circ_inout(float t)
    float glm_ease_back_in(float t)
    float glm_ease_back_out(float t)
    float glm_ease_back_inout(float t)
    float glm_ease_elast_in(float t)
    float glm_ease_elast_out(float t)
    float glm_ease_elast_inout(float t)
    float glm_ease_bounce_out(float t)
    float glm_ease_bounce_in(float t)
    float glm_ease_bounce_inout(float t)

    #glm_euler_h
    ctypedef enum glm_euler_seq:
        GLM_EULER_XYZ
        GLM_EULER_XZY
        GLM_EULER_YZX
        GLM_EULER_YXZ
        GLM_EULER_ZXY
        GLM_EULER_ZYX
    glm_euler_seq glm_euler_order(int newOrder[3])
    void glm_euler_angles(mat4 m, vec3 dest)
    void glm_euler(vec3 angles, mat4 dest)
    void glm_euler_xyz(vec3 angles, mat4 dest)
    void glm_euler_zyx(vec3 angles, mat4 dest)
    void glm_euler_zxy(vec3 angles, mat4 dest)
    void glm_euler_xzy(vec3 angles, mat4 dest)
    void glm_euler_yzx(vec3 angles, mat4 dest)
    void glm_euler_yxz(vec3 angles, mat4 dest)
    void glm_euler_by_order(vec3 angles, glm_euler_seq ord, mat4 dest)

    #cglm_frustum_h
    enum:
        GLM_LBN
        GLM_LTN
        GLM_RTN
        GLM_RBN
        GLM_LBF
        GLM_LTF
        GLM_RTF
        GLM_RBF
    enum:
        GLM_LEFT
        GLM_RIGHT
        GLM_BOTTOM
        GLM_TOP
        GLM_NEAR
        GLM_FAR
    vec4 GLM_CSCOORD_LBN
    vec4 GLM_CSCOORD_LTN
    vec4 GLM_CSCOORD_RTN
    vec4 GLM_CSCOORD_RBN
    vec4 GLM_CSCOORD_LBF
    vec4 GLM_CSCOORD_LTF
    vec4 GLM_CSCOORD_RTF
    vec4 GLM_CSCOORD_RBF
    void glm_frustum_planes(mat4 m, vec4 dest[6])
    void glm_frustum_corners(mat4 invMat, vec4 dest[8])
    void glm_frustum_center(vec4 corners[8], vec4 dest)
    void glm_frustum_box(vec4 corners[8], mat4 m, vec3 box[2])
    void glm_frustum_corners_at(vec4 corners[8], float splitDist, float farDist, vec4 planeCorners[4])

    #cglm_io_h
    void glm_mat4_print(mat4 matrix, FILE *ostream)
    void glm_mat3_print(mat3 matrix, FILE *ostream)
    void glm_vec4_print(vec4 vec, FILE *ostream)
    void glm_vec3_print(vec3 vec, FILE *ostream)
    void glm_ivec3_print(ivec3 vec, FILE *ostream)
    void glm_versor_print(versor vec, FILE *ostream)

    #cglm_mat2_h
    mat2 GLM_MAT2_IDENTITY
    mat2 GLM_MAT2_ZERO
    void glm_mat2_copy(mat2 mat, mat2 dest)
    void glm_mat2_identity(mat2 mat)
    void glm_mat2_identity_array(mat2 *mat, size_t count)
    void glm_mat2_zero(mat2 mat)
    void glm_mat2_mul(mat2 m1, mat2 m2, mat2 dest)
    void glm_mat2_transpose_to(mat2 m, mat2 dest)
    void glm_mat2_transpose(mat2 m)
    void glm_mat2_mulv(mat2 m, vec2 v, vec2 dest)
    float glm_mat2_trace(mat2 m)
    void glm_mat2_scale(mat2 m, float s)
    float glm_mat2_det(mat2 mat)
    void glm_mat2_inv(mat2 mat, mat2 dest)
    void glm_mat2_swap_col(mat2 mat, int col1, int col2)
    void glm_mat2_swap_row(mat2 mat, int row1, int row2)
    float glm_mat2_rmc(vec2 r, mat2 m, vec2 c)

    #cglm_mat3_h
    mat3 GLM_MAT3_IDENTITY
    mat3 GLM_MAT3_ZERO
    void glm_mat3_dup(mat, dest)
    void glm_mat3_copy(mat3 mat, mat3 dest)
    void glm_mat3_identity(mat3 mat)
    void glm_mat3_identity_array(mat3 *mat, size_t count)
    void glm_mat3_zero(mat3 mat)
    void glm_mat3_mul(mat3 m1, mat3 m2, mat3 dest)
    void glm_mat3_transpose_to(mat3 m, mat3 dest)
    void glm_mat3_transpose(mat3 m)
    void glm_mat3_mulv(mat3 m, vec3 v, vec3 dest)
    float glm_mat3_trace(mat3 m)
    void glm_mat3_quat(mat3 m, versor dest)
    void glm_mat3_scale(mat3 m, float s)
    float glm_mat3_det(mat3 mat)
    void glm_mat3_inv(mat3 mat, mat3 dest)
    void glm_mat3_swap_col(mat3 mat, int col1, int col2)
    void glm_mat3_swap_row(mat3 mat, int row1, int row2)
    float glm_mat3_rmc(vec3 r, mat3 m, vec3 c)

    #cglm_mat4_h
    mat4 GLM_MAT4_ZERO_INIT
    mat4 GLM_MAT4_ZERO
    void glm_mat4_ucopy(mat4 mat, mat4 dest)
    void glm_mat4_copy(mat4 mat, mat4 dest)
    void glm_mat4_identity(mat4 mat)
    void glm_mat4_identity_array(mat4 *mat, size_t count)
    void glm_mat4_zero(mat4 mat)
    void glm_mat4_pick3(mat4 mat, mat3 dest)
    void glm_mat4_pick3t(mat4 mat, mat3 dest)
    void glm_mat4_ins3(mat3 mat, mat4 dest)
    void glm_mat4_mul(mat4 m1, mat4 m2, mat4 dest)
    void glm_mat4_mulN(mat4 *matrices[], int len, mat4 dest)
    void glm_mat4_mulv(mat4 m, vec4 v, vec4 dest)
    void glm_mat4_mulv3(mat4 m, vec3 v, vec3 dest)
    float glm_mat4_trace(mat4 m)
    float glm_mat4_trace3(mat4 m)
    void glm_mat4_quat(mat4 m, versor dest) 
    void glm_mat4_transpose_to(mat4 m, mat4 dest)
    void glm_mat4_transpose(mat4 m)
    void glm_mat4_scale_p(mat4 m, float s)
    void glm_mat4_scale(mat4 m, float s)
    float glm_mat4_det(mat4 mat)
    void glm_mat4_inv(mat4 mat, mat4 dest)
    void glm_mat4_inv_fast(mat4 mat, mat4 dest)
    void glm_mat4_swap_col(mat4 mat, int col1, int col2)
    void glm_mat4_swap_row(mat4 mat, int row1, int row2)
    float glm_mat4_rmc(vec4 r, mat4 m, vec4 c)

    #cglm_plane_h
    void glm_plane_normalize(vec4 plane)

    #cglm_project_h
    void glm_unprojecti(vec3 pos, mat4 invMat, vec4 vp, vec3 dest)
    void glm_unproject(vec3 pos, mat4 m, vec4 vp, vec3 dest)
    void glm_project(vec3 pos, mat4 m, vec4 vp, vec3 dest)
    void glm_pickmatrix(vec3 center, vec2 size, vec4 vp, mat4 dest)

    #cglm_quat_h
    versor GLM_QUAT_IDENTITY_INIT
    versor GLM_QUAT_IDENTITY
    void glm_quat_identity(versor q)
    void glm_quat_init(versor q, float x, float y, float z, float w)
    void glm_quat(versor q, float angle, float x, float y, float z)
    void glm_quatv(versor q, float angle, vec3 axis)
    void glm_quat_copy(versor q, versor dest)
    void glm_quat_from_vecs(vec3 a, vec3 b, versor dest)
    float glm_quat_norm(versor q)
    void glm_quat_normalize(versor q)
    void glm_quat_normalize_to(versor q, versor dest)
    float glm_quat_dot(versor p, versor q)
    void glm_quat_conjugate(versor q, versor dest)
    void glm_quat_inv(versor q, versor dest)
    void glm_quat_add(versor p, versor q, versor dest)
    void glm_quat_sub(versor p, versor q, versor dest)
    float glm_quat_real(versor q)
    void glm_quat_imag(versor q, vec3 dest)
    void glm_quat_imagn(versor q, vec3 dest)
    float glm_quat_imaglen(versor q)
    float glm_quat_angle(versor q)
    void glm_quat_axis(versor q, vec3 dest)
    void glm_quat_mul(versor p, versor q, versor dest)
    void glm_quat_mat4(versor q, mat4 dest)
    void glm_quat_mat4t(versor q, mat4 dest)
    void glm_quat_mat3(versor q, mat3 dest)
    void glm_quat_mat3t(versor q, mat3 dest)
    void glm_quat_lerp(versor from_, versor to, float t, versor dest)
    void glm_quat_lerpc(versor from_, versor to, float t, versor dest)
    void glm_quat_slerp(versor q, versor r, float t, versor dest)
    void glm_quat_nlerp(versor q, versor r, float t, versor dest)
    void glm_quat_look(vec3 eye, versor ori, mat4 dest)
    void glm_quat_for(vec3 dir_, vec3 fwd, vec3 up, versor dest)
    void glm_quat_forp(vec3 from_, vec3 to, vec3 fwd, vec3 up, versor dest)
    void glm_quat_rotatev(versor q, vec3 v, vec3 dest)
    void glm_quat_rotate(mat4 m, versor q, mat4 dest)

    #cglm_ray_h
    bint glm_line_triangle_intersect(vec3 origin, vec3 direction, vec3 v0, vec3 v1, vec3 v2, float *d)

    #cglm_sphere_h
    float glm_sphere_radii(vec4 s)
    void glm_sphere_transform(vec4 s, mat4 m, vec4 dest)
    void glm_sphere_merge(vec4 s1, vec4 s2, vec4 dest)
    bint glm_sphere_sphere(vec4 s1, vec4 s2)
    bint glm_sphere_point(vec4 s, vec3 point)

    #cglm_util_h
    int glm_sign(int val)
    float glm_signf(float val)
    float glm_rad(float deg)
    float glm_deg(float rad)
    void glm_make_rad(float *deg)
    void glm_make_deg(float *rad)
    float glm_pow2(float x)
    float glm_min(float a, float b)
    float glm_max(float a, float b)
    float glm_clamp(float val, float minVal, float maxVal)
    float glm_clamp_zo(float val, float minVal, float maxVal)
    float glm_lerp(float from_, float to, float t)
    float glm_lerpc(float from_, float to, float t)
    float glm_step(float edge, float x)
    float glm_smooth(float t)
    float glm_smoothstep(float edge0, float edge1, float x)
    float glm_smoothinterp(float from_, float to, float t)
    float glm_smoothinterpc(float from_, float to, float t)
    bint glm_eq(float a, float b)
    float glm_percent(float from_, float to, float current)
    float glm_percentc(float from_, float to, float current)

    #cglm_vec2_ext_h
    void glm_vec2_fill(vec2 v, float val)
    bint glm_vec2_eq(vec2 v, float val)
    bint glm_vec2_eq_eps(vec2 v, float val)
    bint glm_vec2_eq_all(vec2 v)
    bint glm_vec2_eqv(vec2 a, vec2 b)
    bint glm_vec2_eqv_eps(vec2 a, vec2 b)
    float glm_vec2_max(vec2 v)
    float glm_vec2_min(vec2 v)
    bint glm_vec2_isnan(vec2 v)
    bint glm_vec2_isinf(vec2 v)
    bint glm_vec2_isvalid(vec2 v)
    void glm_vec2_sign(vec2 v, vec2 dest)
    void glm_vec2_sqrt(vec2 v, vec2 dest)

    #cglm_vec2_h
    vec2 GLM_VEC2_ONE
    vec2 GLM_VEC2_ZERO
    void glm_vec2(float *v, vec2 dest)
    void glm_vec2_copy(vec2 a, vec2 dest)
    void glm_vec2_zero(vec2 v)
    void glm_vec2_one(vec2 v)
    float glm_vec2_dot(vec2 a, vec2 b)
    float glm_vec2_cross(vec2 a, vec2 b)
    float glm_vec2_norm2(vec2 v)
    float glm_vec2_norm(vec2 vec)
    void glm_vec2_add(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_adds(vec2 v, float s, vec2 dest)
    void glm_vec2_sub(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_subs(vec2 v, float s, vec2 dest)
    void glm_vec2_mul(vec2 a, vec2 b, vec2 d)
    void glm_vec2_scale(vec2 v, float s, vec2 dest)
    void glm_vec2_scale_as(vec2 v, float s, vec2 dest)
    void glm_vec2_div(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_divs(vec2 v, float s, vec2 dest)
    void glm_vec2_addadd(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_subadd(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_muladd(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_muladds(vec2 a, float s, vec2 dest)
    void glm_vec2_maxadd(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_minadd(vec2 a, vec2 b, vec2 dest)
    void glm_vec2_negate_to(vec2 v, vec2 dest)
    void glm_vec2_negate(vec2 v)
    void glm_vec2_normalize(vec2 v)
    void glm_vec2_normalize_to(vec2 vec, vec2 dest)
    void glm_vec2_rotate(vec2 v, float angle, vec2 dest)
    float glm_vec2_distance2(vec2 a, vec2 b)
    float glm_vec2_distance(vec2 a, vec2 b)
    void glm_vec2_maxv(vec2 v1, vec2 v2, vec2 dest)
    void glm_vec2_minv(vec2 v1, vec2 v2, vec2 dest)
    void glm_vec2_clamp(vec2 v, float minVal, float maxVal)
    void glm_vec2_lerp(vec2 from_, vec2 to, float t, vec2 dest)

    #cglm_vec3_ext_h
    void glm_vec3_broadcast(float val, vec3 d)
    void glm_vec3_fill(vec3 v, float val)
    bint glm_vec3_eq(vec3 v, float val)
    bint glm_vec3_eq_eps(vec3 v, float val)
    bint glm_vec3_eq_all(vec3 v)
    bint glm_vec3_eqv(vec3 a, vec3 b)
    bint glm_vec3_eqv_eps(vec3 a, vec3 b)
    float glm_vec3_max(vec3 v)
    float glm_vec3_min(vec3 v)
    bint glm_vec3_isnan(vec3 v)
    bint glm_vec3_isinf(vec3 v)
    bint glm_vec3_isvalid(vec3 v)
    void glm_vec3_sign(vec3 v, vec3 dest)
    void glm_vec3_abs(vec3 v, vec3 dest)
    void glm_vec3_fract(vec3 v, vec3 dest)
    float glm_vec3_hadd(vec3 v)
    void glm_vec3_sqrt(vec3 v, vec3 dest)

    #glm_vec3_h
    vec3 GLM_VEC3_ONE
    vec3 GLM_VEC3_ZERO
    vec3 GLM_YUP
    vec3 GLM_ZUP
    vec3 GLM_XUP
    void glm_vec3(vec4 v4, vec3 dest)
    void glm_vec3_copy(vec3 a, vec3 dest)
    void glm_vec3_zero(vec3 v)
    void glm_vec3_one(vec3 v)
    float glm_vec3_dot(vec3 a, vec3 b)
    float glm_vec3_norm2(vec3 v)
    float glm_vec3_norm(vec3 v)
    float glm_vec3_norm_one(vec3 v)
    float glm_vec3_norm_inf(vec3 v)
    void glm_vec3_add(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_adds(vec3 a, float s, vec3 dest)
    void glm_vec3_sub(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_subs(vec3 a, float s, vec3 dest)
    void glm_vec3_mul(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_scale(vec3 v, float s, vec3 dest)
    void glm_vec3_scale_as(vec3 v, float s, vec3 dest)
    void glm_vec3_div(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_divs(vec3 a, float s, vec3 dest)
    void glm_vec3_addadd(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_subadd(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_muladd(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_muladds(vec3 a, float s, vec3 dest)
    void glm_vec3_maxadd(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_minadd(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_flipsign(vec3 v)
    void glm_vec3_flipsign_to(vec3 v, vec3 dest)
    void glm_vec3_negate_to(vec3 v, vec3 dest)
    void glm_vec3_negate(vec3 v)
    void glm_vec3_inv(vec3 v)
    void glm_vec3_inv_to(vec3 v, vec3 dest)
    void glm_vec3_normalize(vec3 v)
    void glm_vec3_normalize_to(vec3 v, vec3 dest)
    void glm_vec3_cross(vec3 a, vec3 b, vec3 d)
    void glm_vec3_crossn(vec3 a, vec3 b, vec3 dest)
    float glm_vec3_angle(vec3 a, vec3 b)
    void glm_vec3_rotate(vec3 v, float angle, vec3 axis)
    void glm_vec3_rotate_m4(mat4 m, vec3 v, vec3 dest)
    void glm_vec3_rotate_m3(mat3 m, vec3 v, vec3 dest)
    void glm_vec3_proj(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_center(vec3 a, vec3 b, vec3 dest)
    float glm_vec3_distance(vec3 a, vec3 b)
    float glm_vec3_distance2(vec3 a, vec3 b)
    void glm_vec3_maxv(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_minv(vec3 a, vec3 b, vec3 dest)
    void glm_vec3_ortho(vec3 v, vec3 dest)
    void glm_vec3_clamp(vec3 v, float minVal, float maxVal)
    void glm_vec3_lerp(vec3 from_, vec3 to, float t, vec3 dest)
    void glm_vec3_lerpc(vec3 from_, vec3 to, float t, vec3 dest)
    void glm_vec3_mix(vec3 from_, vec3 to, float t, vec3 dest)
    void glm_vec3_mixc(vec3 from_, vec3 to, float t, vec3 dest)
    void glm_vec3_step_uni(float edge, vec3 x, vec3 dest)
    void glm_vec3_step(vec3 edge, vec3 x, vec3 dest)
    void glm_vec3_smoothstep_uni(float edge0, float edge1, vec3 x, vec3 dest)
    void glm_vec3_smoothstep(vec3 edge0, vec3 edge1, vec3 x, vec3 dest)
    void glm_vec3_smoothinterp(vec3 from_, vec3 to, float t, vec3 dest)
    void glm_vec3_smoothinterpc(vec3 from_, vec3 to, float t, vec3 dest)
    void glm_vec3_swizzle(vec3 v, int mask, vec3 dest)

    #glm_vec4_ext_h
    void glm_vec4_broadcast(float val, vec4 d)
    void glm_vec4_fill(vec4 v, float val)
    bint glm_vec4_eq(vec4 v, float val)
    bint glm_vec4_eq_eps(vec4 v, float val)
    bint glm_vec4_eq_all(vec4 v)
    bint glm_vec4_eqv(vec4 a, vec4 b)
    bint glm_vec4_eqv_eps(vec4 a, vec4 b)
    float glm_vec4_max(vec4 v)
    float glm_vec4_min(vec4 v)
    bint glm_vec4_isnan(vec4 v)
    bint glm_vec4_isinf(vec4 v)
    bint glm_vec4_isvalid(vec4 v)
    void glm_vec4_sign(vec4 v, vec4 dest)
    void glm_vec4_abs(vec4 v, vec4 dest)
    void glm_vec4_fract(vec4 v, vec4 dest)
    float glm_vec4_hadd(vec4 v)
    void glm_vec4_sqrt(vec4 v, vec4 dest)

    #cglm_vec4_h
    vec4 GLM_VEC4_ONE
    vec4 GLM_VEC4_BLACK
    vec4 GLM_VEC4_ZERO
    void glm_vec4(vec3 v3, float last, vec4 dest)
    void glm_vec4_copy3(vec4 a, vec3 dest)
    void glm_vec4_copy(vec4 v, vec4 dest)
    void glm_vec4_ucopy(vec4 v, vec4 dest)
    float glm_vec4_dot(vec4 a, vec4 b)
    float glm_vec4_norm2(vec4 v)
    float glm_vec4_norm(vec4 v)
    float glm_vec4_norm_one(vec4 v)
    float glm_vec4_norm_inf(vec4 v)
    void glm_vec4_add(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_adds(vec4 v, float s, vec4 dest)
    void glm_vec4_sub(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_subs(vec4 v, float s, vec4 dest)
    void glm_vec4_mul(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_scale(vec4 v, float s, vec4 dest)
    void glm_vec4_scale_as(vec4 v, float s, vec4 dest)
    void glm_vec4_div(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_divs(vec4 v, float s, vec4 dest)
    void glm_vec4_addadd(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_subadd(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_muladd(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_muladds(vec4 a, float s, vec4 dest)
    void glm_vec4_maxadd(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_minadd(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_negate(vec4 v)
    void glm_vec4_inv(vec4 v)
    void glm_vec4_inv_to(vec4 v, vec4 dest)
    void glm_vec4_normalize(vec4 v)
    void glm_vec4_normalize_to(vec4 vec, vec4 dest)
    float glm_vec4_distance(vec4 a, vec4 b)
    float glm_vec4_distance2(vec4 a, vec4 b)
    void glm_vec4_maxv(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_minv(vec4 a, vec4 b, vec4 dest)
    void glm_vec4_clamp(vec4 v, float minVal, float maxVal)
    void glm_vec4_lerp(vec4 from_, vec4 to, float t, vec4 dest)
    void glm_vec4_lerpc(vec4 from_, vec4 to, float t, vec4 dest)
    void glm_vec4_step_uni(float edge, vec4 x, vec4 dest)
    void glm_vec4_step(vec4 edge, vec4 x, vec4 dest)
    void glm_vec4_smoothstep_uni(float edge0, float edge1, vec4 x, vec4 dest)
    void glm_vec4_smoothstep(vec4 edge0, vec4 edge1, vec4 x, vec4 dest)
    void glm_vec4_smoothinterp(vec4 from_, vec4 to, float t, vec4 dest)
    void glm_vec4_smoothinterpc(vec4 from_, vec4 to, float t, vec4 dest)
    void glm_vec4_swizzle(vec4 v, int mask, vec4 dest)

    #cglm_version_h (0.8.4)
    enum:
        CGLM_VERSION_MAJOR
        CGLM_VERSION_MINOR
        CGLM_VERSION_PATCH

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