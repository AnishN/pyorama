cimport cython
from cpython.ref cimport *
from pyorama.core.item cimport *
from pyorama.core.item_hash_map cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.gl cimport *
from pyorama.libs.sdl2 cimport *
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
    MATH_TYPE_FLOAT
    MATH_TYPE_VEC2
    MATH_TYPE_VEC3
    MATH_TYPE_VEC4
    MATH_TYPE_MAT2
    MATH_TYPE_MAT3
    MATH_TYPE_MAT4

ctypedef struct MeshAttributeC:
    uint32_t index
    MathType type
    size_t size
    size_t offset

ctypedef struct MeshFormatC:
    size_t num_attributes
    PyObject *attribute_map
    MeshAttributeC attribute_info[16]
    size_t stride

ctypedef struct MeshC:
    Handle format
    float *data
    size_t length

ctypedef struct MeshBatchC:
    uint32_t vao_id
    uint32_t vbo_id
    Handle format
    Handle *meshes
    size_t num_meshes
    float *data
    size_t length

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

@cython.final
cdef class GraphicsManager:
    cdef SDL_Window *root_window
    cdef SDL_GLContext root_context

    cdef ItemSlotMap windows
    cdef ItemSlotMap images
    cdef ItemSlotMap samplers
    cdef ItemSlotMap textures
    cdef ItemSlotMap mesh_formats
    cdef ItemSlotMap meshes
    cdef ItemSlotMap mesh_batches
    cdef ItemSlotMap shaders
    cdef ItemSlotMap programs
    
    cdef WindowC *c_window_get_ptr(self, Handle window) except *
    cdef ImageC *c_image_get_ptr(self, Handle image) except *
    cdef SamplerC *c_sampler_get_ptr(self, Handle sampler) except *
    cdef TextureC *c_texture_get_ptr(self, Handle texture) except *
    cdef MeshFormatC *c_mesh_format_get_ptr(self, Handle mesh_format) except *
    cdef MeshC *c_mesh_get_ptr(self, Handle mesh) except *
    cdef MeshBatchC *c_mesh_batch_get_ptr(self, Handle mesh_batch) except *
    cdef ShaderC *c_shader_get_ptr(self, Handle shader) except *
    cdef ProgramC *c_program_get_ptr(self, Handle program) except *