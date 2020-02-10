cimport cython
from cpython.ref cimport *
from pyorama.core.item cimport *
from pyorama.core.item_hash_map cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.gl cimport *
from pyorama.libs.sdl2 cimport *

from pyorama.math3d.common cimport *
from pyorama.math3d.vec2 cimport *
from pyorama.math3d.vec3 cimport *
from pyorama.math3d.vec4 cimport *
from pyorama.math3d.quat cimport *
from pyorama.math3d.mat2 cimport *
from pyorama.math3d.mat3 cimport *
from pyorama.math3d.mat4 cimport *

ctypedef struct WindowC:
    uint32_t id
    int width
    int height
    char *title
    size_t title_len

"""
ctypedef struct TransformC:
    Vec3C translation
    QuatC rotation
    Vec3C scale
"""

ctypedef struct Camera3dC:
    float fovy
    float aspect
    float near
    float far

    Vec3C forward
    Vec3C up
    Vec3C right
    Vec3C position
    Vec3C target

"""
ctypedef struct Camera2dC:
    float left
    float right
    float bottom
    float top
    float near
    float far
pan
zoom
"""

ctypedef struct ImageC:
    int width
    int height
    uint8_t *pixels

cpdef enum SamplerFilter:
    SAMPLER_FILTER_NEAREST = 9728
    SAMPLER_FILTER_LINEAR = 9729
    SAMPLER_FILTER_NEAREST_MIPMAP_NEAREST = 9984
    SAMPLER_FILTER_LINEAR_MIPMAP_NEAREST = 9985
    SAMPLER_FILTER_NEAREST_MIPMAP_LINEAR = 9986
    SAMPLER_FILTER_LINEAR_MIPMAP_LINEAR = 9987

cpdef enum SamplerWrap:
    SAMPLER_WRAP_CLAMP_TO_EDGE = 33071
    SAMPLER_WRAP_MIRRORED_REPEAT = 33648
    SAMPLER_WRAP_REPEAT = 10497

ctypedef struct SamplerC:
    SamplerFilter mag_filter
    SamplerFilter min_filter
    SamplerWrap wrap_s
    SamplerWrap wrap_t

ctypedef struct TextureC:
    uint32_t id
    Handle sampler
    Handle image

cpdef enum MathType:
    MATH_TYPE_FLOAT = GL_FLOAT
    MATH_TYPE_VEC2 = GL_FLOAT_VEC2
    MATH_TYPE_VEC3 = GL_FLOAT_VEC3
    MATH_TYPE_VEC4 = GL_FLOAT_VEC4
    MATH_TYPE_MAT2 = GL_FLOAT_MAT2
    MATH_TYPE_MAT3 = GL_FLOAT_MAT3
    MATH_TYPE_MAT4 = GL_FLOAT_MAT4

ctypedef struct AttributeC:
    uint32_t index
    MathType type
    size_t size
    size_t offset

ctypedef struct UniformC:
    uint32_t index
    MathType type
    size_t size

ctypedef struct MeshC:
    float *vertices_data
    size_t vertices_length
    uint32_t *indices_data
    size_t indices_length

ctypedef struct ModelC:
    Handle mesh
    Vec3C translation
    QuatC rotation
    Vec3C scale

ctypedef struct ModelBatchC:
    uint32_t vao_id
    uint32_t vbo_id
    uint32_t ibo_id
    uint32_t tbo_id
    uint32_t tbo_tex_id
    float *vertices_data
    size_t vertices_length
    uint32_t *indices_data
    size_t indices_length
    float *transform_data
    size_t transform_length
    size_t num_models

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT

ctypedef struct ShaderC:
    uint32_t id
    ShaderType type
    char *source
    size_t source_length

ctypedef struct ProgramC:
    uint32_t id
    Handle vs
    Handle fs
    size_t num_uniforms
    PyObject *uniform_map
    UniformC uniform_info[16]

ctypedef struct MaterialC:
    char *name
    size_t name_length
    Vec4C ambient
    Vec4C diffuse
    Vec4C specular
    float shininess

ctypedef struct NodeC:
    Mat4C local
    Mat4C world
    Handle parent
    Handle first_child
    Handle next_sibling
    Handle prev_sibling

@cython.final
cdef class GraphicsManager:
    cdef SDL_Window *root_window
    cdef SDL_GLContext root_context

    cdef ItemSlotMap windows
    cdef ItemSlotMap cameras_3d
    cdef ItemSlotMap images
    cdef ItemSlotMap samplers
    cdef ItemSlotMap textures
    cdef ItemSlotMap meshes
    cdef ItemSlotMap models
    cdef ItemSlotMap model_batches
    cdef ItemSlotMap shaders
    cdef ItemSlotMap programs
    cdef ItemSlotMap materials
    cdef ItemSlotMap nodes