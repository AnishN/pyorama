cdef TransformC *c_transform_get_ptr(Handle handle) except *:
    cdef:
        TransformC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.transforms, handle, <void **>&ptr))
    return ptr

cdef Handle c_transform_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.transforms, &handle))
    return handle

cdef void c_transform_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.transforms, handle)

cdef class Transform(HandleObject):

    @staticmethod
    cdef Transform c_from_handle(Handle handle):
        cdef Transform obj
        if handle == 0:
            raise ValueError("Transform: invalid handle")
        obj = Transform.__new__(Transform)
        obj.handle = handle
        return obj

    cdef TransformC *c_get_ptr(self) except *:
        return c_transform_get_ptr(self.handle)

    @staticmethod
    def init_create(Vec3 translation=Vec3(), Quat rotation=Quat(), Vec3 scale=Vec3(1, 1, 1), Vec3 offset=Vec3()):
        cdef:
            Transform transform
        
        transform = Transform.__new__(Transform)
        transform.create(translation, rotation, scale, offset)
        return transform

    cpdef void create(self, Vec3 translation=Vec3(), Quat rotation=Quat(), Vec3 scale=Vec3(1, 1, 1), Vec3 offset=Vec3()) except *:
        cdef:
            TransformC *transform_ptr

        self.handle = c_transform_create()
        transform_ptr = self.c_get_ptr()
        transform_ptr.translation = translation.data
        transform_ptr.rotation = rotation.data
        transform_ptr.scale = scale.data
        transform_ptr.offset = offset.data

    cpdef void delete(self) except *:
        c_transform_delete(self.handle)
        self.handle = 0

    cpdef void set_translation(self, Vec3 translation=Vec3()) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        transform_ptr.translation = translation.data

    cpdef void transform_set_rotation(self, Quat rotation=Quat()) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        transform_ptr.rotation = rotation.data

    cpdef void transform_set_scale(self, Vec3 scale=Vec3(1, 1, 1)) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        transform_ptr.scale = scale.data

    cpdef void transform_set_offset(self, Vec3 offset=Vec3()) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        transform_ptr.offset = offset.data

    cpdef void transform_get_translation(self, Vec3 translation) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        translation.data = transform_ptr.translation

    cpdef void transform_get_rotation(self, Quat rotation) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        rotation.data = transform_ptr.rotation

    cpdef void transform_get_scale(self, Vec3 scale) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        scale.data = transform_ptr.scale

    cpdef void transform_get_offset(self, Vec3 offset) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.c_get_ptr()
        offset.data = transform_ptr.offset