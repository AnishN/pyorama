cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.gl cimport *
from pyorama.libs.sdl2 cimport *
#from pyorama.math3d cimport *
from pyorama.graphics.graphics_enums cimport *
from pyorama.graphics.graphics_structs cimport *

@cython.final
cdef class GraphicsManager:
    cdef:
        SDL_Window *root_window
        SDL_GLContext root_context
        ItemSlotMap vertex_formats
        ItemSlotMap vertex_buffers
        ItemSlotMap index_buffers
        ItemSlotMap uniform_formats
        ItemSlotMap uniforms
        ItemSlotMap shaders
        ItemSlotMap programs
        ItemSlotMap images
        ItemSlotMap textures
        ItemSlotMap views

    cdef VertexFormatC *vertex_format_get_ptr(self, Handle format) except *
    cpdef Handle vertex_format_create(self, list comps) except *
    cpdef void vertex_format_delete(self, Handle format) except *
    
    cdef VertexBufferC *vertex_buffer_get_ptr(self, Handle buffer) except *
    cpdef Handle vertex_buffer_create(self, Handle format, BufferUsage usage) except *
    cpdef void vertex_buffer_delete(self, Handle buffer) except *
    cpdef void vertex_buffer_set_data(self, Handle buffer, uint8_t[:] data) except *
    cpdef void vertex_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *
    
    cdef IndexBufferC *index_buffer_get_ptr(self, Handle buffer) except *
    cpdef Handle index_buffer_create(self, IndexFormat format, BufferUsage usage) except *
    cpdef void index_buffer_delete(self, Handle buffer) except *
    cpdef void index_buffer_set_data(self, Handle buffer, uint8_t[:] data) except *
    cpdef void index_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *
    cdef void _index_buffer_draw(self, Handle buffer) except *
    
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
    cpdef Handle image_create(self, uint16_t width, uint16_t height, uint8_t[:] data=*) except *
    cpdef Handle image_create_from_file(self, bytes file_path, bint flip_x=*, bint flip_y=*) except *
    cpdef void image_delete(self, Handle image) except *
    cpdef void image_set_data(self, Handle image, uint8_t[:] data=*) except *
    cpdef uint16_t image_get_width(self, Handle image) except *
    cpdef uint16_t image_get_height(self, Handle image) except *
    cpdef uint8_t[:] image_get_data(self, Handle image) except *

    cdef TextureC *texture_get_ptr(self, Handle texture) except *
    cpdef Handle texture_create(self, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*) except *
    cpdef void texture_delete(self, Handle texture) except *
    cpdef void texture_set_parameters(self, Handle texture, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*) except *
    cpdef void texture_set_image(self, Handle texture, Handle image) except *

    cdef ViewC *view_get_ptr(self, Handle view) except *
    cpdef Handle view_create(self) except *
    cpdef void view_delete(self, Handle view) except *
    cpdef void view_set_clear_flags(self, Handle view, uint32_t clear_flags) except *
    cpdef void view_set_clear_color(self, Handle view, Vec4 color) except *
    cpdef void view_set_clear_depth(self, Handle view, float depth) except *
    cpdef void view_set_clear_stencil(self, Handle view, uint32_t stencil) except *
    cpdef void view_set_program(self, Handle view, Handle program) except *
    cpdef void view_set_uniforms(self, Handle view, Handle[:] uniforms) except *
    cpdef void view_set_vertex_buffer(self, Handle view, Handle buffer) except *
    cpdef void view_set_index_buffer(self, Handle view, Handle buffer) except *
    cpdef void view_set_texture(self, Handle view, Handle texture, TextureUnit unit) except *

    cpdef void update(self) except *