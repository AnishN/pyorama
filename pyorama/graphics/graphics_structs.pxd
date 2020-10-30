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
    size_t bytes_per_channel#can be 1 (default), 2, 3, or 4
    size_t num_channels#can be 1, 2, 3, or 4 (default)
    size_t data_size
    uint8_t *data

ctypedef struct TextureC:
    Handle handle
    uint32_t gl_id
    bint mipmaps
    TextureFilter filter
    TextureWrap wrap_s
    TextureWrap wrap_t
    TextureFormat format
    bint cubemap

ctypedef struct FrameBufferC:
    Handle handle
    uint32_t gl_id
    Handle[8] textures
    FrameBufferAttachment[8] attachments
    size_t num_attachments

ctypedef struct MeshC:
    uint8_t *vertex_data
    size_t vertex_data_size
    uint8_t *index_data
    size_t index_data_size

ctypedef struct MeshBatchC:
    Handle handle
    uint16_t num_meshes
    Handle[65536] meshes
    Handle vertex_buffer
    Handle index_buffer
    Handle texture

ctypedef struct SpriteC:
    Handle handle
    float width
    float height
    Vec2C position
    Vec2C anchor
    float rotation
    Vec2C scale
    float z_index
    float[12] tex_coords
    bint visible
    Vec3C tint
    float alpha

ctypedef struct SpriteBatchC:
    Handle handle
    size_t num_sprites
    Handle *sprites
    Handle vertex_buffer
    uint8_t *vertex_data_ptr
    Handle index_buffer
    uint8_t *index_data_ptr
    Handle texture

ctypedef struct ViewC:
    Handle handle
    uint32_t clear_flags
    Vec4C clear_color
    float clear_depth
    uint32_t clear_stencil
    uint16_t[4] rect
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

ctypedef struct BitmapFontInfoC:
    char[256] face
    int size
    bint bold
    bint italic
    char[256] charset
    bint unicode
    int stretch_h
    bint smooth
    int aa
    int[4] padding
    int[2] spacing
    int outline

ctypedef struct BitmapFontCommonC:
    int line_height
    int base
    int scale_w, scale_h
    int num_pages
    bint packed
    BitmapFontCommonChannel alpha
    BitmapFontCommonChannel red
    BitmapFontCommonChannel green
    BitmapFontCommonChannel blue

ctypedef struct BitmapFontPageC:
    int id
    char[256] file_name
    Handle texture

ctypedef struct BitmapFontCharC:
    int id
    int x, y
    int width, height
    int offset_x, offset_y
    int advance_x
    int page
    BitmapFontCharChannel channel

ctypedef struct BitmapFontKerningC:
    int first
    int second
    int amount

ctypedef struct BitmapFontC:
    Handle handle
    BitmapFontInfoC info
    BitmapFontCommonC common
    BitmapFontPageC *pages
    size_t num_chars
    BitmapFontCharC *chars
    size_t num_kernings
    BitmapFontKerningC *kernings

ctypedef struct TextC:
    Handle handle
    Handle font
    char *data
    size_t data_length
    Vec2C position
    Vec4C color