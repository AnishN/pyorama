from pyorama.core.handle cimport *
from pyorama.core.item_vector cimport *
from pyorama.math3d.common cimport *

ctypedef struct BufferC:
    char *bytes
    size_t byte_length

cpdef enum BufferViewTarget:
    NONE = 0
    ARRAY_BUFFER = 34962
    ELEMENT_ARRAY_BUFFER = 34963

ctypedef struct BufferViewC:
    Handle buffer#handle to a struct Buffer
    size_t byte_offset
    size_t byte_length
    BufferViewTarget target

cpdef enum AccessorComponentType:
    BYTE = 5120
    UNSIGNED_BYTE = 5121
    SHORT = 5122
    UNSIGNED_SHORT = 5123
    INT = 5124#NOT included in online glTF schema!
    UNSIGNED_INT = 5125
    FLOAT = 5126

cpdef enum AccessorType:
    SCALAR
    VEC2
    VEC3
    VEC4
    MAT2
    MAT3
    MAT4

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
    NEAREST = 9728
    LINEAR = 9729
    NEAREST_MIPMAP_NEAREST = 9984
    LINEAR_MIPMAP_NEAREST = 9985
    NEAREST_MIPMAP_LINEAR = 9986
    LINEAR_MIPMAP_LINEAR = 9987

cpdef enum SamplerWrap:
    CLAMP_TO_EDGE = 33071
    MIRRORED_REPEAT = 33648
    REPEAT = 10497

ctypedef struct SamplerC:
    SamplerFilter mag_filter
    SamplerFilter min_filter
    SamplerWrap wrap_s
    SamplerWrap wrap_t

ctypedef struct ImageC:
    uint32_t *pixels
    size_t width
    size_t height

ctypedef struct TextureC:
    Handle sampler
    Handle source

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
    OPAQUE#default
    MASK
    BLEND

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
    POINTS
    LINES
    LINE_LOOP
    LINE_STRIP
    TRIANGLES
    TRIANGLE_STRIP
    TRIANGLE_FAN

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
    ORTHOGRAPHIC
    PERSPECTIVE

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
    EMPTY_NODE
    MESH_NODE
    CAMERA_NODE
    SKIN_NODE

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