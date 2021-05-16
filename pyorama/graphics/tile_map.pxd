from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.texture_grid_atlas cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.index_buffer cimport *

ctypedef struct TileMapC:
    Handle handle
    Handle atlas
    size_t tile_width
    size_t tile_height
    size_t num_rows
    size_t num_columns
    uint32_t *indices
    Handle vertex_buffer
    uint8_t *vertex_data_ptr
    Handle index_buffer
    uint8_t *index_data_ptr

cdef class TileMap:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    cdef TileMapC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, TextureGridAtlas atlas, size_t tile_width, size_t tile_height, size_t num_rows, size_t num_columns) except *
    cpdef void delete(self) except *
    cpdef void set_indices(self, uint32_t[:] indices) except *
    cpdef VertexBuffer get_vertex_buffer(self)
    cpdef IndexBuffer get_index_buffer(self)
    cdef void c_update(self) except *