cdef class Quat:

    @staticmethod
    cdef Quat c_from_data(quat q):
        cdef Quat out = Quat.__new__(Quat)
        out.data = q
        return out

    @staticmethod
    cdef void c_identity(quat out) nogil:
        glm_quat_identity(out)

    @staticmethod
    cdef void c_init(quat out, float x, float y, float z, float w) nogil:
        glm_quat_init(out, x, y, z, w)

    @staticmethod
    cdef void c_from_angle_axis(quat out, float angle, vec3 axis) nogil:
        glm_quatv(out, angle, axis)

    @staticmethod
    cdef void c_copy(quat out, quat q) nogil:
        glm_quat_copy(q, out)

    @staticmethod
    cdef void c_from_vecs(quat out, vec3 a, vec3 b) nogil:
        glm_quat_from_vecs(a, b, out)

    @staticmethod
    cdef float c_mag(quat q) nogil:
        return glm_quat_norm(q)

    @staticmethod
    cdef void c_normalize(quat out) nogil:
        glm_quat_normalize(out)

    @staticmethod
    cdef void c_normalize_to(quat out, quat q) nogil:
        glm_quat_normalize_to(q, out)

    @staticmethod
    cdef float c_dot(quat a, quat b) nogil:
        return glm_quat_dot(a, b)

    @staticmethod
    cdef void c_conjugate(quat out, quat q) nogil:
        glm_quat_conjugate(q, out)

    @staticmethod
    cdef void c_inv(quat out, quat q) nogil:
        glm_quat_inv(q, out)

    @staticmethod
    cdef void c_add(quat out, quat a, quat b) nogil:
        glm_quat_add(a, b, out)

    @staticmethod
    cdef void c_sub(quat out, quat a, quat b) nogil:
        glm_quat_sub(a, b, out)

    @staticmethod
    cdef float c_real(quat q) nogil:
        return glm_quat_real(q)

    @staticmethod
    cdef void c_imag(quat q, vec3 imag) nogil:
        glm_quat_imag(q, imag)

    @staticmethod
    cdef void c_imag_normalize(quat q, vec3 imag) nogil:
        glm_quat_imagn(q, imag)

    @staticmethod
    cdef float c_imag_mag(quat q) nogil:
        return glm_quat_imaglen(q)
    
    @staticmethod
    cdef float c_angle(quat q) nogil:
        return glm_quat_angle(q)

    @staticmethod
    cdef void c_axis(quat q, vec3 axis) nogil:
        glm_quat_axis(q, axis)

    @staticmethod
    cdef void c_mul(quat out, quat a, quat b) nogil:
        glm_quat_mul(a, b, out)

    @staticmethod
    cdef void c_lerp(quat out, quat a, quat b, float t) nogil:
        glm_quat_lerp(a, b, t, out)

    @staticmethod
    cdef void c_slerp(quat out, quat a, quat b, float t) nogil:
        glm_quat_slerp(a, b, t, out)

    @staticmethod
    cdef void c_nlerp(quat out, quat a, quat b, float t) nogil:
        glm_quat_nlerp(a, b, t, out)

    @staticmethod
    cdef void c_look(quat out, vec3 dir_, vec3 up) nogil:
        glm_quat_for(dir_, up, out)

    @staticmethod
    cdef void c_look_from_pos(quat out, vec3 a, vec3 b, vec3 up) nogil:
        glm_quat_forp(a, b, up, out)

    @staticmethod
    cdef void c_from_mat4(quat out, mat4 a) nogil:
        glm_mat4_quat(a, out)