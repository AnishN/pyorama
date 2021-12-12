cdef TransformC *transform_get_ptr(Handle transform) except *:
    return <TransformC *>graphics.slots.c_get_ptr(transform)

cpdef Handle transform_create(Vec3 translation=Vec3(), Quat rotation=Quat(), Vec3 scale=Vec3(1, 1, 1), Vec3 offset=Vec3()) except *:
    cdef:
        Handle transform
        TransformC *transform_ptr

    transform = graphics.slots.c_create(GRAPHICS_SLOT_TRANSFORM)
    transform_ptr = transform_get_ptr(transform)
    transform_ptr.translation = translation.data[0]
    transform_ptr.rotation = rotation.data[0]
    transform_ptr.scale = scale.data[0]
    transform_ptr.offset = offset.data[0]
    return transform

cpdef void transform_delete(Handle transform) except *:
    graphics.slots.c_delete(transform)

cpdef void transform_set_translation(Handle transform, Vec3 translation=Vec3()) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    transform_ptr.translation = translation.data[0]

cpdef void transform_set_rotation(Handle transform, Quat rotation=Quat()) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    transform_ptr.rotation = rotation.data[0]

cpdef void transform_set_scale(Handle transform, Vec3 scale=Vec3(1, 1, 1)) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    transform_ptr.scale = scale.data[0]

cpdef void transform_set_offset(Handle transform, Vec3 offset=Vec3()) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    transform_ptr.offset = offset.data[0]

cpdef void transform_get_translation(Handle transform, Vec3 translation, bint copy=True) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    if copy: translation.data[0] = transform_ptr.translation
    else: translation.data = &transform_ptr.translation

cpdef void transform_get_rotation(Handle transform, Quat rotation, bint copy=True) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    if copy: rotation.data[0] = transform_ptr.rotation
    else: rotation.data = &transform_ptr.rotation

cpdef void transform_get_scale(Handle transform, Vec3 scale, bint copy=True) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    if copy: scale.data[0] = transform_ptr.scale
    else: scale.data = &transform_ptr.scale

cpdef void transform_get_offset(Handle transform, Vec3 offset, bint copy=True) except *:
    cdef:
        TransformC *transform_ptr
    transform_ptr = transform_get_ptr(transform)
    if copy: offset.data[0] = transform_ptr.offset
    else: offset.data = &transform_ptr.offset