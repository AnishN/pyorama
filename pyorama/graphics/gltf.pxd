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
"""
This integer value is used to construct a string in the format `TEXCOORD_<set index>` 
which is a reference to a key in mesh.primitives.attributes (e.g. A value of `0` corresponds to `TEXCOORD_0`). 
Mesh must have corresponding texture coordinate attributes for the material to be applicable to it."
"""

ctypedef struct NormalTextureInfoC:
    Handle index
    uint8_t tex_coord
    float scale#default = 1.0
"""
The scalar multiplier applied to each normal vector of the texture. 
This value scales the normal vector using the formula: 
`scaledNormal =  normalize((<sampled normal texture value> * 2.0 - 1.0) * vec3(<normal scale>, <normal scale>, 1.0))`. 
This value is ignored if normalTexture is not specified. This value is linear.
"""

#Material PBR Metallic Roughness
#aka pbrMetallicRoughness
ctypedef struct MaterialPBRC:
    Vec4C base_color_factor#default = (1, 1, 1, 1)
    TextureInfoC base_color_texture
    float metallic_factor#(0, 1), default = 1.0
    float roughness_factor#(0, 1), default = 1.0
    TextureInfoC metallic_roughness_texture

ctypedef struct MaterialC:
    float x

ctypedef struct AnimationC:
    float x

ctypedef struct MeshC:
    float x

ctypedef struct CameraC:
    float x

ctypedef struct SkinC:
    float x

ctypedef struct NodeC:
    float x

ctypedef struct SceneC:
    float x

"""
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
    #targets
    #extensions
    #extras

ctypedef struct ImageC:
    Handle buffer_view

ctypedef struct TextureC:
    Handle sampler
    Handle source

ctypedef struct SceneC:
    ItemVectorC nodes

ctypedef struct NodeC:
    ItemVectorC children
    Mat4C matrix
    Vec3C translation
    QuatC rotation
    Vec3C scale
"""