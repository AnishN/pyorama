cdef class TileMap:
    def __cinit__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef TileMapC *get_ptr(self) except *:
        return self.graphics.tile_map_get_ptr(self.handle)
    
    cpdef void create(self, TextureGridAtlas atlas, size_t tile_width, size_t tile_height, size_t num_rows, size_t num_columns) except *:
        cdef:
            TileMapC *map_ptr
            VertexBuffer vbo = VertexBuffer(self.graphics)
            IndexBuffer ibo = IndexBuffer(self.graphics)
            size_t num_tiles

        self.handle = self.graphics.tile_maps.c_create()
        map_ptr = self.get_ptr()
        map_ptr.atlas = atlas.handle
        map_ptr.tile_width = tile_width
        map_ptr.tile_height = tile_height
        map_ptr.num_rows = num_rows
        map_ptr.num_columns = num_columns
        num_tiles = map_ptr.num_rows * map_ptr.num_columns
        map_ptr.indices = <uint32_t *>calloc(num_tiles, sizeof(uint32_t))
        if map_ptr.indices == NULL:
            raise MemoryError("TileMap: cannot allocate indices")
        v_fmt_ptr = self.graphics.vertex_format_get_ptr(self.graphics.v_fmt_sprite.handle)
        vbo.create(self.graphics.v_fmt_tile, usage=BUFFER_USAGE_DYNAMIC)
        vbo_size = v_fmt_ptr.stride * 6 * num_tiles
        map_ptr.vertex_buffer = vbo.handle
        map_ptr.vertex_data_ptr = <uint8_t *>calloc(1, vbo_size)
        if map_ptr.vertex_data_ptr == NULL:
            raise MemoryError("TileMap: cannot allocate vertex data")
        
        ibo.create(self.graphics.i_fmt_tile, usage=BUFFER_USAGE_DYNAMIC)
        ibo_size = sizeof(uint32_t) * 6 * num_tiles
        map_ptr.index_buffer = ibo.handle
        map_ptr.index_data_ptr = <uint8_t *>calloc(1, ibo_size)
        if map_ptr.index_data_ptr == NULL:
            raise MemoryError("TileMap: cannot allocate index data")

    cpdef void delete(self) except *:
        cdef:
            TileMapC *map_ptr
        map_ptr = self.get_ptr()
        free(map_ptr.indices)
        free(map_ptr.vertex_data_ptr)
        free(map_ptr.index_data_ptr)
        self.graphics.tile_maps.c_delete(self.handle)
        self.handle = 0

    cpdef void set_indices(self, uint32_t[:] indices) except *:
        cdef:
            TileMapC *map_ptr
        map_ptr = self.get_ptr()
        if map_ptr.num_rows * map_ptr.num_columns != indices.shape[0]:
            raise ValueError("TileMap: invalid indices shape")
        memcpy(map_ptr.indices, &indices[0], indices.shape[0] * sizeof(uint32_t))

    cpdef VertexBuffer get_vertex_buffer(self):
        cdef:
            TileMapC *map_ptr
            VertexBuffer out = VertexBuffer(self.graphics)
        map_ptr = self.get_ptr()
        out.handle = map_ptr.vertex_buffer
        return out

    cpdef IndexBuffer get_index_buffer(self):
        cdef:
            TileMapC *batch_ptr
            IndexBuffer out = IndexBuffer(self.graphics)
        map_ptr = self.get_ptr()
        out.handle = map_ptr.index_buffer
        return out

    cdef void _update(self) except *:
        cdef:
            TileMapC *map_ptr
            size_t i, j, index
            size_t num_tiles
            Vec2C[6] quad_vertices
            VertexBuffer v_buffer = VertexBuffer(self.graphics)
            IndexBuffer i_buffer = IndexBuffer(self.graphics)
            VertexFormatC *v_fmt_ptr
            uint8_t *vbo
            uint8_t *ibo
            size_t vbo_size, ibo_size
            uint8_t *vbo_index
            uint8_t *ibo_index
            Vec2C position
            float tile_index
            float tile_type
            
        quad_vertices = [
            Vec2C(0.0, 0.0),
            Vec2C(1.0, 0.0),
            Vec2C(0.0, 1.0),
            Vec2C(0.0, 1.0),
            Vec2C(1.0, 0.0),
            Vec2C(1.0, 1.0),
        ]
        map_ptr = self.get_ptr()
        v_fmt_ptr = self.graphics.v_fmt_tile.get_ptr()
        num_tiles = map_ptr.num_rows * map_ptr.num_columns
        vbo_size = v_fmt_ptr.stride * 6 * num_tiles
        ibo_size = sizeof(uint32_t) * 6 * num_tiles
        vbo = map_ptr.vertex_data_ptr
        ibo = map_ptr.index_data_ptr

        for i in range(num_tiles):
            tile_index = <float>i
            tile_type = <float>((<uint32_t *>map_ptr.indices)[i])
            for j in range(6):
                index = 6 * i + j
                vbo_index = vbo + (index * v_fmt_ptr.stride)
                memcpy(vbo_index + 0, &quad_vertices[j], sizeof(Vec2C))
                memcpy(vbo_index + sizeof(Vec2C), &tile_index, sizeof(float))
                memcpy(vbo_index + sizeof(Vec2C) + sizeof(float), &tile_type, sizeof(float))
                ibo_index = ibo + (index * sizeof(uint32_t))
                memcpy(ibo_index, &index, sizeof(uint32_t))

        """
        import numpy as np
        import os
        np.set_printoptions(threshold=np.inf)
        vbo_data = np.array(<uint8_t[:vbo_size]>vbo, dtype=np.uint8)
        ibo_data = np.array(<uint8_t[:ibo_size]>ibo, dtype=np.uint8)
        print(vbo_data.view(np.float32).reshape((num_tiles, 6, 6)))
        print(ibo_data.view(np.uint32))
        os._exit(-1)
        """

        v_buffer.handle = map_ptr.vertex_buffer
        v_buffer.set_data(<uint8_t[:vbo_size]>vbo)
        i_buffer.handle = map_ptr.index_buffer
        i_buffer.set_data(<uint8_t[:ibo_size]>ibo)