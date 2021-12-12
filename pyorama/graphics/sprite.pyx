cdef SpriteC *sprite_get_ptr(Handle sprite) except *:
    return <SpriteC *>graphics.slots.c_get_ptr(sprite)

cpdef Handle sprite_create(Handle color_texture, Handle normal_texture=0, Handle transform=0, list texcoords=None, Vec3 tint=Vec3(1, 1, 1), float alpha=1.0) except *:
    cdef:
        Handle sprite
        SpriteC *sprite_ptr
        size_t i

    sprite = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE)
    sprite_ptr = sprite_get_ptr(sprite)
    sprite_ptr.color_texture = color_texture
    sprite_ptr.normal_texture = normal_texture
    sprite_ptr.transform = transform
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
    sprite_ptr.tint = tint.data[0]
    sprite_ptr.alpha = alpha
    print(sprite_ptr[0])
    return sprite

cpdef void sprite_delete(Handle sprite) except *:
    graphics.slots.c_delete(sprite)