from pyorama.math.mat2 cimport *

cdef class Vec2:

    def __init__(self, float x=0, float y=0):
        self.data.x = x
        self.data.y = y

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

    @staticmethod
    cdef Vec2 c_from_data(Vec2C *v):
        cdef Vec2 out = Vec2.__new__(Vec2)
        out.data = v[0]
        return out

    @staticmethod
    def set_data(Vec2 out, float x, float y):
        out.data.x = x
        out.data.y = y

    @staticmethod
    cdef void c_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_add(<vec2>a, <vec2>b, <vec2>out)
    
    @staticmethod
    def add(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_add_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_adds(<vec2>v, scalar, <vec2>out)

    @staticmethod
    def add_scalar(Vec2 out, Vec2 v, float scalar):
        Vec2.c_add_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef void c_clamp(Vec2C *out, float min_, float max_) nogil:
        glm_vec2_clamp(<vec2>out, min_, max_)
    
    @staticmethod
    def clamp(Vec2 out, float min_, float max_):
        Vec2.c_clamp(&out.data, min_, max_)

    @staticmethod
    cdef void c_copy(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_copy(<vec2>v, <vec2>out)
    
    @staticmethod
    def copy(Vec2 out, Vec2 v):
        Vec2.c_copy(&out.data, &v.data)
    
    @staticmethod
    cdef float c_cross(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_cross(<vec2>a, <vec2>b)

    @staticmethod
    def cross(Vec2 a, Vec2 b):
        return Vec2.c_cross(&a.data, &b.data)
    
    @staticmethod
    cdef float c_dist(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_distance(<vec2>a, <vec2>b)
    
    @staticmethod
    def dist(Vec2 a, Vec2 b):
        return Vec2.c_dist(&a.data, &b.data)

    @staticmethod
    cdef void c_div(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_div(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def div(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_div_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_divs(<vec2>v, scalar, <vec2>out)

    @staticmethod
    def div_scalar(Vec2 out, Vec2 v, float scalar):
        Vec2.c_div_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef float c_dot(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_dot(<vec2>a, <vec2>b)

    @staticmethod
    def dot(Vec2 a, Vec2 b):
        return Vec2.c_dot(&a.data, &b.data)
    
    @staticmethod
    cdef bint c_equal(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_eqv(<vec2>a, <vec2>b)

    @staticmethod
    def equal(Vec2 a, Vec2 b):
        return Vec2.c_equal(&a.data, &b.data)

    @staticmethod
    cdef bint c_equal_comps(Vec2C *v) nogil:
        return glm_vec2_eq_all(<vec2>v)

    @staticmethod
    def equal_comps(Vec2 v):
        return Vec2.c_equal_comps(&v.data)

    @staticmethod
    cdef bint c_equal_value(Vec2C *v, float value) nogil:
        return glm_vec2_eq(<vec2>v, value)

    @staticmethod
    def equal_value(Vec2 v, float value):
        return Vec2.c_equal_value(&v.data, value)
    
    @staticmethod
    cdef void c_fill(Vec2C *out, float value) nogil:
        glm_vec2_fill(<vec2>out, value)
    
    @staticmethod
    def fill(Vec2 out, float value):
        Vec2.c_fill(&out.data, value)

    @staticmethod
    cdef void c_lerp(Vec2C *out, Vec2C *a, Vec2C *b, float t) nogil:
        glm_vec2_lerp(<vec2>a, <vec2>b, t, <vec2>out)
    
    @staticmethod
    def lerp(Vec2 out, Vec2 a, Vec2 b, float t):
        Vec2.c_lerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    cdef float c_mag(Vec2C *v) nogil:
        return glm_vec2_norm(<vec2>v)

    @staticmethod
    def mag(Vec2 v):
        return Vec2.c_mag(&v.data)
    
    @staticmethod
    cdef void c_max_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_maxadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def max_add(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_max_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef float c_max_comp(Vec2C *v) nogil:
        return glm_vec2_max(<vec2>v)

    @staticmethod
    def max_comp(Vec2 v):
        return Vec2.c_max_comp(&v.data)

    @staticmethod
    cdef void c_max_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_maxv(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def max_comps(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_max_comps(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_min_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_minadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def min_add(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_min_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef float c_min_comp(Vec2C *v) nogil:
        return glm_vec2_min(<vec2>v)

    @staticmethod
    def min_comp(Vec2 v):
        Vec2.c_min_comp(&v.data)

    @staticmethod
    cdef void c_min_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_minv(<vec2>a, <vec2>b, <vec2>out)
    
    @staticmethod
    def min_comps(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_min_comps(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_mul(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def mul(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_scale(<vec2>v, scalar, <vec2>out)

    @staticmethod
    def mul_scalar(Vec2 out, Vec2 v, float scalar):
        Vec2.c_mul_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_mul_unit_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_scale_as(<vec2>v, scalar, <vec2>out)

    @staticmethod
    def mul_unit_scalar(Vec2 out, Vec2 v, float scalar):
        Vec2.c_mul_unit_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef bint c_nearly_equal(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_eqv_eps(<vec2>a, <vec2>b)

    @staticmethod
    def nearly_equal(Vec2 a, Vec2 b):
        return Vec2.c_nearly_equal(&a.data, &b.data)

    @staticmethod
    cdef bint c_nearly_equal_value(Vec2C *v, float value) nogil:
        return glm_vec2_eq_eps(<vec2>v, value)

    @staticmethod
    def nearly_equal_value(Vec2 v, float value):
        return Vec2.c_nearly_equal_value(&v.data, value)

    @staticmethod
    cdef void c_negate(Vec2C *out) nogil:
        glm_vec2_negate(<vec2>out)

    @staticmethod
    def negate(Vec2 out):
        Vec2.c_negate(&out.data)

    @staticmethod
    cdef void c_negate_to(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_negate_to(<vec2>v, <vec2>out)

    @staticmethod
    def negate_to(Vec2 out, Vec2 v):
        Vec2.c_negate_to(&out.data, &v.data)
    
    @staticmethod
    cdef void c_norm(Vec2C *out) nogil:
        glm_vec2_normalize(<vec2>out)

    @staticmethod
    def norm(Vec2 out):
        Vec2.c_norm(&out.data)

    @staticmethod
    cdef void c_norm_to(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_normalize_to(<vec2>v, <vec2>out)

    @staticmethod
    def norm_to(Vec2 out, Vec2 v):
        Vec2.c_norm_to(&out.data, &v.data)
    
    @staticmethod
    cdef void c_one(Vec2C *out) nogil:
        glm_vec2_one(<vec2>out)

    @staticmethod
    def one(Vec2 out):
        Vec2.c_one(&out.data)
    
    @staticmethod
    cdef void c_random(Vec2C *out) nogil:
        out.x = c_random_get_f32()
        out.y = c_random_get_f32()

    @staticmethod
    def random(Vec2 out):
        Vec2.c_random(&out.data)

    @staticmethod
    cdef void c_rotate(Vec2C *out, Vec2C *v, float angle) nogil:
        glm_vec2_rotate(<vec2>v, angle, <vec2>out)

    @staticmethod
    def rotate(Vec2 out, Vec2 v, float angle):
        Vec2.c_rotate(&out.data, &v.data, angle)
    
    @staticmethod
    cdef void c_sign(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_sign(<vec2>v, <vec2>out)
    
    @staticmethod
    def sign(Vec2 out, Vec2 v):
        Vec2.c_sign(&out.data, &v.data)

    @staticmethod
    cdef float c_sqr_dist(Vec2C *a, Vec2C *b) nogil:
        return glm_vec2_distance2(<vec2>a, <vec2>b)

    @staticmethod
    def sqr_dist(Vec2 a, Vec2 b):
        return Vec2.c_sqr_dist(&a.data, &b.data)

    @staticmethod
    cdef float c_sqr_mag(Vec2C *v) nogil:
        return glm_vec2_norm2(<vec2>v)

    @staticmethod
    def sqr_mag(Vec2 v):
        Vec2.c_sqr_mag(&v.data)

    @staticmethod
    cdef void c_sqrt(Vec2C *out, Vec2C *v) nogil:
        glm_vec2_sqrt(<vec2>v, <vec2>out)

    @staticmethod
    def sqrt(Vec2 out, Vec2 v):
        Vec2.c_sqrt(&out.data, &v.data)
    
    @staticmethod
    cdef void c_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_sub(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    cdef void c_sub_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_subs(<vec2>v, scalar, <vec2>out)

    @staticmethod
    def sub_scalar(Vec2 out, Vec2 v, float scalar):
        Vec2.c_sub_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_sum_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_addadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def sum_add(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_sum_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sum_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_muladd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def sum_mul(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_sum_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sum_mul_scalar(Vec2C *out, Vec2C *v, float scalar) nogil:
        glm_vec2_muladds(<vec2>v, scalar, <vec2>out)

    @staticmethod
    def sum_mul_scalar(Vec2 out, Vec2 v, float scalar):
        Vec2.c_sum_mul_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_sum_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        glm_vec2_subadd(<vec2>a, <vec2>b, <vec2>out)

    @staticmethod
    def sum_sub(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_sum_sub(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_transform_mat2(Vec2C *out, Mat2C *m, Vec2C *v) nogil:
        glm_mat2_mulv(<mat2>m, <vec2>v, <vec2>out)

    @staticmethod
    def transform_mat2(Vec2 out, Mat2 m, Vec2 v):
        Vec2.c_transform_mat2(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_zero(Vec2C *out) nogil:
        glm_vec2_zero(<vec2>out)

    @staticmethod
    def zero(Vec2 out):
        Vec2.c_zero(&out.data)