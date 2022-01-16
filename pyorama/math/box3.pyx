from pyorama.math.mat4 cimport *
from pyorama.math.sphere cimport *
from pyorama.math.vec3 cimport *

cdef class Box3:

    @staticmethod
    cdef bint c_contains_box(Box3C *a, Box3C *b) nogil:
        return glm_aabb_contains(<vec3 *>a, <vec3 *>b)

    @staticmethod
    def contains_box(Box3 a, Box3 b):
        return Box3.c_contains_box(&a.data, &b.data)

    @staticmethod
    cdef bint c_contains_point(Box3C *b, Vec3C *p) nogil:
        return glm_aabb_point(<vec3 *>b, <vec3>p)

    @staticmethod
    def contains_point(Box3 b, Vec3 p):
        return Box3.c_contains_point(&b.data, &p.data)

    @staticmethod
    cdef void c_crop(Box3C *out, Box3C *b, Box3C *crop) nogil:
        glm_aabb_crop(<vec3 *>b, <vec3 *>crop, <vec3 *>out)

    @staticmethod
    def crop(Box3 out, Box3 b, Box3 crop):
        Box3.c_crop(&out.data, &b.data, &crop.data)

    @staticmethod
    cdef void c_crop_clamp(Box3C *out, Box3C *b, Box3C *crop, Box3C *clamp) nogil:
        glm_aabb_crop_until(<vec3 *>b, <vec3 *>crop, <vec3 *>clamp, <vec3 *>out)

    @staticmethod
    def crop_clamp(Box3 out, Box3 b, Box3 crop, Box3 clamp):
        Box3.c_crop_clamp(&out.data, &b.data, &crop.data, &clamp.data)

    @staticmethod
    cdef void c_get_center(Box3C *b, Vec3C *center) nogil:
        glm_aabb_center(<vec3 *>b, <vec3>center)

    @staticmethod
    def get_center(Box3 b, Vec3 center):
        Box3.c_get_center(&b.data, &center.data)

    @staticmethod
    cdef float c_get_radius(Box3C *b) nogil:
        return glm_aabb_radius(<vec3 *>b)

    @staticmethod
    def get_radius(Box3 b):
        return Box3.c_get_radius(&b.data)

    @staticmethod
    cdef float c_get_size(Box3C *b) nogil:
        return glm_aabb_size(<vec3 *>b)

    @staticmethod
    def get_size(Box3 b):
        return Box3.c_get_size(&b.data)

    @staticmethod
    cdef void c_invalidate(Box3C *b) nogil:
        glm_aabb_invalidate(<vec3 *>b)

    @staticmethod
    def invalidate(Box3 b):
        Box3.c_invalidate(&b.data)

    @staticmethod
    cdef bint c_is_valid(Box3C *b) nogil:
        return glm_aabb_isvalid(<vec3 *>b)

    @staticmethod
    def is_valid(Box3 b):
        return Box3.c_is_valid(&b.data)

    @staticmethod
    cdef bint c_intersects_box(Box3C *a, Box3C *b) nogil:
        return glm_aabb_aabb(<vec3 *>a, <vec3 *>b)

    @staticmethod
    def intersects_box(Box3 a, Box3 b):
        return Box3.c_intersects_box(&a.data, &b.data)

    @staticmethod
    cdef bint c_intersects_sphere(Box3C *b, SphereC *s) nogil:
        return glm_aabb_sphere(<vec3 *>b, <vec4>s)

    @staticmethod
    def intersects_sphere(Box3 b, Sphere s):
        return Box3.c_intersects_sphere(&b.data, &s.data)

    @staticmethod
    cdef void c_merge(Box3C *out, Box3C *a, Box3C *b) nogil:
        glm_aabb_merge(<vec3 *>a, <vec3 *>b, <vec3 *>out)

    @staticmethod
    def merge(Box3 out, Box3 a, Box3 b):
        Box3.c_merge(&out.data, &a.data, &b.data)

    @staticmethod
    cdef void c_transform_mat4(Box3C *out, Box3C *b, Mat4C *m) nogil:
        glm_aabb_transform(<vec3 *>b, <mat4>m, <vec3 *>out)

    @staticmethod
    def transform_mat4(Box3 out, Box3 b, Mat4 m):
        Box3.c_transform_mat4(&out.data, &b.data, &m.data)