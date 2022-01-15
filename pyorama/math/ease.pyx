cdef class Ease:

    @staticmethod
    cdef float c_linear(float t) nogil:
        return glm_ease_linear(t)

    @staticmethod
    cdef float c_sine_in(float t) nogil:
        return glm_ease_sine_in(t)

    @staticmethod
    cdef float c_sine_out(float t) nogil:
        return glm_ease_sine_out(t)

    @staticmethod
    cdef float c_sine_in_out(float t) nogil:
        return glm_ease_sine_inout(t)

    @staticmethod
    cdef float c_quad_in(float t) nogil:
        return glm_ease_quad_in(t)

    @staticmethod
    cdef float c_quad_out(float t) nogil:
        return glm_ease_quad_out(t)

    @staticmethod
    cdef float c_quad_in_out(float t) nogil:
        return glm_ease_quad_inout(t)

    @staticmethod
    cdef float c_cubic_in(float t) nogil:
        return glm_ease_cubic_in(t)

    @staticmethod
    cdef float c_cubic_out(float t) nogil:
        return glm_ease_cubic_out(t)

    @staticmethod
    cdef float c_cubic_in_out(float t) nogil:
        return glm_ease_cubic_inout(t)

    @staticmethod
    cdef float c_quart_in(float t) nogil:
        return glm_ease_quart_in(t)

    @staticmethod
    cdef float c_quart_out(float t) nogil:
        return glm_ease_quart_out(t)

    @staticmethod
    cdef float c_quart_in_out(float t) nogil:
        return glm_ease_quart_inout(t)

    @staticmethod
    cdef float c_quint_in(float t) nogil:
        return glm_ease_quint_in(t)

    @staticmethod
    cdef float c_quint_out(float t) nogil:
        return glm_ease_quint_out(t)

    @staticmethod
    cdef float c_quint_in_out(float t) nogil:
        return glm_ease_quint_inout(t)

    @staticmethod
    cdef float c_exp_in(float t) nogil:
        return glm_ease_exp_in(t)

    @staticmethod
    cdef float c_exp_out(float t) nogil:
        return glm_ease_exp_out(t)

    @staticmethod
    cdef float c_exp_in_out(float t) nogil:
        return glm_ease_exp_inout(t)

    @staticmethod
    cdef float c_circ_in(float t) nogil:
        return glm_ease_circ_in(t)

    @staticmethod
    cdef float c_circ_out(float t) nogil:
        return glm_ease_circ_out(t)

    @staticmethod
    cdef float c_circ_in_out(float t) nogil:
        return glm_ease_circ_inout(t)

    @staticmethod
    cdef float c_back_in(float t) nogil:
        return glm_ease_back_in(t)

    @staticmethod
    cdef float c_back_out(float t) nogil:
        return glm_ease_back_out(t)

    @staticmethod
    cdef float c_back_in_out(float t) nogil:
        return glm_ease_back_inout(t)

    @staticmethod
    cdef float c_elast_in(float t) nogil:
        return glm_ease_elast_in(t)

    @staticmethod
    cdef float c_elast_out(float t) nogil:
        return glm_ease_elast_out(t)

    @staticmethod
    cdef float c_elast_in_out(float t) nogil:
        return glm_ease_elast_inout(t)

    @staticmethod
    cdef float c_bounce_out(float t) nogil:
        return glm_ease_bounce_out(t)

    @staticmethod
    cdef float c_bounce_in(float t) nogil:
        return glm_ease_bounce_in(t)

    @staticmethod
    cdef float c_bounce_in_out(float t) nogil:
        return glm_ease_bounce_inout(t)