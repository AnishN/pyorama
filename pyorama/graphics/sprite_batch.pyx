from cython cimport view

cdef class SpriteBatch(HandleObject):

    @staticmethod
    cdef SpriteBatch c_from_handle(Handle handle):
        cdef SpriteBatch obj
        if handle == 0:
            raise ValueError("SpriteBatch: invalid handle")
        obj = SpriteBatch.__new__(SpriteBatch)
        obj.handle = handle
        return obj

    cdef SpriteBatchC *c_get_ptr(self) except *:
        return <SpriteBatchC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create():
        cdef:
            SpriteBatch sprite_batch

        sprite_batch = SpriteBatch.__new__(SpriteBatch)
        sprite_batch.create()
        return sprite_batch

    cpdef void create(self) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
            VectorC *sprites_ptr
            VectorC *sorted_sprites_ptr
            VertexLayout v_layout
            VertexBuffer v_buffer
            IndexLayout i_layout
            IndexBuffer i_buffer

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_SPRITE_BATCH)
        sprite_batch_ptr = self.c_get_ptr()
        sprites_ptr = &sprite_batch_ptr.sprites
        CHECK_ERROR(vector_init(sprites_ptr, sizeof(Handle)))
        sorted_sprites_ptr = &sprite_batch_ptr.sorted_sprites
        CHECK_ERROR(vector_init(sorted_sprites_ptr, sizeof(Handle)))

        v_layout = graphics.sprite_vertex_layout
        v_buffer = VertexBuffer.init_create_dynamic_resizable(v_layout)
        sprite_batch_ptr.vertex_buffer = v_buffer.handle
        i_layout = INDEX_LAYOUT_U32
        i_buffer = IndexBuffer.init_create_dynamic_resizable(i_layout)
        sprite_batch_ptr.index_buffer = i_buffer.handle

    cpdef void delete(self) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
        
        sprite_batch_ptr = self.c_get_ptr()
        vector_free(&sprite_batch_ptr.sprites)
        vector_free(&sprite_batch_ptr.sorted_sprites)
        graphics.slots.c_delete(self.handle)
        self.handle = 0
    
    cpdef void set_sprites(self, list sprites) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
            size_t num_sprites
            VectorC *sprites_ptr
            VectorC *sorted_sprites_ptr
            VertexBuffer v_buffer = VertexBuffer.__new__(VertexBuffer)
            VertexBufferC *v_buffer_ptr
            VectorC *vertices_ptr
            IndexBuffer i_buffer = IndexBuffer.__new__(IndexBuffer)
            IndexBufferC *i_buffer_ptr
            VectorC *indices_ptr
            
            size_t i, j
            Sprite sprite
            SpriteC *sprite_ptr
            SpriteVertexC *v_ptr
            uint32_t index
            Vec2C[4] quad_vertices = [[0, 0], [1, 0], [1, 1], [0, 1]]
            size_t[6] quad_indices = [0, 1, 2, 0, 2, 3]
        
        sprite_batch_ptr = self.c_get_ptr()
        num_sprites = len(sprites)
        sprites_ptr = &sprite_batch_ptr.sprites
        sorted_sprites_ptr = &sprite_batch_ptr.sorted_sprites
        v_buffer.handle = sprite_batch_ptr.vertex_buffer
        v_buffer_ptr = v_buffer.c_get_ptr()
        vertices_ptr = &v_buffer_ptr.data.resizable
        i_buffer.handle = sprite_batch_ptr.index_buffer
        i_buffer_ptr = i_buffer.c_get_ptr()
        indices_ptr = &i_buffer_ptr.data.resizable
        
        for i in range(num_sprites):
            sprite = <Sprite>sprites[i]
            CHECK_ERROR(vector_push(sprites_ptr, <void *>&sprite.handle))
            CHECK_ERROR(vector_push(sorted_sprites_ptr, <void *>&sprite.handle))
            sprite_ptr = sprite.c_get_ptr()
            for j in range(4):
                index = 4 * i + j
                CHECK_ERROR(vector_push_empty(vertices_ptr))

        for i in range(num_sprites):
            for j in range(6):
                index = i * 4 + quad_indices[j]
                CHECK_ERROR(vector_push(indices_ptr, &index))
        
        v_buffer.update()
        i_buffer.update()

    cpdef void get_vertex_buffer(self, VertexBuffer buffer) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr

        sprite_batch_ptr = self.c_get_ptr()
        buffer.handle = sprite_batch_ptr.vertex_buffer

    cpdef void get_index_buffer(self, IndexBuffer buffer) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
        
        sprite_batch_ptr = self.c_get_ptr()
        buffer.handle = sprite_batch_ptr.index_buffer

    cpdef void update(self) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
            size_t num_sprites
            VectorC *sprites_ptr
            VertexBuffer v_buffer = VertexBuffer.__new__(VertexBuffer)
            VertexBufferC *v_buffer_ptr
            VectorC *vertices_ptr
            IndexBuffer i_buffer = IndexBuffer.__new__(IndexBuffer)
            IndexBufferC *i_buffer_ptr
            VectorC *indices_ptr
            
            size_t i, j
            Sprite sprite = Sprite.__new__(Sprite)
            SpriteC *sprite_ptr
            SpriteVertexC *v_ptr
            uint32_t *index_ptr
            Vec4C t
            Vec2C[4] texcoords
            size_t[6] quad_indices = [0, 1, 2, 0, 2, 3]
            uint8_t[4] tint_alpha_rgba
            Vec3C padding = [1.0, 1.0, 1.0]
        
        self.c_sort_back_to_front()
        sprite_batch_ptr = self.c_get_ptr()
        num_sprites = sprite_batch_ptr.sprites.num_items
        sprites_ptr = &sprite_batch_ptr.sprites
        v_buffer.handle = sprite_batch_ptr.vertex_buffer
        v_buffer_ptr = v_buffer.c_get_ptr()
        vertices_ptr = &v_buffer_ptr.data.resizable
        i_buffer.handle = sprite_batch_ptr.index_buffer
        i_buffer_ptr = i_buffer.c_get_ptr()
        indices_ptr = &i_buffer_ptr.data.resizable
        
        for i in range(num_sprites):
            sprite.handle = (<Handle *>vector_c_get_ptr_unsafe(sprites_ptr, i))[0]
            sprite_ptr = sprite.c_get_ptr()
            t = sprite_ptr.texcoord_xywh
            texcoords = [
                [t.x, t.y],
                [t.x + t.z, t.y],
                [t.x + t.z, t.y + t.w],
                [t.x, t.y + t.w],
            ]
            for j in range(4):
                index = 4 * i + j
                v_ptr = <SpriteVertexC *>vector_c_get_ptr_unsafe(vertices_ptr, index)
                v_ptr.position = sprite_ptr.position
                v_ptr.rotation = sprite_ptr.rotation
                v_ptr.scale = sprite_ptr.scale
                v_ptr.size.x = sprite_ptr.size.x * 1.0 / t.z
                v_ptr.size.y = sprite_ptr.size.y * 1.0 / t.w
                v_ptr.texcoord = texcoords[j]
                v_ptr.offset = sprite_ptr.offset

                tint_alpha_rgba[0] = <uint8_t>f_round(256 * sprite_ptr.tint.x)
                tint_alpha_rgba[1] = <uint8_t>f_round(256 * sprite_ptr.tint.y)
                tint_alpha_rgba[2] = <uint8_t>f_round(256 * sprite_ptr.tint.z)
                tint_alpha_rgba[3] = <uint8_t>f_round(256 * sprite_ptr.alpha)
                memcpy(&v_ptr.tint_alpha, &tint_alpha_rgba, sizeof(float))
                v_ptr.padding = padding

        for i in range(num_sprites):
            for j in range(6):
                index_ptr = <uint32_t *>vector_c_get_ptr_unsafe(indices_ptr, 6 * i + j)
                index_ptr[0] = i * 4 + quad_indices[j]
        
        v_buffer.update()
        i_buffer.update()

    cdef void c_sort_back_to_front(self) except *:
        cdef:
            SpriteBatchC *sprite_batch_ptr
            VectorC *sprites_ptr
            VectorC *sorted_sprites_ptr
            size_t num_sprites
            size_t i

        sprite_batch_ptr = self.c_get_ptr()
        sprites_ptr = &sprite_batch_ptr.sprites
        sorted_sprites_ptr = &sprite_batch_ptr.sorted_sprites
        num_sprites = sprite_batch_ptr.sprites.num_items
        
