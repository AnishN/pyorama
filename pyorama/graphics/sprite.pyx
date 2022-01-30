cdef class Sprite(HandleObject):

    @staticmethod
    cdef Sprite c_from_handle(Handle handle):
        cdef Sprite obj
        if handle == 0:
            raise ValueError("Sprite: invalid handle")
        obj = Sprite.__new__(Sprite)
        obj.handle = handle
        return obj

    cdef SpriteC *c_get_ptr(self) except *:
        return <SpriteC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(
            Texture color_texture, Texture normal_texture=None, 
            Vec3 position=Vec3(0, 0, 0), float rotation=0, Vec2 scale=Vec2(1, 1), 
            Vec2 size=Vec2(1, 1), Vec4 texcoord_xywh=Vec4(0, 0, 1, 1), Vec2 offset=Vec2(0, 0),
            Vec3 tint=Vec3(1, 1, 1), float alpha=1,
    ):
        cdef:
            Sprite sprite

        sprite = Sprite.__new__(Sprite)
        sprite.create(color_texture, normal_texture, position, rotation, scale, size, texcoord_xywh, offset, tint, alpha)
        return sprite

    cpdef void create(self, 
            Texture color_texture, Texture normal_texture=None, 
            Vec3 position=Vec3(0, 0, 0), float rotation=0, Vec2 scale=Vec2(1, 1), 
            Vec2 size=Vec2(1, 1), Vec4 texcoord_xywh=Vec4(0, 0, 1, 1), Vec2 offset=Vec2(0, 0),
            Vec3 tint=Vec3(1, 1, 1), float alpha=1,
    ) except *:
        cdef:
            SpriteC *sprite_ptr
            size_t i

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE)
        sprite_ptr = self.c_get_ptr()
        sprite_ptr.color_texture = color_texture.handle
        sprite_ptr.normal_texture = normal_texture.handle
        sprite_ptr.position = position.data
        sprite_ptr.rotation = rotation
        sprite_ptr.scale = scale.data
        sprite_ptr.size = size.data
        sprite_ptr.texcoord_xywh = texcoord_xywh.data
        sprite_ptr.offset = offset.data
        sprite_ptr.tint = tint.data
        sprite_ptr.alpha = alpha

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    property color_texture:
        def __get__(self):
            return Texture.c_from_handle(self.c_get_ptr().color_texture)
        def __set__(self, Texture color_texture):
            self.c_get_ptr().color_texture = color_texture.handle

    property normal_texture:
        def __get__(self):
            return Texture.c_from_handle(self.c_get_ptr().normal_texture)
        def __set__(self, Texture normal_texture):
            self.c_get_ptr().normal_texture = normal_texture.handle

    property position:
        def __get__(self):
            return Vec3.c_from_data(&self.c_get_ptr().position)
        def __set__(self, Vec3 value):
            self.c_get_ptr().position = value.data

    property rotation:
        def __get__(self):
            return self.c_get_ptr().rotation
        def __set__(self, float value):
            self.c_get_ptr().rotation = value

    property scale:
        def __get__(self):
            return Vec2.c_from_data(&self.c_get_ptr().scale)
        def __set__(self, Vec2 value):
            self.c_get_ptr().scale = value.data

    property size:
        def __get__(self):
            return Vec2.c_from_data(&self.c_get_ptr().size)
        def __set__(self, Vec2 value):
            self.c_get_ptr().size = value.data

    property texcoord_xywh:
        def __get__(self):
            return Vec4.c_from_data(&self.c_get_ptr().texcoord_xywh)
            
        def __set__(self, Vec4 value):
            self.c_get_ptr().texcoord_xywh = value.data

    property offset:
        def __get__(self):
            return Vec2.c_from_data(&self.c_get_ptr().offset)
        def __set__(self, Vec2 value):
            self.c_get_ptr().offset = value.data
    
    property tint:
        def __get__(self):
            return Vec3.c_from_data(&self.c_get_ptr().tint)
        def __set__(self, Vec3 value):
            self.c_get_ptr().tint = value.data

    property alpha:
        def __get__(self):
            return self.c_get_ptr().alpha
        def __set__(self, float value):
            self.c_get_ptr().alpha = value