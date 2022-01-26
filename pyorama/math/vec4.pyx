from pyorama.math.mat4 cimport *

cdef class Vec4:

    def __init__(self, float x=0, float y=0, float z=0, float w=0):
        self.data.x = x
        self.data.y = y
        self.data.z = z
        self.data.w = w

    property x:
        def __get__(self):
            return self.data.x
        def __set__(self, float value):
            self.data.x = value

    property y:
        def __get__(self):
            return self.data.y
        def __set__(self, float value):
            self.data.y = value
    
    property z:
        def __get__(self):
            return self.data.z
        def __set__(self, float value):
            self.data.z = value

    property w:
        def __get__(self):
            return self.data.w
        def __set__(self, float value):
            self.data.w = value

    @staticmethod
    cdef Vec4 c_from_data(Vec4C *v):
        cdef Vec4 out = Vec4.__new__(Vec4)
        out.data = v[0]
        return out

    @staticmethod
    def set_data(Vec4 out, float x, float y, float z, float w):
        out.data.x = x
        out.data.y = y
        out.data.z = z
        out.data.w = w

    @staticmethod
    cdef void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_add(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def add(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_add_scalar(Vec4C *out, Vec4C *v, float scalar) nogil:
        glm_vec4_adds(<vec4>v, scalar, <vec4>out)

    @staticmethod
    def add_scalar(Vec4 out, Vec4 v, float scalar):
        Vec4.c_add_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_clamp(Vec4C *out, float min_, float max_) nogil:
        glm_vec4_clamp(<vec4>out, min_, max_)

    @staticmethod
    def clamp(Vec4 out, float min_, float max_):
        Vec4.c_clamp(&out.data, min_, max_)
    
    @staticmethod
    cdef void c_copy(Vec4C *out, Vec4C *v) nogil:
        glm_vec4_copy(<vec4>v, <vec4>out)

    @staticmethod
    def copy(Vec4 out, Vec4 v):
        Vec4.c_copy(&out.data, &v.data)
    
    @staticmethod
    cdef float c_dist(Vec4C *a, Vec4C *b) nogil:
        return glm_vec4_distance(<vec4>a, <vec4>b)
    
    @staticmethod
    def dist(Vec4 a, Vec4 b):
        return Vec4.c_dist(&a.data, &b.data)
    
    @staticmethod
    cdef void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_div(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def div(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_div_scalar(Vec4C *out, Vec4C *v, float scalar) nogil:
        glm_vec4_divs(<vec4>v, scalar, <vec4>out)

    @staticmethod
    def div_scalar(Vec4 out, Vec4 v, float scalar):
        Vec4.c_div_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef float c_dot(Vec4C *a, Vec4C *b) nogil:
        return glm_vec4_dot(<vec4>a, <vec4>b)

    @staticmethod
    def dot(Vec4 a, Vec4 b):
        return Vec4.c_dot(&a.data, &b.data)
    
    @staticmethod
    cdef bint c_equal(Vec4C *a, Vec4C *b) nogil:
        return glm_vec4_eqv(<vec4>a, <vec4>b)

    @staticmethod
    def equal(Vec4 a, Vec4 b):
        return Vec4.c_equal(&a.data, &b.data)

    @staticmethod
    cdef bint c_equal_comps(Vec4C *v) nogil:
        return glm_vec4_eq_all(<vec4>v)

    @staticmethod
    def equal_comps(Vec4 v):
        return Vec4.c_equal_comps(&v.data)
    
    @staticmethod
    cdef bint c_equal_value(Vec4C *v, float value) nogil:
        return glm_vec4_eq(<vec4>v, value)

    @staticmethod
    def equal_value(Vec4 v, float value):
        return Vec4.c_equal_value(&v.data, value)
    
    @staticmethod
    cdef void c_fill(Vec4C *out, float value) nogil:
        glm_vec4_fill(<vec4>out, value)
    
    @staticmethod
    def fill(Vec4 out, float value):
        Vec4.c_fill(&out.data, value)

    @staticmethod
    cdef void c_inv(Vec4C *out) nogil:
        glm_vec4_inv(<vec4>out)

    @staticmethod
    def inv(Vec4 out):
        Vec4.c_inv(&out.data)

    @staticmethod
    cdef void c_inv_to(Vec4C *out, Vec4C *v) nogil:
        glm_vec4_inv_to(<vec4>v, <vec4>out)
    
    @staticmethod
    def inv_to(Vec4 out, Vec4 v):
        Vec4.c_inv_to(&out.data, &v.data)

    @staticmethod
    cdef void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil:
        glm_vec4_lerp(<vec4>a, <vec4>b, t, <vec4>out)
    
    @staticmethod
    def lerp(Vec4 out, Vec4 a, Vec4 b, float t):
        Vec4.c_lerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    cdef float c_mag(Vec4C *v) nogil:
        return glm_vec4_norm(<vec4>v)
    
    @staticmethod
    def mag(Vec4 v):
        return Vec4.c_mag(&v.data)

    @staticmethod
    cdef void c_max_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_maxadd(<vec4>a, <vec4>b, <vec4>out)
    
    @staticmethod
    def max_add(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_max_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef float c_max_comp(Vec4C *v) nogil:
        return glm_vec4_max(<vec4>v)

    @staticmethod
    def max_comp(Vec4 v):
        return Vec4.c_max_comp(&v.data)

    @staticmethod
    cdef void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_maxv(<vec4>a, <vec4>b, <vec4>out)
    
    @staticmethod
    def max_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_max_comps(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_min_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_minadd(<vec4>a, <vec4>b, <vec4>out)
    
    @staticmethod
    def min_add(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_min_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef float c_min_comp(Vec4C *v) nogil:
        return glm_vec4_min(<vec4>v)

    @staticmethod
    def min_comp(Vec4 v):
        return Vec4.c_min_comp(&v.data)

    @staticmethod
    cdef void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_minv(<vec4>a, <vec4>b, <vec4>out)
    
    @staticmethod
    def min_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_min_comps(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_mul(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def mul(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul_scalar(Vec4C *out, Vec4C *v, float scalar) nogil:
        glm_vec4_scale(<vec4>v, scalar, <vec4>out)
    
    @staticmethod
    def mul_scalar(Vec4 out, Vec4 v, float scalar):
        Vec4.c_mul_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_mul_unit_scalar(Vec4C *out, Vec4C *v, float scalar) nogil:
        glm_vec4_scale_as(<vec4>v, scalar, <vec4>out)
    
    @staticmethod
    def mul_unit_scalar(Vec4 out, Vec4 v, scalar):
        Vec4.c_mul_unit_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef bint c_nearly_equal(Vec4C *a, Vec4C *b) nogil:
        return glm_vec4_eqv_eps(<vec4>a, <vec4>b)

    @staticmethod
    def nearly_equal(Vec4 a, Vec4 b):
        return Vec4.c_nearly_equal(&a.data, &b.data)

    @staticmethod
    cdef bint c_nearly_equal_value(Vec4C *v, float value) nogil:
        return glm_vec4_eq_eps(<vec4>v, value)
    
    @staticmethod
    def nearly_equal_value(Vec4 v, float value):
        return Vec4.c_nearly_equal_value(&v.data, value)

    @staticmethod
    cdef void c_negate(Vec4C *out) nogil:
        glm_vec4_negate(<vec4>out)

    @staticmethod
    def negate(Vec4 out):
        Vec4.c_negate(&out.data)

    @staticmethod
    cdef void c_norm(Vec4C *out) nogil:
        glm_vec4_normalize(<vec4>out)

    @staticmethod
    def norm(Vec4 out):
        Vec4.c_norm(&out.data)

    @staticmethod
    cdef void c_norm_to(Vec4C *out, Vec4C *v) nogil:
        glm_vec4_normalize_to(<vec4>v, <vec4>out)

    @staticmethod
    def norm_to(Vec4 out, Vec4 v):
        Vec4.c_norm_to(&out.data, &v.data)

    @staticmethod
    cdef void c_one(Vec4C *out) nogil:
        glm_vec4_one(<vec4>out)
    
    @staticmethod
    def one(Vec4 out):
        Vec4.c_one(&out.data)

    @staticmethod
    cdef void c_random(Vec4C *out) nogil:
        out.x = random_get_float()
        out.y = random_get_float()
        out.z = random_get_float()
        out.w = random_get_float()

    @staticmethod
    def random(Vec4 out):
        Vec4.c_random(&out.data)

    @staticmethod
    cdef void c_sign(Vec4C *out, Vec4C *v) nogil:
        glm_vec4_sign(<vec4>v, <vec4>out)
    
    @staticmethod
    def sign(Vec4 out, Vec4 v):
        Vec4.c_sign(&out.data, &v.data)

    @staticmethod
    cdef float c_sqr_dist(Vec4C *a, Vec4C *b) nogil:
        return glm_vec4_distance2(<vec4>a, <vec4>b)

    @staticmethod
    def sqr_dist(Vec4 a, Vec4 b):
        Vec4.c_sqr_dist(&a.data, &b.data)

    @staticmethod
    cdef float c_sqr_mag(Vec4C *v) nogil:
        return glm_vec4_norm2(<vec4>v)
    
    @staticmethod
    def sqr_mag(Vec4 v):
        return Vec4.c_sqr_mag(&v.data)

    @staticmethod
    cdef void c_sqrt(Vec4C *out, Vec4C *v) nogil:
        glm_vec4_sqrt(<vec4>v, <vec4>out)
    
    @staticmethod
    def sqrt(Vec4 out, Vec4 v):
        Vec4.c_sqrt(&out.data, &v.data)

    @staticmethod
    cdef void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_sub(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def sub(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sub_scalar(Vec4C *out, Vec4C *v, float scalar) nogil:
        glm_vec4_subs(<vec4>v, scalar, <vec4>out)

    @staticmethod
    def sub_scalar(Vec4 out, Vec4 v, float scalar):
        Vec4.c_sub_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_sum_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_addadd(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def sum_add(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sum_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sum_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_muladd(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def sum_mul(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sum_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sum_mul_scalar(Vec4C *out, Vec4C *v, float scalar) nogil:
        glm_vec4_muladds(<vec4>v, scalar, <vec4>out)

    @staticmethod
    def sum_mul_scalar(Vec4 out, Vec4 v, float scalar):
        Vec4.c_sum_mul_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_sum_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        glm_vec4_subadd(<vec4>a, <vec4>b, <vec4>out)

    @staticmethod
    def sum_sub(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sum_sub(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_transform_mat4(Vec4C *out, Mat4C *m, Vec4C *v) nogil:
        glm_mat4_mulv(<mat4>m, <vec4>v, <vec4>out)

    @staticmethod
    def transform_mat4(Vec4 out, Mat4 m, Vec4 v):
        Vec4.c_transform_mat4(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_zero(Vec4C *out) nogil:
        glm_vec4_zero(<vec4>out)

    @staticmethod
    def zero(Vec4 out):
        Vec4.c_zero(&out.data)