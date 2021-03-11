cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_manager cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.assimp cimport *
from pyorama.libs.gles2 cimport *
from pyorama.libs.sdl2 cimport *
#from pyorama.math3d cimport *

from pyorama.graphics.program cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.uniform cimport *
from pyorama.graphics.uniform_format cimport *
from pyorama.graphics.vertex_format cimport *
from pyorama.graphics.vertex_buffer cimport *

@cython.final
cdef class GraphicsManager(ItemManager):
    cdef:
        SDL_Window *root_window
        SDL_GLContext root_context

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
    
    cdef uint8_t c_register_graphics_item_types(self) except *
    cdef void c_check_gl(self) except *
    cdef void c_check_gl_extensions(self) except *
    cdef void c_create_predefined_uniform_formats(self) except *
    cdef void c_delete_predefined_uniform_formats(self) except *
    cdef void c_create_predefined_vertex_index_formats(self) except *
    cdef void c_delete_predefined_vertex_index_formats(self) except *
    cdef void c_create_quad(self) except *
    cdef void c_delete_quad(self) except *
    cdef void c_swap_root_window(self) except *
    cdef void c_update_batches(self) except *
    cdef void c_update_windows(self) except *
    cdef void c_bind_view_textures(self, Handle view) except *
    cdef void c_unbind_view_textures(self, Handle view) except *
    cdef void c_view_clear(self, Handle view) except *
    cpdef void update(self) except *