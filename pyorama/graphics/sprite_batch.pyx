from cython cimport view

cdef class SpriteBatch(HandleObject):

    cdef SpriteBatchC *get_ptr(self) except *:
        return <SpriteBatchC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(list sprites):
        cdef:
            SpriteBatch sprite_batch

        sprite_batch = SpriteBatch.__new__(SpriteBatch)
        sprite_batch.create(sprites)
        return sprite_batch

    cpdef void create(self, list sprites) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
            VectorC *sprites_ptr
            size_t num_sprites
            size_t i, j, k
            Sprite sprite
            SpriteC *sprite_ptr

            VertexLayout v_layout
            VertexBuffer v_buffer
            VectorC *v_vector
            uint8_t[::1] vertices
            SpriteVertexC *v_ptr

            IndexLayout i_layout
            IndexBuffer i_buffer
            VectorC *i_vector
            uint8_t[::1] indices
            uint32_t index
            size_t[6] texcoord_indices = [0, 1, 2, 0, 2, 3]

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE_BATCH)
        sprite_batch_ptr = self.get_ptr()
        sprites_ptr = &sprite_batch_ptr.sprites
        vector_init(sprites_ptr, sizeof(Handle))
        vector_init(&sprite_batch_ptr.vertices, sizeof(SpriteVertexC))
        vector_init(&sprite_batch_ptr.indices, sizeof(uint32_t))
        
        num_sprites = len(sprites)
        for i in range(num_sprites):
            sprite = <Sprite>sprites[i]
            vector_push(sprites_ptr, <void *>&sprite.handle)
            sprite_ptr = sprite.get_ptr()
            for j in range(4):
                index = 4 * i + j
                vector_push_empty(&sprite_batch_ptr.vertices)
                v_ptr = <SpriteVertexC *>vector_get_ptr_unsafe(&sprite_batch_ptr.vertices, index)
                v_ptr.position = sprite_ptr.position
                v_ptr.rotation = sprite_ptr.rotation
                v_ptr.scale = sprite_ptr.scale
                v_ptr.size = sprite_ptr.size
                v_ptr.texcoord = sprite_ptr.texcoords[j]
                v_ptr.tint[0] = <uint8_t>f_round(255 * sprite_ptr.tint.x)
                v_ptr.tint[1] = <uint8_t>f_round(255 * sprite_ptr.tint.y)
                v_ptr.tint[2] = <uint8_t>f_round(255 * sprite_ptr.tint.z)
                v_ptr.alpha = <uint8_t>f_round(255 * sprite_ptr.alpha)
        v_layout = graphics.sprite_vertex_layout
        v_vector = &sprite_batch_ptr.vertices
        vertices = <uint8_t[:v_vector.num_items * v_vector.item_size]>(<uint8_t *>v_vector.items)
        v_buffer = VertexBuffer.init_create_static_from_array(v_layout, vertices)
        sprite_batch_ptr.vertex_buffer = v_buffer.handle

        for i in range(num_sprites):
            for j in range(6):
                k = i * 4 + texcoord_indices[j]
                vector_push(&sprite_batch_ptr.indices, &k)

        i_layout = INDEX_LAYOUT_U32
        i_vector = &sprite_batch_ptr.indices
        indices = <uint8_t[:i_vector.num_items * i_vector.item_size]>(<uint8_t *>i_vector.items)
        i_buffer = IndexBuffer.init_create_static_from_array(i_layout, indices)
        sprite_batch_ptr.index_buffer = i_buffer.handle

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void get_vertex_buffer(self, VertexBuffer buffer) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr

        sprite_batch_ptr = self.get_ptr()
        buffer.handle = sprite_batch_ptr.vertex_buffer

    cpdef void get_index_buffer(self, IndexBuffer buffer) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
        
        sprite_batch_ptr = self.get_ptr()
        buffer.handle = sprite_batch_ptr.index_buffer

    cpdef void update(self) except *:
        pass