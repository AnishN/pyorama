cdef class Vec2:

    @staticmethod
    cdef Vec2 c_from_data(vec2 v):
        cdef Vec2 out = Vec2.__new__(Vec2)
        out.data = v
        return out

    @staticmethod
    cdef void c_set(vec2 v, float x, float y) nogil:
        v[0] = x
        v[1] = y

    @staticmethod
    cdef void c_copy(vec2 out, vec2 v) nogil:
        glm_vec2_copy(v, out)

    @staticmethod
    cdef void c_zero(vec2 out) nogil:
        glm_vec2_zero(out)

    @staticmethod
    cdef void c_one(vec2 out) nogil:
        glm_vec2_one(out)

    @staticmethod
    cdef float c_dot(vec2 a, vec2 b) nogil:
        return glm_vec2_dot(a, b)

    @staticmethod
    cdef float c_cross(vec2 a, vec2 b) nogil:
        return glm_vec2_cross(a, b)

    @staticmethod
    cdef float c_sqr_mag(vec2 v) nogil:
        return glm_vec2_norm2(v)

    @staticmethod
    cdef float c_mag(vec2 v) nogil:
        return glm_vec2_norm(v)

    @staticmethod
    cdef void c_add(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_add(a, b, out)

    @staticmethod
    cdef void c_add_scalar(vec2 out, vec2 v, float scalar) nogil:
        glm_vec2_adds(v, scalar, out)

    @staticmethod
    cdef void c_sub(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_sub(a, b, out)

    @staticmethod
    cdef void c_sub_scalar(vec2 out, vec2 v, float scalar) nogil:
        glm_vec2_subs(v, scalar, out)

    @staticmethod
    cdef void c_mul(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_mul(a, b, out)

    @staticmethod
    cdef void c_mul_scalar(vec2 out, vec2 v, float scalar) nogil:
        glm_vec2_scale(v, scalar, out)

    @staticmethod
    cdef void c_mul_unit_scalar(vec2 out, vec2 v, float scalar) nogil:
        glm_vec2_scale_as(v, scalar, out)

    @staticmethod
    cdef void c_div(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_div(a, b, out)

    @staticmethod
    cdef void c_div_scalar(vec2 out, vec2 v, float scalar) nogil:
        glm_vec2_divs(v, scalar, out)

    @staticmethod
    cdef void c_sum_add(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_addadd(a, b, out)

    @staticmethod
    cdef void c_sum_sub(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_subadd(a, b, out)

    @staticmethod
    cdef void c_sum_mul(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_muladd(a, b, out)

    @staticmethod
    cdef void c_sum_mul_scalar(vec2 out, vec2 v, float scalar) nogil:
        glm_vec2_muladds(v, scalar, out)

    @staticmethod
    cdef void c_max_add(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_maxadd(a, b, out)

    @staticmethod
    cdef void c_min_add(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_minadd(a, b, out)

    @staticmethod
    cdef void c_negate_to(vec2 out, vec2 v) nogil:
        glm_vec2_negate_to(v, out)

    @staticmethod
    cdef void c_negate(vec2 out) nogil:
        glm_vec2_negate(out)

    @staticmethod
    cdef void c_normalize(vec2 out) nogil:
        glm_vec2_normalize(out)

    @staticmethod
    cdef void c_normalize_to(vec2 out, vec2 v) nogil:
        glm_vec2_normalize_to(v, out)

    @staticmethod
    cdef void c_rotate(vec2 out, vec2 v, float angle) nogil:
        glm_vec2_rotate(v, angle, out)

    @staticmethod
    cdef float c_sqr_dist(vec2 a, vec2 b) nogil:
        return glm_vec2_distance2(a, b)

    @staticmethod
    cdef float c_dist(vec2 a, vec2 b) nogil:
        return glm_vec2_distance(a, b)

    @staticmethod
    cdef void c_max_comps(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_maxv(a, b, out)

    @staticmethod
    cdef void c_min_comps(vec2 out, vec2 a, vec2 b) nogil:
        glm_vec2_minv(a, b, out)

    @staticmethod
    cdef void c_clamp(vec2 out, float min_, float max_) nogil:
        glm_vec2_clamp(out, min_, max_)

    @staticmethod
    cdef void c_lerp(vec2 out, vec2 a, vec2 b, float t) nogil:
        glm_vec2_lerp(a, b, t, out)

    @staticmethod
    cdef void c_fill(vec2 out, float value) nogil:
        glm_vec2_fill(out, value)

    @staticmethod
    cdef bint c_equal_value(vec2 v, float value) nogil:
        return glm_vec2_eq(v, value)

    @staticmethod
    cdef bint c_nearly_equal_value(vec2 v, float value) nogil:
        return glm_vec2_eq_eps(v, value)

    @staticmethod
    cdef bint c_equal_comps(vec2 v) nogil:
        return glm_vec2_eq_all(v)

    @staticmethod
    cdef bint c_equal(vec2 a, vec2 b) nogil:
        return glm_vec2_eqv(a, b)

    @staticmethod
    cdef bint c_nearly_equal(vec2 a, vec2 b) nogil:
        return glm_vec2_eqv_eps(a, b)

    @staticmethod
    cdef float c_max_comp(vec2 v) nogil:
        return glm_vec2_max(v)

    @staticmethod
    cdef float c_min_comp(vec2 v) nogil:
        return glm_vec2_min(v)

    @staticmethod
    cdef void c_sign(vec2 out, vec2 v) nogil:
        glm_vec2_sign(v, out)

    @staticmethod
    cdef void c_sqrt(vec2 out, vec2 v) nogil:
        glm_vec2_sqrt(v, out)

    @staticmethod
    cdef void c_transform_mat2(vec2 out, mat2 m, vec2 v) nogil:
        glm_mat2_mulv(m, v, out)