cdef class Sprite(HandleObject):

    cdef SpriteC *get_ptr(self) except *:
        return <SpriteC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(
            Texture color_texture, Texture normal_texture=None, 
            Vec3 position=Vec3(0, 0, 0), float rotation=0, Vec2 scale=Vec2(1, 1), 
            Vec2 size=Vec2(1, 1), list texcoords=None, Vec2 offset=Vec2(0, 0),
            Vec3 tint=Vec3(1, 1, 1), float alpha=1,
    ):
        cdef:
            Sprite sprite

        sprite = Sprite.__new__(Sprite)
        sprite.create(color_texture, normal_texture, position, rotation, scale, size, texcoords, offset, tint, alpha)
        return sprite

    cpdef void create(self, 
            Texture color_texture, Texture normal_texture=None, 
            Vec3 position=Vec3(0, 0, 0), float rotation=0, Vec2 scale=Vec2(1, 1), 
            Vec2 size=Vec2(1, 1), list texcoords=None, Vec2 offset=Vec2(0, 0),
            Vec3 tint=Vec3(1, 1, 1), float alpha=1,
    ) except *:
        cdef:
            SpriteC *sprite_ptr
            size_t i

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE)
        sprite_ptr = self.get_ptr()
        sprite_ptr.color_texture = color_texture.handle
        sprite_ptr.normal_texture = normal_texture.handle
        sprite_ptr.position = position.data
        sprite_ptr.rotation = rotation
        sprite_ptr.scale = scale.data
        sprite_ptr.size = size.data
        if texcoords == None:
            sprite_ptr.texcoords = [[0, 0], [1, 0], [1, 1], [0, 1]]
        else:
            for i in range(4):
                sprite_ptr.texcoords[i] = <Vec2C>texcoords[i].data
            sprite_ptr.texcoords = texcoords
        sprite_ptr.offset = offset.data
        sprite_ptr.tint = tint.data
        sprite_ptr.alpha = alpha

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0