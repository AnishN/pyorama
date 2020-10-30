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

        Uniform u_quad
        VertexBuffer quad_vbo
        IndexBuffer quad_ibo
        Handle quad_vs, quad_fs, quad_program

        readonly UniformFormat u_fmt_rect
        readonly UniformFormat u_fmt_quad
        readonly UniformFormat u_fmt_proj
        readonly UniformFormat u_fmt_view
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
        readonly IndexFormat i_fmt_quad
        readonly IndexFormat i_fmt_mesh
        readonly IndexFormat i_fmt_sprite
    
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
    cpdef Handle shader_create(self, ShaderType type, bytes source) except *
    cpdef Handle shader_create_from_file(self, ShaderType type, bytes file_path) except *
    cpdef void shader_delete(self, Handle shader) except *
    
    cdef ProgramC *program_get_ptr(self, Handle program) except *
    cpdef Handle program_create(self, Handle vertex, Handle fragment) except *
    cpdef void program_delete(self, Handle program) except *
    cdef void _program_compile(self, Handle program) except *
    cdef void _program_setup_attributes(self, Handle program) except *
    cdef void _program_setup_uniforms(self, Handle program) except *
    cdef void _program_bind_attributes(self, Handle program, Handle buffer) except *
    cdef void _program_unbind_attributes(self, Handle program) except *
    cdef void _program_bind_uniform(self, Handle program, Handle uniform) except *

    cdef ImageC *image_get_ptr(self, Handle image) except *
    cpdef Handle image_create(self, uint16_t width, uint16_t height, uint8_t[::1] data=*, size_t bytes_per_channel=*, size_t num_channels=*) except *
    cpdef Handle image_create_from_file(self, bytes file_path, bint flip_x=*, bint flip_y=*) except *
    cpdef void image_delete(self, Handle image) except *
    cpdef void image_set_data(self, Handle image, uint8_t[::1] data=*) except *
    cpdef uint16_t image_get_width(self, Handle image) except *
    cpdef uint16_t image_get_height(self, Handle image) except *
    cpdef uint8_t[::1] image_get_data(self, Handle image) except *

    cdef TextureC *texture_get_ptr(self, Handle texture) except *
    cpdef Handle texture_create(self, TextureFormat format=*, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*, bint cubemap=*) except *
    cpdef void texture_delete(self, Handle texture) except *
    cpdef void texture_set_parameters(self, Handle texture, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*) except *
    cpdef void texture_set_data_2d_from_image(self, Handle texture, Handle image) except *
    cpdef void texture_set_data_cubemap_from_images(self, Handle texture, 
            Handle image_pos_x, Handle image_neg_x, Handle image_pos_y,
            Handle image_neg_y, Handle image_pos_z, Handle image_neg_z) except *
    cpdef void texture_clear(self, Handle texture, uint16_t width, uint16_t height) except *

    cdef FrameBufferC *frame_buffer_get_ptr(self, Handle frame_buffer) except *
    cpdef Handle frame_buffer_create(self) except *
    cpdef void frame_buffer_delete(self, Handle frame_buffer) except *
    cpdef void frame_buffer_attach_textures(self, Handle frame_buffer, dict textures) except *

    cdef ViewC *view_get_ptr(self, Handle view) except *
    cpdef Handle view_create(self) except *
    cpdef void view_delete(self, Handle view) except *
    cpdef void view_set_clear_flags(self, Handle view, uint32_t clear_flags) except *
    cpdef void view_set_clear_color(self, Handle view, Vec4 color) except *
    cpdef void view_set_clear_depth(self, Handle view, float depth) except *
    cpdef void view_set_clear_stencil(self, Handle view, uint32_t stencil) except *
    cpdef void view_set_rect(self, Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    cpdef void view_set_program(self, Handle view, Handle program) except *
    cpdef void view_set_uniforms(self, Handle view, Handle[::1] uniforms) except *
    cpdef void view_set_vertex_buffer(self, Handle view, Handle buffer) except *
    cpdef void view_set_index_buffer(self, Handle view, Handle buffer) except *
    cpdef void view_set_textures(self, Handle view, dict textures) except *
    cpdef void view_set_frame_buffer(self, Handle view, Handle frame_buffer) except *
    
    cdef MeshC *mesh_get_ptr(self, Handle mesh) except *
    cpdef Handle mesh_create(self, uint8_t[::1] vertex_data, uint8_t[::1] index_data) except *
    cpdef Handle mesh_create_from_file(self, bytes file_path) except *
    cpdef void mesh_delete(self, Handle mesh) except *

    cdef MeshBatchC *mesh_batch_get_ptr(self, Handle batch) except *
    cpdef Handle mesh_batch_create(self) except *
    cpdef void mesh_batch_delete(self, Handle batch) except *
    cpdef void mesh_batch_set_meshes(self, Handle batch, Handle[::1] meshes) except *
    cpdef Handle mesh_batch_get_vertex_buffer(self, Handle batch) except *
    cpdef Handle mesh_batch_get_index_buffer(self, Handle batch) except *
    cdef void _mesh_batch_update(self, Handle batch) except *

    cdef SpriteC *sprite_get_ptr(self, Handle sprite) except *

    cdef SpriteBatchC *sprite_batch_get_ptr(self, Handle batch) except *
    cpdef Handle sprite_batch_create(self) except *
    cpdef void sprite_batch_delete(self, Handle batch) except *
    cpdef void sprite_batch_set_sprites(self, Handle batch, Handle[::1] sprites) except *
    cpdef Handle sprite_batch_get_vertex_buffer(self, Handle batch) except *
    cpdef Handle sprite_batch_get_index_buffer(self, Handle batch) except *
    cdef void _sprite_batch_update(self, Handle batch) except *

    cdef BitmapFontC *bitmap_font_get_ptr(self, Handle font) except *
    cpdef Handle bitmap_font_create_from_file(self, bytes file_path)
    cpdef void bitmap_font_delete(self, Handle font) except *
    cdef void _bitmap_font_parse_file(self, Handle font, bytes file_path) except *
    cdef dict _bitmap_font_parse_pairs(self, bytes line)
    cdef void _bitmap_font_parse_info(self, Handle font, dict pairs) except *
    cdef void _bitmap_font_parse_common(self, Handle font, dict pairs) except *
    cdef void _bitmap_font_parse_page(self, Handle font, dict pairs) except *
    cdef void _bitmap_font_parse_char(self, Handle font, size_t i, dict pairs) except *
    cdef void _bitmap_font_parse_kerning(self, Handle font, size_t i, dict pairs) except *
    cpdef Handle bitmap_font_get_page_texture(self, Handle font, size_t page_num) except *

    cdef TextC *text_get_ptr(self, Handle text) except *
    cpdef Handle text_create(self, Handle font, bytes data, Vec2 position, Vec4 color) except *
    cpdef void text_delete(self, Handle text) except *
    cdef void _text_update(self, Handle text) except *

    cdef void _swap_root_window(self) except *
    cpdef void update(self) except *