#cdef extern from "gl/gl.h":
"""
cdef extern from "gl/glew.h":
    ctypedef float GLfloat
    ctypedef int GLsizei
    ctypedef unsigned int GLenum
    ctypedef unsigned int GLuint
    int GL_POINTS
    int GL_TRIANGLES
    void glBegin(GLenum mode)
    void glEnd()
    void glVertex3f(GLfloat x, GLfloat y, GLfloat z)
    void glColor3f(GLfloat r, GLfloat g, GLfloat b)
    void glGenBuffers(GLsizei n, GLuint *buffers)
"""

cdef extern from "GL/glew.h" nogil:
    enum: __gl_h_
    enum: GL_TYPEDEFS_2_0
    enum: GL_LOGIC_OP
    enum: GL_TEXTURE_COMPONENTS
    enum: GL_VERSION_1_1
    enum: GL_VERSION_1_2
    enum: GL_VERSION_1_3
    enum: GL_VERSION_1_4
    enum: GL_VERSION_1_5
    enum: GL_VERSION_2_0
    enum: GL_VERSION_2_1
    enum: GL_ACCUM
    enum: GL_LOAD
    enum: GL_RETURN
    enum: GL_MULT
    enum: GL_ADD
    enum: GL_NEVER
    enum: GL_LESS
    enum: GL_EQUAL
    enum: GL_LEQUAL
    enum: GL_GREATER
    enum: GL_NOTEQUAL
    enum: GL_GEQUAL
    enum: GL_ALWAYS
    enum: GL_CURRENT_BIT
    enum: GL_POINT_BIT
    enum: GL_LINE_BIT
    enum: GL_POLYGON_BIT
    enum: GL_POLYGON_STIPPLE_BIT
    enum: GL_PIXEL_MODE_BIT
    enum: GL_LIGHTING_BIT
    enum: GL_FOG_BIT
    enum: GL_DEPTH_BUFFER_BIT
    enum: GL_ACCUM_BUFFER_BIT
    enum: GL_STENCIL_BUFFER_BIT
    enum: GL_VIEWPORT_BIT
    enum: GL_TRANSFORM_BIT
    enum: GL_ENABLE_BIT
    enum: GL_COLOR_BUFFER_BIT
    enum: GL_HINT_BIT
    enum: GL_EVAL_BIT
    enum: GL_LIST_BIT
    enum: GL_TEXTURE_BIT
    enum: GL_SCISSOR_BIT
    enum: GL_ALL_ATTRIB_BITS
    enum: GL_POINTS
    enum: GL_LINES
    enum: GL_LINE_LOOP
    enum: GL_LINE_STRIP
    enum: GL_TRIANGLES
    enum: GL_TRIANGLE_STRIP
    enum: GL_TRIANGLE_FAN
    enum: GL_QUADS
    enum: GL_QUAD_STRIP
    enum: GL_POLYGON
    enum: GL_ZERO
    enum: GL_ONE
    enum: GL_SRC_COLOR
    enum: GL_ONE_MINUS_SRC_COLOR
    enum: GL_SRC_ALPHA
    enum: GL_ONE_MINUS_SRC_ALPHA
    enum: GL_DST_ALPHA
    enum: GL_ONE_MINUS_DST_ALPHA
    enum: GL_DST_COLOR
    enum: GL_ONE_MINUS_DST_COLOR
    enum: GL_SRC_ALPHA_SATURATE
    enum: GL_TRUE
    enum: GL_FALSE
    enum: GL_CLIP_PLANE0
    enum: GL_CLIP_PLANE1
    enum: GL_CLIP_PLANE2
    enum: GL_CLIP_PLANE3
    enum: GL_CLIP_PLANE4
    enum: GL_CLIP_PLANE5
    enum: GL_BYTE
    enum: GL_UNSIGNED_BYTE
    enum: GL_SHORT
    enum: GL_UNSIGNED_SHORT
    enum: GL_INT
    enum: GL_UNSIGNED_INT
    enum: GL_FLOAT
    enum: GL_2_BYTES
    enum: GL_3_BYTES
    enum: GL_4_BYTES
    enum: GL_DOUBLE
    enum: GL_NONE
    enum: GL_FRONT_LEFT
    enum: GL_FRONT_RIGHT
    enum: GL_BACK_LEFT
    enum: GL_BACK_RIGHT
    enum: GL_FRONT
    enum: GL_BACK
    enum: GL_LEFT
    enum: GL_RIGHT
    enum: GL_FRONT_AND_BACK
    enum: GL_AUX0
    enum: GL_AUX1
    enum: GL_AUX2
    enum: GL_AUX3
    enum: GL_NO_ERROR
    enum: GL_INVALID_ENUM
    enum: GL_INVALID_VALUE
    enum: GL_INVALID_OPERATION
    enum: GL_STACK_OVERFLOW
    enum: GL_STACK_UNDERFLOW
    enum: GL_OUT_OF_MEMORY
    enum: GL_2D
    enum: GL_3D
    enum: GL_3D_COLOR
    enum: GL_3D_COLOR_TEXTURE
    enum: GL_4D_COLOR_TEXTURE
    enum: GL_PASS_THROUGH_TOKEN
    enum: GL_POINT_TOKEN
    enum: GL_LINE_TOKEN
    enum: GL_POLYGON_TOKEN
    enum: GL_BITMAP_TOKEN
    enum: GL_DRAW_PIXEL_TOKEN
    enum: GL_COPY_PIXEL_TOKEN
    enum: GL_LINE_RESET_TOKEN
    enum: GL_EXP
    enum: GL_EXP2
    enum: GL_CW
    enum: GL_CCW
    enum: GL_COEFF
    enum: GL_ORDER
    enum: GL_DOMAIN
    enum: GL_CURRENT_COLOR
    enum: GL_CURRENT_INDEX
    enum: GL_CURRENT_NORMAL
    enum: GL_CURRENT_TEXTURE_COORDS
    enum: GL_CURRENT_RASTER_COLOR
    enum: GL_CURRENT_RASTER_INDEX
    enum: GL_CURRENT_RASTER_TEXTURE_COORDS
    enum: GL_CURRENT_RASTER_POSITION
    enum: GL_CURRENT_RASTER_POSITION_VALID
    enum: GL_CURRENT_RASTER_DISTANCE
    enum: GL_POINT_SMOOTH
    enum: GL_POINT_SIZE
    enum: GL_POINT_SIZE_RANGE
    enum: GL_POINT_SIZE_GRANULARITY
    enum: GL_LINE_SMOOTH
    enum: GL_LINE_WIDTH
    enum: GL_LINE_WIDTH_RANGE
    enum: GL_LINE_WIDTH_GRANULARITY
    enum: GL_LINE_STIPPLE
    enum: GL_LINE_STIPPLE_PATTERN
    enum: GL_LINE_STIPPLE_REPEAT
    enum: GL_LIST_MODE
    enum: GL_MAX_LIST_NESTING
    enum: GL_LIST_BASE
    enum: GL_LIST_INDEX
    enum: GL_POLYGON_MODE
    enum: GL_POLYGON_SMOOTH
    enum: GL_POLYGON_STIPPLE
    enum: GL_EDGE_FLAG
    enum: GL_CULL_FACE
    enum: GL_CULL_FACE_MODE
    enum: GL_FRONT_FACE
    enum: GL_LIGHTING
    enum: GL_LIGHT_MODEL_LOCAL_VIEWER
    enum: GL_LIGHT_MODEL_TWO_SIDE
    enum: GL_LIGHT_MODEL_AMBIENT
    enum: GL_SHADE_MODEL
    enum: GL_COLOR_MATERIAL_FACE
    enum: GL_COLOR_MATERIAL_PARAMETER
    enum: GL_COLOR_MATERIAL
    enum: GL_FOG
    enum: GL_FOG_INDEX
    enum: GL_FOG_DENSITY
    enum: GL_FOG_START
    enum: GL_FOG_END
    enum: GL_FOG_MODE
    enum: GL_FOG_COLOR
    enum: GL_DEPTH_RANGE
    enum: GL_DEPTH_TEST
    enum: GL_DEPTH_WRITEMASK
    enum: GL_DEPTH_CLEAR_VALUE
    enum: GL_DEPTH_FUNC
    enum: GL_ACCUM_CLEAR_VALUE
    enum: GL_STENCIL_TEST
    enum: GL_STENCIL_CLEAR_VALUE
    enum: GL_STENCIL_FUNC
    enum: GL_STENCIL_VALUE_MASK
    enum: GL_STENCIL_FAIL
    enum: GL_STENCIL_PASS_DEPTH_FAIL
    enum: GL_STENCIL_PASS_DEPTH_PASS
    enum: GL_STENCIL_REF
    enum: GL_STENCIL_WRITEMASK
    enum: GL_MATRIX_MODE
    enum: GL_NORMALIZE
    enum: GL_VIEWPORT
    enum: GL_MODELVIEW_STACK_DEPTH
    enum: GL_PROJECTION_STACK_DEPTH
    enum: GL_TEXTURE_STACK_DEPTH
    enum: GL_MODELVIEW_MATRIX
    enum: GL_PROJECTION_MATRIX
    enum: GL_TEXTURE_MATRIX
    enum: GL_ATTRIB_STACK_DEPTH
    enum: GL_CLIENT_ATTRIB_STACK_DEPTH
    enum: GL_ALPHA_TEST
    enum: GL_ALPHA_TEST_FUNC
    enum: GL_ALPHA_TEST_REF
    enum: GL_DITHER
    enum: GL_BLEND_DST
    enum: GL_BLEND_SRC
    enum: GL_BLEND
    enum: GL_LOGIC_OP_MODE
    enum: GL_INDEX_LOGIC_OP
    enum: GL_COLOR_LOGIC_OP
    enum: GL_AUX_BUFFERS
    enum: GL_DRAW_BUFFER
    enum: GL_READ_BUFFER
    enum: GL_SCISSOR_BOX
    enum: GL_SCISSOR_TEST
    enum: GL_INDEX_CLEAR_VALUE
    enum: GL_INDEX_WRITEMASK
    enum: GL_COLOR_CLEAR_VALUE
    enum: GL_COLOR_WRITEMASK
    enum: GL_INDEX_MODE
    enum: GL_RGBA_MODE
    enum: GL_DOUBLEBUFFER
    enum: GL_STEREO
    enum: GL_RENDER_MODE
    enum: GL_PERSPECTIVE_CORRECTION_HINT
    enum: GL_POINT_SMOOTH_HINT
    enum: GL_LINE_SMOOTH_HINT
    enum: GL_POLYGON_SMOOTH_HINT
    enum: GL_FOG_HINT
    enum: GL_TEXTURE_GEN_S
    enum: GL_TEXTURE_GEN_T
    enum: GL_TEXTURE_GEN_R
    enum: GL_TEXTURE_GEN_Q
    enum: GL_PIXEL_MAP_I_TO_I
    enum: GL_PIXEL_MAP_S_TO_S
    enum: GL_PIXEL_MAP_I_TO_R
    enum: GL_PIXEL_MAP_I_TO_G
    enum: GL_PIXEL_MAP_I_TO_B
    enum: GL_PIXEL_MAP_I_TO_A
    enum: GL_PIXEL_MAP_R_TO_R
    enum: GL_PIXEL_MAP_G_TO_G
    enum: GL_PIXEL_MAP_B_TO_B
    enum: GL_PIXEL_MAP_A_TO_A
    enum: GL_PIXEL_MAP_I_TO_I_SIZE
    enum: GL_PIXEL_MAP_S_TO_S_SIZE
    enum: GL_PIXEL_MAP_I_TO_R_SIZE
    enum: GL_PIXEL_MAP_I_TO_G_SIZE
    enum: GL_PIXEL_MAP_I_TO_B_SIZE
    enum: GL_PIXEL_MAP_I_TO_A_SIZE
    enum: GL_PIXEL_MAP_R_TO_R_SIZE
    enum: GL_PIXEL_MAP_G_TO_G_SIZE
    enum: GL_PIXEL_MAP_B_TO_B_SIZE
    enum: GL_PIXEL_MAP_A_TO_A_SIZE
    enum: GL_UNPACK_SWAP_BYTES
    enum: GL_UNPACK_LSB_FIRST
    enum: GL_UNPACK_ROW_LENGTH
    enum: GL_UNPACK_SKIP_ROWS
    enum: GL_UNPACK_SKIP_PIXELS
    enum: GL_UNPACK_ALIGNMENT
    enum: GL_PACK_SWAP_BYTES
    enum: GL_PACK_LSB_FIRST
    enum: GL_PACK_ROW_LENGTH
    enum: GL_PACK_SKIP_ROWS
    enum: GL_PACK_SKIP_PIXELS
    enum: GL_PACK_ALIGNMENT
    enum: GL_MAP_COLOR
    enum: GL_MAP_STENCIL
    enum: GL_INDEX_SHIFT
    enum: GL_INDEX_OFFSET
    enum: GL_RED_SCALE
    enum: GL_RED_BIAS
    enum: GL_ZOOM_X
    enum: GL_ZOOM_Y
    enum: GL_GREEN_SCALE
    enum: GL_GREEN_BIAS
    enum: GL_BLUE_SCALE
    enum: GL_BLUE_BIAS
    enum: GL_ALPHA_SCALE
    enum: GL_ALPHA_BIAS
    enum: GL_DEPTH_SCALE
    enum: GL_DEPTH_BIAS
    enum: GL_MAX_EVAL_ORDER
    enum: GL_MAX_LIGHTS
    enum: GL_MAX_CLIP_PLANES
    enum: GL_MAX_TEXTURE_SIZE
    enum: GL_MAX_PIXEL_MAP_TABLE
    enum: GL_MAX_ATTRIB_STACK_DEPTH
    enum: GL_MAX_MODELVIEW_STACK_DEPTH
    enum: GL_MAX_NAME_STACK_DEPTH
    enum: GL_MAX_PROJECTION_STACK_DEPTH
    enum: GL_MAX_TEXTURE_STACK_DEPTH
    enum: GL_MAX_VIEWPORT_DIMS
    enum: GL_MAX_CLIENT_ATTRIB_STACK_DEPTH
    enum: GL_SUBPIXEL_BITS
    enum: GL_INDEX_BITS
    enum: GL_RED_BITS
    enum: GL_GREEN_BITS
    enum: GL_BLUE_BITS
    enum: GL_ALPHA_BITS
    enum: GL_DEPTH_BITS
    enum: GL_STENCIL_BITS
    enum: GL_ACCUM_RED_BITS
    enum: GL_ACCUM_GREEN_BITS
    enum: GL_ACCUM_BLUE_BITS
    enum: GL_ACCUM_ALPHA_BITS
    enum: GL_NAME_STACK_DEPTH
    enum: GL_AUTO_NORMAL
    enum: GL_MAP1_COLOR_4
    enum: GL_MAP1_INDEX
    enum: GL_MAP1_NORMAL
    enum: GL_MAP1_TEXTURE_COORD_1
    enum: GL_MAP1_TEXTURE_COORD_2
    enum: GL_MAP1_TEXTURE_COORD_3
    enum: GL_MAP1_TEXTURE_COORD_4
    enum: GL_MAP1_VERTEX_3
    enum: GL_MAP1_VERTEX_4
    enum: GL_MAP2_COLOR_4
    enum: GL_MAP2_INDEX
    enum: GL_MAP2_NORMAL
    enum: GL_MAP2_TEXTURE_COORD_1
    enum: GL_MAP2_TEXTURE_COORD_2
    enum: GL_MAP2_TEXTURE_COORD_3
    enum: GL_MAP2_TEXTURE_COORD_4
    enum: GL_MAP2_VERTEX_3
    enum: GL_MAP2_VERTEX_4
    enum: GL_MAP1_GRID_DOMAIN
    enum: GL_MAP1_GRID_SEGMENTS
    enum: GL_MAP2_GRID_DOMAIN
    enum: GL_MAP2_GRID_SEGMENTS
    enum: GL_TEXTURE_1D
    enum: GL_TEXTURE_2D
    enum: GL_FEEDBACK_BUFFER_POINTER
    enum: GL_FEEDBACK_BUFFER_SIZE
    enum: GL_FEEDBACK_BUFFER_TYPE
    enum: GL_SELECTION_BUFFER_POINTER
    enum: GL_SELECTION_BUFFER_SIZE
    enum: GL_TEXTURE_WIDTH
    enum: GL_TEXTURE_HEIGHT
    enum: GL_TEXTURE_INTERNAL_FORMAT
    enum: GL_TEXTURE_BORDER_COLOR
    enum: GL_TEXTURE_BORDER
    enum: GL_DONT_CARE
    enum: GL_FASTEST
    enum: GL_NICEST
    enum: GL_LIGHT0
    enum: GL_LIGHT1
    enum: GL_LIGHT2
    enum: GL_LIGHT3
    enum: GL_LIGHT4
    enum: GL_LIGHT5
    enum: GL_LIGHT6
    enum: GL_LIGHT7
    enum: GL_AMBIENT
    enum: GL_DIFFUSE
    enum: GL_SPECULAR
    enum: GL_POSITION
    enum: GL_SPOT_DIRECTION
    enum: GL_SPOT_EXPONENT
    enum: GL_SPOT_CUTOFF
    enum: GL_CONSTANT_ATTENUATION
    enum: GL_LINEAR_ATTENUATION
    enum: GL_QUADRATIC_ATTENUATION
    enum: GL_COMPILE
    enum: GL_COMPILE_AND_EXECUTE
    enum: GL_CLEAR
    enum: GL_AND
    enum: GL_AND_REVERSE
    enum: GL_COPY
    enum: GL_AND_INVERTED
    enum: GL_NOOP
    enum: GL_XOR
    enum: GL_OR
    enum: GL_NOR
    enum: GL_EQUIV
    enum: GL_INVERT
    enum: GL_OR_REVERSE
    enum: GL_COPY_INVERTED
    enum: GL_OR_INVERTED
    enum: GL_NAND
    enum: GL_SET
    enum: GL_EMISSION
    enum: GL_SHININESS
    enum: GL_AMBIENT_AND_DIFFUSE
    enum: GL_COLOR_INDEXES
    enum: GL_MODELVIEW
    enum: GL_PROJECTION
    enum: GL_TEXTURE
    enum: GL_COLOR
    enum: GL_DEPTH
    enum: GL_STENCIL
    enum: GL_COLOR_INDEX
    enum: GL_STENCIL_INDEX
    enum: GL_DEPTH_COMPONENT
    enum: GL_RED
    enum: GL_GREEN
    enum: GL_BLUE
    enum: GL_ALPHA
    enum: GL_RGB
    enum: GL_RGBA
    enum: GL_R32F
    enum: GL_RGB32F
    enum: GL_RGBA32F
    enum: GL_LUMINANCE
    enum: GL_LUMINANCE_ALPHA
    enum: GL_BITMAP
    enum: GL_POINT
    enum: GL_LINE
    enum: GL_FILL
    enum: GL_RENDER
    enum: GL_FEEDBACK
    enum: GL_SELECT
    enum: GL_FLAT
    enum: GL_SMOOTH
    enum: GL_KEEP
    enum: GL_REPLACE
    enum: GL_INCR
    enum: GL_DECR
    enum: GL_VENDOR
    enum: GL_RENDERER
    enum: GL_VERSION
    enum: GL_EXTENSIONS
    enum: GL_S
    enum: GL_T
    enum: GL_R
    enum: GL_Q
    enum: GL_MODULATE
    enum: GL_DECAL
    enum: GL_TEXTURE_ENV_MODE
    enum: GL_TEXTURE_ENV_COLOR
    enum: GL_TEXTURE_ENV
    enum: GL_EYE_LINEAR
    enum: GL_OBJECT_LINEAR
    enum: GL_SPHERE_MAP
    enum: GL_TEXTURE_GEN_MODE
    enum: GL_OBJECT_PLANE
    enum: GL_EYE_PLANE
    enum: GL_NEAREST
    enum: GL_LINEAR
    enum: GL_NEAREST_MIPMAP_NEAREST
    enum: GL_LINEAR_MIPMAP_NEAREST
    enum: GL_NEAREST_MIPMAP_LINEAR
    enum: GL_LINEAR_MIPMAP_LINEAR
    enum: GL_TEXTURE_MAG_FILTER
    enum: GL_TEXTURE_MIN_FILTER
    enum: GL_TEXTURE_WRAP_S
    enum: GL_TEXTURE_WRAP_T
    enum: GL_CLAMP
    enum: GL_REPEAT
    enum: GL_CLIENT_PIXEL_STORE_BIT
    enum: GL_CLIENT_VERTEX_ARRAY_BIT
    enum: GL_CLIENT_ALL_ATTRIB_BITS
    enum: GL_POLYGON_OFFSET_FACTOR
    enum: GL_POLYGON_OFFSET_UNITS
    enum: GL_POLYGON_OFFSET_POINT
    enum: GL_POLYGON_OFFSET_LINE
    enum: GL_POLYGON_OFFSET_FILL
    enum: GL_ALPHA4
    enum: GL_ALPHA8
    enum: GL_ALPHA12
    enum: GL_ALPHA16
    enum: GL_LUMINANCE4
    enum: GL_LUMINANCE8
    enum: GL_LUMINANCE12
    enum: GL_LUMINANCE16
    enum: GL_LUMINANCE4_ALPHA4
    enum: GL_LUMINANCE6_ALPHA2
    enum: GL_LUMINANCE8_ALPHA8
    enum: GL_LUMINANCE12_ALPHA4
    enum: GL_LUMINANCE12_ALPHA12
    enum: GL_LUMINANCE16_ALPHA16
    enum: GL_INTENSITY
    enum: GL_INTENSITY4
    enum: GL_INTENSITY8
    enum: GL_INTENSITY12
    enum: GL_INTENSITY16
    enum: GL_R3_G3_B2
    enum: GL_RGB4
    enum: GL_RGB5
    enum: GL_RGB8
    enum: GL_RGB10
    enum: GL_RGB12
    enum: GL_RGB16
    enum: GL_RGBA2
    enum: GL_RGBA4
    enum: GL_RGB5_A1
    enum: GL_RGBA8
    enum: GL_RGB10_A2
    enum: GL_RGBA12
    enum: GL_RGBA16
    enum: GL_TEXTURE_RED_SIZE
    enum: GL_TEXTURE_GREEN_SIZE
    enum: GL_TEXTURE_BLUE_SIZE
    enum: GL_TEXTURE_ALPHA_SIZE
    enum: GL_TEXTURE_LUMINANCE_SIZE
    enum: GL_TEXTURE_INTENSITY_SIZE
    enum: GL_PROXY_TEXTURE_1D
    enum: GL_PROXY_TEXTURE_2D
    enum: GL_TEXTURE_PRIORITY
    enum: GL_TEXTURE_RESIDENT
    enum: GL_TEXTURE_BINDING_1D
    enum: GL_TEXTURE_BINDING_2D
    enum: GL_TEXTURE_BINDING_3D
    enum: GL_VERTEX_ARRAY
    enum: GL_NORMAL_ARRAY
    enum: GL_COLOR_ARRAY
    enum: GL_INDEX_ARRAY
    enum: GL_TEXTURE_COORD_ARRAY
    enum: GL_EDGE_FLAG_ARRAY
    enum: GL_VERTEX_ARRAY_SIZE
    enum: GL_VERTEX_ARRAY_TYPE
    enum: GL_VERTEX_ARRAY_STRIDE
    enum: GL_NORMAL_ARRAY_TYPE
    enum: GL_NORMAL_ARRAY_STRIDE
    enum: GL_COLOR_ARRAY_SIZE
    enum: GL_COLOR_ARRAY_TYPE
    enum: GL_COLOR_ARRAY_STRIDE
    enum: GL_INDEX_ARRAY_TYPE
    enum: GL_INDEX_ARRAY_STRIDE
    enum: GL_TEXTURE_COORD_ARRAY_SIZE
    enum: GL_TEXTURE_COORD_ARRAY_TYPE
    enum: GL_TEXTURE_COORD_ARRAY_STRIDE
    enum: GL_EDGE_FLAG_ARRAY_STRIDE
    enum: GL_VERTEX_ARRAY_POINTER
    enum: GL_NORMAL_ARRAY_POINTER
    enum: GL_COLOR_ARRAY_POINTER
    enum: GL_INDEX_ARRAY_POINTER
    enum: GL_TEXTURE_COORD_ARRAY_POINTER
    enum: GL_EDGE_FLAG_ARRAY_POINTER
    enum: GL_V2F
    enum: GL_V3F
    enum: GL_C4UB_V2F
    enum: GL_C4UB_V3F
    enum: GL_C3F_V3F
    enum: GL_N3F_V3F
    enum: GL_C4F_N3F_V3F
    enum: GL_T2F_V3F
    enum: GL_T4F_V4F
    enum: GL_T2F_C4UB_V3F
    enum: GL_T2F_C3F_V3F
    enum: GL_T2F_N3F_V3F
    enum: GL_T2F_C4F_N3F_V3F
    enum: GL_T4F_C4F_N3F_V4F
    enum: GL_BGR
    enum: GL_BGRA
    enum: GL_CONSTANT_COLOR
    enum: GL_ONE_MINUS_CONSTANT_COLOR
    enum: GL_CONSTANT_ALPHA
    enum: GL_ONE_MINUS_CONSTANT_ALPHA
    enum: GL_BLEND_COLOR
    enum: GL_FUNC_ADD
    enum: GL_MIN
    enum: GL_MAX
    enum: GL_BLEND_EQUATION
    enum: GL_BLEND_EQUATION_RGB
    enum: GL_BLEND_EQUATION_ALPHA
    enum: GL_FUNC_SUBTRACT
    enum: GL_FUNC_REVERSE_SUBTRACT
    enum: GL_COLOR_MATRIX
    enum: GL_COLOR_MATRIX_STACK_DEPTH
    enum: GL_MAX_COLOR_MATRIX_STACK_DEPTH
    enum: GL_POST_COLOR_MATRIX_RED_SCALE
    enum: GL_POST_COLOR_MATRIX_GREEN_SCALE
    enum: GL_POST_COLOR_MATRIX_BLUE_SCALE
    enum: GL_POST_COLOR_MATRIX_ALPHA_SCALE
    enum: GL_POST_COLOR_MATRIX_RED_BIAS
    enum: GL_POST_COLOR_MATRIX_GREEN_BIAS
    enum: GL_POST_COLOR_MATRIX_BLUE_BIAS
    enum: GL_POST_COLOR_MATRIX_ALPHA_BIAS
    enum: GL_COLOR_TABLE
    enum: GL_POST_CONVOLUTION_COLOR_TABLE
    enum: GL_POST_COLOR_MATRIX_COLOR_TABLE
    enum: GL_PROXY_COLOR_TABLE
    enum: GL_PROXY_POST_CONVOLUTION_COLOR_TABLE
    enum: GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE
    enum: GL_COLOR_TABLE_SCALE
    enum: GL_COLOR_TABLE_BIAS
    enum: GL_COLOR_TABLE_FORMAT
    enum: GL_COLOR_TABLE_WIDTH
    enum: GL_COLOR_TABLE_RED_SIZE
    enum: GL_COLOR_TABLE_GREEN_SIZE
    enum: GL_COLOR_TABLE_BLUE_SIZE
    enum: GL_COLOR_TABLE_ALPHA_SIZE
    enum: GL_COLOR_TABLE_LUMINANCE_SIZE
    enum: GL_COLOR_TABLE_INTENSITY_SIZE
    enum: GL_CONVOLUTION_1D
    enum: GL_CONVOLUTION_2D
    enum: GL_SEPARABLE_2D
    enum: GL_CONVOLUTION_BORDER_MODE
    enum: GL_CONVOLUTION_FILTER_SCALE
    enum: GL_CONVOLUTION_FILTER_BIAS
    enum: GL_REDUCE
    enum: GL_CONVOLUTION_FORMAT
    enum: GL_CONVOLUTION_WIDTH
    enum: GL_CONVOLUTION_HEIGHT
    enum: GL_MAX_CONVOLUTION_WIDTH
    enum: GL_MAX_CONVOLUTION_HEIGHT
    enum: GL_POST_CONVOLUTION_RED_SCALE
    enum: GL_POST_CONVOLUTION_GREEN_SCALE
    enum: GL_POST_CONVOLUTION_BLUE_SCALE
    enum: GL_POST_CONVOLUTION_ALPHA_SCALE
    enum: GL_POST_CONVOLUTION_RED_BIAS
    enum: GL_POST_CONVOLUTION_GREEN_BIAS
    enum: GL_POST_CONVOLUTION_BLUE_BIAS
    enum: GL_POST_CONVOLUTION_ALPHA_BIAS
    enum: GL_CONSTANT_BORDER
    enum: GL_REPLICATE_BORDER
    enum: GL_CONVOLUTION_BORDER_COLOR
    enum: GL_MAX_ELEMENTS_VERTICES
    enum: GL_MAX_ELEMENTS_INDICES
    enum: GL_HISTOGRAM
    enum: GL_PROXY_HISTOGRAM
    enum: GL_HISTOGRAM_WIDTH
    enum: GL_HISTOGRAM_FORMAT
    enum: GL_HISTOGRAM_RED_SIZE
    enum: GL_HISTOGRAM_GREEN_SIZE
    enum: GL_HISTOGRAM_BLUE_SIZE
    enum: GL_HISTOGRAM_ALPHA_SIZE
    enum: GL_HISTOGRAM_LUMINANCE_SIZE
    enum: GL_HISTOGRAM_SINK
    enum: GL_MINMAX
    enum: GL_MINMAX_FORMAT
    enum: GL_MINMAX_SINK
    enum: GL_TABLE_TOO_LARGE
    enum: GL_UNSIGNED_BYTE_3_3_2
    enum: GL_UNSIGNED_SHORT_4_4_4_4
    enum: GL_UNSIGNED_SHORT_5_5_5_1
    enum: GL_UNSIGNED_INT_8_8_8_8
    enum: GL_UNSIGNED_INT_10_10_10_2
    enum: GL_UNSIGNED_BYTE_2_3_3_REV
    enum: GL_UNSIGNED_SHORT_5_6_5
    enum: GL_UNSIGNED_SHORT_5_6_5_REV
    enum: GL_UNSIGNED_SHORT_4_4_4_4_REV
    enum: GL_UNSIGNED_SHORT_1_5_5_5_REV
    enum: GL_UNSIGNED_INT_8_8_8_8_REV
    enum: GL_UNSIGNED_INT_2_10_10_10_REV
    enum: GL_RESCALE_NORMAL
    enum: GL_LIGHT_MODEL_COLOR_CONTROL
    enum: GL_SINGLE_COLOR
    enum: GL_SEPARATE_SPECULAR_COLOR
    enum: GL_PACK_SKIP_IMAGES
    enum: GL_PACK_IMAGE_HEIGHT
    enum: GL_UNPACK_SKIP_IMAGES
    enum: GL_UNPACK_IMAGE_HEIGHT
    enum: GL_TEXTURE_3D
    enum: GL_PROXY_TEXTURE_3D
    enum: GL_TEXTURE_DEPTH
    enum: GL_TEXTURE_WRAP_R
    enum: GL_MAX_3D_TEXTURE_SIZE
    enum: GL_CLAMP_TO_EDGE
    enum: GL_MIRROR_CLAMP_TO_EDGE
    enum: GL_CLAMP_TO_BORDER
    enum: GL_TEXTURE_MIN_LOD
    enum: GL_TEXTURE_MAX_LOD
    enum: GL_TEXTURE_BASE_LEVEL
    enum: GL_TEXTURE_MAX_LEVEL
    enum: GL_SMOOTH_POINT_SIZE_RANGE
    enum: GL_SMOOTH_POINT_SIZE_GRANULARITY
    enum: GL_SMOOTH_LINE_WIDTH_RANGE
    enum: GL_SMOOTH_LINE_WIDTH_GRANULARITY
    enum: GL_ALIASED_POINT_SIZE_RANGE
    enum: GL_ALIASED_LINE_WIDTH_RANGE
    enum: GL_TEXTURE0
    enum: GL_TEXTURE1
    enum: GL_TEXTURE2
    enum: GL_TEXTURE3
    enum: GL_TEXTURE4
    enum: GL_TEXTURE5
    enum: GL_TEXTURE6
    enum: GL_TEXTURE7
    enum: GL_TEXTURE8
    enum: GL_TEXTURE9
    enum: GL_TEXTURE10
    enum: GL_TEXTURE11
    enum: GL_TEXTURE12
    enum: GL_TEXTURE13
    enum: GL_TEXTURE14
    enum: GL_TEXTURE15
    enum: GL_TEXTURE16
    enum: GL_TEXTURE17
    enum: GL_TEXTURE18
    enum: GL_TEXTURE19
    enum: GL_TEXTURE20
    enum: GL_TEXTURE21
    enum: GL_TEXTURE22
    enum: GL_TEXTURE23
    enum: GL_TEXTURE24
    enum: GL_TEXTURE25
    enum: GL_TEXTURE26
    enum: GL_TEXTURE27
    enum: GL_TEXTURE28
    enum: GL_TEXTURE29
    enum: GL_TEXTURE30
    enum: GL_TEXTURE31
    enum: GL_ACTIVE_TEXTURE
    enum: GL_CLIENT_ACTIVE_TEXTURE
    enum: GL_MAX_TEXTURE_UNITS
    enum: GL_COMBINE
    enum: GL_COMBINE_RGB
    enum: GL_COMBINE_ALPHA
    enum: GL_RGB_SCALE
    enum: GL_ADD_SIGNED
    enum: GL_INTERPOLATE
    enum: GL_CONSTANT
    enum: GL_PRIMARY_COLOR
    enum: GL_PREVIOUS
    enum: GL_SUBTRACT
    enum: GL_SRC0_RGB
    enum: GL_SRC1_RGB
    enum: GL_SRC2_RGB
    enum: GL_SRC0_ALPHA
    enum: GL_SRC1_ALPHA
    enum: GL_SRC2_ALPHA
    enum: GL_SOURCE0_RGB
    enum: GL_SOURCE1_RGB
    enum: GL_SOURCE2_RGB
    enum: GL_SOURCE0_ALPHA
    enum: GL_SOURCE1_ALPHA
    enum: GL_SOURCE2_ALPHA
    enum: GL_OPERAND0_RGB
    enum: GL_OPERAND1_RGB
    enum: GL_OPERAND2_RGB
    enum: GL_OPERAND0_ALPHA
    enum: GL_OPERAND1_ALPHA
    enum: GL_OPERAND2_ALPHA
    enum: GL_DOT3_RGB
    enum: GL_DOT3_RGBA
    enum: GL_TRANSPOSE_MODELVIEW_MATRIX
    enum: GL_TRANSPOSE_PROJECTION_MATRIX
    enum: GL_TRANSPOSE_TEXTURE_MATRIX
    enum: GL_TRANSPOSE_COLOR_MATRIX
    enum: GL_NORMAL_MAP
    enum: GL_REFLECTION_MAP
    enum: GL_TEXTURE_CUBE_MAP
    enum: GL_TEXTURE_BINDING_CUBE_MAP
    enum: GL_TEXTURE_CUBE_MAP_POSITIVE_X
    enum: GL_TEXTURE_CUBE_MAP_NEGATIVE_X
    enum: GL_TEXTURE_CUBE_MAP_POSITIVE_Y
    enum: GL_TEXTURE_CUBE_MAP_NEGATIVE_Y
    enum: GL_TEXTURE_CUBE_MAP_POSITIVE_Z
    enum: GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
    enum: GL_PROXY_TEXTURE_CUBE_MAP
    enum: GL_MAX_CUBE_MAP_TEXTURE_SIZE
    enum: GL_COMPRESSED_ALPHA
    enum: GL_COMPRESSED_LUMINANCE
    enum: GL_COMPRESSED_LUMINANCE_ALPHA
    enum: GL_COMPRESSED_INTENSITY
    enum: GL_COMPRESSED_RGB
    enum: GL_COMPRESSED_RGBA
    enum: GL_TEXTURE_COMPRESSION_HINT
    enum: GL_TEXTURE_COMPRESSED_IMAGE_SIZE
    enum: GL_TEXTURE_COMPRESSED
    enum: GL_NUM_COMPRESSED_TEXTURE_FORMATS
    enum: GL_COMPRESSED_TEXTURE_FORMATS
    enum: GL_MULTISAMPLE
    enum: GL_SAMPLE_ALPHA_TO_COVERAGE
    enum: GL_SAMPLE_ALPHA_TO_ONE
    enum: GL_SAMPLE_COVERAGE
    enum: GL_SAMPLE_BUFFERS
    enum: GL_SAMPLES
    enum: GL_SAMPLE_COVERAGE_VALUE
    enum: GL_SAMPLE_COVERAGE_INVERT
    enum: GL_MULTISAMPLE_BIT
    enum: GL_DEPTH_COMPONENT16
    enum: GL_DEPTH_COMPONENT24
    enum: GL_DEPTH_COMPONENT32
    enum: GL_TEXTURE_DEPTH_SIZE
    enum: GL_DEPTH_TEXTURE_MODE
    enum: GL_TEXTURE_COMPARE_MODE
    enum: GL_TEXTURE_COMPARE_FUNC
    enum: GL_COMPARE_R_TO_TEXTURE
    enum: GL_QUERY_COUNTER_BITS
    enum: GL_CURRENT_QUERY
    enum: GL_QUERY_RESULT
    enum: GL_QUERY_RESULT_AVAILABLE
    enum: GL_SAMPLES_PASSED
    enum: GL_FOG_COORD_SRC
    enum: GL_FOG_COORD
    enum: GL_FRAGMENT_DEPTH
    enum: GL_CURRENT_FOG_COORD
    enum: GL_FOG_COORD_ARRAY_TYPE
    enum: GL_FOG_COORD_ARRAY_STRIDE
    enum: GL_FOG_COORD_ARRAY_POINTER
    enum: GL_FOG_COORD_ARRAY
    enum: GL_FOG_COORDINATE_SOURCE
    enum: GL_FOG_COORDINATE
    enum: GL_CURRENT_FOG_COORDINATE
    enum: GL_FOG_COORDINATE_ARRAY_TYPE
    enum: GL_FOG_COORDINATE_ARRAY_STRIDE
    enum: GL_FOG_COORDINATE_ARRAY_POINTER
    enum: GL_FOG_COORDINATE_ARRAY
    enum: GL_COLOR_SUM
    enum: GL_CURRENT_SECONDARY_COLOR
    enum: GL_SECONDARY_COLOR_ARRAY_SIZE
    enum: GL_SECONDARY_COLOR_ARRAY_TYPE
    enum: GL_SECONDARY_COLOR_ARRAY_STRIDE
    enum: GL_SECONDARY_COLOR_ARRAY_POINTER
    enum: GL_SECONDARY_COLOR_ARRAY
    enum: GL_POINT_SIZE_MIN
    enum: GL_POINT_SIZE_MAX
    enum: GL_POINT_FADE_THRESHOLD_SIZE
    enum: GL_POINT_DISTANCE_ATTENUATION
    enum: GL_BLEND_DST_RGB
    enum: GL_BLEND_SRC_RGB
    enum: GL_BLEND_DST_ALPHA
    enum: GL_BLEND_SRC_ALPHA
    enum: GL_GENERATE_MIPMAP
    enum: GL_GENERATE_MIPMAP_HINT
    enum: GL_INCR_WRAP
    enum: GL_DECR_WRAP
    enum: GL_MIRRORED_REPEAT
    enum: GL_MAX_TEXTURE_LOD_BIAS
    enum: GL_TEXTURE_FILTER_CONTROL
    enum: GL_TEXTURE_LOD_BIAS
    enum: GL_ARRAY_BUFFER
    enum: GL_ELEMENT_ARRAY_BUFFER
    enum: GL_ARRAY_BUFFER_BINDING
    enum: GL_ELEMENT_ARRAY_BUFFER_BINDING
    enum: GL_VERTEX_ARRAY_BUFFER_BINDING
    enum: GL_NORMAL_ARRAY_BUFFER_BINDING
    enum: GL_COLOR_ARRAY_BUFFER_BINDING
    enum: GL_INDEX_ARRAY_BUFFER_BINDING
    enum: GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING
    enum: GL_TEXTURE_BUFFER
    enum: GL_EDGE_FLAG_ARRAY_BUFFER_BINDING
    enum: GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING
    enum: GL_FOG_COORD_ARRAY_BUFFER_BINDING
    enum: GL_WEIGHT_ARRAY_BUFFER_BINDING
    enum: GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING
    enum: GL_STREAM_DRAW
    enum: GL_STREAM_READ
    enum: GL_STREAM_COPY
    enum: GL_STATIC_DRAW
    enum: GL_STATIC_READ
    enum: GL_STATIC_COPY
    enum: GL_DYNAMIC_DRAW
    enum: GL_DYNAMIC_READ
    enum: GL_DYNAMIC_COPY
    enum: GL_READ_ONLY
    enum: GL_WRITE_ONLY
    enum: GL_READ_WRITE
    enum: GL_BUFFER_SIZE
    enum: GL_BUFFER_USAGE
    enum: GL_BUFFER_ACCESS
    enum: GL_BUFFER_MAPPED
    enum: GL_BUFFER_MAP_POINTER
    enum: GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING
    enum: GL_CURRENT_PROGRAM
    enum: GL_SHADER_TYPE
    enum: GL_DELETE_STATUS
    enum: GL_COMPILE_STATUS
    enum: GL_LINK_STATUS
    enum: GL_VALIDATE_STATUS
    enum: GL_INFO_LOG_LENGTH
    enum: GL_ATTACHED_SHADERS
    enum: GL_ACTIVE_UNIFORMS
    enum: GL_ACTIVE_UNIFORM_MAX_LENGTH
    enum: GL_SHADER_SOURCE_LENGTH
    enum: GL_FLOAT_VEC2
    enum: GL_FLOAT_VEC3
    enum: GL_FLOAT_VEC4
    enum: GL_INT_VEC2
    enum: GL_INT_VEC3
    enum: GL_INT_VEC4
    enum: GL_BOOL
    enum: GL_BOOL_VEC2
    enum: GL_BOOL_VEC3
    enum: GL_BOOL_VEC4
    enum: GL_FLOAT_MAT2
    enum: GL_FLOAT_MAT3
    enum: GL_FLOAT_MAT4
    enum: GL_SAMPLER_1D
    enum: GL_SAMPLER_2D
    enum: GL_SAMPLER_3D
    enum: GL_SAMPLER_CUBE
    enum: GL_SAMPLER_1D_SHADOW
    enum: GL_SAMPLER_2D_SHADOW
    enum: GL_SHADING_LANGUAGE_VERSION
    enum: GL_VERTEX_SHADER
    enum: GL_MAX_VERTEX_UNIFORM_COMPONENTS
    enum: GL_MAX_VARYING_FLOATS
    enum: GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS
    enum: GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS
    enum: GL_ACTIVE_ATTRIBUTES
    enum: GL_ACTIVE_ATTRIBUTE_MAX_LENGTH
    enum: GL_FRAGMENT_SHADER
    enum: GL_MAX_FRAGMENT_UNIFORM_COMPONENTS
    enum: GL_FRAGMENT_SHADER_DERIVATIVE_HINT
    enum: GL_MAX_VERTEX_ATTRIBS
    enum: GL_VERTEX_ATTRIB_ARRAY_ENABLED
    enum: GL_VERTEX_ATTRIB_ARRAY_SIZE
    enum: GL_VERTEX_ATTRIB_ARRAY_STRIDE
    enum: GL_VERTEX_ATTRIB_ARRAY_TYPE
    enum: GL_VERTEX_ATTRIB_ARRAY_NORMALIZED
    enum: GL_CURRENT_VERTEX_ATTRIB
    enum: GL_VERTEX_ATTRIB_ARRAY_POINTER
    enum: GL_VERTEX_PROGRAM_POINT_SIZE
    enum: GL_VERTEX_PROGRAM_TWO_SIDE
    enum: GL_MAX_TEXTURE_COORDS
    enum: GL_MAX_TEXTURE_IMAGE_UNITS
    enum: GL_MAX_DRAW_BUFFERS
    enum: GL_DRAW_BUFFER0
    enum: GL_DRAW_BUFFER1
    enum: GL_DRAW_BUFFER2
    enum: GL_DRAW_BUFFER3
    enum: GL_DRAW_BUFFER4
    enum: GL_DRAW_BUFFER5
    enum: GL_DRAW_BUFFER6
    enum: GL_DRAW_BUFFER7
    enum: GL_DRAW_BUFFER8
    enum: GL_DRAW_BUFFER9
    enum: GL_DRAW_BUFFER10
    enum: GL_DRAW_BUFFER11
    enum: GL_DRAW_BUFFER12
    enum: GL_DRAW_BUFFER13
    enum: GL_DRAW_BUFFER14
    enum: GL_DRAW_BUFFER15
    enum: GL_POINT_SPRITE
    enum: GL_COORD_REPLACE
    enum: GL_POINT_SPRITE_COORD_ORIGIN
    enum: GL_LOWER_LEFT
    enum: GL_UPPER_LEFT
    enum: GL_STENCIL_BACK_FUNC
    enum: GL_STENCIL_BACK_VALUE_MASK
    enum: GL_STENCIL_BACK_REF
    enum: GL_STENCIL_BACK_FAIL
    enum: GL_STENCIL_BACK_PASS_DEPTH_FAIL
    enum: GL_STENCIL_BACK_PASS_DEPTH_PASS
    enum: GL_STENCIL_BACK_WRITEMASK
    enum: GL_CURRENT_RASTER_SECONDARY_COLOR
    enum: GL_PIXEL_PACK_BUFFER
    enum: GL_PIXEL_UNPACK_BUFFER
    enum: GL_PIXEL_PACK_BUFFER_BINDING
    enum: GL_PIXEL_UNPACK_BUFFER_BINDING
    enum: GL_FLOAT_MAT2x3
    enum: GL_FLOAT_MAT2x4
    enum: GL_FLOAT_MAT3x2
    enum: GL_FLOAT_MAT3x4
    enum: GL_FLOAT_MAT4x2
    enum: GL_FLOAT_MAT4x3
    enum: GL_SRGB
    enum: GL_SRGB8
    enum: GL_SRGB_ALPHA
    enum: GL_SRGB8_ALPHA8
    enum: GL_SLUMINANCE_ALPHA
    enum: GL_SLUMINANCE8_ALPHA8
    enum: GL_SLUMINANCE
    enum: GL_SLUMINANCE8
    enum: GL_COMPRESSED_SRGB
    enum: GL_COMPRESSED_SRGB_ALPHA
    enum: GL_COMPRESSED_SLUMINANCE
    enum: GL_COMPRESSED_SLUMINANCE_ALPHA
    enum: GL_COLOR_ATTACHMENT0
    enum: GL_COLOR_ATTACHMENT1
    enum: GL_COLOR_ATTACHMENT2
    enum: GL_COLOR_ATTACHMENT3
    enum: GL_COLOR_ATTACHMENT4
    enum: GL_COLOR_ATTACHMENT5
    enum: GL_COLOR_ATTACHMENT6
    enum: GL_COLOR_ATTACHMENT7
    enum: GL_COLOR_ATTACHMENT8
    enum: GL_COLOR_ATTACHMENT9
    enum: GL_COLOR_ATTACHMENT10
    enum: GL_COLOR_ATTACHMENT11
    enum: GL_COLOR_ATTACHMENT12
    enum: GL_COLOR_ATTACHMENT13
    enum: GL_COLOR_ATTACHMENT14
    enum: GL_COLOR_ATTACHMENT15
    enum: GL_DEPTH_ATTACHMENT
    enum: GL_STENCIL_ATTACHMENT
    enum: GL_FRAMEBUFFER
    enum: GL_DRAW_FRAMEBUFFER
    enum: GL_READ_FRAMEBUFFER
    enum: GL_FRAMEBUFFER_BINDING
    enum: GL_RENDERBUFFER
    ctypedef unsigned int GLenum
    ctypedef unsigned char GLboolean
    ctypedef unsigned int GLbitfield
    ctypedef signed char GLbyte
    ctypedef short GLshort
    ctypedef int GLint
    ctypedef int GLsizei
    ctypedef unsigned char GLubyte
    ctypedef unsigned short GLushort
    ctypedef unsigned int GLuint
    ctypedef float GLfloat
    ctypedef float GLclampf
    ctypedef double GLdouble
    ctypedef double GLclampd
    ctypedef void GLvoid
    ctypedef long GLintptr
    ctypedef long GLsizeiptr
    ctypedef char GLchar
    enum: glewExperimental
    void glewInit()
    void glAccum(GLenum op, GLfloat value)
    void glAlphaFunc(GLenum func, GLclampf ref)
    GLboolean glAreTexturesResident(GLsizei n, GLuint *textures, GLboolean *residences)
    void glArrayElement(GLint i)
    void glBegin(GLenum mode)
    void glBindTexture(GLenum target, GLuint texture)
    void glBitmap(GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, GLubyte *bitmap)
    void glBlendColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha)
    void glBlendEquation(GLenum mode)
    void glBlendEquationSeparate(GLenum modeRGB, GLenum modeAlpha)
    void glBlendFunc(GLenum sfactor, GLenum dfactor)
    void glCallList(GLuint list)
    void glCallLists(GLsizei n, GLenum type, GLvoid *lists)
    void glClear(GLbitfield mask)
    void glClearAccum(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
    void glClearColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha)
    void glClearDepth(GLclampd depth)
    void glClearIndex(GLfloat c)
    void glClearStencil(GLint s)
    void glClipPlane(GLenum plane, GLdouble *equation)
    void glColor3b(GLbyte red, GLbyte green, GLbyte blue)
    void glColor3bv(GLbyte *v)
    void glColor3d(GLdouble red, GLdouble green, GLdouble blue)
    void glColor3dv(GLdouble *v)
    void glColor3f(GLfloat red, GLfloat green, GLfloat blue)
    void glColor3fv(GLfloat *v)
    void glColor3i(GLint red, GLint green, GLint blue)
    void glColor3iv(GLint *v)
    void glColor3s(GLshort red, GLshort green, GLshort blue)
    void glColor3sv(GLshort *v)
    void glColor3ub(GLubyte red, GLubyte green, GLubyte blue)
    void glColor3ubv(GLubyte *v)
    void glColor3ui(GLuint red, GLuint green, GLuint blue)
    void glColor3uiv(GLuint *v)
    void glColor3us(GLushort red, GLushort green, GLushort blue)
    void glColor3usv(GLushort *v)
    void glColor4b(GLbyte red, GLbyte green, GLbyte blue, GLbyte alpha)
    void glColor4bv(GLbyte *v)
    void glColor4d(GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha)
    void glColor4dv(GLdouble *v)
    void glColor4f(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
    void glColor4fv(GLfloat *v)
    void glColor4i(GLint red, GLint green, GLint blue, GLint alpha)
    void glColor4iv(GLint *v)
    void glColor4s(GLshort red, GLshort green, GLshort blue, GLshort alpha)
    void glColor4sv(GLshort *v)
    void glColor4ub(GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha)
    void glColor4ubv(GLubyte *v)
    void glColor4ui(GLuint red, GLuint green, GLuint blue, GLuint alpha)
    void glColor4uiv(GLuint *v)
    void glColor4us(GLushort red, GLushort green, GLushort blue, GLushort alpha)
    void glColor4usv(GLushort *v)
    void glColorMask(GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha)
    void glColorMaterial(GLenum face, GLenum mode)
    void glColorPointer(GLint size, GLenum type, GLsizei stride, GLvoid *pointer)
    void glColorSubTable(GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, GLvoid *data)
    void glColorTable(GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *table)
    void glColorTableParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glColorTableParameteriv(GLenum target, GLenum pname, GLint *params)
    void glConvolutionFilter1D(GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *image)
    void glConvolutionFilter2D(GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *image)
    void glConvolutionParameterf(GLenum target, GLenum pname, GLfloat params)
    void glConvolutionParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glConvolutionParameteri(GLenum target, GLenum pname, GLint params)
    void glConvolutionParameteriv(GLenum target, GLenum pname, GLint *params)
    void glCopyColorSubTable(GLenum target, GLsizei start, GLint x, GLint y, GLsizei width)
    void glCopyColorTable(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width)
    void glCopyConvolutionFilter1D(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width)
    void glCopyConvolutionFilter2D(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height)
    void glCopyPixels(GLint x, GLint y, GLsizei width, GLsizei height, GLenum type)
    void glCopyTexImage1D(GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border)
    void glCopyTexImage2D(GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border)
    void glCopyTexSubImage1D(GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width)
    void glCopyTexSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height)
    void glCopyTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height)
    void glCullFace(GLenum mode)
    void glDeleteLists(GLuint list, GLsizei range)
    void glDeleteTextures(GLsizei n, GLuint *textures)
    void glDepthFunc(GLenum func)
    void glDepthMask(GLboolean flag)
    void glDepthRange(GLclampd zNear, GLclampd zFar)
    void glDisable(GLenum cap)
    void glDisableClientState(GLenum array)
    void glDrawArrays(GLenum mode, GLint first, GLsizei count)
    void glDrawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei primcount)
    void glDrawBuffer(GLenum mode)
    void glDrawElements(GLenum mode, GLsizei count, GLenum type, GLvoid *indices)
    void glDrawPixels(GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels)
    void glDrawRangeElements(GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices)
    void glEdgeFlag(GLboolean flag)
    void glEdgeFlagPointer(GLsizei stride, GLvoid *pointer)
    void glEdgeFlagv(GLboolean *flag)
    void glEnable(GLenum cap)
    void glEnableClientState(GLenum array)
    void glEnd()
    void glEndList()
    void glEvalCoord1d(GLdouble u)
    void glEvalCoord1dv(GLdouble *u)
    void glEvalCoord1f(GLfloat u)
    void glEvalCoord1fv(GLfloat *u)
    void glEvalCoord2d(GLdouble u, GLdouble v)
    void glEvalCoord2dv(GLdouble *u)
    void glEvalCoord2f(GLfloat u, GLfloat v)
    void glEvalCoord2fv(GLfloat *u)
    void glEvalMesh1(GLenum mode, GLint i1, GLint i2)
    void glEvalMesh2(GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2)
    void glEvalPoint1(GLint i)
    void glEvalPoint2(GLint i, GLint j)
    void glFeedbackBuffer(GLsizei size, GLenum type, GLfloat *buffer)
    void glFinish()
    void glFlush()
    void glFogf(GLenum pname, GLfloat param)
    void glFogfv(GLenum pname, GLfloat *params)
    void glFogi(GLenum pname, GLint param)
    void glFogiv(GLenum pname, GLint *params)
    void glFrontFace(GLenum mode)
    void glFrustum(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar)
    GLuint glGenLists(GLsizei range)
    void glGenTextures(GLsizei n, GLuint *textures)
    void glGetBooleanv(GLenum pname, GLboolean *params)
    void glGetClipPlane(GLenum plane, GLdouble *equation)
    void glGetColorTable(GLenum target, GLenum format, GLenum type, GLvoid *table)
    void glGetColorTableParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glGetColorTableParameteriv(GLenum target, GLenum pname, GLint *params)
    void glGetConvolutionFilter(GLenum target, GLenum format, GLenum type, GLvoid *image)
    void glGetConvolutionParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glGetConvolutionParameteriv(GLenum target, GLenum pname, GLint *params)
    void glGetDoublev(GLenum pname, GLdouble *params)
    GLenum glGetError()
    void glGetFloatv(GLenum pname, GLfloat *params)
    void glGetHistogram(GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values)
    void glGetHistogramParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glGetHistogramParameteriv(GLenum target, GLenum pname, GLint *params)
    void glGetIntegerv(GLenum pname, GLint *params)
    void glGetLightfv(GLenum light, GLenum pname, GLfloat *params)
    void glGetLightiv(GLenum light, GLenum pname, GLint *params)
    void glGetMapdv(GLenum target, GLenum query, GLdouble *v)
    void glGetMapfv(GLenum target, GLenum query, GLfloat *v)
    void glGetMapiv(GLenum target, GLenum query, GLint *v)
    void glGetMaterialfv(GLenum face, GLenum pname, GLfloat *params)
    void glGetMaterialiv(GLenum face, GLenum pname, GLint *params)
    void glGetMinmax(GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values)
    void glGetMinmaxParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glGetMinmaxParameteriv(GLenum target, GLenum pname, GLint *params)
    void glGetPixelMapfv(GLenum map, GLfloat *values)
    void glGetPixelMapuiv(GLenum map, GLuint *values)
    void glGetPixelMapusv(GLenum map, GLushort *values)
    void glGetPointerv(GLenum pname, GLvoid ** params)
    void glGetPolygonStipple(GLubyte *mask)
    void glGetSeparableFilter(GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span)
    GLubyte* glGetString(GLenum name)
    void glGetTexEnvfv(GLenum target, GLenum pname, GLfloat *params)
    void glGetTexEnviv(GLenum target, GLenum pname, GLint *params)
    void glGetTexGendv(GLenum coord, GLenum pname, GLdouble *params)
    void glGetTexGenfv(GLenum coord, GLenum pname, GLfloat *params)
    void glGetTexGeniv(GLenum coord, GLenum pname, GLint *params)
    void glGetTexImage(GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels)
    void glGetTexLevelParameterfv(GLenum target, GLint level, GLenum pname, GLfloat *params)
    void glGetTexLevelParameteriv(GLenum target, GLint level, GLenum pname, GLint *params)
    void glGetTexParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glGetTexParameteriv(GLenum target, GLenum pname, GLint *params)
    void glHint(GLenum target, GLenum mode)
    void glHistogram(GLenum target, GLsizei width, GLenum internalformat, GLboolean sink)
    void glIndexMask(GLuint mask)
    void glIndexPointer(GLenum type, GLsizei stride, GLvoid *pointer)
    void glIndexd(GLdouble c)
    void glIndexdv(GLdouble *c)
    void glIndexf(GLfloat c)
    void glIndexfv(GLfloat *c)
    void glIndexi(GLint c)
    void glIndexiv(GLint *c)
    void glIndexs(GLshort c)
    void glIndexsv(GLshort *c)
    void glIndexub(GLubyte c)
    void glIndexubv(GLubyte *c)
    void glInitNames()
    void glInterleavedArrays(GLenum format, GLsizei stride, GLvoid *pointer)
    GLboolean glIsEnabled(GLenum cap)
    GLboolean glIsList(GLuint list)
    GLboolean glIsTexture(GLuint texture)
    void glLightModelf(GLenum pname, GLfloat param)
    void glLightModelfv(GLenum pname, GLfloat *params)
    void glLightModeli(GLenum pname, GLint param)
    void glLightModeliv(GLenum pname, GLint *params)
    void glLightf(GLenum light, GLenum pname, GLfloat param)
    void glLightfv(GLenum light, GLenum pname, GLfloat *params)
    void glLighti(GLenum light, GLenum pname, GLint param)
    void glLightiv(GLenum light, GLenum pname, GLint *params)
    void glLineStipple(GLint factor, GLushort pattern)
    void glLineWidth(GLfloat width)
    void glListBase(GLuint base)
    void glLoadIdentity()
    void glLoadMatrixd(GLdouble *m)
    void glLoadMatrixf(GLfloat *m)
    void glLoadName(GLuint name)
    void glLogicOp(GLenum opcode)
    void glMap1d(GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, GLdouble *points)
    void glMap1f(GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, GLfloat *points)
    void glMap2d(GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble *points)
    void glMap2f(GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat *points)
    void glMapGrid1d(GLint un, GLdouble u1, GLdouble u2)
    void glMapGrid1f(GLint un, GLfloat u1, GLfloat u2)
    void glMapGrid2d(GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2)
    void glMapGrid2f(GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2)
    void glMaterialf(GLenum face, GLenum pname, GLfloat param)
    void glMaterialfv(GLenum face, GLenum pname, GLfloat *params)
    void glMateriali(GLenum face, GLenum pname, GLint param)
    void glMaterialiv(GLenum face, GLenum pname, GLint *params)
    void glMatrixMode(GLenum mode)
    void glMinmax(GLenum target, GLenum internalformat, GLboolean sink)
    void glMultMatrixd(GLdouble *m)
    void glMultMatrixf(GLfloat *m)
    void glNewList(GLuint list, GLenum mode)
    void glNormal3b(GLbyte nx, GLbyte ny, GLbyte nz)
    void glNormal3bv(GLbyte *v)
    void glNormal3d(GLdouble nx, GLdouble ny, GLdouble nz)
    void glNormal3dv(GLdouble *v)
    void glNormal3f(GLfloat nx, GLfloat ny, GLfloat nz)
    void glNormal3fv(GLfloat *v)
    void glNormal3i(GLint nx, GLint ny, GLint nz)
    void glNormal3iv(GLint *v)
    void glNormal3s(GLshort nx, GLshort ny, GLshort nz)
    void glNormal3sv(GLshort *v)
    void glNormalPointer(GLenum type, GLsizei stride, GLvoid *pointer)
    void glOrtho(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar)
    void glPassThrough(GLfloat token)
    void glPixelMapfv(GLenum map, GLint mapsize, GLfloat *values)
    void glPixelMapuiv(GLenum map, GLint mapsize, GLuint *values)
    void glPixelMapusv(GLenum map, GLint mapsize, GLushort *values)
    void glPixelStoref(GLenum pname, GLfloat param)
    void glPixelStorei(GLenum pname, GLint param)
    void glPixelTransferf(GLenum pname, GLfloat param)
    void glPixelTransferi(GLenum pname, GLint param)
    void glPixelZoom(GLfloat xfactor, GLfloat yfactor)
    void glPointSize(GLfloat size)
    void glPolygonMode(GLenum face, GLenum mode)
    void glPolygonOffset(GLfloat factor, GLfloat units)
    void glPolygonStipple(GLubyte *mask)
    void glPopAttrib()
    void glPopClientAttrib()
    void glPopMatrix()
    void glPopName()
    void glPrioritizeTextures(GLsizei n, GLuint *textures, GLclampf *priorities)
    void glPushAttrib(GLbitfield mask)
    void glPushClientAttrib(GLbitfield mask)
    void glPushMatrix()
    void glPushName(GLuint name)
    void glRasterPos2d(GLdouble x, GLdouble y)
    void glRasterPos2dv(GLdouble *v)
    void glRasterPos2f(GLfloat x, GLfloat y)
    void glRasterPos2fv(GLfloat *v)
    void glRasterPos2i(GLint x, GLint y)
    void glRasterPos2iv(GLint *v)
    void glRasterPos2s(GLshort x, GLshort y)
    void glRasterPos2sv(GLshort *v)
    void glRasterPos3d(GLdouble x, GLdouble y, GLdouble z)
    void glRasterPos3dv(GLdouble *v)
    void glRasterPos3f(GLfloat x, GLfloat y, GLfloat z)
    void glRasterPos3fv(GLfloat *v)
    void glRasterPos3i(GLint x, GLint y, GLint z)
    void glRasterPos3iv(GLint *v)
    void glRasterPos3s(GLshort x, GLshort y, GLshort z)
    void glRasterPos3sv(GLshort *v)
    void glRasterPos4d(GLdouble x, GLdouble y, GLdouble z, GLdouble w)
    void glRasterPos4dv(GLdouble *v)
    void glRasterPos4f(GLfloat x, GLfloat y, GLfloat z, GLfloat w)
    void glRasterPos4fv(GLfloat *v)
    void glRasterPos4i(GLint x, GLint y, GLint z, GLint w)
    void glRasterPos4iv(GLint *v)
    void glRasterPos4s(GLshort x, GLshort y, GLshort z, GLshort w)
    void glRasterPos4sv(GLshort *v)
    void glReadBuffer(GLenum mode)
    void glReadPixels(GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels)
    void glRectd(GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2)
    void glRectdv(GLdouble *v1, GLdouble *v2)
    void glRectf(GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2)
    void glRectfv(GLfloat *v1, GLfloat *v2)
    void glRecti(GLint x1, GLint y1, GLint x2, GLint y2)
    void glRectiv(GLint *v1, GLint *v2)
    void glRects(GLshort x1, GLshort y1, GLshort x2, GLshort y2)
    void glRectsv(GLshort *v1, GLshort *v2)
    GLint glRenderMode(GLenum mode)
    void glResetHistogram(GLenum target)
    void glResetMinmax(GLenum target)
    void glRotated(GLdouble angle, GLdouble x, GLdouble y, GLdouble z)
    void glRotatef(GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
    void glScaled(GLdouble x, GLdouble y, GLdouble z)
    void glScalef(GLfloat x, GLfloat y, GLfloat z)
    void glScissor(GLint x, GLint y, GLsizei width, GLsizei height)
    void glSelectBuffer(GLsizei size, GLuint *buffer)
    void glSeparableFilter2D(GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *row, GLvoid *column)
    void glShadeModel(GLenum mode)
    void glStencilFunc(GLenum func, GLint ref, GLuint mask)
    void glStencilMask(GLuint mask)
    void glStencilOp(GLenum fail, GLenum zfail, GLenum zpass)
    void glTexBuffer(GLenum mode, GLenum type, GLuint id)# TODO: rename these params per spec
    void glTexCoord1d(GLdouble s)
    void glTexCoord1dv(GLdouble *v)
    void glTexCoord1f(GLfloat s)
    void glTexCoord1fv(GLfloat *v)
    void glTexCoord1i(GLint s)
    void glTexCoord1iv(GLint *v)
    void glTexCoord1s(GLshort s)
    void glTexCoord1sv(GLshort *v)
    void glTexCoord2d(GLdouble s, GLdouble t)
    void glTexCoord2dv(GLdouble *v)
    void glTexCoord2f(GLfloat s, GLfloat t)
    void glTexCoord2fv(GLfloat *v)
    void glTexCoord2i(GLint s, GLint t)
    void glTexCoord2iv(GLint *v)
    void glTexCoord2s(GLshort s, GLshort t)
    void glTexCoord2sv(GLshort *v)
    void glTexCoord3d(GLdouble s, GLdouble t, GLdouble r)
    void glTexCoord3dv(GLdouble *v)
    void glTexCoord3f(GLfloat s, GLfloat t, GLfloat r)
    void glTexCoord3fv(GLfloat *v)
    void glTexCoord3i(GLint s, GLint t, GLint r)
    void glTexCoord3iv(GLint *v)
    void glTexCoord3s(GLshort s, GLshort t, GLshort r)
    void glTexCoord3sv(GLshort *v)
    void glTexCoord4d(GLdouble s, GLdouble t, GLdouble r, GLdouble q)
    void glTexCoord4dv(GLdouble *v)
    void glTexCoord4f(GLfloat s, GLfloat t, GLfloat r, GLfloat q)
    void glTexCoord4fv(GLfloat *v)
    void glTexCoord4i(GLint s, GLint t, GLint r, GLint q)
    void glTexCoord4iv(GLint *v)
    void glTexCoord4s(GLshort s, GLshort t, GLshort r, GLshort q)
    void glTexCoord4sv(GLshort *v)
    void glTexCoordPointer(GLint size, GLenum type, GLsizei stride, GLvoid *pointer)
    void glTexEnvf(GLenum target, GLenum pname, GLfloat param)
    void glTexEnvfv(GLenum target, GLenum pname, GLfloat *params)
    void glTexEnvi(GLenum target, GLenum pname, GLint param)
    void glTexEnviv(GLenum target, GLenum pname, GLint *params)
    void glTexGend(GLenum coord, GLenum pname, GLdouble param)
    void glTexGendv(GLenum coord, GLenum pname, GLdouble *params)
    void glTexGenf(GLenum coord, GLenum pname, GLfloat param)
    void glTexGenfv(GLenum coord, GLenum pname, GLfloat *params)
    void glTexGeni(GLenum coord, GLenum pname, GLint param)
    void glTexGeniv(GLenum coord, GLenum pname, GLint *params)
    void glTexImage1D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, GLvoid *pixels)
    void glTexImage2D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLvoid *pixels)
    void glTexImage3D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels)
    void glTexParameterf(GLenum target, GLenum pname, GLfloat param)
    void glTexParameterfv(GLenum target, GLenum pname, GLfloat *params)
    void glTexParameteri(GLenum target, GLenum pname, GLint param)
    void glTexParameteriv(GLenum target, GLenum pname, GLint *params)
    void glTexSubImage1D(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels)
    void glTexSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels)
    void glTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels)
    void glTranslated(GLdouble x, GLdouble y, GLdouble z)
    void glTranslatef(GLfloat x, GLfloat y, GLfloat z)
    void glVertex2d(GLdouble x, GLdouble y)
    void glVertex2dv(GLdouble *v)
    void glVertex2f(GLfloat x, GLfloat y)
    void glVertex2fv(GLfloat *v)
    void glVertex2i(GLint x, GLint y)
    void glVertex2iv(GLint *v)
    void glVertex2s(GLshort x, GLshort y)
    void glVertex2sv(GLshort *v)
    void glVertex3d(GLdouble x, GLdouble y, GLdouble z)
    void glVertex3dv(GLdouble *v)
    void glVertex3f(GLfloat x, GLfloat y, GLfloat z)
    void glVertex3fv(GLfloat *v)
    void glVertex3i(GLint x, GLint y, GLint z)
    void glVertex3iv(GLint *v)
    void glVertex3s(GLshort x, GLshort y, GLshort z)
    void glVertex3sv(GLshort *v)
    void glVertex4d(GLdouble x, GLdouble y, GLdouble z, GLdouble w)
    void glVertex4dv(GLdouble *v)
    void glVertex4f(GLfloat x, GLfloat y, GLfloat z, GLfloat w)
    void glVertex4fv(GLfloat *v)
    void glVertex4i(GLint x, GLint y, GLint z, GLint w)
    void glVertex4iv(GLint *v)
    void glVertex4s(GLshort x, GLshort y, GLshort z, GLshort w)
    void glVertex4sv(GLshort *v)
    void glVertexPointer(GLint size, GLenum type, GLsizei stride, GLvoid *pointer)
    void glViewport(GLint x, GLint y, GLsizei width, GLsizei height)
    void glSampleCoverage(GLclampf value, GLboolean invert)
    void glLoadTransposeMatrixf(GLfloat *m)
    void glLoadTransposeMatrixd(GLdouble *m)
    void glMultTransposeMatrixf(GLfloat *m)
    void glMultTransposeMatrixd(GLdouble *m)
    void glCompressedTexImage3D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *data)
    void glCompressedTexImage2D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *data)
    void glCompressedTexImage1D(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *data)
    void glCompressedTexSubImage3D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *data)
    void glCompressedTexSubImage2D(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *data)
    void glCompressedTexSubImage1D(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *data)
    void glGetCompressedTexImage(GLenum target, GLint lod, GLvoid *img)
    void glGenerateMipmap(GLenum target)
    void glGenerateTextureMipmap(GLuint texture)
    void glActiveTexture(GLenum texture)
    void glClientActiveTexture(GLenum texture)
    void glMultiTexCoord1d(GLenum target, GLdouble s)
    void glMultiTexCoord1dv(GLenum target, GLdouble *v)
    void glMultiTexCoord1f(GLenum target, GLfloat s)
    void glMultiTexCoord1fv(GLenum target, GLfloat *v)
    void glMultiTexCoord1i(GLenum target, GLint s)
    void glMultiTexCoord1iv(GLenum target, GLint *v)
    void glMultiTexCoord1s(GLenum target, GLshort s)
    void glMultiTexCoord1sv(GLenum target, GLshort *v)
    void glMultiTexCoord2d(GLenum target, GLdouble s, GLdouble t)
    void glMultiTexCoord2dv(GLenum target, GLdouble *v)
    void glMultiTexCoord2f(GLenum target, GLfloat s, GLfloat t)
    void glMultiTexCoord2fv(GLenum target, GLfloat *v)
    void glMultiTexCoord2i(GLenum target, GLint s, GLint t)
    void glMultiTexCoord2iv(GLenum target, GLint *v)
    void glMultiTexCoord2s(GLenum target, GLshort s, GLshort t)
    void glMultiTexCoord2sv(GLenum target, GLshort *v)
    void glMultiTexCoord3d(GLenum target, GLdouble s, GLdouble t, GLdouble r)
    void glMultiTexCoord3dv(GLenum target, GLdouble *v)
    void glMultiTexCoord3f(GLenum target, GLfloat s, GLfloat t, GLfloat r)
    void glMultiTexCoord3fv(GLenum target, GLfloat *v)
    void glMultiTexCoord3i(GLenum target, GLint s, GLint t, GLint r)
    void glMultiTexCoord3iv(GLenum target, GLint *v)
    void glMultiTexCoord3s(GLenum target, GLshort s, GLshort t, GLshort r)
    void glMultiTexCoord3sv(GLenum target, GLshort *v)
    void glMultiTexCoord4d(GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q)
    void glMultiTexCoord4dv(GLenum target, GLdouble *v)
    void glMultiTexCoord4f(GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q)
    void glMultiTexCoord4fv(GLenum target, GLfloat *v)
    void glMultiTexCoord4i(GLenum target, GLint s, GLint t, GLint r, GLint q)
    void glMultiTexCoord4iv(GLenum target, GLint *v)
    void glMultiTexCoord4s(GLenum target, GLshort s, GLshort t, GLshort r, GLshort q)
    void glMultiTexCoord4sv(GLenum target, GLshort *v)
    void glFogCoordf(GLfloat coord)
    void glFogCoordfv(GLfloat *coord)
    void glFogCoordd(GLdouble coord)
    void glFogCoorddv(GLdouble *coord)
    void glFogCoordPointer(GLenum type, GLsizei stride, GLvoid *pointer)
    void glSecondaryColor3b(GLbyte red, GLbyte green, GLbyte blue)
    void glSecondaryColor3bv(GLbyte *v)
    void glSecondaryColor3d(GLdouble red, GLdouble green, GLdouble blue)
    void glSecondaryColor3dv(GLdouble *v)
    void glSecondaryColor3f(GLfloat red, GLfloat green, GLfloat blue)
    void glSecondaryColor3fv(GLfloat *v)
    void glSecondaryColor3i(GLint red, GLint green, GLint blue)
    void glSecondaryColor3iv(GLint *v)
    void glSecondaryColor3s(GLshort red, GLshort green, GLshort blue)
    void glSecondaryColor3sv(GLshort *v)
    void glSecondaryColor3ub(GLubyte red, GLubyte green, GLubyte blue)
    void glSecondaryColor3ubv(GLubyte *v)
    void glSecondaryColor3ui(GLuint red, GLuint green, GLuint blue)
    void glSecondaryColor3uiv(GLuint *v)
    void glSecondaryColor3us(GLushort red, GLushort green, GLushort blue)
    void glSecondaryColor3usv(GLushort *v)
    void glSecondaryColorPointer(GLint size, GLenum type, GLsizei stride, GLvoid *pointer)
    void glPointParameterf(GLenum pname, GLfloat param)
    void glPointParameterfv(GLenum pname, GLfloat *params)
    void glPointParameteri(GLenum pname, GLint param)
    void glPointParameteriv(GLenum pname, GLint *params)
    void glBlendFuncSeparate(GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha)
    void glMultiDrawArrays(GLenum mode, GLint *first, GLsizei *count, GLsizei primcount)
    void glMultiDrawElements(GLenum mode, GLsizei *count, GLenum type, GLvoid ** indices, GLsizei primcount)
    void glWindowPos2d(GLdouble x, GLdouble y)
    void glWindowPos2dv(GLdouble *v)
    void glWindowPos2f(GLfloat x, GLfloat y)
    void glWindowPos2fv(GLfloat *v)
    void glWindowPos2i(GLint x, GLint y)
    void glWindowPos2iv(GLint *v)
    void glWindowPos2s(GLshort x, GLshort y)
    void glWindowPos2sv(GLshort *v)
    void glWindowPos3d(GLdouble x, GLdouble y, GLdouble z)
    void glWindowPos3dv(GLdouble *v)
    void glWindowPos3f(GLfloat x, GLfloat y, GLfloat z)
    void glWindowPos3fv(GLfloat *v)
    void glWindowPos3i(GLint x, GLint y, GLint z)
    void glWindowPos3iv(GLint *v)
    void glWindowPos3s(GLshort x, GLshort y, GLshort z)
    void glWindowPos3sv(GLshort *v)
    void glGenQueries(GLsizei n, GLuint *ids)
    void glDeleteQueries(GLsizei n, GLuint *ids)
    GLboolean glIsQuery(GLuint id)
    void glBeginQuery(GLenum target, GLuint id)
    void glEndQuery(GLenum target)
    void glGetQueryiv(GLenum target, GLenum pname, GLint *params)
    void glGetQueryObjectiv(GLuint id, GLenum pname, GLint *params)
    void glGetQueryObjectuiv(GLuint id, GLenum pname, GLuint *params)
    void glBindBuffer(GLenum target, GLuint buffer)
    void glDeleteBuffers(GLsizei n, GLuint *buffers)
    void glGenBuffers(GLsizei n, GLuint *buffers)
    GLboolean glIsBuffer(GLuint buffer)
    void glBufferData(GLenum target, GLsizeiptr size, GLvoid *data, GLenum usage)
    void glBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data)
    void glGetBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data)
    GLvoid* glMapBuffer(GLenum target, GLenum access)
    GLboolean glUnmapBuffer(GLenum target)
    void glGetBufferParameteriv(GLenum target, GLenum pname, GLint *params)
    void glGetBufferPointerv(GLenum target, GLenum pname, GLvoid ** params)
    void glDrawBuffers(GLsizei n, GLenum *bufs)
    void glGenVertexArrays(GLsizei n, GLuint *arrays)
    void glBindVertexArray(GLuint array)
    void glDeleteVertexArrays(GLsizei n, GLuint *arrays)
    void glVertexAttribDivisor(	GLuint index, GLuint divisor)
    void glVertexAttrib1d(GLuint index, GLdouble x)
    void glVertexAttrib1dv(GLuint index, GLdouble *v)
    void glVertexAttrib1f(GLuint index, GLfloat x)
    void glVertexAttrib1fv(GLuint index, GLfloat *v)
    void glVertexAttrib1s(GLuint index, GLshort x)
    void glVertexAttrib1sv(GLuint index, GLshort *v)
    void glVertexAttrib2d(GLuint index, GLdouble x, GLdouble y)
    void glVertexAttrib2dv(GLuint index, GLdouble *v)
    void glVertexAttrib2f(GLuint index, GLfloat x, GLfloat y)
    void glVertexAttrib2fv(GLuint index, GLfloat *v)
    void glVertexAttrib2s(GLuint index, GLshort x, GLshort y)
    void glVertexAttrib2sv(GLuint index, GLshort *v)
    void glVertexAttrib3d(GLuint index, GLdouble x, GLdouble y, GLdouble z)
    void glVertexAttrib3dv(GLuint index, GLdouble *v)
    void glVertexAttrib3f(GLuint index, GLfloat x, GLfloat y, GLfloat z)
    void glVertexAttrib3fv(GLuint index, GLfloat *v)
    void glVertexAttrib3s(GLuint index, GLshort x, GLshort y, GLshort z)
    void glVertexAttrib3sv(GLuint index, GLshort *v)
    void glVertexAttrib4Nbv(GLuint index, GLbyte *v)
    void glVertexAttrib4Niv(GLuint index, GLint *v)
    void glVertexAttrib4Nsv(GLuint index, GLshort *v)
    void glVertexAttrib4Nub(GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w)
    void glVertexAttrib4Nubv(GLuint index, GLubyte *v)
    void glVertexAttrib4Nuiv(GLuint index, GLuint *v)
    void glVertexAttrib4Nusv(GLuint index, GLushort *v)
    void glVertexAttrib4bv(GLuint index, GLbyte *v)
    void glVertexAttrib4d(GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
    void glVertexAttrib4dv(GLuint index, GLdouble *v)
    void glVertexAttrib4f(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
    void glVertexAttrib4fv(GLuint index, GLfloat *v)
    void glVertexAttrib4iv(GLuint index, GLint *v)
    void glVertexAttrib4s(GLuint index, GLshort x, GLshort y, GLshort z, GLshort w)
    void glVertexAttrib4sv(GLuint index, GLshort *v)
    void glVertexAttrib4ubv(GLuint index, GLubyte *v)
    void glVertexAttrib4uiv(GLuint index, GLuint *v)
    void glVertexAttrib4usv(GLuint index, GLushort *v)
    void glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLvoid *pointer)
    void glEnableVertexAttribArray(GLuint index)
    void glDisableVertexAttribArray(GLuint index)
    void glGetVertexAttribdv(GLuint index, GLenum pname, GLdouble *params)
    void glGetVertexAttribfv(GLuint index, GLenum pname, GLfloat *params)
    void glGetVertexAttribiv(GLuint index, GLenum pname, GLint *params)
    void glGetVertexAttribPointerv(GLuint index, GLenum pname, GLvoid ** pointer)
    void glDeleteShader(GLuint shader)
    void glDetachShader(GLuint program, GLuint shader)
    GLuint glCreateShader(GLenum type)
    void glShaderSource(GLuint shader, GLsizei count, GLchar ** string, GLint *length)
    void glCompileShader(GLuint shader)
    GLuint glCreateProgram()
    void glAttachShader(GLuint program, GLuint shader)
    void glLinkProgram(GLuint program)
    void glUseProgram(GLuint program)
    void glDeleteProgram(GLuint program)
    void glValidateProgram(GLuint program)
    void glUniform1f(GLint location, GLfloat v0)
    void glUniform2f(GLint location, GLfloat v0, GLfloat v1)
    void glUniform3f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2)
    void glUniform4f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3)
    void glUniform1i(GLint location, GLint v0)
    void glUniform2i(GLint location, GLint v0, GLint v1)
    void glUniform3i(GLint location, GLint v0, GLint v1, GLint v2)
    void glUniform4i(GLint location, GLint v0, GLint v1, GLint v2, GLint v3)
    void glUniform1fv(GLint location, GLsizei count, GLfloat *value)
    void glUniform2fv(GLint location, GLsizei count, GLfloat *value)
    void glUniform3fv(GLint location, GLsizei count, GLfloat *value)
    void glUniform4fv(GLint location, GLsizei count, GLfloat *value)
    void glUniform1iv(GLint location, GLsizei count, GLint *value)
    void glUniform2iv(GLint location, GLsizei count, GLint *value)
    void glUniform3iv(GLint location, GLsizei count, GLint *value)
    void glUniform4iv(GLint location, GLsizei count, GLint *value)
    void glUniformMatrix2fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix3fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    GLboolean glIsShader(GLuint shader)
    GLboolean glIsProgram(GLuint program)
    void glGetShaderiv(GLuint shader, GLenum pname, GLint *params)
    void glGetProgramiv(GLuint program, GLenum pname, GLint *params)
    void glGetAttachedShaders(GLuint program, GLsizei maxCount, GLsizei *count, GLuint *shaders)
    void glGetShaderInfoLog(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog)
    void glGetProgramInfoLog(GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog)
    GLint glGetUniformLocation(GLuint program, GLchar *name)
    void glGetActiveUniform(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name)
    void glGetUniformfv(GLuint program, GLint location, GLfloat *params)
    void glGetUniformiv(GLuint program, GLint location, GLint *params)
    void glGetShaderSource(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source)
    void glBindAttribLocation(GLuint program, GLuint index, GLchar *name)
    void glGetActiveAttrib(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name)
    GLint glGetAttribLocation(GLuint program, GLchar *name)
    void glStencilFuncSeparate(GLenum face, GLenum func, GLint ref, GLuint mask)
    void glStencilOpSeparate(GLenum face, GLenum fail, GLenum zfail, GLenum zpass)
    void glStencilMaskSeparate(GLenum face, GLuint mask)
    void glUniformMatrix2x3fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix3x2fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix2x4fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix4x2fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix3x4fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glUniformMatrix4x3fv(GLint location, GLsizei count, GLboolean transpose, GLfloat *value)
    void glGenFramebuffers(GLsizei n, GLuint *ids)
    void glBindFramebuffer(GLenum target, GLuint framebuffer)
    void glDeleteFramebuffers(GLsizei n, GLuint *framebuffers)
    void glFramebufferTexture2D(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)
    GLenum glCheckFramebufferStatus(GLenum target)
    void glGenRenderbuffers(GLsizei n, GLuint *renderbuffers)
    void glDeleteRenderbuffers(GLsizei n, GLuint *renderbuffers)
    void glBindRenderbuffer(GLenum target, GLuint renderbuffer)
    void glRenderbufferStorage(GLenum target, GLenum internalformat, GLsizei width, GLsizei height)
    void glFramebufferRenderbuffer(GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)