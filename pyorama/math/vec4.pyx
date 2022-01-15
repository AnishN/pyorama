cdef class Vec4:

    @staticmethod
    cdef Vec4 c_from_data(Vec4C v):
        cdef Vec4 out = Vec4.__new__(Vec4)
        out.data = v
        return out

    @staticmethod
    cdef void c_set(Vec4C v, float x, float y, float z, float w) nogil:
        v.x = x
        v.y = y
        v.z = z
        v.w = w

    @staticmethod
    cdef void c_copy(Vec4C out, Vec4C v) nogil:
        glm_vec4_copy(<vec4>&v, <vec4>&out)

    @staticmethod
    cdef void c_zero(Vec4C out) nogil:
        glm_vec4_zero(<vec4>&out)

    @staticmethod
    cdef void c_one(Vec4C out) nogil:
        glm_vec4_one(<vec4>&out)

    @staticmethod
    cdef float c_dot(Vec4C a, Vec4C b) nogil:
        return glm_vec4_dot(<vec4>&a, <vec4>&b)

    @staticmethod
    cdef float c_sqr_mag(Vec4C v) nogil:
        return glm_vec4_norm2(<vec4>&v)

    @staticmethod
    cdef float c_mag(Vec4C v) nogil:
        return glm_vec4_norm(<vec4>&v)

    @staticmethod
    cdef void c_add(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_add(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_add_scalar(Vec4C out, Vec4C v, float scalar) nogil:
        glm_vec4_adds(<vec4>&v, scalar, <vec4>&out)

    @staticmethod
    cdef void c_sub(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_sub(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_sub_scalar(Vec4C out, Vec4C v, float scalar) nogil:
        glm_vec4_subs(<vec4>&v, scalar, <vec4>&out)

    @staticmethod
    cdef void c_mul(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_mul(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_mul_scalar(Vec4C out, Vec4C v, float scalar) nogil:
        glm_vec4_scale(<vec4>&v, scalar, <vec4>&out)

    @staticmethod
    cdef void c_mul_unit_scalar(Vec4C out, Vec4C v, float scalar) nogil:
        glm_vec4_scale_as(<vec4>&v, scalar, <vec4>&out)

    @staticmethod
    cdef void c_div(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_div(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_div_scalar(Vec4C out, Vec4C v, float scalar) nogil:
        glm_vec4_divs(<vec4>&v, scalar, <vec4>&out)

    @staticmethod
    cdef void c_sum_add(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_addadd(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_sum_sub(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_subadd(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_sum_mul(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_muladd(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_sum_mul_scalar(Vec4C out, Vec4C v, float scalar) nogil:
        glm_vec4_muladds(<vec4>&v, scalar, <vec4>&out)

    @staticmethod
    cdef void c_max_add(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_maxadd(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_min_add(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_minadd(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_negate(Vec4C out) nogil:
        glm_vec4_negate(<vec4>&out)

    @staticmethod
    cdef void c_inv(Vec4C out) nogil:
        glm_vec4_inv(<vec4>&out)

    @staticmethod
    cdef void c_inv_to(Vec4C out, Vec4C v) nogil:
        glm_vec4_inv_to(<vec4>&v, <vec4>&out)

    @staticmethod
    cdef void c_normalize(Vec4C out) nogil:
        glm_vec4_normalize(<vec4>&out)

    @staticmethod
    cdef void c_normalize_to(Vec4C out, Vec4C v) nogil:
        glm_vec4_normalize_to(<vec4>&v, <vec4>&out)
    
    @staticmethod
    cdef float c_sqr_dist(Vec4C a, Vec4C b) nogil:
        return glm_vec4_distance2(<vec4>&a, <vec4>&b)

    @staticmethod
    cdef float c_dist(Vec4C a, Vec4C b) nogil:
        return glm_vec4_distance(<vec4>&a, <vec4>&b)

    @staticmethod
    cdef void c_max_comps(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_maxv(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_min_comps(Vec4C out, Vec4C a, Vec4C b) nogil:
        glm_vec4_minv(<vec4>&a, <vec4>&b, <vec4>&out)

    @staticmethod
    cdef void c_clamp(Vec4C out, float min_, float max_) nogil:
        glm_vec4_clamp(<vec4>&out, min_, max_)

    @staticmethod
    cdef void c_lerp(Vec4C out, Vec4C a, Vec4C b, float t) nogil:
        glm_vec4_lerp(<vec4>&a, <vec4>&b, t, <vec4>&out)

    @staticmethod
    cdef void c_fill(Vec4C out, float value) nogil:
        glm_vec4_fill(<vec4>&out, value)

    @staticmethod
    cdef bint c_equal_value(Vec4C v, float value) nogil:
        return glm_vec4_eq(<vec4>&v, value)

    @staticmethod
    cdef bint c_nearly_equal_value(Vec4C v, float value) nogil:
        return glm_vec4_eq_eps(<vec4>&v, value)

    @staticmethod
    cdef bint c_equal_comps(Vec4C v) nogil:
        return glm_vec4_eq_all(<vec4>&v)

    @staticmethod
    cdef bint c_equal(Vec4C a, Vec4C b) nogil:
        return glm_vec4_eqv(<vec4>&a, <vec4>&b)

    @staticmethod
    cdef bint c_nearly_equal(Vec4C a, Vec4C b) nogil:
        return glm_vec4_eqv_eps(<vec4>&a, <vec4>&b)

    @staticmethod
    cdef float c_max_comp(Vec4C v) nogil:
        return glm_vec4_max(<vec4>&v)

    @staticmethod
    cdef float c_min_comp(Vec4C v) nogil:
        return glm_vec4_min(<vec4>&v)

    @staticmethod
    cdef void c_sign(Vec4C out, Vec4C v) nogil:
        glm_vec4_sign(<vec4>&v, <vec4>&out)

    @staticmethod
    cdef void c_sqrt(Vec4C out, Vec4C v) nogil:
        glm_vec4_sqrt(<vec4>&v, <vec4>&out)

    @staticmethod
    cdef void c_transform_mat4(Vec4C out, Mat4C m, Vec4C v) nogil:
        glm_mat4_mulv(<mat4>&m, <vec4>&v, <vec4>&out)