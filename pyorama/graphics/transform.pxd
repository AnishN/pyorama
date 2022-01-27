from pyorama.core.handle cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct TransformC:
    Handle handle
    Vec3C translation
    QuatC rotation
    Vec3C scale
    Vec3C offset

cdef class Transform(HandleObject):
    @staticmethod
    cdef Transform c_from_handle(Handle handle)
    cdef TransformC *c_get_ptr(self) except *
    cpdef void create(self, Vec3 translation=*, Quat rotation=*, Vec3 scale=*, Vec3 offset=*) except *
    cpdef void delete(self) except *
    cpdef void set_translation(self, Vec3 translation=*) except *
    cpdef void transform_set_rotation(self, Quat rotation=*) except *
    cpdef void transform_set_scale(self, Vec3 scale=*) except *
    cpdef void transform_set_offset(self, Vec3 offset=*) except *
    cpdef void transform_get_translation(self, Vec3 translation) except *
    cpdef void transform_get_rotation(self, Quat rotation) except *
    cpdef void transform_get_scale(self, Vec3 scale) except *
    cpdef void transform_get_offset(self, Vec3 offset) except *