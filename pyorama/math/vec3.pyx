cdef class Vec3:

    @staticmethod
    cdef Vec3 c_from_data(vec3 v):
        cdef Vec3 out = Vec3.__new__(Vec3)
        out.data = v
        return out

    @staticmethod
    cdef void c_set(vec3 v, float x, float y, float z) nogil:
        v[0] = x
        v[1] = y
        v[2] = z

    @staticmethod
    cdef void c_copy(vec3 out, vec3 v) nogil:
        glm_vec3_copy(v, out)

    @staticmethod
    cdef void c_zero(vec3 out) nogil:
        glm_vec3_zero(out)

    @staticmethod
    cdef void c_one(vec3 out) nogil:
        glm_vec3_one(out)

    @staticmethod
    cdef float c_dot(vec3 a, vec3 b) nogil:
        return glm_vec3_dot(a, b)

    @staticmethod
    cdef void c_cross(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_cross(a, b, out)
    
    @staticmethod
    cdef void c_cross_norm(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_crossn(a, b, out)

    @staticmethod
    cdef float c_angle(vec3 a, vec3 b) nogil:
        return glm_vec3_angle(a, b)

    @staticmethod
    cdef float c_sqr_mag(vec3 v) nogil:
        return glm_vec3_norm2(v)

    @staticmethod
    cdef float c_mag(vec3 v) nogil:
        return glm_vec3_norm(v)

    @staticmethod
    cdef void c_add(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_add(a, b, out)

    @staticmethod
    cdef void c_add_scalar(vec3 out, vec3 v, float scalar) nogil:
        glm_vec3_adds(v, scalar, out)

    @staticmethod
    cdef void c_sub(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_sub(a, b, out)

    @staticmethod
    cdef void c_sub_scalar(vec3 out, vec3 v, float scalar) nogil:
        glm_vec3_subs(v, scalar, out)

    @staticmethod
    cdef void c_mul(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_mul(a, b, out)

    @staticmethod
    cdef void c_mul_scalar(vec3 out, vec3 v, float scalar) nogil:
        glm_vec3_scale(v, scalar, out)

    @staticmethod
    cdef void c_mul_unit_scalar(vec3 out, vec3 v, float scalar) nogil:
        glm_vec3_scale_as(v, scalar, out)

    @staticmethod
    cdef void c_div(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_div(a, b, out)

    @staticmethod
    cdef void c_div_scalar(vec3 out, vec3 v, float scalar) nogil:
        glm_vec3_divs(v, scalar, out)

    @staticmethod
    cdef void c_sum_add(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_addadd(a, b, out)

    @staticmethod
    cdef void c_sum_sub(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_subadd(a, b, out)

    @staticmethod
    cdef void c_sum_mul(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_muladd(a, b, out)

    @staticmethod
    cdef void c_sum_mul_scalar(vec3 out, vec3 v, float scalar) nogil:
        glm_vec3_muladds(v, scalar, out)

    @staticmethod
    cdef void c_max_add(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_maxadd(a, b, out)

    @staticmethod
    cdef void c_min_add(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_minadd(a, b, out)

    @staticmethod
    cdef void c_flip_sign(vec3 out) nogil:
        glm_vec3_flipsign(out)
    
    @staticmethod
    cdef void c_flip_sign_to(vec3 out, vec3 v) nogil:
        glm_vec3_flipsign_to(v, out)

    @staticmethod
    cdef void c_negate_to(vec3 out, vec3 v) nogil:
        glm_vec3_negate_to(v, out)

    @staticmethod
    cdef void c_negate(vec3 out) nogil:
        glm_vec3_negate(out)

    @staticmethod
    cdef void c_inv(vec3 out) nogil:
        glm_vec3_inv(out)

    @staticmethod
    cdef void c_inv_to(vec3 out, vec3 v) nogil:
        glm_vec3_inv_to(v, out)

    @staticmethod
    cdef void c_normalize(vec3 out) nogil:
        glm_vec3_normalize(out)

    @staticmethod
    cdef void c_normalize_to(vec3 out, vec3 v) nogil:
        glm_vec3_normalize_to(v, out)

    @staticmethod
    cdef void c_rotate_angle_axis(vec3 out, float angle, vec3 axis) nogil:
        glm_vec3_rotate(out, angle, axis)

    @staticmethod
    cdef void c_rotate_mat4(vec3 out, mat4 m, vec3 v) nogil:
        glm_vec3_rotate_m4(m, v, out)

    @staticmethod
    cdef void c_rotate_mat3(vec3 out, mat3 m, vec3 v) nogil:
        glm_vec3_rotate_m3(m, v, out)

    @staticmethod
    cdef void c_proj(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_proj(a, b, out)

    @staticmethod
    cdef void c_center(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_center(a, b, out)
    
    @staticmethod
    cdef float c_sqr_dist(vec3 a, vec3 b) nogil:
        return glm_vec3_distance2(a, b)

    @staticmethod
    cdef float c_dist(vec3 a, vec3 b) nogil:
        return glm_vec3_distance(a, b)

    @staticmethod
    cdef void c_max_comps(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_maxv(a, b, out)

    @staticmethod
    cdef void c_min_comps(vec3 out, vec3 a, vec3 b) nogil:
        glm_vec3_minv(a, b, out)

    @staticmethod
    cdef void c_ortho(vec3 out, vec3 v) nogil:
        glm_vec3_ortho(v, out)

    @staticmethod
    cdef void c_clamp(vec3 out, float min_, float max_) nogil:
        glm_vec3_clamp(out, min_, max_)

    @staticmethod
    cdef void c_lerp(vec3 out, vec3 a, vec3 b, float t) nogil:
        glm_vec3_lerp(a, b, t, out)

    @staticmethod
    cdef void c_fill(vec3 out, float value) nogil:
        glm_vec3_fill(out, value)

    @staticmethod
    cdef bint c_equal_value(vec3 v, float value) nogil:
        return glm_vec3_eq(v, value)

    @staticmethod
    cdef bint c_nearly_equal_value(vec3 v, float value) nogil:
        return glm_vec3_eq_eps(v, value)

    @staticmethod
    cdef bint c_equal_comps(vec3 v) nogil:
        return glm_vec3_eq_all(v)

    @staticmethod
    cdef bint c_equal(vec3 a, vec3 b) nogil:
        return glm_vec3_eqv(a, b)

    @staticmethod
    cdef bint c_nearly_equal(vec3 a, vec3 b) nogil:
        return glm_vec3_eqv_eps(a, b)

    @staticmethod
    cdef float c_max_comp(vec3 v) nogil:
        return glm_vec3_max(v)

    @staticmethod
    cdef float c_min_comp(vec3 v) nogil:
        return glm_vec3_min(v)

    @staticmethod
    cdef void c_sign(vec3 out, vec3 v) nogil:
        glm_vec3_sign(v, out)

    @staticmethod
    cdef void c_sqrt(vec3 out, vec3 v) nogil:
        glm_vec3_sqrt(v, out)

    @staticmethod
    cdef void c_transform_mat3(vec3 out, mat3 m, vec3 v) nogil:
        glm_mat3_mulv(m, v, out)

    @staticmethod
    cdef void c_transform_mat4(vec3 out, mat4 m, vec3 v, float w) nogil:
        glm_mat4_mulv3(m, v, w, out)

    @staticmethod
    cdef void c_transform_quat(vec3 out, quat q, vec3 v) nogil:
        glm_quat_rotatev(q, v, out)

    @staticmethod
    cdef float c_luminance(vec3 rgb) nogil:
        return glm_luminance(rgb)

    @staticmethod
    cdef void c_from_vec4(vec3 out, vec4 v) nogil:
        glm_vec4_copy3(v, out)