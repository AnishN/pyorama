from pyorama.libs.c cimport *
from pyorama.libs.sdl2 cimport *

cdef enum:
    BGFX_CONFIG_RENDERER_OPENGL
    BGFX_CONFIG_RENDERER_OPENGLES

cdef extern from "bgfx/defines.h" nogil:
    cdef enum:
        BGFX_API_VERSION

    cdef enum:
        BGFX_STATE_WRITE_R
        BGFX_STATE_WRITE_G
        BGFX_STATE_WRITE_B
        BGFX_STATE_WRITE_A
        BGFX_STATE_WRITE_Z
        BGFX_STATE_WRITE_RGB
        BGFX_STATE_WRITE_MASK

    cdef enum:
        BGFX_STATE_DEPTH_TEST_LESS
        BGFX_STATE_DEPTH_TEST_LEQUAL
        BGFX_STATE_DEPTH_TEST_EQUAL
        BGFX_STATE_DEPTH_TEST_GEQUAL
        BGFX_STATE_DEPTH_TEST_GREATER
        BGFX_STATE_DEPTH_TEST_NOTEQUAL
        BGFX_STATE_DEPTH_TEST_NEVER
        BGFX_STATE_DEPTH_TEST_ALWAYS
        BGFX_STATE_DEPTH_TEST_SHIFT
        BGFX_STATE_DEPTH_TEST_MASK

    cdef enum:
        BGFX_STATE_BLEND_ZERO
        BGFX_STATE_BLEND_ONE
        BGFX_STATE_BLEND_SRC_COLOR
        BGFX_STATE_BLEND_INV_SRC_COLOR
        BGFX_STATE_BLEND_SRC_ALPHA
        BGFX_STATE_BLEND_INV_SRC_ALPHA
        BGFX_STATE_BLEND_DST_ALPHA
        BGFX_STATE_BLEND_INV_DST_ALPHA
        BGFX_STATE_BLEND_DST_COLOR
        BGFX_STATE_BLEND_INV_DST_COLOR
        BGFX_STATE_BLEND_SRC_ALPHA_SAT
        BGFX_STATE_BLEND_FACTOR
        BGFX_STATE_BLEND_INV_FACTOR
        BGFX_STATE_BLEND_SHIFT
        BGFX_STATE_BLEND_MASK

    cdef enum:
        BGFX_STATE_BLEND_EQUATION_ADD
        BGFX_STATE_BLEND_EQUATION_SUB
        BGFX_STATE_BLEND_EQUATION_REVSUB
        BGFX_STATE_BLEND_EQUATION_MIN
        BGFX_STATE_BLEND_EQUATION_MAX
        BGFX_STATE_BLEND_EQUATION_SHIFT
        BGFX_STATE_BLEND_EQUATION_MASK

    cdef enum:
        BGFX_STATE_CULL_CW
        BGFX_STATE_CULL_CCW
        BGFX_STATE_CULL_SHIFT
        BGFX_STATE_CULL_MASK

    cdef enum:
        BGFX_STATE_ALPHA_REF_SHIFT
        BGFX_STATE_ALPHA_REF_MASK
        BGFX_STATE_PT_TRISTRIP
        BGFX_STATE_PT_LINES
        BGFX_STATE_PT_LINESTRIP
        BGFX_STATE_PT_POINTS
        BGFX_STATE_PT_SHIFT
        BGFX_STATE_PT_MASK
    cdef uint64_t BGFX_STATE_ALPHA_REF(uint64_t v)

    cdef enum:
        BGFX_STATE_POINT_SIZE_SHIFT
        BGFX_STATE_POINT_SIZE_MASK
    cdef uint64_t BGFX_STATE_POINT_SIZE(uint64_t v)

    cdef enum:
        BGFX_STATE_MSAA
        BGFX_STATE_LINEAA
        BGFX_STATE_CONSERVATIVE_RASTER
        BGFX_STATE_NONE
        BGFX_STATE_FRONT_CCW
        BGFX_STATE_BLEND_INDEPENDENT
        BGFX_STATE_BLEND_ALPHA_TO_COVERAGE
        BGFX_STATE_DEFAULT

    cdef enum:
        BGFX_STATE_MASK
        BGFX_STATE_RESERVED_SHIFT
        BGFX_STATE_RESERVED_MASK

    cdef enum:
        BGFX_STENCIL_FUNC_REF_SHIFT
        BGFX_STENCIL_FUNC_REF_MASK
    cdef uint32_t BGFX_STENCIL_FUNC_REF(uint32_t v)

    cdef enum:
        BGFX_STENCIL_FUNC_RMASK_SHIFT
        BGFX_STENCIL_FUNC_RMASK_MASK
    cdef uint32_t BGFX_STENCIL_FUNC_RMASK(uint32_t v)

    cdef enum:
        BGFX_STENCIL_NONE
        BGFX_STENCIL_MASK
        BGFX_STENCIL_DEFAULT

    cdef enum:
        BGFX_STENCIL_TEST_LESS
        BGFX_STENCIL_TEST_LEQUAL
        BGFX_STENCIL_TEST_EQUAL
        BGFX_STENCIL_TEST_GEQUAL
        BGFX_STENCIL_TEST_GREATER
        BGFX_STENCIL_TEST_NOTEQUAL
        BGFX_STENCIL_TEST_NEVER
        BGFX_STENCIL_TEST_ALWAYS
        BGFX_STENCIL_TEST_SHIFT
        BGFX_STENCIL_TEST_MASK

    cdef enum:
        BGFX_STENCIL_OP_FAIL_S_ZERO
        BGFX_STENCIL_OP_FAIL_S_KEEP
        BGFX_STENCIL_OP_FAIL_S_REPLACE
        BGFX_STENCIL_OP_FAIL_S_INCR
        BGFX_STENCIL_OP_FAIL_S_INCRSAT
        BGFX_STENCIL_OP_FAIL_S_DECR
        BGFX_STENCIL_OP_FAIL_S_DECRSAT
        BGFX_STENCIL_OP_FAIL_S_INVERT
        BGFX_STENCIL_OP_FAIL_S_SHIFT
        BGFX_STENCIL_OP_FAIL_S_MASK

    cdef enum:
        BGFX_STENCIL_OP_FAIL_Z_ZERO
        BGFX_STENCIL_OP_FAIL_Z_KEEP
        BGFX_STENCIL_OP_FAIL_Z_REPLACE
        BGFX_STENCIL_OP_FAIL_Z_INCR
        BGFX_STENCIL_OP_FAIL_Z_INCRSAT
        BGFX_STENCIL_OP_FAIL_Z_DECR
        BGFX_STENCIL_OP_FAIL_Z_DECRSAT
        BGFX_STENCIL_OP_FAIL_Z_INVERT
        BGFX_STENCIL_OP_FAIL_Z_SHIFT
        BGFX_STENCIL_OP_FAIL_Z_MASK

    cdef enum:
        BGFX_STENCIL_OP_PASS_Z_ZERO
        BGFX_STENCIL_OP_PASS_Z_KEEP
        BGFX_STENCIL_OP_PASS_Z_REPLACE
        BGFX_STENCIL_OP_PASS_Z_INCR
        BGFX_STENCIL_OP_PASS_Z_INCRSAT
        BGFX_STENCIL_OP_PASS_Z_DECR
        BGFX_STENCIL_OP_PASS_Z_DECRSAT
        BGFX_STENCIL_OP_PASS_Z_INVERT
        BGFX_STENCIL_OP_PASS_Z_SHIFT
        BGFX_STENCIL_OP_PASS_Z_MASK

    cdef enum:
        BGFX_CLEAR_NONE
        BGFX_CLEAR_COLOR
        BGFX_CLEAR_DEPTH
        BGFX_CLEAR_STENCIL
        BGFX_CLEAR_DISCARD_COLOR_0
        BGFX_CLEAR_DISCARD_COLOR_1
        BGFX_CLEAR_DISCARD_COLOR_2
        BGFX_CLEAR_DISCARD_COLOR_3
        BGFX_CLEAR_DISCARD_COLOR_4
        BGFX_CLEAR_DISCARD_COLOR_5
        BGFX_CLEAR_DISCARD_COLOR_6
        BGFX_CLEAR_DISCARD_COLOR_7
        BGFX_CLEAR_DISCARD_DEPTH
        BGFX_CLEAR_DISCARD_STENCIL
        BGFX_CLEAR_DISCARD_COLOR_MASK
        BGFX_CLEAR_DISCARD_MASK

    cdef enum:
        BGFX_DISCARD_NONE
        BGFX_DISCARD_BINDINGS
        BGFX_DISCARD_INDEX_BUFFER
        BGFX_DISCARD_INSTANCE_DATA
        BGFX_DISCARD_STATE
        BGFX_DISCARD_TRANSFORM
        BGFX_DISCARD_VERTEX_STREAMS
        BGFX_DISCARD_ALL

    cdef enum:
        BGFX_DEBUG_NONE
        BGFX_DEBUG_WIREFRAME
        BGFX_DEBUG_IFH
        BGFX_DEBUG_STATS
        BGFX_DEBUG_TEXT
        BGFX_DEBUG_PROFILER

    cdef enum:
        BGFX_BUFFER_COMPUTE_FORMAT_8X1
        BGFX_BUFFER_COMPUTE_FORMAT_8X2
        BGFX_BUFFER_COMPUTE_FORMAT_8X4
        BGFX_BUFFER_COMPUTE_FORMAT_16X1
        BGFX_BUFFER_COMPUTE_FORMAT_16X2
        BGFX_BUFFER_COMPUTE_FORMAT_16X4
        BGFX_BUFFER_COMPUTE_FORMAT_32X1
        BGFX_BUFFER_COMPUTE_FORMAT_32X2
        BGFX_BUFFER_COMPUTE_FORMAT_32X4
        BGFX_BUFFER_COMPUTE_FORMAT_SHIFT
        BGFX_BUFFER_COMPUTE_FORMAT_MASK

    cdef enum:
        BGFX_BUFFER_COMPUTE_TYPE_INT
        BGFX_BUFFER_COMPUTE_TYPE_UINT
        BGFX_BUFFER_COMPUTE_TYPE_FLOAT
        BGFX_BUFFER_COMPUTE_TYPE_SHIFT
        BGFX_BUFFER_COMPUTE_TYPE_MASK

    cdef enum:
        BGFX_BUFFER_NONE
        BGFX_BUFFER_COMPUTE_READ
        BGFX_BUFFER_COMPUTE_WRITE
        BGFX_BUFFER_DRAW_INDIRECT
        BGFX_BUFFER_ALLOW_RESIZE
        BGFX_BUFFER_INDEX32
        BGFX_BUFFER_COMPUTE_READ_WRITE

    cdef enum:
        BGFX_TEXTURE_NONE
        BGFX_TEXTURE_MSAA_SAMPLE
        BGFX_TEXTURE_RT
        BGFX_TEXTURE_COMPUTE_WRITE
        BGFX_TEXTURE_SRGB
        BGFX_TEXTURE_BLIT_DST
        BGFX_TEXTURE_READ_BACK

    cdef enum:
        BGFX_TEXTURE_RT_MSAA_X2
        BGFX_TEXTURE_RT_MSAA_X4
        BGFX_TEXTURE_RT_MSAA_X8
        BGFX_TEXTURE_RT_MSAA_X16
        BGFX_TEXTURE_RT_MSAA_SHIFT
        BGFX_TEXTURE_RT_MSAA_MASK
        BGFX_TEXTURE_RT_WRITE_ONLY
        BGFX_TEXTURE_RT_SHIFT
        BGFX_TEXTURE_RT_MASK

    cdef enum:
        BGFX_SAMPLER_U_MIRROR
        BGFX_SAMPLER_U_CLAMP
        BGFX_SAMPLER_U_BORDER
        BGFX_SAMPLER_U_SHIFT
        BGFX_SAMPLER_U_MASK
        BGFX_SAMPLER_V_MIRROR
        BGFX_SAMPLER_V_CLAMP
        BGFX_SAMPLER_V_BORDER
        BGFX_SAMPLER_V_SHIFT
        BGFX_SAMPLER_V_MASK
        BGFX_SAMPLER_W_MIRROR
        BGFX_SAMPLER_W_CLAMP
        BGFX_SAMPLER_W_BORDER
        BGFX_SAMPLER_W_SHIFT
        BGFX_SAMPLER_W_MASK
        BGFX_SAMPLER_MIN_POINT
        BGFX_SAMPLER_MIN_ANISOTROPIC
        BGFX_SAMPLER_MIN_SHIFT
        BGFX_SAMPLER_MIN_MASK
        BGFX_SAMPLER_MAG_POINT
        BGFX_SAMPLER_MAG_ANISOTROPIC
        BGFX_SAMPLER_MAG_SHIFT
        BGFX_SAMPLER_MAG_MASK
        BGFX_SAMPLER_MIP_POINT
        BGFX_SAMPLER_MIP_SHIFT
        BGFX_SAMPLER_MIP_MASK
        BGFX_SAMPLER_COMPARE_LESS
        BGFX_SAMPLER_COMPARE_LEQUAL
        BGFX_SAMPLER_COMPARE_EQUAL
        BGFX_SAMPLER_COMPARE_GEQUAL
        BGFX_SAMPLER_COMPARE_GREATER
        BGFX_SAMPLER_COMPARE_NOTEQUAL
        BGFX_SAMPLER_COMPARE_NEVER
        BGFX_SAMPLER_COMPARE_ALWAYS
        BGFX_SAMPLER_COMPARE_SHIFT
        BGFX_SAMPLER_COMPARE_MASK
        BGFX_SAMPLER_BORDER_COLOR_SHIFT
        BGFX_SAMPLER_BORDER_COLOR_MASK
        BGFX_SAMPLER_RESERVED_SHIFT
        BGFX_SAMPLER_RESERVED_MASK
        BGFX_SAMPLER_NONE
        BGFX_SAMPLER_SAMPLE_STENCIL
        BGFX_SAMPLER_POINT
        BGFX_SAMPLER_UVW_MIRROR
        BGFX_SAMPLER_UVW_CLAMP
        BGFX_SAMPLER_UVW_BORDER
        BGFX_SAMPLER_BITS_MASK
    
    cdef uint32_t BGFX_SAMPLER_BORDER_COLOR(uint32_t v)

    cdef enum:
        BGFX_RESET_MSAA_X2
        BGFX_RESET_MSAA_X4
        BGFX_RESET_MSAA_X8
        BGFX_RESET_MSAA_X16
        BGFX_RESET_MSAA_SHIFT
        BGFX_RESET_MSAA_MASK

    cdef enum:
        BGFX_RESET_NONE
        BGFX_RESET_FULLSCREEN
        BGFX_RESET_VSYNC
        BGFX_RESET_MAXANISOTROPY
        BGFX_RESET_CAPTURE
        BGFX_RESET_FLUSH_AFTER_RENDER
        BGFX_RESET_FLIP_AFTER_RENDER
        BGFX_RESET_SRGB_BACKBUFFER
        BGFX_RESET_HDR10
        BGFX_RESET_HIDPI
        BGFX_RESET_DEPTH_CLAMP
        BGFX_RESET_SUSPEND
        BGFX_RESET_FULLSCREEN_SHIFT
        BGFX_RESET_FULLSCREEN_MASK
        BGFX_RESET_RESERVED_SHIFT
        BGFX_RESET_RESERVED_MASK

    cdef enum:
        BGFX_CAPS_ALPHA_TO_COVERAGE
        BGFX_CAPS_BLEND_INDEPENDENT
        BGFX_CAPS_COMPUTE
        BGFX_CAPS_CONSERVATIVE_RASTER
        BGFX_CAPS_DRAW_INDIRECT
        BGFX_CAPS_FRAGMENT_DEPTH
        BGFX_CAPS_FRAGMENT_ORDERING
        BGFX_CAPS_GRAPHICS_DEBUGGER
        BGFX_CAPS_HDR10
        BGFX_CAPS_HIDPI
        BGFX_CAPS_IMAGE_RW
        BGFX_CAPS_INDEX32
        BGFX_CAPS_INSTANCING
        BGFX_CAPS_OCCLUSION_QUERY
        BGFX_CAPS_RENDERER_MULTITHREADED
        BGFX_CAPS_SWAP_CHAIN
        BGFX_CAPS_TEXTURE_2D_ARRAY
        BGFX_CAPS_TEXTURE_3D
        BGFX_CAPS_TEXTURE_BLIT
        BGFX_CAPS_TEXTURE_COMPARE_RESERVED
        BGFX_CAPS_TEXTURE_COMPARE_LEQUAL
        BGFX_CAPS_TEXTURE_CUBE_ARRAY
        BGFX_CAPS_TEXTURE_DIRECT_ACCESS
        BGFX_CAPS_TEXTURE_READ_BACK
        BGFX_CAPS_VERTEX_ATTRIB_HALF
        BGFX_CAPS_VERTEX_ATTRIB_UINT10
        BGFX_CAPS_VERTEX_ID
        BGFX_CAPS_VIEWPORT_LAYER_ARRAY
        BGFX_CAPS_TEXTURE_COMPARE_ALL

    cdef enum:
        BGFX_CAPS_FORMAT_TEXTURE_NONE
        BGFX_CAPS_FORMAT_TEXTURE_2D
        BGFX_CAPS_FORMAT_TEXTURE_2D_SRGB
        BGFX_CAPS_FORMAT_TEXTURE_2D_EMULATED
        BGFX_CAPS_FORMAT_TEXTURE_3D
        BGFX_CAPS_FORMAT_TEXTURE_3D_SRGB
        BGFX_CAPS_FORMAT_TEXTURE_3D_EMULATED
        BGFX_CAPS_FORMAT_TEXTURE_CUBE
        BGFX_CAPS_FORMAT_TEXTURE_CUBE_SRGB
        BGFX_CAPS_FORMAT_TEXTURE_CUBE_EMULATED
        BGFX_CAPS_FORMAT_TEXTURE_VERTEX
        BGFX_CAPS_FORMAT_TEXTURE_IMAGE_READ
        BGFX_CAPS_FORMAT_TEXTURE_IMAGE_WRITE
        BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER
        BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA
        BGFX_CAPS_FORMAT_TEXTURE_MSAA
        BGFX_CAPS_FORMAT_TEXTURE_MIP_AUTOGEN

    cdef enum:
        BGFX_RESOLVE_NONE
        BGFX_RESOLVE_AUTO_GEN_MIPS

    cdef enum:
        BGFX_PCI_ID_NONE
        BGFX_PCI_ID_SOFTWARE_RASTERIZER
        BGFX_PCI_ID_AMD
        BGFX_PCI_ID_INTEL
        BGFX_PCI_ID_NVIDIA

    cdef enum:
        BGFX_CUBE_MAP_POSITIVE_X
        BGFX_CUBE_MAP_NEGATIVE_X
        BGFX_CUBE_MAP_POSITIVE_Y
        BGFX_CUBE_MAP_NEGATIVE_Y
        BGFX_CUBE_MAP_POSITIVE_Z
        BGFX_CUBE_MAP_NEGATIVE_Z

    cdef uint64_t BGFX_STATE_BLEND_FUNC_SEPARATE(uint64_t _srcRGB, uint64_t _dstRGB, uint64_t _srcA, uint64_t dstA)
    cdef uint64_t BGFX_STATE_BLEND_EQUATION_SEPARATE(uint64_t _equationRGB, uint64_t _equationA)
    cdef uint64_t BGFX_STATE_BLEND_FUNC(uint64_t _src, uint64_t _dst)
    cdef uint64_t BGFX_STATE_BLEND_EQUATION(uint64_t _equation)

    cdef enum:
        BGFX_STATE_BLEND_ADD
        BGFX_STATE_BLEND_ALPHA
        BGFX_STATE_BLEND_DARKEN
        BGFX_STATE_BLEND_LIGHTEN
        BGFX_STATE_BLEND_MULTIPLY
        BGFX_STATE_BLEND_NORMAL
        BGFX_STATE_BLEND_SCREEN
        BGFX_STATE_BLEND_LINEAR_BURN

    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_x(uint64_t _src, uint64_t _dst)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_xE(uint64_t _src, uint64_t _dst, uint64_t _equation)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_1(uint64_t _src, uint64_t _dst)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_2(uint64_t _src, uint64_t _dst)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_3(uint64_t _src, uint64_t _dst)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_1E(uint64_t _src, uint64_t _dst, uint64_t _equation)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_2E(uint64_t _src, uint64_t _dst, uint64_t _equation)
    cdef uint32_t BGFX_STATE_BLEND_FUNC_RT_3E(uint64_t _src, uint64_t _dst, uint64_t _equation)

