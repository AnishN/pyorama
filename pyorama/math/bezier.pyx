cdef class Bezier:

    @staticmethod
    cdef float c_bezier(float s, float p0, float c0, float c1, float p1) nogil:
        return glm_bezier(s, p0, c0, c1, p1)

    @staticmethod
    def bezier(float s, float p0, float c0, float c1, float p1):
        return Bezier.c_bezier(s, p0, c0, c1, p1)

    @staticmethod
    cdef float c_decasteljau(float prm, float p0, float c0, float c1, float p1) nogil:
        return glm_decasteljau(prm, p0, c0, c1, p1)

    @staticmethod
    def decasteljau(float prm, float p0, float c0, float c1, float p1):
        return Bezier.c_decasteljau(prm, p0, c0, c1, p1)
    
    @staticmethod
    cdef float c_hermite(float s, float p0, float t0, float t1, float p1) nogil:
        return glm_hermite(s, p0, t0, t1, p1)

    @staticmethod
    def hermite(float s, float p0, float t0, float t1, float p1):
        return Bezier.c_hermite(s, p0, t0, t1, p1)