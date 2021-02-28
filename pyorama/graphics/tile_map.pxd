from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.texture_grid_atlas cimport *

cdef class TileMap:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef TileMapC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef TileMapC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef TileMapC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, TextureGridAtlas atlas, size_t tile_width, size_t tile_height, size_t num_rows, size_t num_columns) except *
    cpdef void delete(self) except *
    cpdef void set_indices(self, uint32_t[:] indices) except *
    cpdef VertexBuffer get_vertex_buffer(self)
    cpdef IndexBuffer get_index_buffer(self)
    cdef void _update(self) except *