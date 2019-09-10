from pyorama.core.handle cimport *
from pyorama.core.item_vector cimport *
from pyorama.math3d.common cimport *

ctypedef struct BufferC:
    char *bytes
    size_t byte_length

cpdef enum BufferViewTarget:
    BUFFER_VIEW_TARGET_NONE = 0
    BUFFER_VIEW_TARGET_ARRAY_BUFFER = 34962
    BUFFER_VIEW_TARGET_ELEMENT_ARRAY_BUFFER = 34963

ctypedef struct BufferViewC:
    Handle buffer#handle to a struct Buffer
    size_t byte_offset
    size_t byte_length
    BufferViewTarget target

cpdef enum AccessorComponentType:
    ACCESSOR_COMPONENT_TYPE_BYTE = 5120
    ACCESSOR_COMPONENT_TYPE_UNSIGNED_BYTE = 5121
    ACCESSOR_COMPONENT_TYPE_SHORT = 5122
    ACCESSOR_COMPONENT_TYPE_UNSIGNED_SHORT = 5123
    ACCESSOR_COMPONENT_TYPE_INT = 5124#NOT included in online glTF schema!
    ACCESSOR_COMPONENT_TYPE_UNSIGNED_INT = 5125
    ACCESSOR_COMPONENT_TYPE_FLOAT = 5126

cpdef enum AccessorType:
    ACCESSOR_TYPE_SCALAR
    ACCESSOR_TYPE_VEC2
    ACCESSOR_TYPE_VEC3
    ACCESSOR_TYPE_VEC4
    ACCESSOR_TYPE_MAT2
    ACCESSOR_TYPE_MAT3
    ACCESSOR_TYPE_MAT4

ctypedef struct AccessorC:
    Handle buffer_view
    size_t byte_offset
    AccessorComponentType component_type
    bint normalized
    size_t count
    AccessorType type
    #max
    #min
    #sparse

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

ctypedef struct ImageC:
    uint8_t *pixels
    size_t width
    size_t height

ctypedef struct TextureC:
    Handle sampler
    Handle image

ctypedef struct TextureInfoC:
    Handle index#index to texture
    uint8_t tex_coord
    #The set index of texture's TEXCOORD attribute used for texture coordinate mapping
    #default tex_coord = 0, min = 0

ctypedef struct NormalTextureInfoC:
    Handle index
    uint8_t tex_coord
    float scale#default = 1.0

ctypedef struct OcclusionTextureInfoC:
    Handle index
    uint8_t tex_coord
    float strength#default = 1.0

ctypedef struct PBRMetallicRoughnessC:
    Vec4C base_color_factor#default = (1, 1, 1, 1)
    TextureInfoC base_color_texture
    float metallic_factor#(0, 1), default = 1.0
    float roughness_factor#(0, 1), default = 1.0
    TextureInfoC metallic_roughness_texture

cpdef enum AlphaMode:
    ALPHA_MODE_OPAQUE#default
    ALPHA_MODE_MASK
    ALPHA_MODE_BLEND

ctypedef struct MaterialC:
    PBRMetallicRoughnessC pbr_metallic_roughness
    NormalTextureInfoC normal_texture
    OcclusionTextureInfoC occlusion_texture
    TextureInfoC emissive_texture
    Vec3C emissive_factor
    AlphaMode alpha_mode
    float alpha_cutoff#default = 0.5, min = 0.0
    bint double_sided#default = False

#Incomplete
ctypedef struct AnimationC:
    float x

cpdef enum PrimitiveMode:
    PRIMITIVE_MODE_POINTS
    PRIMITIVE_MODE_LINES
    PRIMITIVE_MODE_LINE_LOOP
    PRIMITIVE_MODE_LINE_STRIP
    PRIMITIVE_MODE_TRIANGLES
    PRIMITIVE_MODE_TRIANGLE_STRIP
    PRIMITIVE_MODE_TRIANGLE_FAN

#Per GLTF: at least two tex_coords, and 1 each of the rest must be supported.
cpdef enum PrimitiveAttributeNames:
    PRIMITIVE_ATTRIBUTE_NAME_POSITION#vec3
    PRIMITIVE_ATTRIBUTE_NAME_NORMAL#vec3
    PRIMITIVE_ATTRIBUTE_NAME_TANGENT#vec4
    PRIMITIVE_ATTRIBUTE_NAME_TEXCOORD_0#vec2
    PRIMITIVE_ATTRIBUTE_NAME_TEXCOORD_1#vec2
    PRIMITIVE_ATTRIBUTE_NAME_COLOR_0#vec3/4
    PRIMITIVE_ATTRIBUTE_NAME_JOINTS_0#vec4
    PRIMITIVE_ATTRIBUTE_NAME_WEIGHTS_0#vec4

ctypedef struct PrimitiveAttributesC:
    int ids[16]
    char names[16][256]

ctypedef struct PrimitiveC:
    PrimitiveAttributesC attributes
    Handle indices
    Handle material
    PrimitiveMode mode
    ItemVectorC targets

ctypedef struct MeshC:
    ItemVectorC primitives
    ItemVectorC weights

cpdef enum CameraType:
    CAMERA_TYPE_ORTHOGRAPHIC
    CAMERA_TYPE_PERSPECTIVE

ctypedef struct OrthographicCameraC:
    float x_mag
    float y_mag
    float z_far
    float z_near

ctypedef struct PerspectiveCameraC:
    float aspect_ratio
    float y_fov
    float z_far
    float z_near

ctypedef union CameraDataC:
    OrthographicCameraC orthographic
    PerspectiveCameraC perspective

ctypedef struct CameraC:
    CameraType type
    CameraDataC data

#Imcomplete
ctypedef struct SkinC:
    float x

cpdef enum NodeType:
    NODE_TYPE_EMPTY
    NODE_TYPE_MESH
    NODE_TYPE_CAMERA
    NODE_TYPE_SKIN

ctypedef struct NodeC:
    ItemVectorC children
    bint use_matrix
    Mat4C matrix
    Vec3C translation
    QuatC rotation
    Vec3C scale
    NodeType type
    Handle handle

ctypedef struct SceneC:
    ItemVectorC nodes

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT

ctypedef struct ShaderC:
    uint32_t id
    ShaderType type
    char *source
    size_t source_len

ctypedef struct ProgramC:
    uint32_t id
    ItemVectorC attributes
    ItemVectorC uniforms
    ItemVectorC textures
    Handle vertex_shader
    Handle fragment_shader