cdef class Quat:

    @staticmethod
    cdef Quat c_from_data(QuatC q):
        cdef Quat out = Quat.__new__(Quat)
        out.data = q
        return out

    @staticmethod
    cdef void c_identity(QuatC out) nogil:
        glm_quat_identity(<versor>&out)

    @staticmethod
    cdef void c_init(QuatC out, float x, float y, float z, float w) nogil:
        glm_quat_init(<versor>&out, x, y, z, w)

    @staticmethod
    cdef void c_from_angle_axis(QuatC out, float angle, vec3 axis) nogil:
        glm_quatv(<versor>&out, angle, axis)

    @staticmethod
    cdef void c_copy(QuatC out, QuatC q) nogil:
        glm_quat_copy(<versor>&q, <versor>&out)

    @staticmethod
    cdef void c_from_vecs(QuatC out, vec3 a, vec3 b) nogil:
        glm_quat_from_vecs(a, b, <versor>&out)

    @staticmethod
    cdef float c_mag(QuatC q) nogil:
        return glm_quat_norm(<versor>&q)

    @staticmethod
    cdef void c_normalize(QuatC out) nogil:
        glm_quat_normalize(<versor>&out)

    @staticmethod
    cdef void c_normalize_to(QuatC out, QuatC q) nogil:
        glm_quat_normalize_to(<versor>&q, <versor>&out)

    @staticmethod
    cdef float c_dot(QuatC a, QuatC b) nogil:
        return glm_quat_dot(<versor>&a, <versor>&b)

    @staticmethod
    cdef void c_conjugate(QuatC out, QuatC q) nogil:
        glm_quat_conjugate(<versor>&q, <versor>&out)

    @staticmethod
    cdef void c_inv(QuatC out, QuatC q) nogil:
        glm_quat_inv(<versor>&q, <versor>&out)

    @staticmethod
    cdef void c_add(QuatC out, QuatC a, QuatC b) nogil:
        glm_quat_add(<versor>&a, <versor>&b, <versor>&out)

    @staticmethod
    cdef void c_sub(QuatC out, QuatC a, QuatC b) nogil:
        glm_quat_sub(<versor>&a, <versor>&b, <versor>&out)

    @staticmethod
    cdef float c_real(QuatC q) nogil:
        return glm_quat_real(<versor>&q)

    @staticmethod
    cdef void c_imag(QuatC q, vec3 imag) nogil:
        glm_quat_imag(<versor>&q, imag)

    @staticmethod
    cdef void c_imag_normalize(QuatC q, vec3 imag) nogil:
        glm_quat_imagn(<versor>&q, imag)

    @staticmethod
    cdef float c_imag_mag(QuatC q) nogil:
        return glm_quat_imaglen(<versor>&q)
    
    @staticmethod
    cdef float c_angle(QuatC q) nogil:
        return glm_quat_angle(<versor>&q)

    @staticmethod
    cdef void c_axis(QuatC q, vec3 axis) nogil:
        glm_quat_axis(<versor>&q, axis)

    @staticmethod
    cdef void c_mul(QuatC out, QuatC a, QuatC b) nogil:
        glm_quat_mul(<versor>&a, <versor>&b, <versor>&out)

    @staticmethod
    cdef void c_lerp(QuatC out, QuatC a, QuatC b, float t) nogil:
        glm_quat_lerp(<versor>&a, <versor>&b, t, <versor>&out)

    @staticmethod
    cdef void c_slerp(QuatC out, QuatC a, QuatC b, float t) nogil:
        glm_quat_slerp(<versor>&a, <versor>&b, t, <versor>&out)

    @staticmethod
    cdef void c_nlerp(QuatC out, QuatC a, QuatC b, float t) nogil:
        glm_quat_nlerp(<versor>&a, <versor>&b, t, <versor>&out)

    @staticmethod
    cdef void c_look(QuatC out, vec3 dir_, vec3 up) nogil:
        glm_quat_for(dir_, up, <versor>&out)

    @staticmethod
    cdef void c_look_from_pos(QuatC out, vec3 a, vec3 b, vec3 up) nogil:
        glm_quat_forp(a, b, up, <versor>&out)

    @staticmethod
    cdef void c_from_mat4(QuatC out, mat4 a) nogil:
        glm_mat4_quat(a, <versor>&out)