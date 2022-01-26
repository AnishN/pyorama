from pyorama.math.mat3 cimport *
from pyorama.math.mat4 cimport *
from pyorama.math.quat cimport *
from pyorama.math.vec4 cimport *

cdef class Vec3:

    def __init__(self, float x=0, float y=0, float z=0):
        self.data.x = x
        self.data.y = y
        self.data.z = z

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

    @staticmethod
    cdef Vec3 c_from_data(Vec3C *v):
        cdef Vec3 out = Vec3.__new__(Vec3)
        out.data = v[0]
        return out

    @staticmethod
    def set_data(Vec3 out, float x, float y, float z):
        out.data.x = x
        out.data.y = y
        out.data.z = z

    @staticmethod
    cdef void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_add(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def add(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_add_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_adds(<vec3>v, scalar, <vec3>out)

    @staticmethod
    def add_scalar(Vec3 out, Vec3 v, float scalar):
        Vec3.c_add_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef float c_angle(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_angle(<vec3>a, <vec3>b)

    @staticmethod
    def angle(Vec3 a, Vec3 b):
        return Vec3.c_angle(&a.data, &b.data)
    
    @staticmethod
    cdef void c_center(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_center(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def center(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_center(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_clamp(Vec3C *out, float min_, float max_) nogil:
        glm_vec3_clamp(<vec3>out, min_, max_)

    @staticmethod
    def clamp(Vec3 out, float min_, float max_):
        Vec3.c_clamp(&out.data, min_, max_)
    
    @staticmethod
    cdef void c_copy(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_copy(<vec3>v, <vec3>out)

    @staticmethod
    def copy(Vec3 out, Vec3 v):
        Vec3.c_copy(&out.data, &v.data)
    
    @staticmethod
    cdef void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_cross(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def cross(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_cross(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_cross_norm(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_crossn(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def cross_norm(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_cross_norm(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef float c_dist(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_distance(<vec3>a, <vec3>b)

    @staticmethod
    def dist(Vec3 a, Vec3 b):
        return Vec3.c_dist(&a.data, &b.data)

    @staticmethod
    cdef void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_div(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def div(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_div_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_divs(<vec3>v, scalar, <vec3>out)

    @staticmethod
    def div_scalar(Vec3 out, Vec3 v, float scalar):
        Vec3.c_div_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef float c_dot(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_dot(<vec3>a, <vec3>b)

    @staticmethod
    def dot(Vec3 a, Vec3 b):
        return Vec3.c_dot(&a.data, &b.data)
    
    @staticmethod
    cdef bint c_equal(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_eqv(<vec3>a, <vec3>b)
    
    @staticmethod
    def equal(Vec3 a, Vec3 b):
        return Vec3.c_equal(&a.data, &b.data)

    @staticmethod
    cdef bint c_equal_comps(Vec3C *v) nogil:
        return glm_vec3_eq_all(<vec3>v)

    @staticmethod
    def equal_comps(Vec3 v):
        return Vec3.c_equal_comps(&v.data)

    @staticmethod
    cdef bint c_equal_value(Vec3C *v, float value) nogil:
        return glm_vec3_eq(<vec3>v, value)

    @staticmethod
    def equal_value(Vec3 v, float value):
        return Vec3.c_equal_value(&v.data, value)
    
    @staticmethod
    cdef void c_fill(Vec3C *out, float value) nogil:
        glm_vec3_fill(<vec3>out, value)
    
    @staticmethod
    def fill(Vec3 out, float value):
        Vec3.c_fill(&out.data, value)

    @staticmethod
    cdef void c_flip_sign(Vec3C *out) nogil:
        glm_vec3_flipsign(<vec3>out)

    @staticmethod
    def flip_sign(Vec3 out):
        Vec3.c_flip_sign(&out.data)
    
    @staticmethod
    cdef void c_flip_sign_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_flipsign_to(<vec3>v, <vec3>out)

    @staticmethod
    def flip_sign_to(Vec3 out, Vec3 v):
        Vec3.c_flip_sign_to(&out.data, &v.data)
    
    @staticmethod
    cdef void c_from_vec4(Vec3C *out, Vec4C *v) nogil:
        glm_vec4_copy3(<vec4>v, <vec3>out)

    @staticmethod
    def from_vec4(Vec3 out, Vec4 v):
        Vec3.c_from_vec4(&out.data, &v.data)
    
    @staticmethod
    cdef void c_inv(Vec3C *out) nogil:
        glm_vec3_inv(<vec3>out)

    @staticmethod
    def inv(Vec3 out):
        Vec3.c_inv(&out.data)

    @staticmethod
    cdef void c_inv_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_inv_to(<vec3>v, <vec3>out)

    @staticmethod
    def inv_to(Vec3 out, Vec3 v):
        Vec3.c_inv_to(&out.data, &v.data)
    
    @staticmethod
    cdef void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil:
        glm_vec3_lerp(<vec3>a, <vec3>b, t, <vec3>out)

    @staticmethod
    def lerp(Vec3 out, Vec3 a, Vec3 b, float t):
        Vec3.c_lerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    cdef float c_luminance(Vec3C *rgb) nogil:
        return glm_luminance(<vec3>rgb)

    @staticmethod
    def luminance(Vec3 rgb):
        return Vec3.c_luminance(&rgb.data)

    @staticmethod
    cdef float c_mag(Vec3C *v) nogil:
        return glm_vec3_norm(<vec3>v)

    @staticmethod
    def mag(Vec3 v):
        return Vec3.c_mag(&v.data)
    
    @staticmethod
    cdef void c_max_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_maxadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def max_add(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_max_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef float c_max_comp(Vec3C *v) nogil:
        return glm_vec3_max(<vec3>v)
    
    @staticmethod
    def max_comp(Vec3 v):
        return Vec3.c_max_comp(&v.data)
    
    @staticmethod
    cdef void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_maxv(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def max_comps(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_max_comps(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_min_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_minadd(<vec3>a, <vec3>b, <vec3>out)
    
    @staticmethod
    def min_add(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_min_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef float c_min_comp(Vec3C *v) nogil:
        return glm_vec3_min(<vec3>v)

    @staticmethod
    def min_comp(Vec3 v):
        return Vec3.c_min_comp(&v.data)

    @staticmethod
    cdef void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_minv(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def min_comps(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_min_comps(&out.data, &a.data, &b.data)
    
    @staticmethod
    cdef void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_mul(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def mul(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_mul_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_scale(<vec3>v, scalar, <vec3>out)
    
    @staticmethod
    def mul_scalar(Vec3 out, Vec3 v, float scalar):
        Vec3.c_mul_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_mul_unit_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_scale_as(<vec3>v, scalar, <vec3>out)

    @staticmethod
    def mul_unit_scalar(Vec3 out, Vec3 v, scalar):
        Vec3.c_mul_unit_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef bint c_nearly_equal(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_eqv_eps(<vec3>a, <vec3>b)

    @staticmethod
    def nearly_equal(Vec3 a, Vec3 b):
        return Vec3.c_nearly_equal(&a.data, &b.data)
    
    @staticmethod
    cdef bint c_nearly_equal_value(Vec3C *v, float value) nogil:
        return glm_vec3_eq_eps(<vec3>v, value)

    @staticmethod
    def nearly_equal_value(Vec3 v, float value):
        return Vec3.c_nearly_equal_value(&v.data, value)
    
    @staticmethod
    cdef void c_negate(Vec3C *out) nogil:
        glm_vec3_negate(<vec3>out)

    @staticmethod
    def negate(Vec3 out):
        Vec3.c_negate(&out.data)

    @staticmethod
    cdef void c_negate_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_negate_to(<vec3>v, <vec3>out)

    @staticmethod
    def negate_to(Vec3 out, Vec3 v):
        Vec3.c_negate_to(&out.data, &v.data)
    
    @staticmethod
    cdef void c_norm(Vec3C *out) nogil:
        glm_vec3_normalize(<vec3>out)
    
    @staticmethod
    def norm(Vec3 out):
        Vec3.c_norm(&out.data)

    @staticmethod
    cdef void c_norm_to(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_normalize_to(<vec3>v, <vec3>out)

    @staticmethod
    def norm_to(Vec3 out, Vec3 v):
        Vec3.c_norm_to(&out.data, &v.data)
    
    @staticmethod
    cdef void c_one(Vec3C *out) nogil:
        glm_vec3_one(<vec3>out)

    @staticmethod
    def one(Vec3 out):
        Vec3.c_one(&out.data)
    
    @staticmethod
    cdef void c_orthogonal(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_ortho(<vec3>v, <vec3>out)

    @staticmethod
    def orthogonal(Vec3 out, Vec3 v):
        Vec3.c_orthogonal(&out.data, &v.data)
    
    @staticmethod
    cdef void c_project(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_proj(<vec3>a, <vec3>b, <vec3>out)
    
    @staticmethod
    def project(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_project(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_random(Vec3C *out) nogil:
        out.x = random_get_float()
        out.y = random_get_float()
        out.z = random_get_float()

    @staticmethod
    def random(Vec3 out):
        Vec3.c_random(&out.data)

    @staticmethod
    cdef void c_rotate_angle_axis(Vec3C *out, float angle, Vec3C *axis) nogil:
        glm_vec3_rotate(<vec3>out, angle, <vec3>axis)

    @staticmethod
    def rotate_angle_axis(Vec3 out, float angle, Vec3 axis):
        Vec3.c_rotate_angle_axis(&out.data, angle, &axis.data)
    
    @staticmethod
    cdef void c_rotate_mat3(Vec3C *out, Mat3C *m, Vec3C *v) nogil:
        glm_vec3_rotate_m3(<mat3>m, <vec3>v, <vec3>out)

    @staticmethod
    def rotate_mat3(Vec3 out, Mat3 m, Vec3 v):
        Vec3.c_rotate_mat3(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_rotate_mat4(Vec3C *out, Mat4C *m, Vec3C *v) nogil:
        glm_vec3_rotate_m4(<mat4>m, <vec3>v, <vec3>out)

    @staticmethod
    def rotate_mat4(Vec3 out, Mat4 m, Vec3 v):
        Vec3.c_rotate_mat4(&out.data, &m.data, &v.data)
    
    @staticmethod
    cdef void c_sign(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_sign(<vec3>v, <vec3>out)

    @staticmethod
    def sign(Vec3 out, Vec3 v):
        Vec3.c_sign(&out.data, &v.data)
    
    @staticmethod
    cdef float c_sqr_dist(Vec3C *a, Vec3C *b) nogil:
        return glm_vec3_distance2(<vec3>a, <vec3>b)

    @staticmethod
    def sqr_dist(Vec3 a, Vec3 b):
        Vec3.c_sqr_dist(&a.data, &b.data)

    @staticmethod
    cdef float c_sqr_mag(Vec3C *v) nogil:
        return glm_vec3_norm2(<vec3>v)

    @staticmethod
    def sqr_mag(Vec3 v):
        return Vec3.c_sqr_mag(&v.data)

    @staticmethod
    cdef void c_sqrt(Vec3C *out, Vec3C *v) nogil:
        glm_vec3_sqrt(<vec3>v, <vec3>out)

    @staticmethod
    def sqrt(Vec3 out, Vec3 v):
        Vec3.c_sqrt(&out.data, &v.data)

    @staticmethod
    cdef void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_sub(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def sub(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sub_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_subs(<vec3>v, scalar, <vec3>out)

    @staticmethod
    def sub_scalar(Vec3 out, Vec3 v, float scalar):
        Vec3.c_sub_scalar(&out.data, &v.data, scalar)
    
    @staticmethod
    cdef void c_sum_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_addadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def sum_add(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_sum_add(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sum_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_muladd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def sum_mul(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_sum_mul(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_sum_mul_scalar(Vec3C *out, Vec3C *v, float scalar) nogil:
        glm_vec3_muladds(<vec3>v, scalar, <vec3>out)

    @staticmethod
    def sum_mul_scalar(Vec3 out, Vec3 v, float scalar):
        Vec3.c_sum_mul_scalar(&out.data, &v.data, scalar)

    @staticmethod
    cdef void c_sum_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        glm_vec3_subadd(<vec3>a, <vec3>b, <vec3>out)

    @staticmethod
    def sum_sub(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_sum_sub(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_transform_mat3(Vec3C *out, Mat3C *m, Vec3C *v) nogil:
        glm_mat3_mulv(<mat3>m, <vec3>v, <vec3>out)

    @staticmethod
    def transform_mat3(Vec3 out, Mat3 m, Vec3 v):
        Vec3.c_transform_mat3(&out.data, &m.data, &v.data)

    @staticmethod
    cdef void c_transform_mat4(Vec3C *out, Mat4C *m, Vec3C *v, float w=1.0) nogil:
        glm_mat4_mulv3(<mat4>m, <vec3>v, w, <vec3>out)

    @staticmethod
    def transform_mat4(Vec3 out, Mat4 m, Vec3 v, float w=1.0):
        Vec3.c_transform_mat4(&out.data, &m.data, &v.data, w)

    @staticmethod
    cdef void c_transform_quat(Vec3C *out, QuatC *q, Vec3C *v) nogil:
        glm_quat_rotatev(<versor>q, <vec3>v, <vec3>out)

    @staticmethod
    def transform_quat(Vec3 out, Quat q, Vec3 v):
        Vec3.c_transform_quat(&out.data, &q.data, &v.data)

    @staticmethod
    cdef void c_zero(Vec3C *out) nogil:
        glm_vec3_zero(<vec3>out)

    @staticmethod
    def zero(Vec3 out):
        Vec3.c_zero(&out.data)