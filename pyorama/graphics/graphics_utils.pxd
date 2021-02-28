from pyorama.graphics.view cimport *
from pyorama.libs.c cimport *
from pyorama.libs.assimp cimport *
from pyorama.libs.gles2 cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.graphics.buffer_enums cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.view cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.program_enums cimport *

cdef uint32_t c_buffer_usage_to_gl(BufferUsage usage) nogil
cdef size_t c_index_format_get_size(IndexFormat format) nogil
cdef uint32_t c_index_format_to_gl(IndexFormat format) nogil
cdef size_t c_uniform_type_get_size(UniformType type) nogil
cdef uint32_t c_shader_type_to_gl(ShaderType type) nogil
cdef uint32_t c_vertex_comp_type_to_gl(VertexCompType type) nogil
cdef size_t c_vertex_comp_type_get_size(VertexCompType type) nogil
cdef uint32_t c_texture_filter_to_gl(TextureFilter filter, bint mipmaps) nogil
cdef uint32_t c_texture_wrap_to_gl(TextureWrap wrap) nogil
cdef AttributeType c_attribute_type_from_gl(uint32_t gl_type) except *
cdef UniformType c_uniform_type_from_gl(uint32_t gl_type) except *
cdef void c_image_data_flip_x(uint16_t width, uint16_t height, uint8_t *data) nogil
cdef void c_image_data_flip_y(uint16_t width, uint16_t height, uint8_t *data) nogil
cdef void c_image_data_premultiply_alpha(uint16_t width, uint16_t height, uint8_t *data) nogil
cdef uint32_t c_clear_flags_to_gl(uint32_t flags) nogil
cdef uint32_t c_texture_unit_to_gl(TextureUnit unit)
cdef uint32_t c_frame_buffer_attachment_to_gl(FrameBufferAttachment attachment) nogil
cdef uint32_t c_texture_format_to_internal_format_gl(TextureFormat format) nogil
cdef uint32_t c_texture_format_to_format_gl(TextureFormat format) nogil
cdef uint32_t c_texture_format_to_type_gl(TextureFormat format) nogil
cdef uint32_t c_blend_func_to_gl(BlendFunc func) nogil
cdef uint32_t c_depth_func_to_gl(DepthFunc func) nogil