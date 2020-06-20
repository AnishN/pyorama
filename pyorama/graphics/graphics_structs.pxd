from pyorama.core.handle cimport *
from pyorama.libs.c cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.math3d cimport *
from pyorama.graphics.graphics_enums cimport *

ctypedef struct WindowC:
    Handle handle
    SDL_Window *sdl_ptr
    uint16_t width
    uint16_t height
    char[256] title
    size_t title_length
    Handle texture

ctypedef struct VertexCompC:
    Handle handle
    char[256] name
    size_t name_length
    VertexCompType type
    size_t count
    bint normalized
    size_t offset

ctypedef struct VertexFormatC:
    Handle handle
    VertexCompC[16] comps
    size_t count
    size_t stride

ctypedef struct VertexBufferC:
    Handle handle
    uint32_t gl_id
    Handle format
    BufferUsage usage
    size_t size

ctypedef struct IndexBufferC:
    Handle handle
    uint32_t gl_id
    IndexFormat format
    BufferUsage usage
    size_t size

ctypedef struct MeshC:
    Handle vertex_format
    uint8_t *vertex_data
    size_t vertex_data_size
    IndexFormat index_format
    uint8_t *index_data
    size_t index_data_size

ctypedef struct UniformFormatC:
    Handle handle
    char[256] name
    size_t name_length
    UniformType type
    size_t count
    size_t size

ctypedef struct UniformC:
    Handle handle
    Handle format
    uint8_t *data

ctypedef struct ShaderC:
    Handle handle
    uint32_t gl_id
    ShaderType type

#Part of ProgramC, not directly created!
ctypedef struct ProgramAttributeC:
    char[256] name
    size_t name_length
    size_t size#in multiples of the type's size
    AttributeType type
    size_t location

#Part of ProgramC, not directly create!
ctypedef struct ProgramUniformC:
    char[256] name
    size_t name_length
    size_t size
    UniformType type
    size_t location

ctypedef struct ProgramC:
    Handle handle
    uint32_t gl_id
    Handle vertex
    Handle fragment
    ProgramAttributeC[16] attributes
    size_t num_attributes
    ProgramUniformC[16] uniforms
    size_t num_uniforms

ctypedef struct ImageC:
    Handle handle
    uint16_t width
    uint16_t height
    size_t data_size
    uint8_t *data

ctypedef struct TextureC:
    Handle handle
    uint32_t gl_id
    bint mipmaps
    TextureFilter filter
    TextureWrap wrap_s
    TextureWrap wrap_t

ctypedef struct FrameBufferC:
    Handle handle
    uint32_t gl_id
    Handle[8] textures
    FrameBufferAttachment[8] attachments
    size_t num_attachments

ctypedef struct ViewC:
    Handle handle
    uint32_t clear_flags
    Vec4C clear_color
    float clear_depth
    uint32_t clear_stencil
    Mat4C view_mat
    Mat4C proj_mat
    Handle program
    Handle[16] uniforms
    size_t num_uniforms
    Handle vertex_buffer
    Handle index_buffer
    Handle[16] textures
    TextureUnit[16] texture_units
    size_t num_texture_units
    Handle frame_buffer