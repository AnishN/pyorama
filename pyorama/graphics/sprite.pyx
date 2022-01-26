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

    cpdef void get_color_texture(self, Texture color_texture) except *:
        color_texture.handle = self.get_ptr().color_texture

    cpdef void get_normal_texture(self, Texture normal_texture) except *:
        normal_texture.handle = self.get_ptr().normal_texture

    cpdef void get_position(self, Vec3 position) except *:
        position.data = self.get_ptr().position

    cpdef float get_rotation(self) except *:
        return self.get_ptr().rotation

    cpdef void get_scale(self, Vec2 scale) except *:
        scale.data = self.get_ptr().scale

    cpdef void get_size(self, Vec2 size) except *:
        size.data = self.get_ptr().size
    
    cpdef list get_texcoords(self):
        cdef:
            SpriteC *sprite_ptr
            list texcoords = []
            Vec2 tc
            size_t i
        
        sprite_ptr = self.get_ptr()
        for i in range(4):
            tc = Vec2.__new__(Vec2) 
            tc.data = sprite_ptr.texcoords[i]
            texcoords.append(tc)
        return texcoords

    cpdef void get_offset(self, Vec2 offset) except *: pass
    cpdef void get_tint(self, Vec3 tint) except *: pass
    cpdef float get_alpha(self) except *: pass

    cpdef void set_color_texture(self, Texture color_texture) except *: pass
    cpdef void set_normal_texture(self, Texture normal_texture) except *: pass
    cpdef void set_position(self, Vec3 position) except *: pass

    cpdef void set_rotation(self, float rotation) except *:
        self.get_ptr().rotation = rotation
    
    cpdef void set_scale(self, Vec2 scale) except *: pass
    cpdef void set_size(self, Vec2 size) except *: pass
    cpdef void set_texcoords(self, list texcoords) except *: pass
    cpdef void set_offset(self, Vec2 offset) except *: pass
    cpdef void set_tint(self, Vec3 tint) except *: pass
    cpdef void set_alpha(self, float alpha) except *: pass