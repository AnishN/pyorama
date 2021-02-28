ctypedef TileMapC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class TileMap:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return TileMap.get_ptr_by_handle(self.manager, self.handle)
    
    @staticmethod
    cdef uint8_t c_get_type() nogil:
        return ITEM_TYPE

    @staticmethod
    def get_type():
        return ITEM_TYPE

    @staticmethod
    cdef size_t c_get_size() nogil:
        return ITEM_SIZE

    @staticmethod
    def get_size():
        return ITEM_SIZE

    cpdef void create(self, TextureGridAtlas atlas, size_t tile_width, size_t tile_height, size_t num_rows, size_t num_columns) except *:
        cdef:
            TileMapC *map_ptr
            VertexBuffer vbo = VertexBuffer(self.manager)
            IndexBuffer ibo = IndexBuffer(self.manager)
            size_t num_tiles

        self.handle = self.manager.create(ITEM_TYPE)
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
        v_fmt_ptr = VertexFormat.get_ptr_by_handle(self.manager, self.manager.v_fmt_sprite.handle)
        vbo.create(self.manager.v_fmt_tile, usage=BUFFER_USAGE_DYNAMIC)
        vbo_size = v_fmt_ptr.stride * 6 * num_tiles
        map_ptr.vertex_buffer = vbo.handle
        map_ptr.vertex_data_ptr = <uint8_t *>calloc(1, vbo_size)
        if map_ptr.vertex_data_ptr == NULL:
            raise MemoryError("TileMap: cannot allocate vertex data")
        
        ibo.create(self.manager.i_fmt_tile, usage=BUFFER_USAGE_DYNAMIC)
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
        self.manager.delete(self.handle)
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
            VertexBuffer out = VertexBuffer(self.manager)
        map_ptr = self.get_ptr()
        out.handle = map_ptr.vertex_buffer
        return out

    cpdef IndexBuffer get_index_buffer(self):
        cdef:
            TileMapC *batch_ptr
            IndexBuffer out = IndexBuffer(self.manager)
        map_ptr = self.get_ptr()
        out.handle = map_ptr.index_buffer
        return out

    cdef void _update(self) except *:
        cdef:
            TileMapC *map_ptr
            size_t i, j, index
            size_t num_tiles
            Vec2C[6] quad_vertices
            VertexBuffer v_buffer = VertexBuffer(self.manager)
            IndexBuffer i_buffer = IndexBuffer(self.manager)
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
        v_fmt_ptr = self.manager.v_fmt_tile.get_ptr()
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