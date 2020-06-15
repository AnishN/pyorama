cimport cython
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.gl cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.math3d cimport *

ctypedef enum RendererItemType:
    RENDERER_ITEM_TYPE_VERTEX_FORMAT
    RENDERER_ITEM_TYPE_VERTEX_BUFFER
    RENDERER_ITEM_TYPE_INDEX_BUFFER
    RENDERER_ITEM_TYPE_SHADER
    RENDERER_ITEM_TYPE_PROGRAM
    RENDERER_ITEM_TYPE_IMAGE
    RENDERER_ITEM_TYPE_TEXTURE
    RENDERER_ITEM_TYPE_VIEW

"""
ctypedef enum DepthTest:
    DEPTH_TEST_NONE
    DEPTH_TEST_NEVER
    DEPTH_TEST_LESS
    DEPTH_TEST_EQUAL
    DEPTH_TEST_LEQUAL
    DEPTH_TEST_GREATER
    DEPTH_TEST_NOTEQUAL
    DEPTH_TEST_GEQUAL
    DEPTH_TEST_ALWAYS

ctypedef struct RenderRectC:
    uint16_t x
    uint16_t y
    uint16_t w
    uint16_t h

ctypedef enum DrawMode:
    DRAW_MODE_TRIANGLE
    DRAW_MODE_POINT
    DRAW_MODE_LINE
    DRAW_MODE_LINE_STRIP
    DRAW_MODE_LINE_LOOP
    DRAW_MODE_TRIANGLE_STRIP
    DRAW_MODE_TRIANGLE_FAN
"""

cpdef enum BufferUsage:
    BUFFER_USAGE_STATIC
    BUFFER_USAGE_DYNAMIC
    BUFFER_USAGE_STREAM

cpdef enum VertexCompType:
    VERTEX_COMP_TYPE_F32
    VERTEX_COMP_TYPE_I8
    VERTEX_COMP_TYPE_U8
    VERTEX_COMP_TYPE_I16
    VERTEX_COMP_TYPE_U16

ctypedef struct VertexCompC:
    Handle handle
    Attribute attribute
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

cpdef enum IndexFormat:
    INDEX_FORMAT_U8
    INDEX_FORMAT_U16
    INDEX_FORMAT_U32

ctypedef struct IndexBufferC:
    Handle handle
    uint32_t gl_id
    IndexFormat format
    BufferUsage usage
    size_t size

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT

ctypedef struct ShaderC:
    Handle handle
    uint32_t gl_id
    ShaderType type

cpdef enum Attribute:
    ATTRIBUTE_POSITION
    ATTRIBUTE_NORMAL
    ATTRIBUTE_TANGENT
    ATTRIBUTE_BITANGENT
    ATTRIBUTE_COLOR_0
    ATTRIBUTE_COLOR_1
    ATTRIBUTE_COLOR_2
    ATTRIBUTE_COLOR_3
    ATTRIBUTE_INDICES
    ATTRIBUTE_WEIGHT
    ATTRIBUTE_TEX_COORD_0
    ATTRIBUTE_TEX_COORD_1
    ATTRIBUTE_TEX_COORD_2
    ATTRIBUTE_TEX_COORD_3
    ATTRIBUTE_TEX_COORD_4
    ATTRIBUTE_TEX_COORD_5
    ATTRIBUTE_TEX_COORD_6
    ATTRIBUTE_TEX_COORD_7

cdef enum:
    ATTRIBUTE_COUNT = 18

cdef extern from *:
    """
    char *attribute_names[] = {
        "a_position",
        "a_normal",
        "a_tangent",
        "a_bitangent",
        "a_color_0",
        "a_color_1",
        "a_color_2",
        "a_color_3",
        "a_indices",
        "a_weight",
        "a_tex_coord_0",
        "a_tex_coord_1",
        "a_tex_coord_2",
        "a_tex_coord_3",
        "a_tex_coord_4",
        "a_tex_coord_5",
        "a_tex_coord_6",
        "a_tex_coord_7",
    };
    """
    cdef char **attribute_names

cpdef enum UniformType:
    UNIFORM_TYPE_INT
    UNIFORM_TYPE_FLOAT
    UNIFORM_TYPE_VEC2
    UNIFORM_TYPE_VEC3
    UNIFORM_TYPE_VEC4
    UNIFORM_TYPE_MAT2
    UNIFORM_TYPE_MAT3
    UNIFORM_TYPE_MAT4

#attributes = used attribute enums (densely packed at front)
#attributes maxes at 16 since this is the minimum guaranteed by OpenGL
#attribute_locations maxes at ATTRIBUTE_COUNT = 18
ctypedef struct ProgramC:
    Handle handle
    uint32_t gl_id
    Handle vertex
    Handle fragment
    size_t num_attributes
    Attribute[16] attributes
    size_t[18] attribute_locations

ctypedef struct ImageC:
    Handle handle
    uint16_t width
    uint16_t height
    size_t data_size
    uint8_t *data

cpdef enum TextureFilter:
    TEXTURE_FILTER_NEAREST
    TEXTURE_FILTER_LINEAR

cpdef enum TextureWrap:
    TEXTURE_WRAP_REPEAT
    TEXTURE_WRAP_MIRRORED_REPEAT
    TEXTURE_WRAP_CLAMP_TO_EDGE

ctypedef struct TextureC:
    Handle handle
    uint32_t gl_id
    bint mipmaps
    TextureFilter filter
    TextureWrap wrap_s
    TextureWrap wrap_t

cpdef enum ViewClear:
    VIEW_CLEAR_COLOR = (1 << 0)
    VIEW_CLEAR_DEPTH = (1 << 1)
    VIEW_CLEAR_STENCIL = (1 << 2)

ctypedef struct ViewC:
    Handle handle
    uint32_t clear_flags
    ColorC clear_color
    float clear_depth
    uint32_t clear_stencil
    Mat4C view
    Mat4C projection

@cython.final
cdef class GraphicsManager:
    cdef:
        SDL_Window *root_window
        SDL_GLContext root_context
        ItemSlotMap vertex_formats
        ItemSlotMap vertex_buffers
        ItemSlotMap index_buffers
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
    cpdef void view_set_clear_color(self, Handle view, Color color) except *
    cpdef void view_set_clear_depth(self, Handle view, float depth) except *
    cpdef void view_set_clear_stencil(self, Handle view, uint32_t stencil) except *

    cpdef void update(self) except *