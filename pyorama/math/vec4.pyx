cdef class Vec4:

    @staticmethod
    cdef Vec4 c_from_data(vec4 v):
        cdef Vec4 out = Vec4.__new__(Vec4)
        out.data = v
        return out

    @staticmethod
    cdef void c_set(vec4 v, float x, float y, float z, float w) nogil:
        v[0] = x
        v[1] = y
        v[2] = z
        v[3] = w

    @staticmethod
    cdef void c_copy(vec4 out, vec4 v) nogil:
        glm_vec4_copy(v, out)

    @staticmethod
    cdef void c_zero(vec4 out) nogil:
        glm_vec4_zero(out)

    @staticmethod
    cdef void c_one(vec4 out) nogil:
        glm_vec4_one(out)

    @staticmethod
    cdef float c_dot(vec4 a, vec4 b) nogil:
        return glm_vec4_dot(a, b)

    @staticmethod
    cdef float c_sqr_mag(vec4 v) nogil:
        return glm_vec4_norm2(v)

    @staticmethod
    cdef float c_mag(vec4 v) nogil:
        return glm_vec4_norm(v)

    @staticmethod
    cdef void c_add(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_add(a, b, out)

    @staticmethod
    cdef void c_add_scalar(vec4 out, vec4 v, float scalar) nogil:
        glm_vec4_adds(v, scalar, out)

    @staticmethod
    cdef void c_sub(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_sub(a, b, out)

    @staticmethod
    cdef void c_sub_scalar(vec4 out, vec4 v, float scalar) nogil:
        glm_vec4_subs(v, scalar, out)

    @staticmethod
    cdef void c_mul(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_mul(a, b, out)

    @staticmethod
    cdef void c_mul_scalar(vec4 out, vec4 v, float scalar) nogil:
        glm_vec4_scale(v, scalar, out)

    @staticmethod
    cdef void c_mul_unit_scalar(vec4 out, vec4 v, float scalar) nogil:
        glm_vec4_scale_as(v, scalar, out)

    @staticmethod
    cdef void c_div(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_div(a, b, out)

    @staticmethod
    cdef void c_div_scalar(vec4 out, vec4 v, float scalar) nogil:
        glm_vec4_divs(v, scalar, out)

    @staticmethod
    cdef void c_sum_add(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_addadd(a, b, out)

    @staticmethod
    cdef void c_sum_sub(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_subadd(a, b, out)

    @staticmethod
    cdef void c_sum_mul(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_muladd(a, b, out)

    @staticmethod
    cdef void c_sum_mul_scalar(vec4 out, vec4 v, float scalar) nogil:
        glm_vec4_muladds(v, scalar, out)

    @staticmethod
    cdef void c_max_add(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_maxadd(a, b, out)

    @staticmethod
    cdef void c_min_add(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_minadd(a, b, out)

    @staticmethod
    cdef void c_negate(vec4 out) nogil:
        glm_vec4_negate(out)

    @staticmethod
    cdef void c_inv(vec4 out) nogil:
        glm_vec4_inv(out)

    @staticmethod
    cdef void c_inv_to(vec4 out, vec4 v) nogil:
        glm_vec4_inv_to(v, out)

    @staticmethod
    cdef void c_normalize(vec4 out) nogil:
        glm_vec4_normalize(out)

    @staticmethod
    cdef void c_normalize_to(vec4 out, vec4 v) nogil:
        glm_vec4_normalize_to(v, out)
    
    @staticmethod
    cdef float c_sqr_dist(vec4 a, vec4 b) nogil:
        return glm_vec4_distance2(a, b)

    @staticmethod
    cdef float c_dist(vec4 a, vec4 b) nogil:
        return glm_vec4_distance(a, b)

    @staticmethod
    cdef void c_max_comps(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_maxv(a, b, out)

    @staticmethod
    cdef void c_min_comps(vec4 out, vec4 a, vec4 b) nogil:
        glm_vec4_minv(a, b, out)

    @staticmethod
    cdef void c_clamp(vec4 out, float min_, float max_) nogil:
        glm_vec4_clamp(out, min_, max_)

    @staticmethod
    cdef void c_lerp(vec4 out, vec4 a, vec4 b, float t) nogil:
        glm_vec4_lerp(a, b, t, out)

    @staticmethod
    cdef void c_fill(vec4 out, float value) nogil:
        glm_vec4_fill(out, value)

    @staticmethod
    cdef bint c_equal_value(vec4 v, float value) nogil:
        return glm_vec4_eq(v, value)

    @staticmethod
    cdef bint c_nearly_equal_value(vec4 v, float value) nogil:
        return glm_vec4_eq_eps(v, value)

    @staticmethod
    cdef bint c_equal_comps(vec4 v) nogil:
        return glm_vec4_eq_all(v)

    @staticmethod
    cdef bint c_equal(vec4 a, vec4 b) nogil:
        return glm_vec4_eqv(a, b)

    @staticmethod
    cdef bint c_nearly_equal(vec4 a, vec4 b) nogil:
        return glm_vec4_eqv_eps(a, b)

    @staticmethod
    cdef float c_max_comp(vec4 v) nogil:
        return glm_vec4_max(v)

    @staticmethod
    cdef float c_min_comp(vec4 v) nogil:
        return glm_vec4_min(v)

    @staticmethod
    cdef void c_sign(vec4 out, vec4 v) nogil:
        glm_vec4_sign(v, out)

    @staticmethod
    cdef void c_sqrt(vec4 out, vec4 v) nogil:
        glm_vec4_sqrt(v, out)

    @staticmethod
    cdef void c_transform_mat4(vec4 out, mat4 m, vec4 v) nogil:
        glm_mat4_mulv(m, v, out)