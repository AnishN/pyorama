from pyorama.math.mat4 cimport *
from pyorama.math.vec3 cimport *

cdef class Quat:

    @staticmethod
    cdef Quat c_from_data(QuatC *q):
        cdef Quat out = Quat.__new__(Quat)
        out.data = q[0]
        return out
    
    @staticmethod
    cdef void c_init(QuatC *out, float x, float y, float z, float w) nogil:
        glm_quat_init(<versor>out, x, y, z, w)

    @staticmethod
    def init(Quat out, float x, float y, float z, float w):
        Quat.c_init(&out.data, x, y, z, w)
    
    @staticmethod
    cdef void c_add(QuatC *out, QuatC *a, QuatC *b) nogil:
        glm_quat_add(<versor>a, <versor>b, <versor>out)

    @staticmethod
    def add(Quat out, Quat a, Quat b):
        Quat.c_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_axis(QuatC *q, Vec3C *axis) nogil:
        glm_quat_axis(<versor>q, <vec3>axis)
    
    @staticmethod
    def axis(Quat q, Vec3 axis):
        Quat.c_axis(&q.data, &axis.data)
    
    @staticmethod
    cdef float c_angle(QuatC *q) nogil:
        return glm_quat_angle(<versor>q)

    @staticmethod
    def angle(Quat q):
        return Quat.c_angle(&q.data)
    
    @staticmethod
    cdef void c_conjugate(QuatC *out, QuatC *q) nogil:
        glm_quat_conjugate(<versor>q, <versor>out)

    @staticmethod
    def conjugate(Quat out, Quat q):
        Quat.c_conjugate(&out.data, &q.data)
    
    @staticmethod
    cdef void c_copy(QuatC *out, QuatC *q) nogil:
        glm_quat_copy(<versor>q, <versor>out)

    @staticmethod
    def copy(Quat out, Quat q):
        Quat.c_copy(&out.data, &q.data)
    
    @staticmethod
    cdef float c_dot(QuatC *a, QuatC *b) nogil:
        return glm_quat_dot(<versor>a, <versor>b)

    @staticmethod
    def dot(Quat a, Quat b):
        return Quat.c_dot(&a.data, &b.data)
    
    @staticmethod
    cdef void c_from_angle_axis(QuatC *out, float angle, Vec3C *axis) nogil:
        glm_quatv(<versor>out, angle, <vec3>axis)
    
    @staticmethod
    def from_angle_axis(Quat out, float angle, Vec3 axis):
        Quat.c_from_angle_axis(&out.data, angle, &axis.data)

    @staticmethod
    cdef void c_from_mat4(QuatC *out, Mat4C *a) nogil:
        glm_mat4_quat(<mat4>a, <versor>out)

    @staticmethod
    def from_mat4(Quat out, Mat4 a):
        Quat.c_from_mat4(&out.data, &a.data)
    
    @staticmethod
    cdef void c_from_vecs(QuatC *out, Vec3C *a, Vec3C *b) nogil:
        glm_quat_from_vecs(<vec3>a, <vec3>b, <versor>out)

    @staticmethod
    def from_vecs(Quat out, Vec3 a, Vec3 b):
        Quat.c_from_vecs(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_identity(QuatC *out) nogil:
        glm_quat_identity(<versor>out)

    @staticmethod
    def identity(Quat out):
        Quat.c_identity(&out.data)
    
    @staticmethod
    cdef void c_imag(QuatC *q, Vec3C *imag) nogil:
        glm_quat_imag(<versor>q, <vec3>imag)

    @staticmethod
    def imag(Quat q, Vec3 imag):
        Quat.c_imag(&q.data, &imag.data)

    @staticmethod
    cdef float c_imag_mag(QuatC *q) nogil:
        return glm_quat_imaglen(<versor>q)

    @staticmethod
    def imag_mag(Quat q):
        return Quat.c_imag_mag(&q.data)

    @staticmethod
    cdef void c_imag_normalize(QuatC *q, Vec3C *imag) nogil:
        glm_quat_imagn(<versor>q, <vec3>imag)

    @staticmethod
    def imag_normalize(Quat q, Vec3 imag):
        Quat.c_imag_normalize(&q.data, &imag.data)

    @staticmethod
    cdef void c_inv(QuatC *out, QuatC *q) nogil:
        glm_quat_inv(<versor>q, <versor>out)

    @staticmethod
    def inv(Quat out, Quat q):
        Quat.c_inv(&out.data, &q.data)
    
    @staticmethod
    cdef void c_lerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        glm_quat_lerp(<versor>a, <versor>b, t, <versor>out)

    @staticmethod
    def lerp(Quat out, Quat a, Quat b, float t):
        Quat.c_lerp(&out.data, &a.data, &b.data, t)
    
    @staticmethod
    cdef float c_mag(QuatC *q) nogil:
        return glm_quat_norm(<versor>q)

    @staticmethod
    def mag(Quat q):
        return Quat.c_mag(&q.data)
    
    @staticmethod
    cdef void c_mul(QuatC *out, QuatC *a, QuatC *b) nogil:
        glm_quat_mul(<versor>a, <versor>b, <versor>out)

    @staticmethod
    def mul(Quat out, Quat a, Quat b):
        Quat.c_mul(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_nlerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        glm_quat_nlerp(<versor>a, <versor>b, t, <versor>out)

    @staticmethod
    def nlerp(Quat out, Quat a, Quat b, float t):
        Quat.c_nlerp(&out.data, &a.data, &b.data, t)
    
    @staticmethod
    cdef void c_normalize(QuatC *out) nogil:
        glm_quat_normalize(<versor>out)

    @staticmethod
    def normalize(Quat out):
        Quat.c_normalize(&out.data)
    
    @staticmethod
    cdef void c_normalize_to(QuatC *out, QuatC *q) nogil:
        glm_quat_normalize_to(<versor>q, <versor>out)

    @staticmethod
    def normalize_to(Quat out, Quat q):
        Quat.c_normalize_to(&out.data, &q.data)
    
    @staticmethod
    cdef float c_real(QuatC *q) nogil:
        return glm_quat_real(<versor>q)

    @staticmethod
    def real(Quat q):
        return Quat.c_real(&q.data)
    
    @staticmethod
    cdef void c_slerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        glm_quat_slerp(<versor>a, <versor>b, t, <versor>out)
    
    @staticmethod
    def slerp(Quat out, Quat a, Quat b, float t):
        Quat.c_slerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    cdef void c_sub(QuatC *out, QuatC *a, QuatC *b) nogil:
        glm_quat_sub(<versor>a, <versor>b, <versor>out)

    @staticmethod
    def sub(Quat out, Quat a, Quat b):
        Quat.c_sub(&out.data, &a.data, &b.data)