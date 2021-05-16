cpdef enum:
    MAX_TEXTURE_UNITS = 16

#Each enum maps to a (internal format, format, data type) in OpenGL
cpdef enum TextureFormat:
    TEXTURE_FORMAT_RGBA_8U#GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE
    TEXTURE_FORMAT_RGBA_32F#GL_RGBA, GL_RGBA, GL_FLOAT
    TEXTURE_FORMAT_DEPTH_16U#GL_DEPTH_COMPONENT, GL_DEPTH_COMPONENT, GL_UNSIGNED_SHORT
    TEXTURE_FORMAT_DEPTH_32U#GL_DEPTH_COMPONENT, GL_DEPTH_COMPONENT, GL_UNSIGNED_INT
    #TEXTURE_FORMAT_DEPTH_STENCIL_24_8U#GL_DEPTH_STENCIL, GL_DEPTH_STENCIL, GL_UNSIGNED_INT_24_8

cpdef enum TextureFilter:
    TEXTURE_FILTER_NEAREST
    TEXTURE_FILTER_LINEAR

cpdef enum TextureWrap:
    TEXTURE_WRAP_REPEAT
    TEXTURE_WRAP_MIRRORED_REPEAT
    TEXTURE_WRAP_CLAMP_TO_EDGE

cpdef enum TextureUnit:
    TEXTURE_UNIT_0
    TEXTURE_UNIT_1
    TEXTURE_UNIT_2
    TEXTURE_UNIT_3
    TEXTURE_UNIT_4
    TEXTURE_UNIT_5
    TEXTURE_UNIT_6
    TEXTURE_UNIT_7
    TEXTURE_UNIT_8
    TEXTURE_UNIT_9
    TEXTURE_UNIT_10
    TEXTURE_UNIT_11
    TEXTURE_UNIT_12
    TEXTURE_UNIT_13
    TEXTURE_UNIT_14
    TEXTURE_UNIT_15