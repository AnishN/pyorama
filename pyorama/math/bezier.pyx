cdef class Bezier:

    @staticmethod
    cdef float bezier(float s, float p_0, float c_0, float c_1, float p_1) nogil:
        return glm_bezier(s, p_0, c_0, c_1, p_1)

    @staticmethod
    cdef float hermite(float s, float p_0, float t_0, float t_1, float p_1) nogil:
        return glm_hermite(s, p_0, t_0, t_1, p_1)

    @staticmethod
    cdef float decasteljau(float prm, float p_0, float c_0, float c_1, float p_1) nogil:
        return glm_decasteljau(prm, p_0, c_0, c_1, p_1)
