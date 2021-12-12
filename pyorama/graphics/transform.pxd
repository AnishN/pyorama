from pyorama.data.handle cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct TransformC:
    Handle handle
    Vec3C translation
    QuatC rotation
    Vec3C scale
    Vec3C offset

cdef TransformC *transform_get_ptr(Handle transform) except *
cpdef Handle transform_create(Vec3 translation=*, Quat rotation=*, Vec3 scale=*, Vec3 offset=*) except *
cpdef void transform_delete(Handle transform) except *
cpdef void transform_set_translation(Handle transform, Vec3 translation=*) except *
cpdef void transform_set_rotation(Handle transform, Quat rotation=*) except *
cpdef void transform_set_scale(Handle transform, Vec3 scale=*) except *
cpdef void transform_set_offset(Handle transform, Vec3 offset=*) except *
cpdef void transform_get_translation(Handle transform, Vec3 translation, bint copy=*) except *
cpdef void transform_get_rotation(Handle transform, Quat rotation, bint copy=*) except *
cpdef void transform_get_scale(Handle transform, Vec3 scale, bint copy=*) except *
cpdef void transform_get_offset(Handle transform, Vec3 offset, bint copy=*) except *