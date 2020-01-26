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

ctypedef struct TransformC:
    Vec3C translation
    QuatC rotation
    Vec3C scale

cpdef enum CameraType:
    CAMERA_ORTHOGRAPHIC
    CAMERA_PERSPECTIVE

ctypedef struct CameraC:
    CameraType type
    float z_near
    float z_far
    TransformC transform

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

@cython.final
cdef class GraphicsManager:
    cdef SDL_Window *root_window
    cdef SDL_GLContext root_context

    cdef ItemSlotMap windows
    cdef ItemSlotMap images
    cdef ItemSlotMap samplers
    cdef ItemSlotMap textures
    cdef ItemSlotMap meshes
    cdef ItemSlotMap models
    cdef ItemSlotMap model_batches
    cdef ItemSlotMap shaders
    cdef ItemSlotMap programs
    
    cdef WindowC *c_window_get_ptr(self, Handle window) except *
    cdef ImageC *c_image_get_ptr(self, Handle image) except *
    cdef SamplerC *c_sampler_get_ptr(self, Handle sampler) except *
    cdef TextureC *c_texture_get_ptr(self, Handle texture) except *
    cdef MeshC *c_mesh_get_ptr(self, Handle mesh) except *
    cdef ModelC *c_model_get_ptr(self, Handle model) except *
    cdef ModelBatchC *c_model_batch_get_ptr(self, Handle model_batch) except *
    cdef ShaderC *c_shader_get_ptr(self, Handle shader) except *
    cdef ProgramC *c_program_get_ptr(self, Handle program) except *