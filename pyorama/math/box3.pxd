from pyorama.libs.c cimport *
from pyorama.math.common cimport *

cdef class Box3:

    cdef:
        Box3C data

    @staticmethod
    cdef bint c_contains_box(Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef bint c_contains_point(Box3C *b, Vec3C *p) nogil
    @staticmethod
    cdef void c_crop(Box3C *out, Box3C *b, Box3C *crop) nogil
    @staticmethod
    cdef void c_crop_clamp(Box3C *out, Box3C *b, Box3C *crop, Box3C *clamp) nogil
    @staticmethod
    cdef void c_get_center(Box3C *b, Vec3C *center) nogil
    @staticmethod
    cdef float c_get_radius(Box3C *b) nogil
    @staticmethod
    cdef float c_get_size(Box3C *b) nogil
    @staticmethod
    cdef void c_invalidate(Box3C *b) nogil
    @staticmethod
    cdef bint c_is_valid(Box3C *b) nogil
    @staticmethod
    cdef bint c_intersects_box(Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef bint c_intersects_sphere(Box3C *b, SphereC *s) nogil
    @staticmethod
    cdef void c_merge(Box3C *out, Box3C *a, Box3C *b) nogil
    @staticmethod
    cdef void c_transform_mat4(Box3C *out, Box3C *b, Mat4C *m) nogil