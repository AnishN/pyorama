cdef class Vec3:

    @staticmethod
    cdef Vec3 c_from_data(Vec3C *v):
        cdef Vec3 out = Vec3.__new__(Vec3)
        out.data = v[0]
        return out

    @staticmethod
    cdef void c_set(Vec3C *v, float x, float y, float z) nogil:
        v.x = x
        v.y = y
        v.z = z

    @staticmethod
    cdef void c_copy(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_copy(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_zero(Vec3C *out) nogil:
        glm_vec3_zero(<vec3>out)

    @staticmethod
    cdef void c_one(Vec3C *out) nogil:
        glm_vec3_one(<vec3>out)

    @staticmethod
    cdef float c_dot(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_dot(<vec3>a, <vec3>b)

    @staticmethod
    cdef void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_cross(<vec3>a, <vec3>b, <vec3>out)
    
    @staticmethod
    cdef void c_cross_norm(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_crossn(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef float c_angle(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_angle(<vec3>a, <vec3>b)

    @staticmethod
    cdef float c_sqr_mag(Vec3C *v) nogil:
        return glm_vec3_norm2(<vec3>v)

    @staticmethod
    cdef float c_mag(Vec3C *v) nogil:
        return glm_vec3_norm(<vec3>v)

    @staticmethod
    cdef void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_add(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_add_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_adds(<vec3>v, scalar, <vec3>out)

    @staticmethod
    cdef void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_sub(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_sub_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_subs(<vec3>v, scalar, <vec3>out)

    @staticmethod
    cdef void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_mul(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_mul_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_scale(<vec3>v, scalar, <vec3>out)

    @staticmethod
    cdef void c_mul_unit_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_scale_as(<vec3>v, scalar, <vec3>out)

    @staticmethod
    cdef void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_div(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_div_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_divs(<vec3>v, scalar, <vec3>out)

    @staticmethod
    cdef void c_sum_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_addadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_sum_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_subadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_sum_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_muladd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_sum_mul_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_muladds(<vec3>v, scalar, <vec3>out)

    @staticmethod
    cdef void c_max_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_maxadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_min_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_minadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_flip_sign(Vec3C *out) nogil:
        glm_vec3_flipsign(<vec3>out)
    
    @staticmethod
    cdef void c_flip_sign_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_flipsign_to(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_negate_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_negate_to(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_negate(Vec3C *out) nogil:
        glm_vec3_negate(<vec3>out)

    @staticmethod
    cdef void c_inv(Vec3C *out) nogil:
        glm_vec3_inv(<vec3>out)

    @staticmethod
    cdef void c_inv_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_inv_to(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_normalize(Vec3C *out) nogil:
        glm_vec3_normalize(<vec3>out)

    @staticmethod
    cdef void c_normalize_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_normalize_to(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_rotate_angle_axis(Vec3C *out, float angle, Vec3C *axis) nogil:
        glm_vec3_rotate(<vec3>out, angle, <vec3>axis)

    @staticmethod
    cdef void c_rotate_mat4(Vec3C *out, Mat4C *m, Vec3C *v) nogil:
        glm_vec3_rotate_m4(<mat4>m, <vec3>v, <vec3>out)

    @staticmethod
    cdef void c_rotate_mat3(Vec3C *out, Mat3C *m, Vec3C *v) nogil:
        glm_vec3_rotate_m3(<mat3>m, <vec3>v, <vec3>out)

    @staticmethod
    cdef void c_proj(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_proj(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_center(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_center(<vec3>a, <vec3>b, <vec3>out)
    
    @staticmethod
    cdef float c_sqr_dist(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_distance2(<vec3>a, <vec3>b)

    @staticmethod
    cdef float c_dist(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_distance(<vec3>a, <vec3>b)

    @staticmethod
    cdef void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_maxv(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_minv(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    cdef void c_ortho(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_ortho(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_clamp(Vec3C *out, float min_, float max_) nogil:
        glm_vec3_clamp(<vec3>out, min_, max_)

    @staticmethod
    cdef void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil:
        glm_vec3_lerp(<vec3>a, <vec3>b, t, <vec3>out)

    @staticmethod
    cdef void c_fill(Vec3C *out, float value) nogil:
        glm_vec3_fill(<vec3>out, value)

    @staticmethod
    cdef bint c_equal_value(Vec3C *v, float value) nogil:
        return glm_vec3_eq(<vec3>v, value)

    @staticmethod
    cdef bint c_nearly_equal_value(Vec3C *v, float value) nogil:
        return glm_vec3_eq_eps(<vec3>v, value)

    @staticmethod
    cdef bint c_equal_comps(Vec3C *v) nogil:
        return glm_vec3_eq_all(<vec3>v)

    @staticmethod
    cdef bint c_equal(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_eqv(<vec3>a, <vec3>b)

    @staticmethod
    cdef bint c_nearly_equal(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_eqv_eps(<vec3>a, <vec3>b)

    @staticmethod
    cdef float c_max_comp(Vec3C *v) nogil:
        return glm_vec3_max(<vec3>v)

    @staticmethod
    cdef float c_min_comp(Vec3C *v) nogil:
        return glm_vec3_min(<vec3>v)

    @staticmethod
    cdef void c_sign(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_sign(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_sqrt(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_sqrt(<vec3>v, <vec3>out)

    @staticmethod
    cdef void c_transform_mat3(Vec3C *out, Mat3C *m, Vec3C *v) nogil:
        glm_mat3_mulv(<mat3>m, <vec3>v, <vec3>out)

    @staticmethod
    cdef void c_transform_mat4(Vec3C *out, Mat4C *m, Vec3C *v, float w) nogil:
        glm_mat4_mulv3(<mat4>m, <vec3>v, w, <vec3>out)

    @staticmethod
    cdef void c_transform_quat(Vec3C *out, QuatC *q, Vec3C *v) nogil:
        glm_quat_rotatev(<versor>q, <vec3>v, <vec3>out)

    @staticmethod
    cdef float c_luminance(Vec3C *rgb) nogil:
        return glm_luminance(<vec3>rgb)

    @staticmethod
    cdef void c_from_vec4(Vec3C *out, Vec4C *v) nogil:
        glm_vec4_copy3(<vec4>v, <vec3>out)