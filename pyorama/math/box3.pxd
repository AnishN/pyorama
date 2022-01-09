from pyorama.libs.c cimport *
from pyorama.math.common cimport *
from pyorama.math.vec3 cimport *

"""
#cglm_box_h
    void glm_aabb_transform(vec3 box[2], mat4 m, vec3 dest[2])
    void glm_aabb_merge(vec3 box1[2], vec3 box2[2], vec3 dest[2])
    void glm_aabb_crop(vec3 box[2], vec3 cropBox[2], vec3 dest[2])
    void glm_aabb_crop_until(vec3 box[2], vec3 cropBox[2], vec3 clampBox[2], vec3 dest[2])
    bint glm_aabb_frustum(vec3 box[2], vec4 planes[6])
    void glm_aabb_invalidate(vec3 box[2])
    bint glm_aabb_isvalid(vec3 box[2])
    float glm_aabb_size(vec3 box[2])
    float glm_aabb_radius(vec3 box[2])
    void glm_aabb_center(vec3 box[2], vec3 dest)
    bint glm_aabb_aabb(vec3 box[2], vec3 other[2])
    bint glm_aabb_sphere(vec3 box[2], vec4 s)
    bint glm_aabb_point(vec3 box[2], vec3 point)
    bint glm_aabb_contains(vec3 box[2], vec3 other[2])
"""

"""
cdef class Box3:
    cdef:
        Box3C *data
        readonly bint is_owner

    @staticmethod
    cdef Box3 c_from_ptr(Box3C *a)
    cdef void c_set_ptr(self, Box3C *a) nogil
    
    @staticmethod
    cdef void c_center(Vec3C *out, Box3C *a) nogil
    @staticmethod
    cdef void c_copy(Box3C *out, Box3C *a) nogil
    @staticmethod
    cdef void c_diagonal(Vec3C *out, Box3C *a) nogil
    @staticmethod
    cdef float c_diagonal_length(Box3C *a) nogil
    @staticmethod
    cdef void c_difference(Box3C *out, Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef bint c_equals(Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef void c_expand(Box3C *out, Box3C *a, Vec3C *distance) nogil
    @staticmethod
    cdef void c_expand_relative(Box3C *out, Box3C *a, Vec3C *scale) nogil
    @staticmethod
    cdef bint c_has_non_negative_extent(Box3C *a) nogil
    @staticmethod
    cdef bint c_has_positive_extent(Box3C *a) nogil
    @staticmethod
    cdef void c_intersection(Box3C *out, Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef bint c_intersects_plane(Box3C *a, Vec3C *origin, Vec3C *normal) nogil
    @staticmethod
    cdef bint c_intersects_ray(Box3C *a, Vec3C *origin, Vec3C *direction) nogil
    @staticmethod
    cdef bint c_nearly_equals(Box3C *a, Box3C *b, float epsilon=*) nogil
    @staticmethod
    cdef void c_normalize(Box3C *out, Box3C *a) nogil
    @staticmethod
    cdef float c_radius(Box3C *a) nogil
    @staticmethod
    cdef void c_scale(Box3C *out, Box3C *a, Vec3C *scale) nogil
    @staticmethod
    cdef void c_set_data(Box3C *out, Vec3C *min, Vec3C *max) nogil
    @staticmethod
    cdef void c_shape(Vec3C *out, Box3C *a) nogil
    @staticmethod
    cdef float c_squared_diagonal_length(Box3C *a) nogil
    @staticmethod
    cdef float c_squared_radius(Box3C *a) nogil
    @staticmethod
    cdef float c_surface_area(Box3C *a) nogil
    @staticmethod
    cdef void c_transform_mat3(Box3C *out, Box3C *a, Mat3C *m) nogil
    @staticmethod
    cdef void c_transform_mat4(Box3C *out, Box3C *a, Mat4C *m) nogil
    @staticmethod
    cdef void c_transform_quat(Box3C *out, Box3C *a, QuatC *q) nogil
    @staticmethod
    cdef void c_translate(Box3C *out, Box3C *a, Vec3C *b) nogil
    @staticmethod
    cdef void c_union(Box3C *out, Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef float c_volume(Box3C *a) nogil
"""