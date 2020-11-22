cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.assimp cimport *
from pyorama.libs.gles2 cimport *
from pyorama.libs.sdl2 cimport *
#from pyorama.math3d cimport *
from pyorama.graphics.graphics_enums cimport *
from pyorama.graphics.graphics_structs cimport *
from pyorama.graphics.graphics_utils cimport *

from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.sprite_batch cimport *
from pyorama.graphics.tile_map cimport *
from pyorama.graphics.uniform cimport *
from pyorama.graphics.uniform_format cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.vertex_format cimport *
from pyorama.graphics.window cimport *

@cython.final
cdef class GraphicsManager:
    cdef:
        SDL_Window *root_window
        SDL_GLContext root_context
        ItemSlotMap windows
        ItemSlotMap vertex_formats
        ItemSlotMap vertex_buffers
        ItemSlotMap index_buffers
        ItemSlotMap uniform_formats
        ItemSlotMap uniforms
        ItemSlotMap shaders
        ItemSlotMap programs
        ItemSlotMap images
        ItemSlotMap textures
        ItemSlotMap frame_buffers
        ItemSlotMap views
        ItemSlotMap meshes
        ItemSlotMap mesh_batches
        ItemSlotMap sprites
        ItemSlotMap sprite_batches
        ItemSlotMap bitmap_fonts
        ItemSlotMap texts
        ItemSlotMap texture_grid_atlases
        ItemSlotMap tile_maps

        Uniform u_quad
        VertexBuffer quad_vbo
        IndexBuffer quad_ibo
        Shader quad_vs
        Shader quad_fs
        Program quad_program

        readonly UniformFormat u_fmt_rect
        readonly UniformFormat u_fmt_quad
        readonly UniformFormat u_fmt_proj
        readonly UniformFormat u_fmt_view
        readonly UniformFormat u_fmt_tile_map_size
        readonly UniformFormat u_fmt_tile_size
        readonly UniformFormat u_fmt_atlas_size
        readonly UniformFormat u_fmt_texture_0
        readonly UniformFormat u_fmt_texture_1
        readonly UniformFormat u_fmt_texture_2
        readonly UniformFormat u_fmt_texture_3
        readonly UniformFormat u_fmt_texture_4
        readonly UniformFormat u_fmt_texture_5
        readonly UniformFormat u_fmt_texture_6
        readonly UniformFormat u_fmt_texture_7

        readonly VertexFormat v_fmt_quad
        readonly VertexFormat v_fmt_mesh
        readonly VertexFormat v_fmt_sprite
        readonly VertexFormat v_fmt_tile
        readonly IndexFormat i_fmt_quad
        readonly IndexFormat i_fmt_mesh
        readonly IndexFormat i_fmt_sprite
        readonly IndexFormat i_fmt_tile
    
    cdef void c_check_gl(self) except *
    cdef void c_check_gl_extensions(self) except *
    cdef void c_create_slot_maps(self) except *
    cdef void c_delete_slot_maps(self) except *
    cdef void c_create_predefined_uniform_formats(self) except *
    cdef void c_delete_predefined_uniform_formats(self) except *
    cdef void c_create_predefined_vertex_index_formats(self) except *
    cdef void c_delete_predefined_vertex_index_formats(self) except *
    cdef void c_create_quad(self) except *
    cdef void c_delete_quad(self) except *

    cdef WindowC *window_get_ptr(self, Handle window) except *
    cdef VertexFormatC *vertex_format_get_ptr(self, Handle format) except *
    cdef VertexBufferC *vertex_buffer_get_ptr(self, Handle buffer) except *
    cdef IndexBufferC *index_buffer_get_ptr(self, Handle buffer) except *
    cdef UniformFormatC *uniform_format_get_ptr(self, Handle format) except *
    cdef UniformC *uniform_get_ptr(self, Handle uniform) except *
    cdef ShaderC *shader_get_ptr(self, Handle shader) except *
    cdef ProgramC *program_get_ptr(self, Handle program) except *
    cdef ImageC *image_get_ptr(self, Handle image) except *
    cdef TextureC *texture_get_ptr(self, Handle texture) except *
    cdef FrameBufferC *frame_buffer_get_ptr(self, Handle frame_buffer) except *
    cdef ViewC *view_get_ptr(self, Handle view) except *
    cdef MeshC *mesh_get_ptr(self, Handle mesh) except *
    cdef MeshBatchC *mesh_batch_get_ptr(self, Handle batch) except *
    cdef SpriteC *sprite_get_ptr(self, Handle sprite) except *
    cdef SpriteBatchC *sprite_batch_get_ptr(self, Handle batch) except *
    cdef BitmapFontC *bitmap_font_get_ptr(self, Handle font) except *
    cdef TextC *text_get_ptr(self, Handle text) except *
    cdef TextureGridAtlasC *texture_grid_atlas_get_ptr(self, Handle atlas) except *
    cdef TileMapC *tile_map_get_ptr(self, Handle tile_map) except *

    cdef void c_swap_root_window(self) except *
    cpdef void update(self) except *