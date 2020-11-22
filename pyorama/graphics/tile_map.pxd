from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.texture_grid_atlas cimport *

cdef class TileMap:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics
    
    cdef TileMapC *get_ptr(self) except *
    cpdef void create(self, TextureGridAtlas atlas, size_t tile_width, size_t tile_height, size_t num_rows, size_t num_columns) except *
    cpdef void delete(self) except *
    cpdef void set_indices(self, uint32_t[:] indices) except *
    cpdef VertexBuffer get_vertex_buffer(self)
    cpdef IndexBuffer get_index_buffer(self)
    cdef void _update(self) except *