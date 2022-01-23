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
            #Buffer vb, ib
            #BufferFormat v_format
            VertexLayout v_layout
            #VertexBuffer v_buffer
            IndexLayout i_layout = INDEX_LAYOUT_U32
            IndexBuffer i_buffer
            SpriteVertexC *v_ptr
            uint32_t index
            size_t[6] texcoord_indices = [0, 1, 2, 0, 2, 3]

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE_BATCH)
        sprite_batch_ptr = self.get_ptr()
        sprites_ptr = &sprite_batch_ptr.sprites
        vector_init(sprites_ptr, sizeof(Handle))
        vector_init(&sprite_batch_ptr.vertices, sizeof(SpriteVertexC))
        vector_init(&sprite_batch_ptr.indices, sizeof(uint32_t))
        
        #v_format = graphics.sprite_vertex_format
        v_layout = graphics.sprite_vertex_layout
        #v_buffer = Buffer(v_format)

        num_sprites = len(sprites)
        for i in range(num_sprites):
            sprite = <Sprite>sprites[i]
            vector_push(sprites_ptr, <void *>&sprite.handle)
            sprite_ptr = sprite.get_ptr()
            for j in range(6):
                vector_push_empty(&sprite_batch_ptr.vertices)
                index = 6 * i + j
                vector_push(&sprite_batch_ptr.indices, &index)
                v_ptr = <SpriteVertexC *>vector_get_ptr_unsafe(&sprite_batch_ptr.vertices, i)
                v_ptr.position = sprite_ptr.position
                v_ptr.rotation = sprite_ptr.rotation
                v_ptr.scale = sprite_ptr.scale
                v_ptr.size = sprite_ptr.size
                k = texcoord_indices[j]
                v_ptr.texcoord = sprite_ptr.texcoords[k]
                v_ptr.tint = sprite_ptr.tint
                v_ptr.alpha = sprite_ptr.alpha
        
        """
        #buffer.add_rows([1, 0, 0, 1, 0, 1, 1])
        #buffer.add_row([]
        #buffer.add_row([]
        #buffer.add_row([]
        #vb = Buffer(graphics.sprite_vertex_format)
        #vb.c_init_from_ptr(sprite_ptr.vertices.items, sprite_ptr.vertices.num_items * sprite_ptr.vertices.item_size, copy=False)
        #v_buffer.c_init_from_ptr
        """

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void update(self) except *:
        pass