cdef class Sprite(HandleObject):

    cdef SpriteC *get_ptr(self) except *:
        return <SpriteC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(Texture color_texture, Texture normal_texture=None, Transform transform=None, list texcoords=None, Vec3 tint=Vec3(1, 1, 1), float alpha=1.0):
        cdef:
            Sprite sprite

        sprite = Sprite.__new__(Sprite)
        sprite.create(color_texture, normal_texture, transform, texcoords, tint, alpha)
        return alpha

    cpdef void create(self, Texture color_texture, Texture normal_texture=None, Transform transform=None, list texcoords=None, Vec3 tint=Vec3(1, 1, 1), float alpha=1.0) except *:
        cdef:
            SpriteC *sprite_ptr
            size_t i

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE)
        sprite_ptr = self.get_ptr()
        sprite_ptr.color_texture = color_texture.handle
        sprite_ptr.normal_texture = normal_texture.handle
        sprite_ptr.transform = transform.handle
        if texcoords == None:
            sprite_ptr.texcoords = [
                Vec2C(0.0, 0.0),
                Vec2C(1.0, 0.0),
                Vec2C(0.0, 1.0),
                Vec2C(1.0, 1.0),
            ]
        else:
            for i in range(4):
                sprite_ptr.texcoords[i] = (<Vec2C *>texcoords[i].data)[0]
            sprite_ptr.texcoords = texcoords
        sprite_ptr.tint = tint.data
        sprite_ptr.alpha = alpha

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0