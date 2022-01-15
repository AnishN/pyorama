from pyorama.libs.c cimport *
from pyorama.math.common cimport *

cdef class Box3:

    cdef:
        Box3C data

    @staticmethod
    cdef void transform(Box3C *out, Box3C *b, Mat4C *m) nogil
    @staticmethod
    cdef void merge(Box3C *out, Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef void crop(Box3C *out, Box3C *b, Box3C *crop) nogil
    @staticmethod
    cdef void crop_clamp(Box3C *out, Box3C *b, Box3C *crop, Box3C *clamp) nogil
    @staticmethod
    cdef void invalidate(Box3C *b) nogil
    @staticmethod
    cdef bint is_valid(Box3C *b) nogil
    @staticmethod
    cdef float get_size(Box3C *b) nogil
    @staticmethod
    cdef float get_radius(Box3C *b) nogil
    @staticmethod
    cdef void get_center(Box3C *b, Vec3C *center) nogil
    @staticmethod
    cdef bint intersects(Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef bint intersects_sphere(Box3C *b, SphereC *s) nogil
    @staticmethod
    cdef bint contains_point(Box3C *b, Vec3C *p) nogil
    @staticmethod
    cdef bint contains_box(Box3C *a, Box3C *b) nogil

"""
cdef class Box3:
    cdef:
        Box3C **data
        readonly bint is_owner

    @staticmethod
    cdef Box3 c_from_ptr(Box3C **a)
    cdef void c_set_ptr(self, Box3C **a) nogil
    
    @staticmethod
    cdef void c_center(Vec3C *out, Box3C **a) nogil
    @staticmethod
    cdef void c_copy(Box3C **out, Box3C **a) nogil
    @staticmethod
    cdef void c_diagonal(Vec3C *out, Box3C **a) nogil
    @staticmethod
    cdef float c_diagonal_length(Box3C **a) nogil
    @staticmethod
    cdef void c_difference(Box3C **out, Box3C **a, Box3C **b) nogil
    @staticmethod
    cdef bint c_equals(Box3C **a, Box3C **b) nogil
    @staticmethod
    cdef void c_expand(Box3C **out, Box3C **a, Vec3C *distance) nogil
    @staticmethod
    cdef void c_expand_relative(Box3C **out, Box3C **a, Vec3C *scale) nogil
    @staticmethod
    cdef bint c_has_non_negative_extent(Box3C **a) nogil
    @staticmethod
    cdef bint c_has_positive_extent(Box3C **a) nogil
    @staticmethod
    cdef void c_intersection(Box3C **out, Box3C **a, Box3C **b) nogil
    @staticmethod
    cdef bint c_intersects_plane(Box3C **a, Vec3C *origin, Vec3C *normal) nogil
    @staticmethod
    cdef bint c_intersects_ray(Box3C **a, Vec3C *origin, Vec3C *direction) nogil
    @staticmethod
    cdef bint c_nearly_equals(Box3C **a, Box3C **b, float epsilon=*) nogil
    @staticmethod
    cdef void c_normalize(Box3C **out, Box3C **a) nogil
    @staticmethod
    cdef float c_radius(Box3C **a) nogil
    @staticmethod
    cdef void c_scale(Box3C **out, Box3C **a, Vec3C *scale) nogil
    @staticmethod
    cdef void c_set_data(Box3C **out, Vec3C *min, Vec3C *max) nogil
    @staticmethod
    cdef void c_shape(Vec3C *out, Box3C **a) nogil
    @staticmethod
    cdef float c_squared_diagonal_length(Box3C **a) nogil
    @staticmethod
    cdef float c_squared_radius(Box3C **a) nogil
    @staticmethod
    cdef float c_surface_area(Box3C **a) nogil
    @staticmethod
    cdef void c_transform_mat3(Box3C **out, Box3C **a, Mat3C *m) nogil
    @staticmethod
    cdef void c_transform_mat4(Box3C **out, Box3C **a, Mat4C *m) nogil
    @staticmethod
    cdef void c_transform_quat(Box3C **out, Box3C **a, QuatC *q) nogil
    @staticmethod
    cdef void c_translate(Box3C **out, Box3C **a, Vec3C *b) nogil
    @staticmethod
    cdef void c_union(Box3C **out, Box3C **a, Box3C **b) nogil
    @staticmethod
    cdef float c_volume(Box3C **a) nogil
"""