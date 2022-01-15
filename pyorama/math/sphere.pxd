from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

cdef class Sphere:

    cdef:
        SphereC data

    @staticmethod
    cdef float c_get_radius(SphereC *s) nogil
    @staticmethod
    cdef void c_transform(SphereC *out, SphereC *s, Mat4C *m) nogil
    @staticmethod
    cdef void c_merge(SphereC *out, SphereC *a, SphereC *b) nogil
    @staticmethod
    cdef bint c_intersects_sphere(SphereC *a, SphereC *b) nogil
    @staticmethod
    cdef bint c_intersects_point(SphereC *s, Vec3C *p) nogil