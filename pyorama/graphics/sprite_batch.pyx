cdef SpriteBatchC *sprite_batch_get_ptr(Handle sprite_batch) except *:
    return <SpriteBatchC *>graphics.slots.c_get_ptr(sprite_batch)

cpdef Handle sprite_batch_create(Handle[::1] sprites) except *:
    cdef:
        Handle sprite_batch
        SpriteBatchC *sprite_batch_ptr
        size_t num_sprites

    sprite_batch = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE_BATCH)
    sprite_batch_ptr = sprite_batch_get_ptr(sprite_batch)
    num_sprites = sprites.shape[0]

    sprite_batch_ptr.sprites = <Handle *>calloc(num_sprites, sizeof(Handle))
    if sprite_batch_ptr.sprites == NULL:
        raise MemoryError()
    memcpy(sprite_batch_ptr.sprites, &sprites[0], num_sprites * sizeof(Handle))
    sprite_batch_ptr.num_sprites = num_sprites
    return sprite_batch

cpdef void sprite_batch_delete(Handle sprite_batch) except *:
    cdef:
        SpriteBatchC *sprite_batch_ptr

    sprite_batch_ptr = sprite_batch_get_ptr(sprite_batch)
    graphics.slots.c_delete(sprite_batch)

cpdef void sprite_batch_update(Handle sprite_batch) except *:
    pass