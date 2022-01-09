cdef class Transform(HandleObject):

    cdef TransformC *get_ptr(self) except *:
        return <TransformC *>graphics.slots.c_get_ptr(self.handle)

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

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_TRANSFORM)
        transform_ptr = self.get_ptr()
        #transform_ptr.translation = translation.data[0]
        #transform_ptr.rotation = rotation.data[0]
        #transform_ptr.scale = scale.data[0]
        #transform_ptr.offset = offset.data[0]

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void set_translation(self, Vec3 translation=Vec3()) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #transform_ptr.translation = translation.data[0]

    cpdef void transform_set_rotation(self, Quat rotation=Quat()) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #transform_ptr.rotation = rotation.data[0]

    cpdef void transform_set_scale(self, Vec3 scale=Vec3(1, 1, 1)) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #transform_ptr.scale = scale.data[0]

    cpdef void transform_set_offset(self, Vec3 offset=Vec3()) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #transform_ptr.offset = offset.data[0]

    cpdef void transform_get_translation(self, Vec3 translation, bint copy=True) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #if copy: translation.data[0] = transform_ptr.translation
        #else: translation.data = &transform_ptr.translation

    cpdef void transform_get_rotation(self, Quat rotation, bint copy=True) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #if copy: rotation.data[0] = transform_ptr.rotation
        #else: rotation.data = &transform_ptr.rotation

    cpdef void transform_get_scale(self, Vec3 scale, bint copy=True) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #if copy: scale.data[0] = transform_ptr.scale
        #else: scale.data = &transform_ptr.scale

    cpdef void transform_get_offset(self, Vec3 offset, bint copy=True) except *:
        cdef:
            TransformC *transform_ptr
        transform_ptr = self.get_ptr()
        #if copy: offset.data[0] = transform_ptr.offset
        #else: offset.data = &transform_ptr.offset