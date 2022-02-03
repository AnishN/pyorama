cdef Scene2DC *c_scene2d_get_ptr(Handle handle) except *:
    cdef:
        Scene2DC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.scene2ds, handle, <void **>&ptr))
    return ptr

cdef Handle c_scene2d_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.scene2ds, &handle))
    return handle

cdef void c_scene2d_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.scene2ds, handle)

cdef class Scene2D(HandleObject):

    @staticmethod
    cdef Scene2D c_from_handle(Handle handle):
        cdef Scene2D obj
        if handle == 0:
            raise ValueError("Scene2D: invalid handle")
        obj = Scene2D.__new__(Scene2D)
        obj.handle = handle
        return obj

    cdef Scene2DC *c_get_ptr(self) except *:
        return c_scene2d_get_ptr(self.handle)

    cpdef void create(self) except *:
        cdef:
            Scene2DC *scene_ptr
            VectorC *sprites_ptr

        self.handle = c_scene2d_create()
        scene_ptr = self.c_get_ptr()
        sprites_ptr = &scene_ptr.sprites
        CHECK_ERROR(vector_init(sprites_ptr, sizeof(Handle)))
    
    cpdef void delete(self) except *:
        cdef:
            Scene2DC *scene_ptr
            VectorC *sprites_ptr
        
        scene_ptr = self.c_get_ptr()
        sprites_ptr = &scene_ptr.sprites
        vector_free(sprites_ptr)
        c_scene2d_delete(self.handle)
        self.handle = 0

    cpdef void add_sprite(self, Sprite sprite) except *:
        cdef:
            Scene2DC *scene_ptr
            VectorC *sprites_ptr
        
        scene_ptr = self.c_get_ptr()
        sprites_ptr = &scene_ptr.sprites
        vector_push(sprites_ptr, &sprite.handle)

    cpdef void remove_sprite(self, Sprite sprite) except *:#TODO: maybe use hash_map instead???
        cdef:
            Scene2DC *scene_ptr
            VectorC *sprites_ptr
            size_t i
        
        scene_ptr = self.c_get_ptr()
        sprites_ptr = &scene_ptr.sprites
        CHECK_ERROR(vector_find(sprites_ptr, &sprite.handle, &i))
        vector_remove_empty(sprites_ptr, i)

    cpdef void add_sprites(self, list sprites) except *:
        cdef:
            size_t i
            size_t num_sprites = len(sprites)
            Sprite sprite
        
        for i in range(num_sprites):
            sprite = <Sprite>sprites[i]
            self.add_sprite(sprite)

    cpdef void remove_sprites(self, list sprites) except *:
        cdef:
            size_t i
            size_t num_sprites = len(sprites)
            Sprite sprite
        
        for i in range(num_sprites):
            sprite = <Sprite>sprites[i]
            self.remove_sprite(sprite)

    cpdef void update(self) except *:
        cdef:
            Scene2DC *scene_ptr
            VectorC *sprites_ptr
            size_t o_index#opaque index
            size_t a_index#alpha index
            Handle front
            Handle back
            SpriteC *front_ptr
            SpriteC *back_ptr
            bint front_alpha
            bint back_alpha

        scene_ptr = self.c_get_ptr()
        sprites_ptr = &scene_ptr.sprites
        o_index = 0
        a_index = sprites_ptr.num_items - 1

        while o_index < a_index:
            vector_get(sprites_ptr, o_index, &front)
            front_ptr = c_sprite_get_ptr(front)
            front_alpha = front_ptr.alpha != 1
            if front_alpha:
                while a_index > o_index:
                    vector_get(sprites_ptr, a_index, &back)
                    back_ptr = c_sprite_get_ptr(back)
                    back_alpha = back_ptr.alpha != 1
                    if not back_alpha:
                        vector_swap(sprites_ptr, o_index, a_index)
                        break
                    a_index -= 1
            o_index += 1