cdef extern from "bgfx/c99/bgfx.h" nogil:
    cdef enum:
        BGFX_INVALID_HANDLE
        BGFX_C_API
        BGFX_SHARED_LIB_BUILD
        BGFX_SHARED_LIB_USE
        BGFX_SHARED_LIB_API
        BGFX_SYMBOL_EXPORT
        BX_PLATFORM_WINDOWS
        BX_PLATFORM_WINRT

    ctypedef enum bgfx_fatal_t:
        BGFX_FATAL_DEBUG_CHECK,
        BGFX_FATAL_INVALID_SHADER,
        BGFX_FATAL_UNABLE_TO_INITIALIZE,
        BGFX_FATAL_UNABLE_TO_CREATE_TEXTURE,
        BGFX_FATAL_DEVICE_LOST,
        BGFX_FATAL_COUNT

    ctypedef enum bgfx_renderer_type_t:
        BGFX_RENDERER_TYPE_NOOP,
        BGFX_RENDERER_TYPE_DIRECT3D9,
        BGFX_RENDERER_TYPE_DIRECT3D11,
        BGFX_RENDERER_TYPE_DIRECT3D12,
        BGFX_RENDERER_TYPE_GNM,
        BGFX_RENDERER_TYPE_METAL,
        BGFX_RENDERER_TYPE_NVN,
        BGFX_RENDERER_TYPE_OPENGLES,
        BGFX_RENDERER_TYPE_OPENGL,
        BGFX_RENDERER_TYPE_VULKAN,
        BGFX_RENDERER_TYPE_WEBGPU,
        BGFX_RENDERER_TYPE_COUNT

    ctypedef enum bgfx_access_t:
        BGFX_ACCESS_READ,
        BGFX_ACCESS_WRITE,
        BGFX_ACCESS_READWRITE,
        BGFX_ACCESS_COUNT

    ctypedef enum bgfx_attrib_t:
        BGFX_ATTRIB_POSITION,
        BGFX_ATTRIB_NORMAL,
        BGFX_ATTRIB_TANGENT,
        BGFX_ATTRIB_BITANGENT,
        BGFX_ATTRIB_COLOR0,
        BGFX_ATTRIB_COLOR1,
        BGFX_ATTRIB_COLOR2,
        BGFX_ATTRIB_COLOR3,
        BGFX_ATTRIB_INDICES,
        BGFX_ATTRIB_WEIGHT,
        BGFX_ATTRIB_TEXCOORD0,
        BGFX_ATTRIB_TEXCOORD1,
        BGFX_ATTRIB_TEXCOORD2,
        BGFX_ATTRIB_TEXCOORD3,
        BGFX_ATTRIB_TEXCOORD4,
        BGFX_ATTRIB_TEXCOORD5,
        BGFX_ATTRIB_TEXCOORD6,
        BGFX_ATTRIB_TEXCOORD7,
        BGFX_ATTRIB_COUNT

    ctypedef enum bgfx_attrib_type_t:
        BGFX_ATTRIB_TYPE_UINT8,
        BGFX_ATTRIB_TYPE_UINT10,
        BGFX_ATTRIB_TYPE_INT16,
        BGFX_ATTRIB_TYPE_HALF,
        BGFX_ATTRIB_TYPE_FLOAT,
        BGFX_ATTRIB_TYPE_COUNT

    ctypedef enum bgfx_texture_format_t:
        BGFX_TEXTURE_FORMAT_BC1,
        BGFX_TEXTURE_FORMAT_BC2,
        BGFX_TEXTURE_FORMAT_BC3,
        BGFX_TEXTURE_FORMAT_BC4,
        BGFX_TEXTURE_FORMAT_BC5,
        BGFX_TEXTURE_FORMAT_BC6H,
        BGFX_TEXTURE_FORMAT_BC7,
        BGFX_TEXTURE_FORMAT_ETC1,
        BGFX_TEXTURE_FORMAT_ETC2,
        BGFX_TEXTURE_FORMAT_ETC2A,
        BGFX_TEXTURE_FORMAT_ETC2A1,
        BGFX_TEXTURE_FORMAT_PTC12,
        BGFX_TEXTURE_FORMAT_PTC14,
        BGFX_TEXTURE_FORMAT_PTC12A,
        BGFX_TEXTURE_FORMAT_PTC14A,
        BGFX_TEXTURE_FORMAT_PTC22,
        BGFX_TEXTURE_FORMAT_PTC24,
        BGFX_TEXTURE_FORMAT_ATC,
        BGFX_TEXTURE_FORMAT_ATCE,
        BGFX_TEXTURE_FORMAT_ATCI,
        BGFX_TEXTURE_FORMAT_ASTC4X4,
        BGFX_TEXTURE_FORMAT_ASTC5X5,
        BGFX_TEXTURE_FORMAT_ASTC6X6,
        BGFX_TEXTURE_FORMAT_ASTC8X5,
        BGFX_TEXTURE_FORMAT_ASTC8X6,
        BGFX_TEXTURE_FORMAT_ASTC10X5,
        BGFX_TEXTURE_FORMAT_UNKNOWN,
        BGFX_TEXTURE_FORMAT_R1,
        BGFX_TEXTURE_FORMAT_A8,
        BGFX_TEXTURE_FORMAT_R8,
        BGFX_TEXTURE_FORMAT_R8I,
        BGFX_TEXTURE_FORMAT_R8U,
        BGFX_TEXTURE_FORMAT_R8S,
        BGFX_TEXTURE_FORMAT_R16,
        BGFX_TEXTURE_FORMAT_R16I,
        BGFX_TEXTURE_FORMAT_R16U,
        BGFX_TEXTURE_FORMAT_R16F,
        BGFX_TEXTURE_FORMAT_R16S,
        BGFX_TEXTURE_FORMAT_R32I,
        BGFX_TEXTURE_FORMAT_R32U,
        BGFX_TEXTURE_FORMAT_R32F,
        BGFX_TEXTURE_FORMAT_RG8,
        BGFX_TEXTURE_FORMAT_RG8I,
        BGFX_TEXTURE_FORMAT_RG8U,
        BGFX_TEXTURE_FORMAT_RG8S,
        BGFX_TEXTURE_FORMAT_RG16,
        BGFX_TEXTURE_FORMAT_RG16I,
        BGFX_TEXTURE_FORMAT_RG16U,
        BGFX_TEXTURE_FORMAT_RG16F,
        BGFX_TEXTURE_FORMAT_RG16S,
        BGFX_TEXTURE_FORMAT_RG32I,
        BGFX_TEXTURE_FORMAT_RG32U,
        BGFX_TEXTURE_FORMAT_RG32F,
        BGFX_TEXTURE_FORMAT_RGB8,
        BGFX_TEXTURE_FORMAT_RGB8I,
        BGFX_TEXTURE_FORMAT_RGB8U,
        BGFX_TEXTURE_FORMAT_RGB8S,
        BGFX_TEXTURE_FORMAT_RGB9E5F,
        BGFX_TEXTURE_FORMAT_BGRA8,
        BGFX_TEXTURE_FORMAT_RGBA8,
        BGFX_TEXTURE_FORMAT_RGBA8I,
        BGFX_TEXTURE_FORMAT_RGBA8U,
        BGFX_TEXTURE_FORMAT_RGBA8S,
        BGFX_TEXTURE_FORMAT_RGBA16,
        BGFX_TEXTURE_FORMAT_RGBA16I,
        BGFX_TEXTURE_FORMAT_RGBA16U,
        BGFX_TEXTURE_FORMAT_RGBA16F,
        BGFX_TEXTURE_FORMAT_RGBA16S,
        BGFX_TEXTURE_FORMAT_RGBA32I,
        BGFX_TEXTURE_FORMAT_RGBA32U,
        BGFX_TEXTURE_FORMAT_RGBA32F,
        BGFX_TEXTURE_FORMAT_R5G6B5,
        BGFX_TEXTURE_FORMAT_RGBA4,
        BGFX_TEXTURE_FORMAT_RGB5A1,
        BGFX_TEXTURE_FORMAT_RGB10A2,
        BGFX_TEXTURE_FORMAT_RG11B10F,
        BGFX_TEXTURE_FORMAT_UNKNOWNDEPTH,
        BGFX_TEXTURE_FORMAT_D16,
        BGFX_TEXTURE_FORMAT_D24,
        BGFX_TEXTURE_FORMAT_D24S8,
        BGFX_TEXTURE_FORMAT_D32,
        BGFX_TEXTURE_FORMAT_D16F,
        BGFX_TEXTURE_FORMAT_D24F,
        BGFX_TEXTURE_FORMAT_D32F,
        BGFX_TEXTURE_FORMAT_D0S8,
        BGFX_TEXTURE_FORMAT_COUNT

    ctypedef enum bgfx_uniform_type_t:
        BGFX_UNIFORM_TYPE_SAMPLER,
        BGFX_UNIFORM_TYPE_END,
        BGFX_UNIFORM_TYPE_VEC4,
        BGFX_UNIFORM_TYPE_MAT3,
        BGFX_UNIFORM_TYPE_MAT4,
        BGFX_UNIFORM_TYPE_COUNT

    ctypedef enum bgfx_backbuffer_ratio_t:
        BGFX_BACKBUFFER_RATIO_EQUAL,
        BGFX_BACKBUFFER_RATIO_HALF,
        BGFX_BACKBUFFER_RATIO_QUARTER,
        BGFX_BACKBUFFER_RATIO_EIGHTH,
        BGFX_BACKBUFFER_RATIO_SIXTEENTH,
        BGFX_BACKBUFFER_RATIO_DOUBLE,
        BGFX_BACKBUFFER_RATIO_COUNT

    ctypedef enum bgfx_occlusion_query_result_t:
        BGFX_OCCLUSION_QUERY_RESULT_INVISIBLE,
        BGFX_OCCLUSION_QUERY_RESULT_VISIBLE,
        BGFX_OCCLUSION_QUERY_RESULT_NORESULT,
        BGFX_OCCLUSION_QUERY_RESULT_COUNT

    ctypedef enum bgfx_topology_t:
        BGFX_TOPOLOGY_TRI_LIST,
        BGFX_TOPOLOGY_TRI_STRIP,
        BGFX_TOPOLOGY_LINE_LIST,
        BGFX_TOPOLOGY_LINE_STRIP,
        BGFX_TOPOLOGY_POINT_LIST,
        BGFX_TOPOLOGY_COUNT

    ctypedef enum bgfx_topology_convert_t:
        BGFX_TOPOLOGY_CONVERT_TRI_LIST_FLIP_WINDING,
        BGFX_TOPOLOGY_CONVERT_TRI_STRIP_FLIP_WINDING,
        BGFX_TOPOLOGY_CONVERT_TRI_LIST_TO_LINE_LIST,
        BGFX_TOPOLOGY_CONVERT_TRI_STRIP_TO_TRI_LIST,
        BGFX_TOPOLOGY_CONVERT_LINE_STRIP_TO_LINE_LIST,
        BGFX_TOPOLOGY_CONVERT_COUNT

    ctypedef enum bgfx_topology_sort_t:
        BGFX_TOPOLOGY_SORT_DIRECTION_FRONT_TO_BACK_MIN,
        BGFX_TOPOLOGY_SORT_DIRECTION_FRONT_TO_BACK_AVG,
        BGFX_TOPOLOGY_SORT_DIRECTION_FRONT_TO_BACK_MAX,
        BGFX_TOPOLOGY_SORT_DIRECTION_BACK_TO_FRONT_MIN,
        BGFX_TOPOLOGY_SORT_DIRECTION_BACK_TO_FRONT_AVG,
        BGFX_TOPOLOGY_SORT_DIRECTION_BACK_TO_FRONT_MAX,
        BGFX_TOPOLOGY_SORT_DISTANCE_FRONT_TO_BACK_MIN,
        BGFX_TOPOLOGY_SORT_DISTANCE_FRONT_TO_BACK_AVG,
        BGFX_TOPOLOGY_SORT_DISTANCE_FRONT_TO_BACK_MAX,
        BGFX_TOPOLOGY_SORT_DISTANCE_BACK_TO_FRONT_MIN,
        BGFX_TOPOLOGY_SORT_DISTANCE_BACK_TO_FRONT_AVG,
        BGFX_TOPOLOGY_SORT_DISTANCE_BACK_TO_FRONT_MAX,
        BGFX_TOPOLOGY_SORT_COUNT

    ctypedef enum bgfx_view_mode_t:
        BGFX_VIEW_MODE_DEFAULT,
        BGFX_VIEW_MODE_SEQUENTIAL,
        BGFX_VIEW_MODE_DEPTH_ASCENDING,
        BGFX_VIEW_MODE_DEPTH_DESCENDING,
        BGFX_VIEW_MODE_COUNT

    ctypedef enum bgfx_render_frame_t:
        BGFX_RENDER_FRAME_NO_CONTEXT,
        BGFX_RENDER_FRAME_RENDER,
        BGFX_RENDER_FRAME_TIMEOUT,
        BGFX_RENDER_FRAME_EXITING,
        BGFX_RENDER_FRAME_COUNT

    ctypedef uint16_t bgfx_view_id_t

    ctypedef struct bgfx_allocator_interface_t:
        bgfx_allocator_vtbl_t* vtbl

    ctypedef struct bgfx_allocator_vtbl_t:
        void* (*realloc)(bgfx_allocator_interface_t* _this, void* _ptr, size_t _size, size_t _align, const char* _file, uint32_t _line)

    ctypedef struct bgfx_interface_vtbl_t:
        pass

    ctypedef struct bgfx_callback_interface_t:
        bgfx_callback_vtbl_t* vtbl

    ctypedef struct bgfx_callback_vtbl_t:
        void (*fatal)(bgfx_callback_interface_t* _this, const char* _filePath, uint16_t _line, bgfx_fatal_t _code, const char* _str)
        void (*trace_vargs)(bgfx_callback_interface_t* _this, const char* _filePath, uint16_t _line, const char* _format, va_list _argList)
        void (*profiler_begin)(bgfx_callback_interface_t* _this, const char* _name, uint32_t _abgr, const char* _filePath, uint16_t _line)
        void (*profiler_begin_literal)(bgfx_callback_interface_t* _this, const char* _name, uint32_t _abgr, const char* _filePath, uint16_t _line)
        void (*profiler_end)(bgfx_callback_interface_t* _this)
        uint32_t (*cache_read_size)(bgfx_callback_interface_t* _this, uint64_t _id)
        bint (*cache_read)(bgfx_callback_interface_t* _this, uint64_t _id, void* _data, uint32_t _size)
        void (*cache_write)(bgfx_callback_interface_t* _this, uint64_t _id, const void* _data, uint32_t _size)
        void (*screen_shot)(bgfx_callback_interface_t* _this, const char* _filePath, uint32_t _width, uint32_t _height, uint32_t _pitch, const void* _data, uint32_t _size, bint _yflip)
        void (*capture_begin)(bgfx_callback_interface_t* _this, uint32_t _width, uint32_t _height, uint32_t _pitch, bgfx_texture_format_t _format, bint _yflip)
        void (*capture_end)(bgfx_callback_interface_t* _this)
        void (*capture_frame)(bgfx_callback_interface_t* _this, const void* _data, uint32_t _size)

    ctypedef struct bgfx_dynamic_index_buffer_handle_t:
        uint16_t idx
    ctypedef struct bgfx_dynamic_vertex_buffer_handle_t:
        uint16_t idx
    ctypedef struct bgfx_frame_buffer_handle_t:
        uint16_t idx
    ctypedef struct bgfx_index_buffer_handle_t:
        uint16_t idx
    ctypedef struct bgfx_indirect_buffer_handle_t:
        uint16_t idx
    ctypedef struct bgfx_occlusion_query_handle_t:
        uint16_t idx
    ctypedef struct bgfx_program_handle_t:
        uint16_t idx
    ctypedef struct bgfx_shader_handle_t:
        uint16_t idx
    ctypedef struct bgfx_texture_handle_t:
        uint16_t idx
    ctypedef struct bgfx_uniform_handle_t:
        uint16_t idx
    ctypedef struct bgfx_vertex_buffer_handle_t:
        uint16_t idx
    ctypedef struct bgfx_vertex_layout_handle_t:
        uint16_t idx
    ctypedef struct bgfx_handle_t:
        uint16_t idx
    cdef bint BGFX_HANDLE_IS_VALID(bgfx_handle_t h)

    ctypedef void (*bgfx_release_fn_t)(void* _ptr, void* _userData)

    ctypedef struct bgfx_caps_gpu_t:
        uint16_t vendorId
        uint16_t deviceId

    ctypedef struct bgfx_caps_limits_t:
        uint32_t maxDrawCalls
        uint32_t maxBlits
        uint32_t maxTextureSize
        uint32_t maxTextureLayers
        uint32_t maxViews
        uint32_t maxFrameBuffers
        uint32_t maxFBAttachments
        uint32_t maxPrograms
        uint32_t maxShaders
        uint32_t maxTextures
        uint32_t maxTextureSamplers
        uint32_t maxComputeBindings
        uint32_t maxVertexLayouts
        uint32_t maxVertexStreams
        uint32_t maxIndexBuffers
        uint32_t maxVertexBuffers
        uint32_t maxDynamicIndexBuffers
        uint32_t maxDynamicVertexBuffers
        uint32_t maxUniforms
        uint32_t maxOcclusionQueries
        uint32_t maxEncoders
        uint32_t minResourceCbSize
        uint32_t transientVbSize
        uint32_t transientIbSize

    ctypedef struct bgfx_caps_t:
        bgfx_renderer_type_t rendererType
        uint64_t supported
        uint16_t vendorId
        uint16_t deviceId
        bint homogeneousDepth
        bint originBottomLeft
        uint8_t numGPUs
        bgfx_caps_gpu_t gpu[4]
        bgfx_caps_limits_t limits
        uint16_t *formats

    ctypedef struct bgfx_internal_data_t:
        const bgfx_caps_t* caps
        void* context

    ctypedef struct bgfx_platform_data_t:
        void* ndt
        void* nwh
        void* context
        void* backBuffer
        void* backBufferDS

    ctypedef struct bgfx_resolution_t:
        bgfx_texture_format_t format
        uint32_t width
        uint32_t height
        uint32_t reset
        uint8_t numBackBuffers
        uint8_t maxFrameLatency

    ctypedef struct bgfx_init_limits_t:
        uint16_t maxEncoders
        uint32_t minResourceCbSize
        uint32_t transientVbSize
        uint32_t transientIbSize

    ctypedef struct bgfx_init_t:
        bgfx_renderer_type_t type
        uint16_t vendorId
        uint16_t deviceId
        uint64_t capabilities
        bint debug
        bint profile
        bgfx_platform_data_t platformData
        bgfx_resolution_t resolution
        bgfx_init_limits_t limits
        bgfx_callback_interface_t* callback
        bgfx_allocator_interface_t* allocator

    ctypedef struct bgfx_memory_t:
        uint8_t* data
        uint32_t size

    ctypedef struct bgfx_transient_index_buffer_t:
        uint8_t* data
        uint32_t size
        uint32_t startIndex
        bgfx_index_buffer_handle_t handle
        bint isIndex16

    ctypedef struct bgfx_transient_vertex_buffer_t:
        uint8_t* data
        uint32_t size
        uint32_t startVertex
        uint16_t stride
        bgfx_vertex_buffer_handle_t handle
        bgfx_vertex_layout_handle_t layoutHandle

    ctypedef struct bgfx_instance_data_buffer_t:
        uint8_t* data
        uint32_t size
        uint32_t offset
        uint32_t num
        uint16_t stride
        bgfx_vertex_buffer_handle_t handle

    ctypedef struct bgfx_texture_info_t:
        bgfx_texture_format_t format
        uint32_t storageSize
        uint16_t width
        uint16_t height
        uint16_t depth
        uint16_t numLayers
        uint8_t numMips
        uint8_t bitsPerPixel
        bint cubeMap

    ctypedef struct bgfx_uniform_info_t:
        char name[256]
        bgfx_uniform_type_t type
        uint16_t num

    ctypedef struct bgfx_attachment_t:
        bgfx_access_t access
        bgfx_texture_handle_t handle
        uint16_t mip
        uint16_t layer
        uint16_t numLayers
        uint8_t resolve

    ctypedef struct bgfx_transform_t:
        float* data
        uint16_t num

    ctypedef struct bgfx_view_stats_t:
        char name[256]
        bgfx_view_id_t view
        int64_t cpuTimeBegin
        int64_t cpuTimeEnd
        int64_t gpuTimeBegin
        int64_t gpuTimeEnd

    ctypedef struct bgfx_encoder_stats_t:
        int64_t cpuTimeBegin
        int64_t cpuTimeEnd

    ctypedef struct bgfx_stats_t:
        int64_t cpuTimeFrame
        int64_t cpuTimeBegin
        int64_t cpuTimeEnd
        int64_t cpuTimerFreq
        int64_t gpuTimeBegin
        int64_t gpuTimeEnd
        int64_t gpuTimerFreq
        int64_t waitRender
        int64_t waitSubmit
        uint32_t numDraw
        uint32_t numCompute
        uint32_t numBlit
        uint32_t maxGpuLatency
        uint16_t numDynamicIndexBuffers
        uint16_t numDynamicVertexBuffers
        uint16_t numFrameBuffers
        uint16_t numIndexBuffers
        uint16_t numOcclusionQueries
        uint16_t numPrograms
        uint16_t numShaders
        uint16_t numTextures
        uint16_t numUniforms
        uint16_t numVertexBuffers
        uint16_t numVertexLayouts
        int64_t textureMemoryUsed
        int64_t rtMemoryUsed
        int32_t transientVbUsed
        int32_t transientIbUsed
        uint32_t *numPrims
        int64_t gpuMemoryMax
        int64_t gpuMemoryUsed
        uint16_t width
        uint16_t height
        uint16_t textWidth
        uint16_t textHeight
        uint16_t numViews
        bgfx_view_stats_t* viewStats
        uint8_t numEncoders
        bgfx_encoder_stats_t* encoderStats

    ctypedef struct bgfx_vertex_layout_t:
        uint32_t hash
        uint16_t stride
        uint16_t *offset
        uint16_t *attributes

    ctypedef struct bgfx_encoder_t:
        pass

    void bgfx_attachment_init(bgfx_attachment_t* _this, bgfx_texture_handle_t _handle, bgfx_access_t _access, uint16_t _layer, uint16_t _numLayers, uint16_t _mip, uint8_t _resolve)
    bgfx_vertex_layout_t* bgfx_vertex_layout_begin(bgfx_vertex_layout_t* _this, bgfx_renderer_type_t _rendererType)
    bgfx_vertex_layout_t* bgfx_vertex_layout_add(bgfx_vertex_layout_t* _this, bgfx_attrib_t _attrib, uint8_t _num, bgfx_attrib_type_t _type, bint _normalized, bint _asInt)
    void bgfx_vertex_layout_decode(const bgfx_vertex_layout_t* _this, bgfx_attrib_t _attrib, uint8_t * _num, bgfx_attrib_type_t * _type, bint * _normalized, bint * _asInt)
    bint bgfx_vertex_layout_has(const bgfx_vertex_layout_t* _this, bgfx_attrib_t _attrib)
    bgfx_vertex_layout_t* bgfx_vertex_layout_skip(bgfx_vertex_layout_t* _this, uint8_t _num)
    void bgfx_vertex_layout_end(bgfx_vertex_layout_t* _this)
    void bgfx_vertex_pack(const float _input[4], bint _inputNormalized, bgfx_attrib_t _attr, const bgfx_vertex_layout_t * _layout, void* _data, uint32_t _index)
    void bgfx_vertex_unpack(float _output[4], bgfx_attrib_t _attr, const bgfx_vertex_layout_t * _layout, const void* _data, uint32_t _index)
    void bgfx_vertex_convert(const bgfx_vertex_layout_t * _dstLayout, void* _dstData, const bgfx_vertex_layout_t * _srcLayout, const void* _srcData, uint32_t _num)
    uint32_t bgfx_weld_vertices(void* _output, const bgfx_vertex_layout_t * _layout, const void* _data, uint32_t _num, bint _index32, float _epsilon)
    uint32_t bgfx_topology_convert(bgfx_topology_convert_t _conversion, void* _dst, uint32_t _dstSize, const void* _indices, uint32_t _numIndices, bint _index32)
    void bgfx_topology_sort_tri_list(bgfx_topology_sort_t _sort, void* _dst, uint32_t _dstSize, const float _dir[3], const float _pos[3], const void* _vertices, uint32_t _stride, const void* _indices, uint32_t _numIndices, bint _index32)
    uint8_t bgfx_get_supported_renderers(uint8_t _max, bgfx_renderer_type_t* _enum)
    const char* bgfx_get_renderer_name(bgfx_renderer_type_t _type)
    void bgfx_init_ctor(bgfx_init_t* _init)
    bint bgfx_init(const bgfx_init_t * _init)
    void bgfx_shutdown()
    void bgfx_reset(uint32_t _width, uint32_t _height, uint32_t _flags, bgfx_texture_format_t _format)
    uint32_t bgfx_frame(bint _capture)
    bgfx_renderer_type_t bgfx_get_renderer_type()
    const bgfx_caps_t* bgfx_get_caps()
    const bgfx_stats_t* bgfx_get_stats()
    const bgfx_memory_t* bgfx_alloc(uint32_t _size)
    const bgfx_memory_t* bgfx_copy(const void* _data, uint32_t _size)
    const bgfx_memory_t* bgfx_make_ref(const void* _data, uint32_t _size)
    const bgfx_memory_t* bgfx_make_ref_release(const void* _data, uint32_t _size, bgfx_release_fn_t _releaseFn, void* _userData)
    void bgfx_set_debug(uint32_t _debug)
    void bgfx_dbg_text_clear(uint8_t _attr, bint _small)
    void bgfx_dbg_text_printf(uint16_t _x, uint16_t _y, uint8_t _attr, const char* _format, ... )
    void bgfx_dbg_text_vprintf(uint16_t _x, uint16_t _y, uint8_t _attr, const char* _format, va_list _argList)
    void bgfx_dbg_text_image(uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const void* _data, uint16_t _pitch)
    bgfx_index_buffer_handle_t bgfx_create_index_buffer(const bgfx_memory_t* _mem, uint16_t _flags)
    void bgfx_set_index_buffer_name(bgfx_index_buffer_handle_t _handle, const char* _name, int32_t _len)
    void bgfx_destroy_index_buffer(bgfx_index_buffer_handle_t _handle)
    bgfx_vertex_layout_handle_t bgfx_create_vertex_layout(const bgfx_vertex_layout_t * _layout)
    void bgfx_destroy_vertex_layout(bgfx_vertex_layout_handle_t _layoutHandle)
    bgfx_vertex_buffer_handle_t bgfx_create_vertex_buffer(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t * _layout, uint16_t _flags)
    void bgfx_set_vertex_buffer_name(bgfx_vertex_buffer_handle_t _handle, const char* _name, int32_t _len)
    void bgfx_destroy_vertex_buffer(bgfx_vertex_buffer_handle_t _handle)
    bgfx_dynamic_index_buffer_handle_t bgfx_create_dynamic_index_buffer(uint32_t _num, uint16_t _flags)
    bgfx_dynamic_index_buffer_handle_t bgfx_create_dynamic_index_buffer_mem(const bgfx_memory_t* _mem, uint16_t _flags)
    void bgfx_update_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _startIndex, const bgfx_memory_t* _mem)
    void bgfx_destroy_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle)
    bgfx_dynamic_vertex_buffer_handle_t bgfx_create_dynamic_vertex_buffer(uint32_t _num, const bgfx_vertex_layout_t* _layout, uint16_t _flags)
    bgfx_dynamic_vertex_buffer_handle_t bgfx_create_dynamic_vertex_buffer_mem(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t* _layout, uint16_t _flags)
    void bgfx_update_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, const bgfx_memory_t* _mem)
    void bgfx_destroy_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle)
    uint32_t bgfx_get_avail_transient_index_buffer(uint32_t _num, bint _index32)
    uint32_t bgfx_get_avail_transient_vertex_buffer(uint32_t _num, const bgfx_vertex_layout_t * _layout)
    uint32_t bgfx_get_avail_instance_data_buffer(uint32_t _num, uint16_t _stride)
    void bgfx_alloc_transient_index_buffer(bgfx_transient_index_buffer_t* _tib, uint32_t _num, bint _index32)
    void bgfx_alloc_transient_vertex_buffer(bgfx_transient_vertex_buffer_t* _tvb, uint32_t _num, const bgfx_vertex_layout_t * _layout)
    bint bgfx_alloc_transient_buffers(bgfx_transient_vertex_buffer_t* _tvb, const bgfx_vertex_layout_t * _layout, uint32_t _numVertices, bgfx_transient_index_buffer_t* _tib, uint32_t _numIndices, bint _index32)
    void bgfx_alloc_instance_data_buffer(bgfx_instance_data_buffer_t* _idb, uint32_t _num, uint16_t _stride)
    bgfx_indirect_buffer_handle_t bgfx_create_indirect_buffer(uint32_t _num)
    void bgfx_destroy_indirect_buffer(bgfx_indirect_buffer_handle_t _handle)
    bgfx_shader_handle_t bgfx_create_shader(const bgfx_memory_t* _mem)
    uint16_t bgfx_get_shader_uniforms(bgfx_shader_handle_t _handle, bgfx_uniform_handle_t* _uniforms, uint16_t _max)
    void bgfx_set_shader_name(bgfx_shader_handle_t _handle, const char* _name, int32_t _len)
    void bgfx_destroy_shader(bgfx_shader_handle_t _handle)
    bgfx_program_handle_t bgfx_create_program(bgfx_shader_handle_t _vsh, bgfx_shader_handle_t _fsh, bint _destroyShaders)
    bgfx_program_handle_t bgfx_create_compute_program(bgfx_shader_handle_t _csh, bint _destroyShaders)
    void bgfx_destroy_program(bgfx_program_handle_t _handle)
    bint bgfx_is_texture_valid(uint16_t _depth, bint _cubeMap, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags)
    bint bgfx_is_frame_buffer_valid(uint8_t _num, const bgfx_attachment_t* _attachment)
    void bgfx_calc_texture_size(bgfx_texture_info_t * _info, uint16_t _width, uint16_t _height, uint16_t _depth, bint _cubeMap, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format)
    bgfx_texture_handle_t bgfx_create_texture(const bgfx_memory_t* _mem, uint64_t _flags, uint8_t _skip, bgfx_texture_info_t* _info)
    bgfx_texture_handle_t bgfx_create_texture_2d(uint16_t _width, uint16_t _height, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
    bgfx_texture_handle_t bgfx_create_texture_2d_scaled(bgfx_backbuffer_ratio_t _ratio, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags)
    bgfx_texture_handle_t bgfx_create_texture_3d(uint16_t _width, uint16_t _height, uint16_t _depth, bint _hasMips, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
    bgfx_texture_handle_t bgfx_create_texture_cube(uint16_t _size, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
    void bgfx_update_texture_2d(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch)
    void bgfx_update_texture_3d(bgfx_texture_handle_t _handle, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _z, uint16_t _width, uint16_t _height, uint16_t _depth, const bgfx_memory_t* _mem)
    void bgfx_update_texture_cube(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _side, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch)
    uint32_t bgfx_read_texture(bgfx_texture_handle_t _handle, void* _data, uint8_t _mip)
    void bgfx_set_texture_name(bgfx_texture_handle_t _handle, const char* _name, int32_t _len)
    void* bgfx_get_direct_access_ptr(bgfx_texture_handle_t _handle)
    void bgfx_destroy_texture(bgfx_texture_handle_t _handle)
    bgfx_frame_buffer_handle_t bgfx_create_frame_buffer(uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, uint64_t _textureFlags)
    bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_scaled(bgfx_backbuffer_ratio_t _ratio, bgfx_texture_format_t _format, uint64_t _textureFlags)
    bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_c_from_handles(uint8_t _num, const bgfx_texture_handle_t* _handles, bint _destroyTexture)
    bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_attachment(uint8_t _num, const bgfx_attachment_t* _attachment, bint _destroyTexture)
    bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_nwh(void* _nwh, uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, bgfx_texture_format_t _depthFormat)
    void bgfx_set_frame_buffer_name(bgfx_frame_buffer_handle_t _handle, const char* _name, int32_t _len)
    bgfx_texture_handle_t bgfx_get_texture(bgfx_frame_buffer_handle_t _handle, uint8_t _attachment)
    void bgfx_destroy_frame_buffer(bgfx_frame_buffer_handle_t _handle)
    bgfx_uniform_handle_t bgfx_create_uniform(const char* _name, bgfx_uniform_type_t _type, uint16_t _num)
    void bgfx_get_uniform_info(bgfx_uniform_handle_t _handle, bgfx_uniform_info_t * _info)
    void bgfx_destroy_uniform(bgfx_uniform_handle_t _handle)
    bgfx_occlusion_query_handle_t bgfx_create_occlusion_query()
    bgfx_occlusion_query_result_t bgfx_get_result(bgfx_occlusion_query_handle_t _handle, int32_t* _result)
    void bgfx_destroy_occlusion_query(bgfx_occlusion_query_handle_t _handle)
    void bgfx_set_palette_color(uint8_t _index, const float _rgba[4])
    void bgfx_set_palette_color_rgba8(uint8_t _index, uint32_t _rgba)
    void bgfx_set_view_name(bgfx_view_id_t _id, const char* _name)
    void bgfx_set_view_rect(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
    void bgfx_set_view_rect_ratio(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, bgfx_backbuffer_ratio_t _ratio)
    void bgfx_set_view_scissor(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
    void bgfx_set_view_clear(bgfx_view_id_t _id, uint16_t _flags, uint32_t _rgba, float _depth, uint8_t _stencil)
    void bgfx_set_view_clear_mrt(bgfx_view_id_t _id, uint16_t _flags, float _depth, uint8_t _stencil, uint8_t _c0, uint8_t _c1, uint8_t _c2, uint8_t _c3, uint8_t _c4, uint8_t _c5, uint8_t _c6, uint8_t _c7)
    void bgfx_set_view_mode(bgfx_view_id_t _id, bgfx_view_mode_t _mode)
    void bgfx_set_view_frame_buffer(bgfx_view_id_t _id, bgfx_frame_buffer_handle_t _handle)
    void bgfx_set_view_transform(bgfx_view_id_t _id, const void* _view, const void* _proj)
    void bgfx_set_view_order(bgfx_view_id_t _id, uint16_t _num, const bgfx_view_id_t* _order)
    void bgfx_reset_view(bgfx_view_id_t _id)
    bgfx_encoder_t* bgfx_encoder_begin(bint _forThread)
    void bgfx_encoder_end(bgfx_encoder_t* _encoder)
    void bgfx_encoder_set_marker(bgfx_encoder_t* _this, const char* _marker)
    void bgfx_encoder_set_state(bgfx_encoder_t* _this, uint64_t _state, uint32_t _rgba)
    void bgfx_encoder_set_condition(bgfx_encoder_t* _this, bgfx_occlusion_query_handle_t _handle, bint _visible)
    void bgfx_encoder_set_stencil(bgfx_encoder_t* _this, uint32_t _fstencil, uint32_t _bstencil)
    uint16_t bgfx_encoder_set_scissor(bgfx_encoder_t* _this, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
    void bgfx_encoder_set_scissor_cached(bgfx_encoder_t* _this, uint16_t _cache)
    uint32_t bgfx_encoder_set_transform(bgfx_encoder_t* _this, const void* _mtx, uint16_t _num)
    void bgfx_encoder_set_transform_cached(bgfx_encoder_t* _this, uint32_t _cache, uint16_t _num)
    uint32_t bgfx_encoder_alloc_transform(bgfx_encoder_t* _this, bgfx_transform_t* _transform, uint16_t _num)
    void bgfx_encoder_set_uniform(bgfx_encoder_t* _this, bgfx_uniform_handle_t _handle, const void* _value, uint16_t _num)
    void bgfx_encoder_set_index_buffer(bgfx_encoder_t* _this, bgfx_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
    void bgfx_encoder_set_dynamic_index_buffer(bgfx_encoder_t* _this, bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
    void bgfx_encoder_set_transient_index_buffer(bgfx_encoder_t* _this, const bgfx_transient_index_buffer_t* _tib, uint32_t _firstIndex, uint32_t _numIndices)
    void bgfx_encoder_set_vertex_buffer(bgfx_encoder_t* _this, uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
    void bgfx_encoder_set_vertex_buffer_with_layout(bgfx_encoder_t* _this, uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
    void bgfx_encoder_set_dynamic_vertex_buffer(bgfx_encoder_t* _this, uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
    void bgfx_encoder_set_dynamic_vertex_buffer_with_layout(bgfx_encoder_t* _this, uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
    void bgfx_encoder_set_transient_vertex_buffer(bgfx_encoder_t* _this, uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices)
    void bgfx_encoder_set_transient_vertex_buffer_with_layout(bgfx_encoder_t* _this, uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
    void bgfx_encoder_set_vertex_count(bgfx_encoder_t* _this, uint32_t _numVertices)
    void bgfx_encoder_set_instance_data_buffer(bgfx_encoder_t* _this, const bgfx_instance_data_buffer_t* _idb, uint32_t _start, uint32_t _num)
    void bgfx_encoder_set_instance_data_from_vertex_buffer(bgfx_encoder_t* _this, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
    void bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer(bgfx_encoder_t* _this, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
    void bgfx_encoder_set_instance_count(bgfx_encoder_t* _this, uint32_t _numInstances)
    void bgfx_encoder_set_texture(bgfx_encoder_t* _this, uint8_t _stage, bgfx_uniform_handle_t _sampler, bgfx_texture_handle_t _handle, uint32_t _flags)
    void bgfx_encoder_touch(bgfx_encoder_t* _this, bgfx_view_id_t _id)
    void bgfx_encoder_submit(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _depth, uint8_t _flags)
    void bgfx_encoder_submit_occlusion_query(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_occlusion_query_handle_t _occlusionQuery, uint32_t _depth, uint8_t _flags)
    void bgfx_encoder_submit_indirect(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint32_t _depth, uint8_t _flags)
    void bgfx_encoder_set_compute_index_buffer(bgfx_encoder_t* _this, uint8_t _stage, bgfx_index_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_encoder_set_compute_vertex_buffer(bgfx_encoder_t* _this, uint8_t _stage, bgfx_vertex_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_encoder_set_compute_dynamic_index_buffer(bgfx_encoder_t* _this, uint8_t _stage, bgfx_dynamic_index_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_encoder_set_compute_dynamic_vertex_buffer(bgfx_encoder_t* _this, uint8_t _stage, bgfx_dynamic_vertex_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_encoder_set_compute_indirect_buffer(bgfx_encoder_t* _this, uint8_t _stage, bgfx_indirect_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_encoder_set_image(bgfx_encoder_t* _this, uint8_t _stage, bgfx_texture_handle_t _handle, uint8_t _mip, bgfx_access_t _access, bgfx_texture_format_t _format)
    void bgfx_encoder_dispatch(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _numX, uint32_t _numY, uint32_t _numZ, uint8_t _flags)
    void bgfx_encoder_dispatch_indirect(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint8_t _flags)
    void bgfx_encoder_discard(bgfx_encoder_t* _this, uint8_t _flags)
    void bgfx_encoder_blit(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_texture_handle_t _dst, uint8_t _dstMip, uint16_t _dstX, uint16_t _dstY, uint16_t _dstZ, bgfx_texture_handle_t _src, uint8_t _srcMip, uint16_t _srcX, uint16_t _srcY, uint16_t _srcZ, uint16_t _width, uint16_t _height, uint16_t _depth)
    void bgfx_request_screen_shot(bgfx_frame_buffer_handle_t _handle, const char* _filePath)
    bgfx_render_frame_t bgfx_render_frame(int32_t _msecs)
    void bgfx_set_platform_data(const bgfx_platform_data_t * _data)
    const bgfx_internal_data_t* bgfx_get_internal_data()
    uintptr_t bgfx_override_internal_texture_ptr(bgfx_texture_handle_t _handle, uintptr_t _ptr)
    uintptr_t bgfx_override_internal_texture(bgfx_texture_handle_t _handle, uint16_t _width, uint16_t _height, uint8_t _numMips, bgfx_texture_format_t _format, uint64_t _flags)
    void bgfx_set_marker(const char* _marker)
    void bgfx_set_state(uint64_t _state, uint32_t _rgba)
    void bgfx_set_condition(bgfx_occlusion_query_handle_t _handle, bint _visible)
    void bgfx_set_stencil(uint32_t _fstencil, uint32_t _bstencil)
    uint16_t bgfx_set_scissor(uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
    void bgfx_set_scissor_cached(uint16_t _cache)
    uint32_t bgfx_set_transform(const void* _mtx, uint16_t _num)
    void bgfx_set_transform_cached(uint32_t _cache, uint16_t _num)
    uint32_t bgfx_alloc_transform(bgfx_transform_t* _transform, uint16_t _num)
    void bgfx_set_uniform(bgfx_uniform_handle_t _handle, const void* _value, uint16_t _num)
    void bgfx_set_index_buffer(bgfx_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
    void bgfx_set_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
    void bgfx_set_transient_index_buffer(const bgfx_transient_index_buffer_t* _tib, uint32_t _firstIndex, uint32_t _numIndices)
    void bgfx_set_vertex_buffer(uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
    void bgfx_set_vertex_buffer_with_layout(uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
    void bgfx_set_dynamic_vertex_buffer(uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
    void bgfx_set_dynamic_vertex_buffer_with_layout(uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
    void bgfx_set_transient_vertex_buffer(uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices)
    void bgfx_set_transient_vertex_buffer_with_layout(uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
    void bgfx_set_vertex_count(uint32_t _numVertices)
    void bgfx_set_instance_data_buffer(const bgfx_instance_data_buffer_t* _idb, uint32_t _start, uint32_t _num)
    void bgfx_set_instance_data_from_vertex_buffer(bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
    void bgfx_set_instance_data_from_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
    void bgfx_set_instance_count(uint32_t _numInstances)
    void bgfx_set_texture(uint8_t _stage, bgfx_uniform_handle_t _sampler, bgfx_texture_handle_t _handle, uint32_t _flags)
    void bgfx_touch(bgfx_view_id_t _id)
    void bgfx_submit(bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _depth, uint8_t _flags)
    void bgfx_submit_occlusion_query(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_occlusion_query_handle_t _occlusionQuery, uint32_t _depth, uint8_t _flags)
    void bgfx_submit_indirect(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint32_t _depth, uint8_t _flags)
    void bgfx_set_compute_index_buffer(uint8_t _stage, bgfx_index_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_set_compute_vertex_buffer(uint8_t _stage, bgfx_vertex_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_set_compute_dynamic_index_buffer(uint8_t _stage, bgfx_dynamic_index_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_set_compute_dynamic_vertex_buffer(uint8_t _stage, bgfx_dynamic_vertex_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_set_compute_indirect_buffer(uint8_t _stage, bgfx_indirect_buffer_handle_t _handle, bgfx_access_t _access)
    void bgfx_set_image(uint8_t _stage, bgfx_texture_handle_t _handle, uint8_t _mip, bgfx_access_t _access, bgfx_texture_format_t _format)
    void bgfx_dispatch(bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _numX, uint32_t _numY, uint32_t _numZ, uint8_t _flags)
    void bgfx_dispatch_indirect(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint8_t _flags)
    void bgfx_discard(uint8_t _flags)
    void bgfx_blit(bgfx_view_id_t _id, bgfx_texture_handle_t _dst, uint8_t _dstMip, uint16_t _dstX, uint16_t _dstY, uint16_t _dstZ, bgfx_texture_handle_t _src, uint8_t _srcMip, uint16_t _srcX, uint16_t _srcY, uint16_t _srcZ, uint16_t _width, uint16_t _height, uint16_t _depth)

    ctypedef enum bgfx_function_id_t:
        BGFX_FUNCTION_ID_ATTACHMENT_INIT
        BGFX_FUNCTION_ID_VERTEX_LAYOUT_BEGIN
        BGFX_FUNCTION_ID_VERTEX_LAYOUT_ADD
        BGFX_FUNCTION_ID_VERTEX_LAYOUT_DECODE
        BGFX_FUNCTION_ID_VERTEX_LAYOUT_HAS
        BGFX_FUNCTION_ID_VERTEX_LAYOUT_SKIP
        BGFX_FUNCTION_ID_VERTEX_LAYOUT_END
        BGFX_FUNCTION_ID_VERTEX_PACK
        BGFX_FUNCTION_ID_VERTEX_UNPACK
        BGFX_FUNCTION_ID_VERTEX_CONVERT
        BGFX_FUNCTION_ID_WELD_VERTICES
        BGFX_FUNCTION_ID_TOPOLOGY_CONVERT
        BGFX_FUNCTION_ID_TOPOLOGY_SORT_TRI_LIST
        BGFX_FUNCTION_ID_GET_SUPPORTED_RENDERERS
        BGFX_FUNCTION_ID_GET_RENDERER_NAME
        BGFX_FUNCTION_ID_INIT_CTOR
        BGFX_FUNCTION_ID_INIT
        BGFX_FUNCTION_ID_SHUTDOWN
        BGFX_FUNCTION_ID_RESET
        BGFX_FUNCTION_ID_FRAME
        BGFX_FUNCTION_ID_GET_RENDERER_TYPE
        BGFX_FUNCTION_ID_GET_CAPS
        BGFX_FUNCTION_ID_GET_STATS
        BGFX_FUNCTION_ID_ALLOC
        BGFX_FUNCTION_ID_COPY
        BGFX_FUNCTION_ID_MAKE_REF
        BGFX_FUNCTION_ID_MAKE_REF_RELEASE
        BGFX_FUNCTION_ID_SET_DEBUG
        BGFX_FUNCTION_ID_DBG_TEXT_CLEAR
        BGFX_FUNCTION_ID_DBG_TEXT_PRINTF
        BGFX_FUNCTION_ID_DBG_TEXT_VPRINTF
        BGFX_FUNCTION_ID_DBG_TEXT_IMAGE
        BGFX_FUNCTION_ID_CREATE_INDEX_BUFFER
        BGFX_FUNCTION_ID_SET_INDEX_BUFFER_NAME
        BGFX_FUNCTION_ID_DESTROY_INDEX_BUFFER
        BGFX_FUNCTION_ID_CREATE_VERTEX_LAYOUT
        BGFX_FUNCTION_ID_DESTROY_VERTEX_LAYOUT
        BGFX_FUNCTION_ID_CREATE_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_VERTEX_BUFFER_NAME
        BGFX_FUNCTION_ID_DESTROY_VERTEX_BUFFER
        BGFX_FUNCTION_ID_CREATE_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_CREATE_DYNAMIC_INDEX_BUFFER_MEM
        BGFX_FUNCTION_ID_UPDATE_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_DESTROY_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_CREATE_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_CREATE_DYNAMIC_VERTEX_BUFFER_MEM
        BGFX_FUNCTION_ID_UPDATE_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_DESTROY_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_GET_AVAIL_TRANSIENT_INDEX_BUFFER
        BGFX_FUNCTION_ID_GET_AVAIL_TRANSIENT_VERTEX_BUFFER
        BGFX_FUNCTION_ID_GET_AVAIL_INSTANCE_DATA_BUFFER
        BGFX_FUNCTION_ID_ALLOC_TRANSIENT_INDEX_BUFFER
        BGFX_FUNCTION_ID_ALLOC_TRANSIENT_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ALLOC_TRANSIENT_BUFFERS
        BGFX_FUNCTION_ID_ALLOC_INSTANCE_DATA_BUFFER
        BGFX_FUNCTION_ID_CREATE_INDIRECT_BUFFER
        BGFX_FUNCTION_ID_DESTROY_INDIRECT_BUFFER
        BGFX_FUNCTION_ID_CREATE_SHADER
        BGFX_FUNCTION_ID_GET_SHADER_UNIFORMS
        BGFX_FUNCTION_ID_SET_SHADER_NAME
        BGFX_FUNCTION_ID_DESTROY_SHADER
        BGFX_FUNCTION_ID_CREATE_PROGRAM
        BGFX_FUNCTION_ID_CREATE_COMPUTE_PROGRAM
        BGFX_FUNCTION_ID_DESTROY_PROGRAM
        BGFX_FUNCTION_ID_IS_TEXTURE_VALID
        BGFX_FUNCTION_ID_IS_FRAME_BUFFER_VALID
        BGFX_FUNCTION_ID_CALC_TEXTURE_SIZE
        BGFX_FUNCTION_ID_CREATE_TEXTURE
        BGFX_FUNCTION_ID_CREATE_TEXTURE_2D
        BGFX_FUNCTION_ID_CREATE_TEXTURE_2D_SCALED
        BGFX_FUNCTION_ID_CREATE_TEXTURE_3D
        BGFX_FUNCTION_ID_CREATE_TEXTURE_CUBE
        BGFX_FUNCTION_ID_UPDATE_TEXTURE_2D
        BGFX_FUNCTION_ID_UPDATE_TEXTURE_3D
        BGFX_FUNCTION_ID_UPDATE_TEXTURE_CUBE
        BGFX_FUNCTION_ID_READ_TEXTURE
        BGFX_FUNCTION_ID_SET_TEXTURE_NAME
        BGFX_FUNCTION_ID_GET_DIRECT_ACCESS_PTR
        BGFX_FUNCTION_ID_DESTROY_TEXTURE
        BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER
        BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_SCALED
        BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_c_from_handleS
        BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_FROM_ATTACHMENT
        BGFX_FUNCTION_ID_CREATE_FRAME_BUFFER_FROM_NWH
        BGFX_FUNCTION_ID_SET_FRAME_BUFFER_NAME
        BGFX_FUNCTION_ID_GET_TEXTURE
        BGFX_FUNCTION_ID_DESTROY_FRAME_BUFFER
        BGFX_FUNCTION_ID_CREATE_UNIFORM
        BGFX_FUNCTION_ID_GET_UNIFORM_INFO
        BGFX_FUNCTION_ID_DESTROY_UNIFORM
        BGFX_FUNCTION_ID_CREATE_OCCLUSION_QUERY
        BGFX_FUNCTION_ID_GET_RESULT
        BGFX_FUNCTION_ID_DESTROY_OCCLUSION_QUERY
        BGFX_FUNCTION_ID_SET_PALETTE_COLOR
        BGFX_FUNCTION_ID_SET_PALETTE_COLOR_RGBA8
        BGFX_FUNCTION_ID_SET_VIEW_NAME
        BGFX_FUNCTION_ID_SET_VIEW_RECT
        BGFX_FUNCTION_ID_SET_VIEW_RECT_RATIO
        BGFX_FUNCTION_ID_SET_VIEW_SCISSOR
        BGFX_FUNCTION_ID_SET_VIEW_CLEAR
        BGFX_FUNCTION_ID_SET_VIEW_CLEAR_MRT
        BGFX_FUNCTION_ID_SET_VIEW_MODE
        BGFX_FUNCTION_ID_SET_VIEW_FRAME_BUFFER
        BGFX_FUNCTION_ID_SET_VIEW_TRANSFORM
        BGFX_FUNCTION_ID_SET_VIEW_ORDER
        BGFX_FUNCTION_ID_RESET_VIEW
        BGFX_FUNCTION_ID_ENCODER_BEGIN
        BGFX_FUNCTION_ID_ENCODER_END
        BGFX_FUNCTION_ID_ENCODER_SET_MARKER
        BGFX_FUNCTION_ID_ENCODER_SET_STATE
        BGFX_FUNCTION_ID_ENCODER_SET_CONDITION
        BGFX_FUNCTION_ID_ENCODER_SET_STENCIL
        BGFX_FUNCTION_ID_ENCODER_SET_SCISSOR
        BGFX_FUNCTION_ID_ENCODER_SET_SCISSOR_CACHED
        BGFX_FUNCTION_ID_ENCODER_SET_TRANSFORM
        BGFX_FUNCTION_ID_ENCODER_SET_TRANSFORM_CACHED
        BGFX_FUNCTION_ID_ENCODER_ALLOC_TRANSFORM
        BGFX_FUNCTION_ID_ENCODER_SET_UNIFORM
        BGFX_FUNCTION_ID_ENCODER_SET_INDEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_TRANSIENT_INDEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_VERTEX_BUFFER_WITH_LAYOUT
        BGFX_FUNCTION_ID_ENCODER_SET_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_DYNAMIC_VERTEX_BUFFER_WITH_LAYOUT
        BGFX_FUNCTION_ID_ENCODER_SET_TRANSIENT_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_TRANSIENT_VERTEX_BUFFER_WITH_LAYOUT
        BGFX_FUNCTION_ID_ENCODER_SET_VERTEX_COUNT
        BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_DATA_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_DATA_FROM_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_DATA_FROM_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_INSTANCE_COUNT
        BGFX_FUNCTION_ID_ENCODER_SET_TEXTURE
        BGFX_FUNCTION_ID_ENCODER_TOUCH
        BGFX_FUNCTION_ID_ENCODER_SUBMIT
        BGFX_FUNCTION_ID_ENCODER_SUBMIT_OCCLUSION_QUERY
        BGFX_FUNCTION_ID_ENCODER_SUBMIT_INDIRECT
        BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_INDEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_COMPUTE_INDIRECT_BUFFER
        BGFX_FUNCTION_ID_ENCODER_SET_IMAGE
        BGFX_FUNCTION_ID_ENCODER_DISPATCH
        BGFX_FUNCTION_ID_ENCODER_DISPATCH_INDIRECT
        BGFX_FUNCTION_ID_ENCODER_DISCARD
        BGFX_FUNCTION_ID_ENCODER_BLIT
        BGFX_FUNCTION_ID_REQUEST_SCREEN_SHOT
        BGFX_FUNCTION_ID_RENDER_FRAME
        BGFX_FUNCTION_ID_SET_PLATFORM_DATA
        BGFX_FUNCTION_ID_GET_INTERNAL_DATA
        BGFX_FUNCTION_ID_OVERRIDE_INTERNAL_TEXTURE_PTR
        BGFX_FUNCTION_ID_OVERRIDE_INTERNAL_TEXTURE
        BGFX_FUNCTION_ID_SET_MARKER
        BGFX_FUNCTION_ID_SET_STATE
        BGFX_FUNCTION_ID_SET_CONDITION
        BGFX_FUNCTION_ID_SET_STENCIL
        BGFX_FUNCTION_ID_SET_SCISSOR
        BGFX_FUNCTION_ID_SET_SCISSOR_CACHED
        BGFX_FUNCTION_ID_SET_TRANSFORM
        BGFX_FUNCTION_ID_SET_TRANSFORM_CACHED
        BGFX_FUNCTION_ID_ALLOC_TRANSFORM
        BGFX_FUNCTION_ID_SET_UNIFORM
        BGFX_FUNCTION_ID_SET_INDEX_BUFFER
        BGFX_FUNCTION_ID_SET_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_SET_TRANSIENT_INDEX_BUFFER
        BGFX_FUNCTION_ID_SET_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_VERTEX_BUFFER_WITH_LAYOUT
        BGFX_FUNCTION_ID_SET_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_DYNAMIC_VERTEX_BUFFER_WITH_LAYOUT
        BGFX_FUNCTION_ID_SET_TRANSIENT_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_TRANSIENT_VERTEX_BUFFER_WITH_LAYOUT
        BGFX_FUNCTION_ID_SET_VERTEX_COUNT
        BGFX_FUNCTION_ID_SET_INSTANCE_DATA_BUFFER
        BGFX_FUNCTION_ID_SET_INSTANCE_DATA_FROM_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_INSTANCE_DATA_FROM_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_INSTANCE_COUNT
        BGFX_FUNCTION_ID_SET_TEXTURE
        BGFX_FUNCTION_ID_TOUCH
        BGFX_FUNCTION_ID_SUBMIT
        BGFX_FUNCTION_ID_SUBMIT_OCCLUSION_QUERY
        BGFX_FUNCTION_ID_SUBMIT_INDIRECT
        BGFX_FUNCTION_ID_SET_COMPUTE_INDEX_BUFFER
        BGFX_FUNCTION_ID_SET_COMPUTE_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_COMPUTE_DYNAMIC_INDEX_BUFFER
        BGFX_FUNCTION_ID_SET_COMPUTE_DYNAMIC_VERTEX_BUFFER
        BGFX_FUNCTION_ID_SET_COMPUTE_INDIRECT_BUFFER
        BGFX_FUNCTION_ID_SET_IMAGE
        BGFX_FUNCTION_ID_DISPATCH
        BGFX_FUNCTION_ID_DISPATCH_INDIRECT
        BGFX_FUNCTION_ID_DISCARD
        BGFX_FUNCTION_ID_BLIT
        BGFX_FUNCTION_ID_COUNT

    ctypedef struct bgfx_interface_vtbl_t:
        void (*attachment_init)(bgfx_attachment_t* _this, bgfx_texture_handle_t _handle, bgfx_access_t _access, uint16_t _layer, uint16_t _numLayers, uint16_t _mip, uint8_t _resolve)
        bgfx_vertex_layout_t* (*vertex_layout_begin)(bgfx_vertex_layout_t* _this, bgfx_renderer_type_t _rendererType)
        bgfx_vertex_layout_t* (*vertex_layout_add)(bgfx_vertex_layout_t* _this, bgfx_attrib_t _attrib, uint8_t _num, bgfx_attrib_type_t _type, bint _normalized, bint _asInt)
        void (*vertex_layout_decode)(const bgfx_vertex_layout_t* _this, bgfx_attrib_t _attrib, uint8_t * _num, bgfx_attrib_type_t * _type, bint * _normalized, bint * _asInt)
        bint (*vertex_layout_has)(const bgfx_vertex_layout_t* _this, bgfx_attrib_t _attrib)
        bgfx_vertex_layout_t* (*vertex_layout_skip)(bgfx_vertex_layout_t* _this, uint8_t _num)
        void (*vertex_layout_end)(bgfx_vertex_layout_t* _this)
        void (*vertex_pack)(const float _input[4], bint _inputNormalized, bgfx_attrib_t _attr, const bgfx_vertex_layout_t * _layout, void* _data, uint32_t _index)
        void (*vertex_unpack)(float _output[4], bgfx_attrib_t _attr, const bgfx_vertex_layout_t * _layout, const void* _data, uint32_t _index)
        void (*vertex_convert)(const bgfx_vertex_layout_t * _dstLayout, void* _dstData, const bgfx_vertex_layout_t * _srcLayout, const void* _srcData, uint32_t _num)
        uint32_t (*weld_vertices)(void* _output, const bgfx_vertex_layout_t * _layout, const void* _data, uint32_t _num, bint _index32, float _epsilon)
        uint32_t (*topology_convert)(bgfx_topology_convert_t _conversion, void* _dst, uint32_t _dstSize, const void* _indices, uint32_t _numIndices, bint _index32)
        void (*topology_sort_tri_list)(bgfx_topology_sort_t _sort, void* _dst, uint32_t _dstSize, const float _dir[3], const float _pos[3], const void* _vertices, uint32_t _stride, const void* _indices, uint32_t _numIndices, bint _index32)
        uint8_t (*get_supported_renderers)(uint8_t _max, bgfx_renderer_type_t* _enum)
        const char* (*get_renderer_name)(bgfx_renderer_type_t _type)
        void (*init_ctor)(bgfx_init_t* _init)
        bint (*init)(const bgfx_init_t * _init)
        void (*shutdown)()
        void (*reset)(uint32_t _width, uint32_t _height, uint32_t _flags, bgfx_texture_format_t _format)
        uint32_t (*frame)(bint _capture)
        bgfx_renderer_type_t (*get_renderer_type)()
        const bgfx_caps_t* (*get_caps)()
        const bgfx_stats_t* (*get_stats)()
        const bgfx_memory_t* (*alloc)(uint32_t _size)
        const bgfx_memory_t* (*copy)(const void* _data, uint32_t _size)
        const bgfx_memory_t* (*make_ref)(const void* _data, uint32_t _size)
        const bgfx_memory_t* (*make_ref_release)(const void* _data, uint32_t _size, bgfx_release_fn_t _releaseFn, void* _userData)
        void (*set_debug)(uint32_t _debug)
        void (*dbg_text_clear)(uint8_t _attr, bint _small)
        void (*dbg_text_printf)(uint16_t _x, uint16_t _y, uint8_t _attr, const char* _format, ... )
        void (*dbg_text_vprintf)(uint16_t _x, uint16_t _y, uint8_t _attr, const char* _format, va_list _argList)
        void (*dbg_text_image)(uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const void* _data, uint16_t _pitch)
        bgfx_index_buffer_handle_t (*create_index_buffer)(const bgfx_memory_t* _mem, uint16_t _flags)
        void (*set_index_buffer_name)(bgfx_index_buffer_handle_t _handle, const char* _name, int32_t _len)
        void (*destroy_index_buffer)(bgfx_index_buffer_handle_t _handle)
        bgfx_vertex_layout_handle_t (*create_vertex_layout)(const bgfx_vertex_layout_t * _layout)
        void (*destroy_vertex_layout)(bgfx_vertex_layout_handle_t _layoutHandle)
        bgfx_vertex_buffer_handle_t (*create_vertex_buffer)(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t * _layout, uint16_t _flags)
        void (*set_vertex_buffer_name)(bgfx_vertex_buffer_handle_t _handle, const char* _name, int32_t _len)
        void (*destroy_vertex_buffer)(bgfx_vertex_buffer_handle_t _handle)
        bgfx_dynamic_index_buffer_handle_t (*create_dynamic_index_buffer)(uint32_t _num, uint16_t _flags)
        bgfx_dynamic_index_buffer_handle_t (*create_dynamic_index_buffer_mem)(const bgfx_memory_t* _mem, uint16_t _flags)
        void (*update_dynamic_index_buffer)(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _startIndex, const bgfx_memory_t* _mem)
        void (*destroy_dynamic_index_buffer)(bgfx_dynamic_index_buffer_handle_t _handle)
        bgfx_dynamic_vertex_buffer_handle_t (*create_dynamic_vertex_buffer)(uint32_t _num, const bgfx_vertex_layout_t* _layout, uint16_t _flags)
        bgfx_dynamic_vertex_buffer_handle_t (*create_dynamic_vertex_buffer_mem)(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t* _layout, uint16_t _flags)
        void (*update_dynamic_vertex_buffer)(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, const bgfx_memory_t* _mem)
        void (*destroy_dynamic_vertex_buffer)(bgfx_dynamic_vertex_buffer_handle_t _handle)
        uint32_t (*get_avail_transient_index_buffer)(uint32_t _num, bint _index32)
        uint32_t (*get_avail_transient_vertex_buffer)(uint32_t _num, const bgfx_vertex_layout_t * _layout)
        uint32_t (*get_avail_instance_data_buffer)(uint32_t _num, uint16_t _stride)
        void (*alloc_transient_index_buffer)(bgfx_transient_index_buffer_t* _tib, uint32_t _num, bint _index32)
        void (*alloc_transient_vertex_buffer)(bgfx_transient_vertex_buffer_t* _tvb, uint32_t _num, const bgfx_vertex_layout_t * _layout)
        bint (*alloc_transient_buffers)(bgfx_transient_vertex_buffer_t* _tvb, const bgfx_vertex_layout_t * _layout, uint32_t _numVertices, bgfx_transient_index_buffer_t* _tib, uint32_t _numIndices, bint _index32)
        void (*alloc_instance_data_buffer)(bgfx_instance_data_buffer_t* _idb, uint32_t _num, uint16_t _stride)
        bgfx_indirect_buffer_handle_t (*create_indirect_buffer)(uint32_t _num)
        void (*destroy_indirect_buffer)(bgfx_indirect_buffer_handle_t _handle)
        bgfx_shader_handle_t (*create_shader)(const bgfx_memory_t* _mem)
        uint16_t (*get_shader_uniforms)(bgfx_shader_handle_t _handle, bgfx_uniform_handle_t* _uniforms, uint16_t _max)
        void (*set_shader_name)(bgfx_shader_handle_t _handle, const char* _name, int32_t _len)
        void (*destroy_shader)(bgfx_shader_handle_t _handle)
        bgfx_program_handle_t (*create_program)(bgfx_shader_handle_t _vsh, bgfx_shader_handle_t _fsh, bint _destroyShaders)
        bgfx_program_handle_t (*create_compute_program)(bgfx_shader_handle_t _csh, bint _destroyShaders)
        void (*destroy_program)(bgfx_program_handle_t _handle)
        bint (*is_texture_valid)(uint16_t _depth, bint _cubeMap, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags)
        bint (*is_frame_buffer_valid)(uint8_t _num, const bgfx_attachment_t* _attachment)
        void (*calc_texture_size)(bgfx_texture_info_t * _info, uint16_t _width, uint16_t _height, uint16_t _depth, bint _cubeMap, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format)
        bgfx_texture_handle_t (*create_texture)(const bgfx_memory_t* _mem, uint64_t _flags, uint8_t _skip, bgfx_texture_info_t* _info)
        bgfx_texture_handle_t (*create_texture_2d)(uint16_t _width, uint16_t _height, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
        bgfx_texture_handle_t (*create_texture_2d_scaled)(bgfx_backbuffer_ratio_t _ratio, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags)
        bgfx_texture_handle_t (*create_texture_3d)(uint16_t _width, uint16_t _height, uint16_t _depth, bint _hasMips, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
        bgfx_texture_handle_t (*create_texture_cube)(uint16_t _size, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
        void (*update_texture_2d)(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch)
        void (*update_texture_3d)(bgfx_texture_handle_t _handle, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _z, uint16_t _width, uint16_t _height, uint16_t _depth, const bgfx_memory_t* _mem)
        void (*update_texture_cube)(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _side, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch)
        uint32_t (*read_texture)(bgfx_texture_handle_t _handle, void* _data, uint8_t _mip)
        void (*set_texture_name)(bgfx_texture_handle_t _handle, const char* _name, int32_t _len)
        void* (*get_direct_access_ptr)(bgfx_texture_handle_t _handle)
        void (*destroy_texture)(bgfx_texture_handle_t _handle)
        bgfx_frame_buffer_handle_t (*create_frame_buffer)(uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, uint64_t _textureFlags)
        bgfx_frame_buffer_handle_t (*create_frame_buffer_scaled)(bgfx_backbuffer_ratio_t _ratio, bgfx_texture_format_t _format, uint64_t _textureFlags)
        bgfx_frame_buffer_handle_t (*create_frame_buffer_c_from_handles)(uint8_t _num, const bgfx_texture_handle_t* _handles, bint _destroyTexture)
        bgfx_frame_buffer_handle_t (*create_frame_buffer_from_attachment)(uint8_t _num, const bgfx_attachment_t* _attachment, bint _destroyTexture)
        bgfx_frame_buffer_handle_t (*create_frame_buffer_from_nwh)(void* _nwh, uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, bgfx_texture_format_t _depthFormat)
        void (*set_frame_buffer_name)(bgfx_frame_buffer_handle_t _handle, const char* _name, int32_t _len)
        bgfx_texture_handle_t (*get_texture)(bgfx_frame_buffer_handle_t _handle, uint8_t _attachment)
        void (*destroy_frame_buffer)(bgfx_frame_buffer_handle_t _handle)
        bgfx_uniform_handle_t (*create_uniform)(const char* _name, bgfx_uniform_type_t _type, uint16_t _num)
        void (*get_uniform_info)(bgfx_uniform_handle_t _handle, bgfx_uniform_info_t * _info)
        void (*destroy_uniform)(bgfx_uniform_handle_t _handle)
        bgfx_occlusion_query_handle_t (*create_occlusion_query)()
        bgfx_occlusion_query_result_t (*get_result)(bgfx_occlusion_query_handle_t _handle, int32_t* _result)
        void (*destroy_occlusion_query)(bgfx_occlusion_query_handle_t _handle)
        void (*set_palette_color)(uint8_t _index, const float _rgba[4])
        void (*set_palette_color_rgba8)(uint8_t _index, uint32_t _rgba)
        void (*set_view_name)(bgfx_view_id_t _id, const char* _name)
        void (*set_view_rect)(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
        void (*set_view_rect_ratio)(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, bgfx_backbuffer_ratio_t _ratio)
        void (*set_view_scissor)(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
        void (*set_view_clear)(bgfx_view_id_t _id, uint16_t _flags, uint32_t _rgba, float _depth, uint8_t _stencil)
        void (*set_view_clear_mrt)(bgfx_view_id_t _id, uint16_t _flags, float _depth, uint8_t _stencil, uint8_t _c0, uint8_t _c1, uint8_t _c2, uint8_t _c3, uint8_t _c4, uint8_t _c5, uint8_t _c6, uint8_t _c7)
        void (*set_view_mode)(bgfx_view_id_t _id, bgfx_view_mode_t _mode)
        void (*set_view_frame_buffer)(bgfx_view_id_t _id, bgfx_frame_buffer_handle_t _handle)
        void (*set_view_transform)(bgfx_view_id_t _id, const void* _view, const void* _proj)
        void (*set_view_order)(bgfx_view_id_t _id, uint16_t _num, const bgfx_view_id_t* _order)
        void (*reset_view)(bgfx_view_id_t _id)
        bgfx_encoder_t* (*encoder_begin)(bint _forThread)
        void (*encoder_end)(bgfx_encoder_t* _encoder)
        void (*encoder_set_marker)(bgfx_encoder_t* _this, const char* _marker)
        void (*encoder_set_state)(bgfx_encoder_t* _this, uint64_t _state, uint32_t _rgba)
        void (*encoder_set_condition)(bgfx_encoder_t* _this, bgfx_occlusion_query_handle_t _handle, bint _visible)
        void (*encoder_set_stencil)(bgfx_encoder_t* _this, uint32_t _fstencil, uint32_t _bstencil)
        uint16_t (*encoder_set_scissor)(bgfx_encoder_t* _this, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
        void (*encoder_set_scissor_cached)(bgfx_encoder_t* _this, uint16_t _cache)
        uint32_t (*encoder_set_transform)(bgfx_encoder_t* _this, const void* _mtx, uint16_t _num)
        void (*encoder_set_transform_cached)(bgfx_encoder_t* _this, uint32_t _cache, uint16_t _num)
        uint32_t (*encoder_alloc_transform)(bgfx_encoder_t* _this, bgfx_transform_t* _transform, uint16_t _num)
        void (*encoder_set_uniform)(bgfx_encoder_t* _this, bgfx_uniform_handle_t _handle, const void* _value, uint16_t _num)
        void (*encoder_set_index_buffer)(bgfx_encoder_t* _this, bgfx_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
        void (*encoder_set_dynamic_index_buffer)(bgfx_encoder_t* _this, bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
        void (*encoder_set_transient_index_buffer)(bgfx_encoder_t* _this, const bgfx_transient_index_buffer_t* _tib, uint32_t _firstIndex, uint32_t _numIndices)
        void (*encoder_set_vertex_buffer)(bgfx_encoder_t* _this, uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
        void (*encoder_set_vertex_buffer_with_layout)(bgfx_encoder_t* _this, uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
        void (*encoder_set_dynamic_vertex_buffer)(bgfx_encoder_t* _this, uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
        void (*encoder_set_dynamic_vertex_buffer_with_layout)(bgfx_encoder_t* _this, uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
        void (*encoder_set_transient_vertex_buffer)(bgfx_encoder_t* _this, uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices)
        void (*encoder_set_transient_vertex_buffer_with_layout)(bgfx_encoder_t* _this, uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
        void (*encoder_set_vertex_count)(bgfx_encoder_t* _this, uint32_t _numVertices)
        void (*encoder_set_instance_data_buffer)(bgfx_encoder_t* _this, const bgfx_instance_data_buffer_t* _idb, uint32_t _start, uint32_t _num)
        void (*encoder_set_instance_data_from_vertex_buffer)(bgfx_encoder_t* _this, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
        void (*encoder_set_instance_data_from_dynamic_vertex_buffer)(bgfx_encoder_t* _this, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
        void (*encoder_set_instance_count)(bgfx_encoder_t* _this, uint32_t _numInstances)
        void (*encoder_set_texture)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_uniform_handle_t _sampler, bgfx_texture_handle_t _handle, uint32_t _flags)
        void (*encoder_touch)(bgfx_encoder_t* _this, bgfx_view_id_t _id)
        void (*encoder_submit)(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _depth, uint8_t _flags)
        void (*encoder_submit_occlusion_query)(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_occlusion_query_handle_t _occlusionQuery, uint32_t _depth, uint8_t _flags)
        void (*encoder_submit_indirect)(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint32_t _depth, uint8_t _flags)
        void (*encoder_set_compute_index_buffer)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_index_buffer_handle_t _handle, bgfx_access_t _access)
        void (*encoder_set_compute_vertex_buffer)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_vertex_buffer_handle_t _handle, bgfx_access_t _access)
        void (*encoder_set_compute_dynamic_index_buffer)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_dynamic_index_buffer_handle_t _handle, bgfx_access_t _access)
        void (*encoder_set_compute_dynamic_vertex_buffer)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_dynamic_vertex_buffer_handle_t _handle, bgfx_access_t _access)
        void (*encoder_set_compute_indirect_buffer)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_indirect_buffer_handle_t _handle, bgfx_access_t _access)
        void (*encoder_set_image)(bgfx_encoder_t* _this, uint8_t _stage, bgfx_texture_handle_t _handle, uint8_t _mip, bgfx_access_t _access, bgfx_texture_format_t _format)
        void (*encoder_dispatch)(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _numX, uint32_t _numY, uint32_t _numZ, uint8_t _flags)
        void (*encoder_dispatch_indirect)(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint8_t _flags)
        void (*encoder_discard)(bgfx_encoder_t* _this, uint8_t _flags)
        void (*encoder_blit)(bgfx_encoder_t* _this, bgfx_view_id_t _id, bgfx_texture_handle_t _dst, uint8_t _dstMip, uint16_t _dstX, uint16_t _dstY, uint16_t _dstZ, bgfx_texture_handle_t _src, uint8_t _srcMip, uint16_t _srcX, uint16_t _srcY, uint16_t _srcZ, uint16_t _width, uint16_t _height, uint16_t _depth)
        void (*request_screen_shot)(bgfx_frame_buffer_handle_t _handle, const char* _filePath)
        bgfx_render_frame_t (*render_frame)(int32_t _msecs)
        void (*set_platform_data)(const bgfx_platform_data_t * _data)
        const bgfx_internal_data_t* (*get_internal_data)()
        uintptr_t (*override_internal_texture_ptr)(bgfx_texture_handle_t _handle, uintptr_t _ptr)
        uintptr_t (*override_internal_texture)(bgfx_texture_handle_t _handle, uint16_t _width, uint16_t _height, uint8_t _numMips, bgfx_texture_format_t _format, uint64_t _flags)
        void (*set_marker)(const char* _marker)
        void (*set_state)(uint64_t _state, uint32_t _rgba)
        void (*set_condition)(bgfx_occlusion_query_handle_t _handle, bint _visible)
        void (*set_stencil)(uint32_t _fstencil, uint32_t _bstencil)
        uint16_t (*set_scissor)(uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height)
        void (*set_scissor_cached)(uint16_t _cache)
        uint32_t (*set_transform)(const void* _mtx, uint16_t _num)
        void (*set_transform_cached)(uint32_t _cache, uint16_t _num)
        uint32_t (*alloc_transform)(bgfx_transform_t* _transform, uint16_t _num)
        void (*set_uniform)(bgfx_uniform_handle_t _handle, const void* _value, uint16_t _num)
        void (*set_index_buffer)(bgfx_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
        void (*set_dynamic_index_buffer)(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices)
        void (*set_transient_index_buffer)(const bgfx_transient_index_buffer_t* _tib, uint32_t _firstIndex, uint32_t _numIndices)
        void (*set_vertex_buffer)(uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
        void (*set_vertex_buffer_with_layout)(uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
        void (*set_dynamic_vertex_buffer)(uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices)
        void (*set_dynamic_vertex_buffer_with_layout)(uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
        void (*set_transient_vertex_buffer)(uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices)
        void (*set_transient_vertex_buffer_with_layout)(uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle)
        void (*set_vertex_count)(uint32_t _numVertices)
        void (*set_instance_data_buffer)(const bgfx_instance_data_buffer_t* _idb, uint32_t _start, uint32_t _num)
        void (*set_instance_data_from_vertex_buffer)(bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
        void (*set_instance_data_from_dynamic_vertex_buffer)(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num)
        void (*set_instance_count)(uint32_t _numInstances)
        void (*set_texture)(uint8_t _stage, bgfx_uniform_handle_t _sampler, bgfx_texture_handle_t _handle, uint32_t _flags)
        void (*touch)(bgfx_view_id_t _id)
        void (*submit)(bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _depth, uint8_t _flags)
        void (*submit_occlusion_query)(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_occlusion_query_handle_t _occlusionQuery, uint32_t _depth, uint8_t _flags)
        void (*submit_indirect)(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint32_t _depth, uint8_t _flags)
        void (*set_compute_index_buffer)(uint8_t _stage, bgfx_index_buffer_handle_t _handle, bgfx_access_t _access)
        void (*set_compute_vertex_buffer)(uint8_t _stage, bgfx_vertex_buffer_handle_t _handle, bgfx_access_t _access)
        void (*set_compute_dynamic_index_buffer)(uint8_t _stage, bgfx_dynamic_index_buffer_handle_t _handle, bgfx_access_t _access)
        void (*set_compute_dynamic_vertex_buffer)(uint8_t _stage, bgfx_dynamic_vertex_buffer_handle_t _handle, bgfx_access_t _access)
        void (*set_compute_indirect_buffer)(uint8_t _stage, bgfx_indirect_buffer_handle_t _handle, bgfx_access_t _access)
        void (*set_image)(uint8_t _stage, bgfx_texture_handle_t _handle, uint8_t _mip, bgfx_access_t _access, bgfx_texture_format_t _format)
        void (*dispatch)(bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _numX, uint32_t _numY, uint32_t _numZ, uint8_t _flags)
        void (*dispatch_indirect)(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint16_t _start, uint16_t _num, uint8_t _flags)
        void (*discard)(uint8_t _flags)
        void (*blit)(bgfx_view_id_t _id, bgfx_texture_handle_t _dst, uint8_t _dstMip, uint16_t _dstX, uint16_t _dstY, uint16_t _dstZ, bgfx_texture_handle_t _src, uint8_t _srcMip, uint16_t _srcX, uint16_t _srcY, uint16_t _srcZ, uint16_t _width, uint16_t _height, uint16_t _depth)

    ctypedef bgfx_interface_vtbl_t* (*PFN_BGFX_GET_INTERFACE)(uint32_t _version)
    bgfx_interface_vtbl_t* bgfx_get_interface(uint32_t _version)

cdef extern from "custom_bgfx_platform.h" nogil:
    SDL_SysWMinfo *bgfx_fetch_wmi()
    void *bgfx_get_window_nwh(SDL_SysWMinfo *wmi, SDL_Window* _window)
    void *bgfx_get_window_ndt(SDL_SysWMinfo *wmi, SDL_Window* _window)
    void bgfx_get_platform_data_from_window(bgfx_platform_data_t *pd, SDL_SysWMinfo *wmi, SDL_Window* _window)