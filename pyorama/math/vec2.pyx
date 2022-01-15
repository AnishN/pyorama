cdef class Vec2:

    @staticmethod
    cdef Vec2 c_from_data(Vec2C *v):
        cdef Vec2 out = Vec2.__new__(Vec2)
        out.data = v[0]
        return out

    @staticmethod
    cdef void c_set(Vec2C *v, float x, float y) nogil:
        v.x = x
        v.y = y

    @staticmethod
    cdef void c_copy(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_copy(<vec2>v, <vec2>out)

    @staticmethod
    cdef void c_zero(Vec2C *out) nogil:
        glm_vec2_zero(<vec2>out)

    @staticmethod
    cdef void c_one(Vec2C *out) nogil:
        glm_vec2_one(<vec2>out)

    @staticmethod
    cdef float c_dot(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_dot(<vec2>a, <vec2>b)

    @staticmethod
    cdef float c_cross(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_cross(<vec2>a, <vec2>b)

    @staticmethod
    cdef float c_sqr_mag(Vec2C *v) nogil:
        return glm_vec2_norm2(<vec2>v)

    @staticmethod
    cdef float c_mag(Vec2C *v) nogil:
        return glm_vec2_norm(<vec2>v)

    @staticmethod
    cdef void c_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_add(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_add_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_adds(<vec2>v, scalar, <vec2>out)

    @staticmethod
    cdef void c_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_sub(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_sub_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_subs(<vec2>v, scalar, <vec2>out)

    @staticmethod
    cdef void c_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_mul(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_mul_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_scale(<vec2>v, scalar, <vec2>out)

    @staticmethod
    cdef void c_mul_unit_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_scale_as(<vec2>v, scalar, <vec2>out)

    @staticmethod
    cdef void c_div(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_div(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_div_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_divs(<vec2>v, scalar, <vec2>out)

    @staticmethod
    cdef void c_sum_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_addadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_sum_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_subadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_sum_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_muladd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_sum_mul_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_muladds(<vec2>v, scalar, <vec2>out)

    @staticmethod
    cdef void c_max_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_maxadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_min_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_minadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_negate_to(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_negate_to(<vec2>v, <vec2>out)

    @staticmethod
    cdef void c_negate(Vec2C *out) nogil:
        glm_vec2_negate(<vec2>out)

    @staticmethod
    cdef void c_normalize(Vec2C *out) nogil:
        glm_vec2_normalize(<vec2>out)

    @staticmethod
    cdef void c_normalize_to(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_normalize_to(<vec2>v, <vec2>out)

    @staticmethod
    cdef void c_rotate(Vec2C *out, Vec2C *v, float angle) nogil:
        glm_vec2_rotate(<vec2>v, angle, <vec2>out)

    @staticmethod
    cdef float c_sqr_dist(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_distance2(<vec2>a, <vec2>b)

    @staticmethod
    cdef float c_dist(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_distance(<vec2>a, <vec2>b)

    @staticmethod
    cdef void c_max_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_maxv(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_min_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_minv(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_clamp(Vec2C *out, float min_, float max_) nogil:
        glm_vec2_clamp(<vec2>out, min_, max_)

    @staticmethod
    cdef void c_lerp(Vec2C *out, Vec2C *a, Vec2C *b, float t) nogil:
        glm_vec2_lerp(<vec2>a, <vec2>b, t, <vec2>out)

    @staticmethod
    cdef void c_fill(Vec2C *out, float value) nogil:
        glm_vec2_fill(<vec2>out, value)

    @staticmethod
    cdef bint c_equal_value(Vec2C *v, float value) nogil:
        return glm_vec2_eq(<vec2>v, value)

    @staticmethod
    cdef bint c_nearly_equal_value(Vec2C *v, float value) nogil:
        return glm_vec2_eq_eps(<vec2>v, value)

    @staticmethod
    cdef bint c_equal_comps(Vec2C *v) nogil:
        return glm_vec2_eq_all(<vec2>v)

    @staticmethod
    cdef bint c_equal(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_eqv(<vec2>a, <vec2>b)

    @staticmethod
    cdef bint c_nearly_equal(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_eqv_eps(<vec2>a, <vec2>b)

    @staticmethod
    cdef float c_max_comp(Vec2C *v) nogil:
        return glm_vec2_max(<vec2>v)

    @staticmethod
    cdef float c_min_comp(Vec2C *v) nogil:
        return glm_vec2_min(<vec2>v)

    @staticmethod
    cdef void c_sign(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_sign(<vec2>v, <vec2>out)

    @staticmethod
    cdef void c_sqrt(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_sqrt(<vec2>v, <vec2>out)

    @staticmethod
    cdef void c_transform_mat2(Vec2C *out, Mat2C *m, Vec2C *v) nogil:
        glm_mat2_mulv(<mat2>m, <vec2>v, <vec2>out)