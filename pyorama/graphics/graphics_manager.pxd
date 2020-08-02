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

@cython.final
cdef class GraphicsManager:
    cdef:
        SDL_Window *root_window
        SDL_GLContext root_context
        ItemSlotMap windows
        ItemSlotMap vertex_formats
        ItemSlotMap vertex_buffers
        ItemSlotMap index_buffers
        ItemSlotMap meshes
        ItemSlotMap uniform_formats
        ItemSlotMap uniforms
        ItemSlotMap shaders
        ItemSlotMap programs
        ItemSlotMap images
        ItemSlotMap textures
        ItemSlotMap frame_buffers
        ItemSlotMap views

        Handle u_quad
        Handle quad_vbo, quad_ibo
        Handle quad_vs, quad_fs, quad_program

        readonly Handle u_fmt_quad
        readonly Handle u_fmt_proj
        readonly Handle u_fmt_view
        readonly Handle u_fmt_texture_0
        readonly Handle u_fmt_texture_1
        readonly Handle u_fmt_texture_2
        readonly Handle u_fmt_texture_3
        readonly Handle u_fmt_texture_4
        readonly Handle u_fmt_texture_5
        readonly Handle u_fmt_texture_6
        readonly Handle u_fmt_texture_7

        readonly Handle v_fmt_quad
        readonly Handle v_fmt_mesh
        readonly IndexFormat i_fmt_quad
        readonly IndexFormat i_fmt_mesh

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
    cpdef Handle window_create(self, uint16_t width, uint16_t height, bytes title) except *
    cpdef void window_delete(self, Handle window) except *
    cpdef void window_set_texture(self, Handle window, Handle texture) except *

    cdef VertexFormatC *vertex_format_get_ptr(self, Handle format) except *
    cpdef Handle vertex_format_create(self, list comps) except *
    cpdef void vertex_format_delete(self, Handle format) except *
    
    cdef VertexBufferC *vertex_buffer_get_ptr(self, Handle buffer) except *
    cpdef Handle vertex_buffer_create(self, Handle format, BufferUsage usage=*) except *
    cpdef void vertex_buffer_delete(self, Handle buffer) except *
    cpdef void vertex_buffer_set_data(self, Handle buffer, uint8_t[:] data) except *
    cpdef void vertex_buffer_set_data_from_mesh(self, Handle buffer, Handle mesh) except *
    cpdef void vertex_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *
    cpdef void vertex_buffer_set_sub_data_from_mesh(self, Handle buffer, Handle mesh, size_t offset) except *
    
    cdef IndexBufferC *index_buffer_get_ptr(self, Handle buffer) except *
    cpdef Handle index_buffer_create(self, IndexFormat format, BufferUsage usage=*) except *
    cpdef void index_buffer_delete(self, Handle buffer) except *
    cpdef void index_buffer_set_data(self, Handle buffer, uint8_t[:] data) except *
    cpdef void index_buffer_set_data_from_mesh(self, Handle buffer, Handle mesh) except *
    cpdef void index_buffer_set_sub_data_from_mesh(self, Handle buffer, Handle mesh, size_t offset) except *
    cpdef void index_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *
    cdef void _index_buffer_draw(self, Handle buffer) except *
    
    cdef MeshC *mesh_get_ptr(self, Handle mesh) except *
    cpdef Handle mesh_create(self, uint8_t[:] vertex_data, uint8_t[:] index_data) except *
    cpdef Handle mesh_create_from_file(self, bytes file_path) except *
    cpdef void mesh_delete(self, Handle mesh) except *

    cdef UniformFormatC *uniform_format_get_ptr(self, Handle format) except *
    cpdef Handle uniform_format_create(self, bytes name, UniformType type, size_t count=*) except *
    cpdef void uniform_format_delete(self, Handle format) except *

    cdef UniformC *uniform_get_ptr(self, Handle uniform) except *
    cpdef Handle uniform_create(self, Handle format) except *
    cpdef void uniform_delete(self, Handle uniform) except *
    cpdef void uniform_set_data(self, Handle uniform, object data, size_t index=*) except *

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
    cpdef Handle image_create(self, uint16_t width, uint16_t height, uint8_t[:] data=*, size_t bytes_per_channel=*, size_t num_channels=*) except *
    cpdef Handle image_create_from_file(self, bytes file_path, bint flip_x=*, bint flip_y=*) except *
    cpdef void image_delete(self, Handle image) except *
    cpdef void image_set_data(self, Handle image, uint8_t[:] data=*) except *
    cpdef uint16_t image_get_width(self, Handle image) except *
    cpdef uint16_t image_get_height(self, Handle image) except *
    cpdef uint8_t[:] image_get_data(self, Handle image) except *

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
    cpdef void view_set_uniforms(self, Handle view, Handle[:] uniforms) except *
    cpdef void view_set_vertex_buffer(self, Handle view, Handle buffer) except *
    cpdef void view_set_index_buffer(self, Handle view, Handle buffer) except *
    cpdef void view_set_textures(self, Handle view, dict textures) except *
    cpdef void view_set_frame_buffer(self, Handle view, Handle frame_buffer) except *
    
    cpdef void update(self) except *