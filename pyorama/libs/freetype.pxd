from pyorama.libs.c cimport *

cdef extern from "ft2build.h" nogil:
    pass

cdef extern from "freetype/config/ftconfig.h" nogil:
    ctypedef int16_t FT_Int16
    ctypedef uint16_t FT_UInt16
    ctypedef int32_t FT_Int32
    ctypedef uint32_t FT_UInt32
    ctypedef int64_t FT_Int64
    ctypedef uint64_t FT_UInt64

cdef extern from "freetype/config/ftstdlib.h" nogil:
    ctypedef ptrdiff_t ft_ptrdiff_t 
    cdef enum:
        FT_CHAR_BIT 
        FT_USHORT_MAX
        FT_INT_MAX 
        FT_INT_MIN
        FT_UINT_MAX
        FT_LONG_MIN
        FT_LONG_MAX
        FT_ULONG_MAX

cdef extern from "freetype/ftsystem.h" nogil:
    ctypedef FT_MemoryRec *FT_Memory
    ctypedef void *(*FT_Alloc_Func)(FT_Memory memory, long size)
    ctypedef void (*FT_Free_Func)(FT_Memory memory, void* block)
    ctypedef void *(*FT_Realloc_Func)(FT_Memory memory, long cur_size, long new_size, void* block)
    ctypedef struct FT_MemoryRec:
        void *user
        FT_Alloc_Func alloc
        FT_Free_Func free
        FT_Realloc_Func realloc
    ctypedef FT_StreamRec *FT_Stream
    ctypedef union FT_StreamDesc:
        long value
        void *pointer
    ctypedef unsigned long (*FT_Stream_IoFunc)(FT_Stream stream, unsigned long offset, unsigned char* buffer, unsigned long count)
    ctypedef void (*FT_Stream_CloseFunc)(FT_Stream stream)
    ctypedef struct FT_StreamRec:
        unsigned char *base
        unsigned long size
        unsigned long pos
        FT_StreamDesc descriptor
        FT_StreamDesc pathname
        FT_Stream_IoFunc read
        FT_Stream_CloseFunc close
        FT_Memory memory
        unsigned char *cursor
        unsigned char *limit

cdef extern from "freetype/fttypes.h" nogil:
    ctypedef unsigned char FT_Bool
    ctypedef signed short FT_FWord
    ctypedef unsigned short FT_UFWord
    ctypedef signed char FT_Char
    ctypedef unsigned char FT_Byte
    ctypedef const FT_Byte *FT_Bytes
    ctypedef FT_UInt32 FT_Tag
    ctypedef char FT_String
    ctypedef signed short FT_Short
    ctypedef unsigned short FT_UShort
    ctypedef signed int FT_Int
    ctypedef unsigned int FT_UInt
    ctypedef signed long FT_Long
    ctypedef unsigned long FT_ULong
    ctypedef signed short FT_F2Dot14
    ctypedef signed long FT_F26Dot6
    ctypedef signed long FT_Fixed
    ctypedef int FT_Error
    ctypedef void *FT_Pointer
    ctypedef size_t FT_Offset
    ctypedef ft_ptrdiff_t FT_PtrDist
    ctypedef struct FT_UnitVector:
        FT_F2Dot14 x
        FT_F2Dot14 y
    ctypedef struct FT_Matrix:
        FT_Fixed xx, xy
        FT_Fixed yx, yy
    ctypedef struct FT_Data:
        const FT_Byte *pointer
        FT_Int length
    ctypedef void (*FT_Generic_Finalizer)(void *object)
    ctypedef struct FT_Generic:
        void *data
        FT_Generic_Finalizer finalizer
    ctypedef FT_ListNodeRec *FT_ListNode
    ctypedef FT_ListRec *FT_List
    ctypedef struct FT_ListNodeRec:
        FT_ListNode prev
        FT_ListNode next
        void *data
    ctypedef struct FT_ListRec:
        FT_ListNode head
        FT_ListNode tail

cdef extern from "freetype/ftimage.h" nogil:
    ctypedef signed long FT_Pos
    ctypedef struct FT_Vector:
        FT_Pos x
        FT_Pos y
    ctypedef struct FT_BBox:
        FT_Pos xMin, yMin
        FT_Pos xMax, yMax
    ctypedef enum FT_Pixel_Mode:
        FT_PIXEL_MODE_NONE = 0
        FT_PIXEL_MODE_MONO
        FT_PIXEL_MODE_GRAY
        FT_PIXEL_MODE_GRAY2
        FT_PIXEL_MODE_GRAY4
        FT_PIXEL_MODE_LCD
        FT_PIXEL_MODE_LCD_V
        FT_PIXEL_MODE_BGRA
        FT_PIXEL_MODE_MAX
    ctypedef struct FT_Bitmap:
        unsigned int rows
        unsigned int width
        int pitch
        unsigned char *buffer
        unsigned short num_grays
        unsigned char pixel_mode
        unsigned char palette_mode
        void *palette
    ctypedef struct FT_Outline:
        short n_contours
        short n_points
        FT_Vector *points
        char *tags
        short *contours
        int flags
    cdef enum:
        FT_OUTLINE_CONTOURS_MAX
        FT_OUTLINE_POINTS_MAX
    cdef enum:
        FT_OUTLINE_NONE
        FT_OUTLINE_OWNER
        FT_OUTLINE_EVEN_ODD_FILL
        FT_OUTLINE_REVERSE_FILL
        FT_OUTLINE_IGNORE_DROPOUTS
        FT_OUTLINE_SMART_DROPOUTS
        FT_OUTLINE_INCLUDE_STUBS
        FT_OUTLINE_HIGH_PRECISION
        FT_OUTLINE_SINGLE_PASS
    cdef enum:
        FT_CURVE_TAG_ON
        FT_CURVE_TAG_CONIC
        FT_CURVE_TAG_CUBIC
        FT_CURVE_TAG_HAS_SCANMODE
        FT_CURVE_TAG_TOUCH_X 
        FT_CURVE_TAG_TOUCH_Y
    ctypedef int (*FT_Outline_MoveToFunc)(const FT_Vector *to, void *user)
    ctypedef int (*FT_Outline_LineToFunc)(const FT_Vector *to, void *user)
    ctypedef int (*FT_Outline_ConicToFunc)(const FT_Vector *control, const FT_Vector *to, void *user)
    ctypedef int (*FT_Outline_CubicToFunc)(const FT_Vector *control1, const FT_Vector *control2, const FT_Vector *to, void *user)
    ctypedef struct FT_Outline_Funcs:
        FT_Outline_MoveToFunc move_to
        FT_Outline_LineToFunc line_to
        FT_Outline_ConicToFunc conic_to
        FT_Outline_CubicToFunc cubic_to
        int shift
        FT_Pos delta
    ctypedef enum FT_Glyph_Format:
        FT_GLYPH_FORMAT_NONE
        FT_GLYPH_FORMAT_COMPOSITE
        FT_GLYPH_FORMAT_BITMAP
        FT_GLYPH_FORMAT_OUTLINE
        FT_GLYPH_FORMAT_PLOTTER
    ctypedef struct FT_RasterRec
    ctypedef FT_RasterRec *FT_Raster
    ctypedef struct FT_Span:
        short x
        unsigned short len
        unsigned char coverage
    ctypedef void (*FT_SpanFunc)(int y, int count, const FT_Span *spans, void *user)
    ctypedef int (*FT_Raster_BitTest_Func)(int y, int x, void *user)
    ctypedef void (*FT_Raster_BitSet_Func)(int y, int x, void *user)
    cdef enum:
        FT_RASTER_FLAG_DEFAULT
        FT_RASTER_FLAG_AA
        FT_RASTER_FLAG_DIRECT
        FT_RASTER_FLAG_CLIP
    ctypedef struct FT_Raster_Params:
        const FT_Bitmap *target
        const void *source
        int flags
        FT_SpanFunc gray_spans
        FT_SpanFunc black_spans
        FT_Raster_BitTest_Func bit_test
        FT_Raster_BitSet_Func bit_set
        void *user
        FT_BBox clip_box
    ctypedef int (*FT_Raster_NewFunc)(void *memory, FT_Raster *raster)
    ctypedef void (*FT_Raster_DoneFunc)(FT_Raster raster)
    ctypedef void (*FT_Raster_ResetFunc)(FT_Raster raster, unsigned char *pool_base, unsigned long pool_size)
    ctypedef int (*FT_Raster_SetModeFunc)(FT_Raster raster, unsigned long mode, void *args)
    ctypedef int (*FT_Raster_RenderFunc)(FT_Raster raster, const FT_Raster_Params *params)
    ctypedef struct FT_Raster_Funcs:
        FT_Glyph_Format glyph_format
        FT_Raster_NewFunc raster_new
        FT_Raster_ResetFunc raster_reset
        FT_Raster_SetModeFunc raster_set_mode
        FT_Raster_RenderFunc raster_render
        FT_Raster_DoneFunc raster_done

cdef extern from "freetype/freetype.h" nogil:
    ctypedef struct FT_Glyph_Metrics:
        FT_Pos width
        FT_Pos height
        FT_Pos horiBearingX
        FT_Pos horiBearingY
        FT_Pos horiAdvance
        FT_Pos vertBearingX
        FT_Pos vertBearingY
        FT_Pos vertAdvance
    ctypedef struct FT_Bitmap_Size:
        FT_Short height
        FT_Short width
        FT_Pos size
        FT_Pos x_ppem
        FT_Pos y_ppem
    ctypedef struct FT_LibraryRec
    ctypedef struct FT_ModuleRec
    ctypedef struct FT_DriverRec
    ctypedef struct FT_RendererRec
    ctypedef struct FT_FaceRec
    ctypedef struct FT_SizeRec
    ctypedef struct FT_GlyphSlotRec
    ctypedef struct FT_CharMapRec
    ctypedef FT_LibraryRec *FT_Library
    ctypedef FT_ModuleRec *FT_Module
    ctypedef FT_DriverRec *FT_Driver
    ctypedef FT_RendererRec *FT_Renderer
    ctypedef FT_FaceRec *FT_Face
    ctypedef FT_SizeRec *FT_Size
    ctypedef FT_GlyphSlotRec *FT_GlyphSlot
    ctypedef FT_CharMapRec *FT_CharMap
    ctypedef enum FT_Encoding:
        FT_ENCODING_NONE
        FT_ENCODING_MS_SYMBOL
        FT_ENCODING_UNICODE
        FT_ENCODING_SJIS
        FT_ENCODING_PRC
        FT_ENCODING_BIG5
        FT_ENCODING_WANSUNG
        FT_ENCODING_JOHAB
        FT_ENCODING_ADOBE_STANDARD
        FT_ENCODING_ADOBE_EXPERT
        FT_ENCODING_ADOBE_CUSTOM
        FT_ENCODING_ADOBE_LATIN_1
        FT_ENCODING_OLD_LATIN_2
        FT_ENCODING_APPLE_ROMAN
    ctypedef struct FT_CharMapRec:
        FT_Face face
        FT_Encoding encoding
        FT_UShort platform_id
        FT_UShort encoding_id
    ctypedef struct FT_Face_InternalRec
    ctypedef FT_Face_InternalRec *FT_Face_Internal
    ctypedef struct FT_FaceRec:
        FT_Long num_faces
        FT_Long face_index
        FT_Long face_flags
        FT_Long style_flags
        FT_Long num_glyphs
        FT_String *family_name
        FT_String *style_name
        FT_Int num_fixed_sizes
        FT_Bitmap_Size *available_sizes
        FT_Int num_charmaps
        FT_CharMap *charmaps
        FT_Generic generic
        FT_BBox bbox
        FT_UShort units_per_EM
        FT_Short ascender
        FT_Short descender
        FT_Short height
        FT_Short max_advance_width
        FT_Short max_advance_height
        FT_Short underline_position
        FT_Short underline_thickness
        FT_GlyphSlot glyph
        FT_Size size
        FT_CharMap charmap
        FT_Driver driver
        FT_Memory memory
        FT_Stream stream
        FT_ListRec sizes_list
        FT_Generic autohint
        void *extensions
        FT_Face_Internal internal
    cdef enum:
        FT_FACE_FLAG_SCALABLE
        FT_FACE_FLAG_FIXED_SIZES
        FT_FACE_FLAG_FIXED_WIDTH
        FT_FACE_FLAG_SFNT
        FT_FACE_FLAG_HORIZONTAL
        FT_FACE_FLAG_VERTICAL
        FT_FACE_FLAG_KERNING
        FT_FACE_FLAG_FAST_GLYPHS
        FT_FACE_FLAG_MULTIPLE_MASTERS
        FT_FACE_FLAG_GLYPH_NAMES
        FT_FACE_FLAG_EXTERNAL_STREAM
        FT_FACE_FLAG_HINTER
        FT_FACE_FLAG_CID_KEYED
        FT_FACE_FLAG_TRICKY
        FT_FACE_FLAG_COLOR
        FT_FACE_FLAG_VARIATION
    FT_Bool FT_HAS_HORIZONTAL(FT_Face face)
    FT_Bool FT_HAS_VERTICAL(FT_Face face)
    FT_Bool FT_HAS_KERNING(FT_Face face)
    FT_Bool FT_IS_SCALABLE(FT_Face face)
    FT_Bool FT_IS_SFNT(FT_Face face)
    FT_Bool FT_IS_FIXED_WIDTH(FT_Face face)
    FT_Bool FT_HAS_FIXED_SIZES(FT_Face face)
    FT_Bool FT_HAS_FAST_GLYPHS(FT_Face face)
    FT_Bool FT_HAS_GLYPH_NAMES(FT_Face face)
    FT_Bool FT_HAS_MULTIPLE_MASTERS(FT_Face face)
    FT_Bool FT_IS_NAMED_INSTANCE(FT_Face face)
    FT_Bool FT_IS_VARIATION(FT_Face face)
    FT_Bool FT_IS_CID_KEYED(FT_Face face)
    FT_Bool FT_IS_TRICKY(FT_Face face)
    FT_Bool FT_HAS_COLOR(FT_Face face)
    cdef enum:
        FT_STYLE_FLAG_ITALIC
        FT_STYLE_FLAG_BOLD
    ctypedef struct FT_Size_InternalRec
    ctypedef FT_Size_InternalRec *FT_Size_Internal
    ctypedef struct FT_Size_Metrics:
        FT_UShort x_ppem
        FT_UShort y_ppem
        FT_Fixed x_scale
        FT_Fixed y_scale
        FT_Pos ascender
        FT_Pos descender
        FT_Pos height
        FT_Pos max_advance
    ctypedef struct FT_SizeRec:
        FT_Face face
        FT_Generic generic
        FT_Size_Metrics metrics
        FT_Size_Internal internal
    ctypedef struct FT_SubGlyphRec
    ctypedef FT_SubGlyphRec *FT_SubGlyph
    ctypedef struct FT_Slot_InternalRec
    ctypedef FT_Slot_InternalRec *FT_Slot_Internal
    ctypedef struct FT_GlyphSlotRec:
        FT_Library library
        FT_Face face
        FT_GlyphSlot next
        FT_UInt glyph_index
        FT_Generic generic
        FT_Glyph_Metrics metrics
        FT_Fixed linearHoriAdvance
        FT_Fixed linearVertAdvance
        FT_Vector advance
        FT_Glyph_Format format
        FT_Bitmap bitmap
        FT_Int bitmap_left
        FT_Int bitmap_top
        FT_Outline outline
        FT_UInt num_subglyphs
        FT_SubGlyph subglyphs
        void *control_data
        long control_len
        FT_Pos lsb_delta
        FT_Pos rsb_delta
        void *other
        FT_Slot_Internal internal
    FT_Error FT_Init_FreeType(FT_Library *alibrary)
    FT_Error FT_Done_FreeType(FT_Library library)
    cdef enum:
        FT_OPEN_MEMORY
        FT_OPEN_STREAM
        FT_OPEN_PATHNAME
        FT_OPEN_DRIVER
        FT_OPEN_PARAMS
    ctypedef struct FT_Parameter:
        FT_ULong tag
        FT_Pointer data
    ctypedef struct FT_Open_Args:
        FT_UInt flags
        const FT_Byte *memory_base
        FT_Long memory_size
        FT_String *pathname
        FT_Stream stream
        FT_Module driver
        FT_Int num_params
        FT_Parameter *params
    FT_Error FT_New_Face(FT_Library library, const char *filepathname, FT_Long face_index, FT_Face *aface)
    FT_Error FT_New_Memory_Face(FT_Library library, const FT_Byte *file_base, FT_Long file_size, FT_Long face_index, FT_Face *aface)
    FT_Error FT_Open_Face(FT_Library library, const FT_Open_Args *args, FT_Long face_index, FT_Face *aface)
    FT_Error FT_Attach_File(FT_Face face, const char *filepathname)
    FT_Error FT_Attach_Stream(FT_Face face, FT_Open_Args *parameters)
    FT_Error FT_Reference_Face(FT_Face face)
    FT_Error FT_Done_Face(FT_Face face)
    FT_Error FT_Select_Size(FT_Face face, FT_Int strike_index)
    ctypedef enum FT_Size_Request_Type:
        FT_SIZE_REQUEST_TYPE_NOMINAL
        FT_SIZE_REQUEST_TYPE_REAL_DIM
        FT_SIZE_REQUEST_TYPE_BBOX
        FT_SIZE_REQUEST_TYPE_CELL
        FT_SIZE_REQUEST_TYPE_SCALES
        FT_SIZE_REQUEST_TYPE_MAX
    ctypedef struct FT_Size_RequestRec:
        FT_Size_Request_Type type
        FT_Long width
        FT_Long height
        FT_UInt horiResolution
        FT_UInt vertResolution
    ctypedef FT_Size_RequestRec *FT_Size_Request
    FT_Error FT_Request_Size(FT_Face face, FT_Size_Request req)
    FT_Error FT_Set_Char_Size(FT_Face face, FT_F26Dot6 char_width, FT_F26Dot6 char_height, FT_UInt horz_resolution, FT_UInt vert_resolution)
    FT_Error FT_Set_Pixel_Sizes(FT_Face face, FT_UInt pixel_width, FT_UInt pixel_height)
    FT_Error FT_Load_Glyph(FT_Face face, FT_UInt glyph_index, FT_Int32 load_flags)
    FT_Error FT_Load_Char(FT_Face face, FT_ULong char_code, FT_Int32 load_flags)
    cdef enum:
        FT_LOAD_DEFAULT
        FT_LOAD_NO_SCALE
        FT_LOAD_NO_HINTING
        FT_LOAD_RENDER
        FT_LOAD_NO_BITMAP
        FT_LOAD_VERTICAL_LAYOUT
        FT_LOAD_FORCE_AUTOHINT
        FT_LOAD_CROP_BITMAP
        FT_LOAD_PEDANTIC
        FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH
        FT_LOAD_NO_RECURSE
        FT_LOAD_IGNORE_TRANSFORM
        FT_LOAD_MONOCHROME
        FT_LOAD_LINEAR_DESIGN
        FT_LOAD_NO_AUTOHINT
        FT_LOAD_COLOR
        FT_LOAD_COMPUTE_METRICS
        FT_LOAD_BITMAP_METRICS_ONLY
        FT_LOAD_ADVANCE_ONLY
        FT_LOAD_SBITS_ONLY
    FT_Int32 FT_LOAD_TARGET_(FT_Render_Mode x)
    cdef enum:
        FT_LOAD_TARGET_NORMAL
        FT_LOAD_TARGET_LIGHT
        FT_LOAD_TARGET_MONO
        FT_LOAD_TARGET_LCD
        FT_LOAD_TARGET_LCD_V
    FT_Render_Mode FT_LOAD_TARGET_MODE(FT_UInt x)
    void FT_Set_Transform(FT_Face face, FT_Matrix *matrix, FT_Vector *delta)
    ctypedef enum FT_Render_Mode:
        FT_RENDER_MODE_NORMAL
        FT_RENDER_MODE_LIGHT
        FT_RENDER_MODE_MONO
        FT_RENDER_MODE_LCD
        FT_RENDER_MODE_LCD_V
        FT_RENDER_MODE_MAX
    FT_Error FT_Render_Glyph(FT_GlyphSlot slot, FT_Render_Mode render_mode)
    ctypedef enum FT_Kerning_Mode:
        FT_KERNING_DEFAULT
        FT_KERNING_UNFITTED
        FT_KERNING_UNSCALED
    FT_Error FT_Get_Kerning(FT_Face face, FT_UInt left_glyph, FT_UInt right_glyph, FT_UInt kern_mode, FT_Vector *akerning)
    FT_Error FT_Get_Track_Kerning(FT_Face face, FT_Fixed point_size, FT_Int degree, FT_Fixed *akerning)
    FT_Error FT_Get_Glyph_Name(FT_Face face, FT_UInt glyph_index, FT_Pointer buffer, FT_UInt buffer_max)
    const char *FT_Get_Postscript_Name(FT_Face face)
    FT_Error FT_Select_Charmap(FT_Face face, FT_Encoding encoding)
    FT_Error FT_Set_Charmap(FT_Face face, FT_CharMap charmap)
    FT_Int FT_Get_Charmap_Index(FT_CharMap charmap)
    FT_UInt FT_Get_Char_Index(FT_Face face, FT_ULong charcode)
    FT_ULong FT_Get_First_Char(FT_Face face, FT_UInt *agindex)
    FT_ULong FT_Get_Next_Char(FT_Face face, FT_ULong char_code, FT_UInt *agindex)
    FT_Error FT_Face_Properties(FT_Face face, FT_UInt num_properties, FT_Parameter *properties)
    FT_UInt FT_Get_Name_Index(FT_Face face, const FT_String *glyph_name)
    cdef enum:
        FT_SUBGLYPH_FLAG_ARGS_ARE_WORDS
        FT_SUBGLYPH_FLAG_ARGS_ARE_XY_VALUES
        FT_SUBGLYPH_FLAG_ROUND_XY_TO_GRID
        FT_SUBGLYPH_FLAG_SCALE
        FT_SUBGLYPH_FLAG_XY_SCALE
        FT_SUBGLYPH_FLAG_2X2
        FT_SUBGLYPH_FLAG_USE_MY_METRICS
    FT_Error FT_Get_SubGlyph_Info(FT_GlyphSlot glyph, FT_UInt sub_index, FT_Int *p_index, FT_UInt *p_flags, FT_Int *p_arg1, FT_Int *p_arg2, FT_Matrix *p_transform)
    ctypedef struct FT_LayerIterator:
        FT_UInt num_layers
        FT_UInt layer
        FT_Byte *p
    FT_Bool FT_Get_Color_Glyph_Layer(FT_Face face, FT_UInt base_glyph, FT_UInt *aglyph_index, FT_UInt *acolor_index, FT_LayerIterator *iterator)
    cdef enum:
        FT_FSTYPE_INSTALLABLE_EMBEDDING
        FT_FSTYPE_RESTRICTED_LICENSE_EMBEDDING
        FT_FSTYPE_PREVIEW_AND_PRINT_EMBEDDING
        FT_FSTYPE_EDITABLE_EMBEDDING
        FT_FSTYPE_NO_SUBSETTING
        FT_FSTYPE_BITMAP_EMBEDDING_ONLY
    FT_UShort FT_Get_FSType_Flags(FT_Face face)
    FT_UInt FT_Face_GetCharVariantIndex(FT_Face face, FT_ULong charcode, FT_ULong variantSelector)
    FT_Int FT_Face_GetCharVariantIsDefault(FT_Face face, FT_ULong charcode, FT_ULong variantSelector)
    FT_UInt32 *FT_Face_GetVariantSelectors(FT_Face face)
    FT_UInt32 *FT_Face_GetVariantsOfChar(FT_Face face, FT_ULong charcode)
    FT_UInt32 *FT_Face_GetCharsOfVariant(FT_Face face, FT_ULong variantSelector)
    FT_Long FT_MulDiv(FT_Long a, FT_Long b, FT_Long c)
    FT_Long FT_MulFix(FT_Long a, FT_Long b)
    FT_Long FT_DivFix(FT_Long a, FT_Long b)
    FT_Fixed FT_RoundFix(FT_Fixed a)
    FT_Fixed FT_CeilFix(FT_Fixed a)
    FT_Fixed FT_FloorFix(FT_Fixed a)
    void FT_Vector_Transform(FT_Vector *vector, const FT_Matrix *matrix)
    cdef enum:
        FREETYPE_MAJOR
        FREETYPE_MINOR
        FREETYPE_PATCH
    void FT_Library_Version(FT_Library library, FT_Int *amajor, FT_Int *aminor, FT_Int *apatch)
    FT_Bool FT_Face_CheckTrueTypePatents(FT_Face face)
    FT_Bool FT_Face_SetUnpatentedHinting(FT_Face face, FT_Bool value)

cdef extern from "freetype/ftadvanc.h" nogil:
    cdef enum:
        FT_ADVANCE_FLAG_FAST_ONLY
    FT_Error FT_Get_Advance(FT_Face face, FT_UInt gindex, FT_Int32 load_flags, FT_Fixed  *padvance)
    FT_Error FT_Get_Advances(FT_Face face, FT_UInt start, FT_UInt count, FT_Int32 load_flags, FT_Fixed *padvances)

cdef extern from "freetype/ftbbox.h" nogil:
    FT_Error FT_Outline_Get_BBox(FT_Outline *outline, FT_BBox *abbox)

cdef extern from "freetype/ftbdf.h" nogil:
    ctypedef enum BDF_PropertyType:
        BDF_PROPERTY_TYPE_NONE
        BDF_PROPERTY_TYPE_ATOM
        BDF_PROPERTY_TYPE_INTEGER
        BDF_PROPERTY_TYPE_CARDINAL
    ctypedef BDF_PropertyRec *BDF_Property
    ctypedef union BDF_PropertyRec_u:
        const char *atom
        FT_Int32 integer
        FT_UInt32 cardinal
    ctypedef struct BDF_PropertyRec:
        BDF_PropertyType type
        BDF_PropertyRec_u u
    FT_Error FT_Get_BDF_Charset_ID(FT_Face face, const char **acharset_encoding, const char **acharset_registry)
    FT_Error FT_Get_BDF_Property(FT_Face face, const char *prop_name, BDF_PropertyRec *aproperty)

cdef extern from "freetype/ftcolor.h" nogil:
    ctypedef struct FT_Color:
        FT_Byte blue
        FT_Byte green
        FT_Byte red
        FT_Byte alpha
    cdef enum:
        FT_PALETTE_FOR_LIGHT_BACKGROUND
        FT_PALETTE_FOR_DARK_BACKGROUND
    ctypedef struct FT_Palette_Data:
        FT_UShort num_palettes;
        const FT_UShort *palette_name_ids
        const FT_UShort *palette_flags
        FT_UShort num_palette_entries
        const FT_UShort *palette_entry_name_ids
    FT_Error FT_Palette_Data_Get(FT_Face face, FT_Palette_Data *apalette)
    FT_Error FT_Palette_Select(FT_Face face, FT_UShort palette_index, FT_Color **apalette)
    FT_Error FT_Palette_Set_Foreground_Color(FT_Face face, FT_Color foreground_color)

cdef extern from "freetype/ftbitmap.h" nogil:
    void FT_Bitmap_Init(FT_Bitmap *abitmap)
    FT_Error FT_Bitmap_Copy(FT_Library library, const FT_Bitmap *source, FT_Bitmap *target)
    FT_Error FT_Bitmap_Embolden(FT_Library library, FT_Bitmap* bitmap, FT_Pos xStrength, FT_Pos yStrength)
    FT_Error FT_Bitmap_Convert(FT_Library library, const FT_Bitmap *source, FT_Bitmap *target, FT_Int alignment)
    FT_Error FT_Bitmap_Blend(FT_Library library, const FT_Bitmap* source, const FT_Vector source_offset, FT_Bitmap* target, FT_Vector *atarget_offset, FT_Color color)
    FT_Error FT_GlyphSlot_Own_Bitmap(FT_GlyphSlot slot)
    FT_Error FT_Bitmap_Done(FT_Library library, FT_Bitmap *bitmap)

cdef extern from "freetype/ftbzip2.h" nogil:
    FT_Error FT_Stream_OpenBzip2(FT_Stream stream, FT_Stream source)

cdef extern from "freetype/ftglyph.h" nogil:
    ctypedef struct FT_Glyph_Class_
    ctypedef FT_Glyph_Class_ FT_Glyph_Class
    ctypedef FT_GlyphRec *FT_Glyph
    ctypedef struct FT_GlyphRec:
        FT_Library library
        const FT_Glyph_Class* clazz
        FT_Glyph_Format format
        FT_Vector advance
    ctypedef FT_BitmapGlyphRec *FT_BitmapGlyph
    ctypedef struct FT_BitmapGlyphRec:
        FT_GlyphRec root
        FT_Int left
        FT_Int top
        FT_Bitmap bitmap
    ctypedef FT_OutlineGlyphRec *FT_OutlineGlyph
    ctypedef struct FT_OutlineGlyphRec:
        FT_GlyphRec root
        FT_Outline outline
    FT_Error FT_New_Glyph(FT_Library library, FT_Glyph_Format format, FT_Glyph *aglyph)
    FT_Error FT_Get_Glyph(FT_GlyphSlot slot, FT_Glyph *aglyph)
    FT_Error FT_Glyph_Copy(FT_Glyph source, FT_Glyph *target)
    FT_Error FT_Glyph_Transform(FT_Glyph glyph, FT_Matrix *matrix, FT_Vector *delta)
    ctypedef enum FT_Glyph_BBox_Mode:
        FT_GLYPH_BBOX_UNSCALED = 0
        FT_GLYPH_BBOX_SUBPIXELS = 0
        FT_GLYPH_BBOX_GRIDFIT = 1
        FT_GLYPH_BBOX_TRUNCATE = 2
        FT_GLYPH_BBOX_PIXELS = 3
    void FT_Glyph_Get_CBox(FT_Glyph glyph, FT_UInt bbox_mode, FT_BBox *acbox)
    FT_Error FT_Glyph_To_Bitmap(FT_Glyph *the_glyph, FT_Render_Mode render_mode, FT_Vector* origin, FT_Bool destroy)
    void FT_Done_Glyph(FT_Glyph glyph)
    void FT_Matrix_Multiply(const FT_Matrix *a,FT_Matrix *b)
    FT_Error FT_Matrix_Invert(FT_Matrix *matrix)

cdef extern from "freetype/ftcache.h" nogil:
    ctypedef FT_Pointer FTC_FaceID
    ctypedef FT_Error (*FTC_Face_Requester)(FTC_FaceID face_id, FT_Library library, FT_Pointer req_data, FT_Face* aface)
    ctypedef struct FTC_ManagerRec
    ctypedef FTC_ManagerRec *FTC_Manager
    ctypedef struct FTC_NodeRec
    ctypedef FTC_NodeRec *FTC_Node
    FT_Error FTC_Manager_New(FT_Library library, FT_UInt max_faces, FT_UInt max_sizes, FT_ULong max_bytes, FTC_Face_Requester requester, FT_Pointer req_data, FTC_Manager *amanager)
    void FTC_Manager_Reset(FTC_Manager manager)
    void FTC_Manager_Done(FTC_Manager manager)
    FT_Error FTC_Manager_LookupFace(FTC_Manager manager, FTC_FaceID face_id, FT_Face *aface)
    ctypedef struct FTC_ScalerRec:
        FTC_FaceID face_id
        FT_UInt width
        FT_UInt height
        FT_Int pixel
        FT_UInt x_res
        FT_UInt y_res
    ctypedef FTC_ScalerRec *FTC_Scaler
    FT_Error FTC_Manager_LookupSize(FTC_Manager manager, FTC_Scaler scaler, FT_Size *asize)
    void FTC_Node_Unref(FTC_Node node, FTC_Manager manager)
    void FTC_Manager_RemoveFaceID(FTC_Manager manager, FTC_FaceID face_id)
    ctypedef struct FTC_CMapCacheRec
    ctypedef FTC_CMapCacheRec *FTC_CMapCache
    FT_Error FTC_CMapCache_New(FTC_Manager manager, FTC_CMapCache *acache)
    FT_UInt FTC_CMapCache_Lookup(FTC_CMapCache cache, FTC_FaceID face_id, FT_Int cmap_index, FT_UInt32 char_code)
    ctypedef struct FTC_ImageTypeRec:
        FTC_FaceID face_id
        FT_UInt width
        FT_UInt height
        FT_Int32 flags
    ctypedef FTC_ImageTypeRec *FTC_ImageType
    FT_Bool FTC_IMAGE_TYPE_COMPARE(FTC_ImageType d1, FTC_ImageType d2)
    ctypedef struct FTC_ImageCacheRec
    ctypedef FTC_ImageCacheRec *FTC_ImageCache
    FT_Error FTC_ImageCache_New(FTC_Manager manager, FTC_ImageCache *acache)
    FT_Error FTC_ImageCache_Lookup(FTC_ImageCache cache, FTC_ImageType type, FT_UInt gindex, FT_Glyph *aglyph, FTC_Node *anode)
    FT_Error FTC_ImageCache_LookupScaler(FTC_ImageCache cache, FTC_Scaler scaler, FT_ULong load_flags, FT_UInt gindex, FT_Glyph *aglyph, FTC_Node *anode)
    ctypedef FTC_SBitRec *FTC_SBit
    ctypedef struct FTC_SBitRec:
        FT_Byte width
        FT_Byte height
        FT_Char left
        FT_Char top
        FT_Byte format
        FT_Byte max_grays
        FT_Short pitch
        FT_Char xadvance
        FT_Char yadvance
        FT_Byte* buffer
    ctypedef struct FTC_SBitCacheRec
    ctypedef FTC_SBitCacheRec *FTC_SBitCache
    FT_Error FTC_SBitCache_New(FTC_Manager manager, FTC_SBitCache *acache)
    FT_Error FTC_SBitCache_Lookup(FTC_SBitCache cache, FTC_ImageType type, FT_UInt gindex, FTC_SBit *sbit, FTC_Node *anode)
    FT_Error FTC_SBitCache_LookupScaler(FTC_SBitCache cache, FTC_Scaler scaler, FT_ULong load_flags, FT_UInt gindex, FTC_SBit *sbit, FTC_Node *anode)

cdef extern from "freetype/ftcid.h" nogil:
    FT_Error FT_Get_CID_Registry_Ordering_Supplement(FT_Face face, const char **registry, const char **ordering, FT_Int *supplement) 
    FT_Error FT_Get_CID_Is_Internally_CID_Keyed(FT_Face face, FT_Bool *is_cid) 
    FT_Error FT_Get_CID_From_Glyph_Index(FT_Face face, FT_UInt glyph_index, FT_UInt *cid)

cdef extern from "freetype/ftdriver.h" nogil:
    cdef enum:
        FT_HINTING_FREETYPE
        FT_HINTING_ADOBE
    cdef enum:
        TT_INTERPRETER_VERSION_35
        TT_INTERPRETER_VERSION_38
        TT_INTERPRETER_VERSION_40
    cdef enum:
        FT_AUTOHINTER_SCRIPT_NONE
        FT_AUTOHINTER_SCRIPT_LATIN
        FT_AUTOHINTER_SCRIPT_CJK
        FT_AUTOHINTER_SCRIPT_INDIC
    ctypedef struct  FT_Prop_GlyphToScriptMap:
        FT_Face face
        FT_UShort *map
    ctypedef struct  FT_Prop_IncreaseXHeight:
        FT_Face face
        FT_UInt limit

cdef extern from "freetype/ftfntfmt.h" nogil:
    const char *FT_Get_Font_Format(FT_Face face)

cdef extern from "freetype/ftgasp.h" nogil:
    cdef enum:
        FT_GASP_NO_TABLE
        FT_GASP_DO_GRIDFIT
        FT_GASP_DO_GRAY
        FT_GASP_SYMMETRIC_GRIDFIT
        FT_GASP_SYMMETRIC_SMOOTHING
    FT_Int FT_Get_Gasp(FT_Face face, FT_UInt ppem)

cdef extern from "freetype/ftgxval.h" nogil:
    cdef enum:
        FT_VALIDATE_feat_INDEX
        FT_VALIDATE_mort_INDEX
        FT_VALIDATE_morx_INDEX
        FT_VALIDATE_bsln_INDEX
        FT_VALIDATE_just_INDEX
        FT_VALIDATE_kern_INDEX
        FT_VALIDATE_opbd_INDEX
        FT_VALIDATE_trak_INDEX
        FT_VALIDATE_prop_INDEX
        FT_VALIDATE_lcar_INDEX
        FT_VALIDATE_GX_LAST_INDEX
        FT_VALIDATE_GX_LENGTH
        FT_VALIDATE_GX_START
    cdef enum:
        FT_VALIDATE_feat
        FT_VALIDATE_mort
        FT_VALIDATE_morx
        FT_VALIDATE_bsln
        FT_VALIDATE_just
        FT_VALIDATE_kern
        FT_VALIDATE_opbd
        FT_VALIDATE_trak
        FT_VALIDATE_prop
        FT_VALIDATE_lcar
        FT_VALIDATE_GX
    FT_Error FT_TrueTypeGX_Validate(FT_Face face, FT_UInt validation_flags, FT_Bytes tables[FT_VALIDATE_GX_LENGTH], FT_UInt table_length)
    void FT_TrueTypeGX_Free(FT_Face face, FT_Bytes table)
    cdef enum:
        FT_VALIDATE_MS
        FT_VALIDATE_APPLE
        FT_VALIDATE_CKERN
    FT_Error FT_ClassicKern_Validate(FT_Face face, FT_UInt validation_flags, FT_Bytes *ckern_table )
    void FT_ClassicKern_Free(FT_Face face, FT_Bytes table)

cdef extern from "freetype/ftgzip.h" nogil:
    FT_Error FT_Stream_OpenGzip(FT_Stream stream, FT_Stream source)
    FT_Error FT_Gzip_Uncompress(FT_Memory memory, FT_Byte *output, FT_ULong *output_len, const FT_Byte *input, FT_ULong input_len)

cdef extern from "freetype/ftincrem.h" nogil:
    ctypedef struct FT_IncrementalRec
    ctypedef FT_IncrementalRec *FT_Incremental
    ctypedef struct FT_Incremental_MetricsRec:
        FT_Long bearing_x
        FT_Long bearing_y
        FT_Long advance
        FT_Long advance_v
    ctypedef FT_Incremental_MetricsRec *FT_Incremental_Metrics
    ctypedef FT_Error (*FT_Incremental_GetGlyphDataFunc)(FT_Incremental incremental, FT_UInt glyph_index, FT_Data *adata)
    ctypedef void (*FT_Incremental_FreeGlyphDataFunc)( FT_Incremental incremental, FT_Data *data)
    ctypedef FT_Error (*FT_Incremental_GetGlyphMetricsFunc)(FT_Incremental incremental, FT_UInt glyph_index, FT_Bool vertical, FT_Incremental_MetricsRec *ametrics)
    ctypedef struct FT_Incremental_FuncsRec:
        FT_Incremental_GetGlyphDataFunc get_glyph_data
        FT_Incremental_FreeGlyphDataFunc free_glyph_data
        FT_Incremental_GetGlyphMetricsFunc get_glyph_metrics
    ctypedef struct FT_Incremental_InterfaceRec:
        const FT_Incremental_FuncsRec *funcs
        FT_Incremental object
    ctypedef FT_Incremental_InterfaceRec *FT_Incremental_Interface

cdef extern from "freetype/ftlcdfil.h" nogil:
    ctypedef enum FT_LcdFilter:
        FT_LCD_FILTER_NONE
        FT_LCD_FILTER_DEFAULT
        FT_LCD_FILTER_LIGHT
        FT_LCD_FILTER_LEGACY1
        FT_LCD_FILTER_LEGACY
        FT_LCD_FILTER_MAX
    FT_Error FT_Library_SetLcdFilter(FT_Library library, FT_LcdFilter filter)
    FT_Error FT_Library_SetLcdFilterWeights(FT_Library library, unsigned char *weights)
    cdef enum:
        FT_LCD_FILTER_FIVE_TAPS
    ctypedef FT_Byte FT_LcdFiveTapFilter[FT_LCD_FILTER_FIVE_TAPS]
    FT_Error FT_Library_SetLcdGeometry(FT_Library library, FT_Vector sub[3])

cdef extern from "freetype/ftlist.h" nogil:
    FT_ListNode FT_List_Find(FT_List list, void *data)
    void FT_List_Add(FT_List list, FT_ListNode node)
    void FT_List_Insert(FT_List list, FT_ListNode node)
    void FT_List_Remove(FT_List list, FT_ListNode node)
    void FT_List_Up(FT_List list, FT_ListNode node)
    ctypedef FT_Error (*FT_List_Iterator)(FT_ListNode node, void *user)
    FT_Error FT_List_Iterate(FT_List list, FT_List_Iterator iterator, void *user)
    ctypedef void (*FT_List_Destructor)(FT_Memory memory, void *data, void *user)
    void FT_List_Finalize(FT_List list, FT_List_Destructor destroy, FT_Memory memory, void *user)

cdef extern from "freetype/ftlzw.h" nogil:
    FT_Error FT_Stream_OpenLZW(FT_Stream stream, FT_Stream source)

cdef extern from "freetype/ftmm.h" nogil:
    ctypedef struct FT_MM_Axis:
        FT_String *name 
        FT_Long minimum 
        FT_Long maximum
    cdef enum:
        T1_MAX_MM_AXIS
    ctypedef struct FT_Multi_Master:
        FT_UInt num_axis 
        FT_UInt num_designs 
        FT_MM_Axis axis[T1_MAX_MM_AXIS] 
    ctypedef struct FT_Var_Axis:
        FT_String *name 
        FT_Fixed minimum 
        FT_Fixed def_ "def" 
        FT_Fixed maximum
        FT_ULong tag 
        FT_UInt strid 
    ctypedef struct FT_Var_Named_Style:
        FT_Fixed *coords 
        FT_UInt strid 
        FT_UInt psid
    ctypedef struct FT_MM_Var:
        FT_UInt num_axis 
        FT_UInt num_designs 
        FT_UInt num_namedstyles 
        FT_Var_Axis *axis 
        FT_Var_Named_Style *namedstyle
    FT_Error FT_Get_Multi_Master(FT_Face face, FT_Multi_Master *amaster) 
    FT_Error FT_Get_MM_Var(FT_Face face, FT_MM_Var **amaster) 
    FT_Error FT_Done_MM_Var(FT_Library library, FT_MM_Var *amaster) 
    FT_Error FT_Set_MM_Design_Coordinates(FT_Face face, FT_UInt num_coords, FT_Long *coords) 
    FT_Error FT_Set_Var_Design_Coordinates(FT_Face face, FT_UInt num_coords, FT_Fixed *coords) 
    FT_Error FT_Get_Var_Design_Coordinates(FT_Face face, FT_UInt num_coords, FT_Fixed *coords) 
    FT_Error FT_Set_MM_Blend_Coordinates(FT_Face face, FT_UInt num_coords, FT_Fixed *coords) 
    FT_Error FT_Get_MM_Blend_Coordinates(FT_Face face, FT_UInt num_coords, FT_Fixed *coords) 
    FT_Error FT_Set_Var_Blend_Coordinates(FT_Face face, FT_UInt num_coords, FT_Fixed *coords) 
    FT_Error FT_Get_Var_Blend_Coordinates(FT_Face face, FT_UInt num_coords, FT_Fixed *coords) 
    FT_Error FT_Set_MM_WeightVector(FT_Face face, FT_UInt len, FT_Fixed *weightvector) 
    FT_Error FT_Get_MM_WeightVector(FT_Face face, FT_UInt *len, FT_Fixed *weightvector) 
    cdef enum:
        FT_VAR_AXIS_FLAG_HIDDEN
    FT_Error FT_Get_Var_Axis_Flags(FT_MM_Var *master, FT_UInt axis_index, FT_UInt *flags) 
    FT_Error FT_Set_Named_Instance(FT_Face face, FT_UInt instance_index) 

cdef extern from "freetype/ftmodapi.h" nogil:
    cdef enum:
        FT_MODULE_FONT_DRIVER 
        FT_MODULE_RENDERER
        FT_MODULE_HINTER
        FT_MODULE_STYLER
    cdef enum:
        FT_MODULE_DRIVER_SCALABLE
        FT_MODULE_DRIVER_NO_OUTLINES
        FT_MODULE_DRIVER_HAS_HINTER
        FT_MODULE_DRIVER_HINTS_LIGHTLY
    ctypedef FT_Pointer FT_Module_Interface
    ctypedef FT_Error (*FT_Module_Constructor)(FT_Module module)
    ctypedef void (*FT_Module_Destructor)(FT_Module module)
    ctypedef FT_Module_Interface (*FT_Module_Requester)(FT_Module module, const char *name)
    ctypedef struct FT_Module_Class:
        FT_ULong module_flags
        FT_Long module_size
        const FT_String *module_name
        FT_Fixed module_version
        FT_Fixed module_requires
        const void *module_interface
        FT_Module_Constructor module_init
        FT_Module_Destructor module_done
        FT_Module_Requester get_interface
    FT_Error FT_Add_Module(FT_Library library, const FT_Module_Class *clazz)
    FT_Module FT_Get_Module(FT_Library library, const char *module_name)
    FT_Error FT_Remove_Module(FT_Library library, FT_Module module)
    FT_Error FT_Property_Set(FT_Library library, const FT_String *module_name, const FT_String *property_name, const void *value)
    FT_Error FT_Property_Get(FT_Library library, const FT_String *module_name, const FT_String *property_name, void *value)
    void FT_Set_Default_Properties(FT_Library library)
    FT_Error FT_Reference_Library(FT_Library library)
    FT_Error FT_New_Library(FT_Memory memory, FT_Library *alibrary)
    FT_Error FT_Done_Library(FT_Library library)
    ctypedef FT_Error (*FT_DebugHook_Func)(void *arg)
    cdef enum:
        FT_DEBUG_HOOK_TRUETYPE
    void FT_Set_Debug_Hook(FT_Library library, FT_UInt hook_index, FT_DebugHook_Func debug_hook)
    void FT_Add_Default_Modules(FT_Library library)
    ctypedef enum FT_TrueTypeEngineType:
        FT_TRUETYPE_ENGINE_TYPE_NONE
        FT_TRUETYPE_ENGINE_TYPE_UNPATENTED
        FT_TRUETYPE_ENGINE_TYPE_PATENTED
    FT_TrueTypeEngineType FT_Get_TrueType_Engine_Type(FT_Library library)

cdef extern from "freetype/ftotval.h" nogil:
    cdef enum:
        FT_VALIDATE_BASE
        FT_VALIDATE_GDEF
        FT_VALIDATE_GPOS
        FT_VALIDATE_GSUB
        FT_VALIDATE_JSTF
        FT_VALIDATE_MATH
        FT_VALIDATE_OT
    FT_Error FT_OpenType_Validate(FT_Face face, FT_UInt validation_flags, FT_Bytes *BASE_table, FT_Bytes *GDEF_table, FT_Bytes *GPOS_table, FT_Bytes *GSUB_table, FT_Bytes *JSTF_table)
    void FT_OpenType_Free(FT_Face face, FT_Bytes table)

cdef extern from "freetype/ftoutln.h" nogil:
    FT_Error FT_Outline_Decompose(FT_Outline *outline, const FT_Outline_Funcs *func_interface, void *user)
    FT_Error FT_Outline_New(FT_Library library, FT_UInt numPoints, FT_Int numContours, FT_Outline *anoutline)
    FT_Error FT_Outline_Done(FT_Library library, FT_Outline *outline)
    FT_Error FT_Outline_Check(FT_Outline *outline)
    void FT_Outline_Get_CBox(const FT_Outline *outline,FT_BBox *acbox)
    void FT_Outline_Translate(const FT_Outline *outline, FT_Pos xOffset, FT_Pos yOffset)
    FT_Error FT_Outline_Copy(const FT_Outline *source, FT_Outline *target)
    void FT_Outline_Transform(const FT_Outline *outline, const FT_Matrix *matrix)
    FT_Error FT_Outline_Embolden(FT_Outline *outline, FT_Pos strength)
    FT_Error FT_Outline_EmboldenXY(FT_Outline *outline, FT_Pos xstrength, FT_Pos ystrength)
    void FT_Outline_Reverse(FT_Outline *outline)
    FT_Error FT_Outline_Get_Bitmap(FT_Library library, FT_Outline *outline, const FT_Bitmap *abitmap)
    FT_Error FT_Outline_Render(FT_Library library, FT_Outline *outline, FT_Raster_Params *params)
    ctypedef enum FT_Orientation:
        FT_ORIENTATION_TRUETYPE
        FT_ORIENTATION_POSTSCRIPT
        FT_ORIENTATION_FILL_RIGHT
        FT_ORIENTATION_FILL_LEFT
        FT_ORIENTATION_NONE
    FT_Orientation FT_Outline_Get_Orientation(FT_Outline *outline)

cdef extern from "freetype/ftparams.h" nogil:
    cdef enum:
        FT_PARAM_TAG_IGNORE_TYPOGRAPHIC_FAMILY
        FT_PARAM_TAG_IGNORE_TYPOGRAPHIC_SUBFAMILY
        FT_PARAM_TAG_INCREMENTAL
        FT_PARAM_TAG_LCD_FILTER_WEIGHTS
        FT_PARAM_TAG_RANDOM_SEED
        FT_PARAM_TAG_STEM_DARKENING
        FT_PARAM_TAG_UNPATENTED_HINTING

cdef extern from "freetype/ftpfr.h" nogil:
    FT_Error FT_Get_PFR_Metrics(FT_Face face, FT_UInt *aoutline_resolution, FT_UInt *ametrics_resolution, FT_Fixed *ametrics_x_scale, FT_Fixed *ametrics_y_scale)
    FT_Error FT_Get_PFR_Kerning(FT_Face face, FT_UInt left, FT_UInt right, FT_Vector *avector)
    FT_Error FT_Get_PFR_Advance(FT_Face face, FT_UInt gindex, FT_Pos *aadvance)

cdef extern from "freetype/ftrender.h" nogil:
    ctypedef FT_Error (*FT_Glyph_InitFunc)(FT_Glyph glyph, FT_GlyphSlot slot)
    ctypedef void (*FT_Glyph_DoneFunc)(FT_Glyph glyph)
    ctypedef void (*FT_Glyph_TransformFunc)(FT_Glyph glyph, const FT_Matrix *matrix, const FT_Vector *delta)
    ctypedef void (*FT_Glyph_GetBBoxFunc)(FT_Glyph glyph, FT_BBox *abbox)
    ctypedef FT_Error (*FT_Glyph_CopyFunc)(FT_Glyph source, FT_Glyph target)
    ctypedef FT_Error (*FT_Glyph_PrepareFunc)(FT_Glyph glyph, FT_GlyphSlot slot)
    ctypedef struct FT_Glyph_Class_:
        FT_Long glyph_size
        FT_Glyph_Format glyph_format
        FT_Glyph_InitFunc glyph_init
        FT_Glyph_DoneFunc glyph_done
        FT_Glyph_CopyFunc glyph_copy
        FT_Glyph_TransformFunc glyph_transform
        FT_Glyph_GetBBoxFunc glyph_bbox
        FT_Glyph_PrepareFunc glyph_prepare
    ctypedef FT_Error (*FT_Renderer_RenderFunc)(FT_Renderer renderer, FT_GlyphSlot slot, FT_Render_Mode mode, const FT_Vector *origin)
    ctypedef FT_Error (*FT_Renderer_TransformFunc)(FT_Renderer renderer, FT_GlyphSlot slot, const FT_Matrix *matrix, const FT_Vector *delta)
    ctypedef void (*FT_Renderer_GetCBoxFunc)(FT_Renderer renderer, FT_GlyphSlot slot, FT_BBox *cbox)
    ctypedef FT_Error (*FT_Renderer_SetModeFunc)(FT_Renderer renderer, FT_ULong mode_tag, FT_Pointer mode_ptr)
    ctypedef struct FT_Renderer_Class:
        FT_Module_Class root
        FT_Glyph_Format glyph_format
        FT_Renderer_RenderFunc render_glyph
        FT_Renderer_TransformFunc transform_glyph
        FT_Renderer_GetCBoxFunc get_glyph_cbox
        FT_Renderer_SetModeFunc set_mode
        FT_Raster_Funcs *raster_class
    FT_Renderer FT_Get_Renderer(FT_Library library, FT_Glyph_Format format)
    FT_Error FT_Set_Renderer(FT_Library library, FT_Renderer renderer, FT_UInt num_params, FT_Parameter *parameters)

cdef extern from "freetype/ftsizes.h" nogil:
    FT_Error FT_New_Size(FT_Face face, FT_Size *size)
    FT_Error FT_Done_Size(FT_Size size)
    FT_Error FT_Activate_Size(FT_Size size)

cdef extern from "freetype/ftsnames.h" nogil:
    ctypedef struct FT_SfntName:
        FT_UShort platform_id
        FT_UShort encoding_id
        FT_UShort language_id
        FT_UShort name_id
        FT_Byte *string
        FT_UInt string_len
    FT_UInt FT_Get_Sfnt_Name_Count(FT_Face face)
    FT_Error FT_Get_Sfnt_Name(FT_Face face, FT_UInt idx, FT_SfntName *aname)
    ctypedef struct FT_SfntLangTag:
        FT_Byte *string
        FT_UInt string_len
    FT_Error FT_Get_Sfnt_LangTag(FT_Face face, FT_UInt langID, FT_SfntLangTag *alangTag)

cdef extern from "freetype/ftstroke.h" nogil:
    ctypedef struct FT_StrokerRec
    ctypedef FT_StrokerRec *FT_Stroker
    ctypedef enum FT_Stroker_LineJoin:
        FT_STROKER_LINEJOIN_ROUND
        FT_STROKER_LINEJOIN_BEVEL
        FT_STROKER_LINEJOIN_MITER_VARIABLE
        FT_STROKER_LINEJOIN_MITER
        FT_STROKER_LINEJOIN_MITER_FIXED
    ctypedef enum FT_Stroker_LineCap:
        FT_STROKER_LINECAP_BUTT
        FT_STROKER_LINECAP_ROUND
        FT_STROKER_LINECAP_SQUARE
    ctypedef enum FT_StrokerBorder:
        FT_STROKER_BORDER_LEFT
        FT_STROKER_BORDER_RIGHT
    FT_StrokerBorder FT_Outline_GetInsideBorder(FT_Outline *outline)
    FT_StrokerBorder FT_Outline_GetOutsideBorder(FT_Outline *outline)
    FT_Error FT_Stroker_New(FT_Library library, FT_Stroker *astroker)
    void FT_Stroker_Set(FT_Stroker stroker, FT_Fixed radius, FT_Stroker_LineCap line_cap, FT_Stroker_LineJoin line_join, FT_Fixed miter_limit)
    void FT_Stroker_Rewind(FT_Stroker stroker)
    FT_Error FT_Stroker_ParseOutline(FT_Stroker stroker, FT_Outline *outline, FT_Bool opened)
    FT_Error FT_Stroker_BeginSubPath(FT_Stroker stroker, FT_Vector *to, FT_Bool open)
    FT_Error FT_Stroker_EndSubPath(FT_Stroker stroker)
    FT_Error FT_Stroker_LineTo(FT_Stroker stroker, FT_Vector *to)
    FT_Error FT_Stroker_ConicTo(FT_Stroker stroker, FT_Vector *control, FT_Vector *to)
    FT_Error FT_Stroker_CubicTo(FT_Stroker stroker, FT_Vector *control1, FT_Vector *control2, FT_Vector *to)
    FT_Error FT_Stroker_GetBorderCounts(FT_Stroker stroker, FT_StrokerBorder border, FT_UInt *anum_points, FT_UInt *anum_contours)
    void FT_Stroker_ExportBorder(FT_Stroker stroker, FT_StrokerBorder border, FT_Outline *outline)
    FT_Error FT_Stroker_GetCounts(FT_Stroker stroker, FT_UInt *anum_points, FT_UInt *anum_contours)
    void FT_Stroker_Export(FT_Stroker stroker, FT_Outline *outline)
    void FT_Stroker_Done(FT_Stroker stroker)
    FT_Error FT_Glyph_Stroke(FT_Glyph *pglyph, FT_Stroker stroker, FT_Bool destroy)
    FT_Error FT_Glyph_StrokeBorder(FT_Glyph *pglyph, FT_Stroker stroker, FT_Bool inside, FT_Bool destroy)

cdef extern from "freetype/ftsynth.h" nogil:
    void FT_GlyphSlot_Embolden(FT_GlyphSlot slot)
    void FT_GlyphSlot_Oblique(FT_GlyphSlot slot)

cdef extern from "freetype/fttrigon.h" nogil:
    ctypedef FT_Fixed FT_Angle
    cdef enum:
        FT_ANGLE_PI
        FT_ANGLE_2PI
        FT_ANGLE_PI2
        FT_ANGLE_PI4
    FT_Fixed FT_Sin(FT_Angle angle)
    FT_Fixed FT_Cos(FT_Angle angle)
    FT_Fixed FT_Tan(FT_Angle angle)
    FT_Angle FT_Atan2(FT_Fixed x, FT_Fixed y)
    FT_Angle FT_Angle_Diff(FT_Angle angle1, FT_Angle angle2)
    void FT_Vector_Unit(FT_Vector *vec, FT_Angle angle)
    void FT_Vector_Rotate(FT_Vector *vec, FT_Angle angle)
    FT_Fixed FT_Vector_Length(FT_Vector *vec)
    void FT_Vector_Polarize(FT_Vector *vec, FT_Fixed *length, FT_Angle *angle)
    void FT_Vector_From_Polar(FT_Vector *vec, FT_Fixed length, FT_Angle angle)

cdef extern from "freetype/tttags.h" nogil:
    cdef enum:
        TTAG_avar
        TTAG_BASE
        TTAG_bdat
        TTAG_BDF
        TTAG_bhed
        TTAG_bloc
        TTAG_bsln
        TTAG_CBDT
        TTAG_CBLC
        TTAG_CFF
        TTAG_CFF2
        TTAG_CID
        TTAG_cmap
        TTAG_COLR
        TTAG_CPAL
        TTAG_cvar
        TTAG_cvt
        TTAG_DSIG
        TTAG_EBDT
        TTAG_EBLC
        TTAG_EBSC
        TTAG_feat
        TTAG_FOND
        TTAG_fpgm
        TTAG_fvar
        TTAG_gasp
        TTAG_GDEF
        TTAG_glyf
        TTAG_GPOS
        TTAG_GSUB
        TTAG_gvar
        TTAG_HVAR
        TTAG_hdmx
        TTAG_head
        TTAG_hhea
        TTAG_hmtx
        TTAG_JSTF
        TTAG_just
        TTAG_kern
        TTAG_lcar
        TTAG_loca
        TTAG_LTSH
        TTAG_LWFN
        TTAG_MATH
        TTAG_maxp
        TTAG_META
        TTAG_MMFX
        TTAG_MMSD
        TTAG_mort
        TTAG_morx
        TTAG_MVAR
        TTAG_name
        TTAG_opbd
        TTAG_OS2
        TTAG_OTTO
        TTAG_PCLT
        TTAG_POST
        TTAG_post
        TTAG_prep
        TTAG_prop
        TTAG_sbix
        TTAG_sfnt
        TTAG_SING
        TTAG_trak
        TTAG_true
        TTAG_ttc
        TTAG_ttcf
        TTAG_TYP1
        TTAG_typ1
        TTAG_VDMX
        TTAG_vhea
        TTAG_vmtx
        TTAG_VVAR
        TTAG_wOFF
        TTAG_wOF2
        TTAG_0xA5kbd
        TTAG_0xA5lst

cdef extern from "freetype/ttnameid.h" nogil:
    cdef enum:
        TT_PLATFORM_APPLE_UNICODE
        TT_PLATFORM_MACINTOSH
        TT_PLATFORM_ISO
        TT_PLATFORM_MICROSOFT
        TT_PLATFORM_CUSTOM
        TT_PLATFORM_ADOBE
    cdef enum:
        TT_APPLE_ID_DEFAULT
        TT_APPLE_ID_UNICODE_1_1
        TT_APPLE_ID_ISO_10646
        TT_APPLE_ID_UNICODE_2_0
        TT_APPLE_ID_UNICODE_32
        TT_APPLE_ID_VARIANT_SELECTOR
        TT_APPLE_ID_FULL_UNICODE
    cdef enum:
        TT_MAC_ID_ROMAN
        TT_MAC_ID_JAPANESE
        TT_MAC_ID_TRADITIONAL_CHINESE
        TT_MAC_ID_KOREAN
        TT_MAC_ID_ARABIC
        TT_MAC_ID_HEBREW
        TT_MAC_ID_GREEK
        TT_MAC_ID_RUSSIAN
        TT_MAC_ID_RSYMBOL
        TT_MAC_ID_DEVANAGARI
        TT_MAC_ID_GURMUKHI
        TT_MAC_ID_GUJARATI
        TT_MAC_ID_ORIYA
        TT_MAC_ID_BENGALI
        TT_MAC_ID_TAMIL
        TT_MAC_ID_TELUGU
        TT_MAC_ID_KANNADA
        TT_MAC_ID_MALAYALAM
        TT_MAC_ID_SINHALESE
        TT_MAC_ID_BURMESE
        TT_MAC_ID_KHMER
        TT_MAC_ID_THAI
        TT_MAC_ID_LAOTIAN
        TT_MAC_ID_GEORGIAN
        TT_MAC_ID_ARMENIAN
        TT_MAC_ID_MALDIVIAN
        TT_MAC_ID_SIMPLIFIED_CHINESE
        TT_MAC_ID_TIBETAN
        TT_MAC_ID_MONGOLIAN
        TT_MAC_ID_GEEZ
        TT_MAC_ID_SLAVIC
        TT_MAC_ID_VIETNAMESE
        TT_MAC_ID_SINDHI
        TT_MAC_ID_UNINTERP
    cdef enum:
        TT_ISO_ID_7BIT_ASCII
        TT_ISO_ID_10646
        TT_ISO_ID_8859_1
    cdef enum:
        TT_MS_ID_SYMBOL_CS
        TT_MS_ID_UNICODE_CS
        TT_MS_ID_SJIS
        TT_MS_ID_PRC
        TT_MS_ID_BIG_5
        TT_MS_ID_WANSUNG
        TT_MS_ID_JOHAB
        TT_MS_ID_UCS_4
        TT_MS_ID_GB2312
    cdef enum:
        TT_ADOBE_ID_STANDARD
        TT_ADOBE_ID_EXPERT
        TT_ADOBE_ID_CUSTOM
        TT_ADOBE_ID_LATIN_1
    cdef enum:
        TT_MAC_LANGID_ENGLISH
        TT_MAC_LANGID_FRENCH
        TT_MAC_LANGID_GERMAN
        TT_MAC_LANGID_ITALIAN
        TT_MAC_LANGID_DUTCH
        TT_MAC_LANGID_SWEDISH
        TT_MAC_LANGID_SPANISH
        TT_MAC_LANGID_DANISH
        TT_MAC_LANGID_PORTUGUESE
        TT_MAC_LANGID_NORWEGIAN
        TT_MAC_LANGID_HEBREW
        TT_MAC_LANGID_JAPANESE
        TT_MAC_LANGID_ARABIC
        TT_MAC_LANGID_FINNISH
        TT_MAC_LANGID_GREEK
        TT_MAC_LANGID_ICELANDIC
        TT_MAC_LANGID_MALTESE
        TT_MAC_LANGID_TURKISH
        TT_MAC_LANGID_CROATIAN
        TT_MAC_LANGID_CHINESE_TRADITIONAL
        TT_MAC_LANGID_URDU
        TT_MAC_LANGID_HINDI
        TT_MAC_LANGID_THAI
        TT_MAC_LANGID_KOREAN
        TT_MAC_LANGID_LITHUANIAN
        TT_MAC_LANGID_POLISH
        TT_MAC_LANGID_HUNGARIAN
        TT_MAC_LANGID_ESTONIAN
        TT_MAC_LANGID_LETTISH
        TT_MAC_LANGID_SAAMISK
        TT_MAC_LANGID_FAEROESE
        TT_MAC_LANGID_FARSI
        TT_MAC_LANGID_RUSSIAN
        TT_MAC_LANGID_CHINESE_SIMPLIFIED
        TT_MAC_LANGID_FLEMISH
        TT_MAC_LANGID_IRISH
        TT_MAC_LANGID_ALBANIAN
        TT_MAC_LANGID_ROMANIAN
        TT_MAC_LANGID_CZECH
        TT_MAC_LANGID_SLOVAK
        TT_MAC_LANGID_SLOVENIAN
        TT_MAC_LANGID_YIDDISH
        TT_MAC_LANGID_SERBIAN
        TT_MAC_LANGID_MACEDONIAN
        TT_MAC_LANGID_BULGARIAN
        TT_MAC_LANGID_UKRAINIAN
        TT_MAC_LANGID_BYELORUSSIAN
        TT_MAC_LANGID_UZBEK
        TT_MAC_LANGID_KAZAKH
        TT_MAC_LANGID_AZERBAIJANI
        TT_MAC_LANGID_AZERBAIJANI_CYRILLIC_SCRIPT
        TT_MAC_LANGID_AZERBAIJANI_ARABIC_SCRIPT
        TT_MAC_LANGID_ARMENIAN
        TT_MAC_LANGID_GEORGIAN
        TT_MAC_LANGID_MOLDAVIAN
        TT_MAC_LANGID_KIRGHIZ
        TT_MAC_LANGID_TAJIKI
        TT_MAC_LANGID_TURKMEN
        TT_MAC_LANGID_MONGOLIAN
        TT_MAC_LANGID_MONGOLIAN_MONGOLIAN_SCRIPT
        TT_MAC_LANGID_MONGOLIAN_CYRILLIC_SCRIPT
        TT_MAC_LANGID_PASHTO
        TT_MAC_LANGID_KURDISH
        TT_MAC_LANGID_KASHMIRI
        TT_MAC_LANGID_SINDHI
        TT_MAC_LANGID_TIBETAN
        TT_MAC_LANGID_NEPALI
        TT_MAC_LANGID_SANSKRIT
        TT_MAC_LANGID_MARATHI
        TT_MAC_LANGID_BENGALI
        TT_MAC_LANGID_ASSAMESE
        TT_MAC_LANGID_GUJARATI
        TT_MAC_LANGID_PUNJABI
        TT_MAC_LANGID_ORIYA
        TT_MAC_LANGID_MALAYALAM
        TT_MAC_LANGID_KANNADA
        TT_MAC_LANGID_TAMIL
        TT_MAC_LANGID_TELUGU
        TT_MAC_LANGID_SINHALESE
        TT_MAC_LANGID_BURMESE
        TT_MAC_LANGID_KHMER
        TT_MAC_LANGID_LAO
        TT_MAC_LANGID_VIETNAMESE
        TT_MAC_LANGID_INDONESIAN
        TT_MAC_LANGID_TAGALOG
        TT_MAC_LANGID_MALAY_ROMAN_SCRIPT
        TT_MAC_LANGID_MALAY_ARABIC_SCRIPT
        TT_MAC_LANGID_AMHARIC
        TT_MAC_LANGID_TIGRINYA
        TT_MAC_LANGID_GALLA
        TT_MAC_LANGID_SOMALI
        TT_MAC_LANGID_SWAHILI
        TT_MAC_LANGID_RUANDA
        TT_MAC_LANGID_RUNDI
        TT_MAC_LANGID_CHEWA
        TT_MAC_LANGID_MALAGASY
        TT_MAC_LANGID_ESPERANTO
        TT_MAC_LANGID_WELSH
        TT_MAC_LANGID_BASQUE
        TT_MAC_LANGID_CATALAN
        TT_MAC_LANGID_LATIN
        TT_MAC_LANGID_QUECHUA
        TT_MAC_LANGID_GUARANI
        TT_MAC_LANGID_AYMARA
        TT_MAC_LANGID_TATAR
        TT_MAC_LANGID_UIGHUR
        TT_MAC_LANGID_DZONGKHA
        TT_MAC_LANGID_JAVANESE
        TT_MAC_LANGID_SUNDANESE
        TT_MAC_LANGID_GALICIAN
        TT_MAC_LANGID_AFRIKAANS
        TT_MAC_LANGID_BRETON
        TT_MAC_LANGID_INUKTITUT
        TT_MAC_LANGID_SCOTTISH_GAELIC
        TT_MAC_LANGID_MANX_GAELIC
        TT_MAC_LANGID_IRISH_GAELIC
        TT_MAC_LANGID_TONGAN
        TT_MAC_LANGID_GREEK_POLYTONIC
        TT_MAC_LANGID_GREELANDIC
        TT_MAC_LANGID_AZERBAIJANI_ROMAN_SCRIPT
    cdef enum:
        TT_MS_LANGID_ARABIC_SAUDI_ARABIA
        TT_MS_LANGID_ARABIC_IRAQ
        TT_MS_LANGID_ARABIC_EGYPT
        TT_MS_LANGID_ARABIC_LIBYA
        TT_MS_LANGID_ARABIC_ALGERIA
        TT_MS_LANGID_ARABIC_MOROCCO
        TT_MS_LANGID_ARABIC_TUNISIA
        TT_MS_LANGID_ARABIC_OMAN
        TT_MS_LANGID_ARABIC_YEMEN
        TT_MS_LANGID_ARABIC_SYRIA
        TT_MS_LANGID_ARABIC_JORDAN
        TT_MS_LANGID_ARABIC_LEBANON
        TT_MS_LANGID_ARABIC_KUWAIT
        TT_MS_LANGID_ARABIC_UAE
        TT_MS_LANGID_ARABIC_BAHRAIN
        TT_MS_LANGID_ARABIC_QATAR
        TT_MS_LANGID_BULGARIAN_BULGARIA
        TT_MS_LANGID_CATALAN_CATALAN
        TT_MS_LANGID_CHINESE_TAIWAN
        TT_MS_LANGID_CHINESE_PRC
        TT_MS_LANGID_CHINESE_HONG_KONG
        TT_MS_LANGID_CHINESE_SINGAPORE
        TT_MS_LANGID_CHINESE_MACAO
        TT_MS_LANGID_CZECH_CZECH_REPUBLIC
        TT_MS_LANGID_DANISH_DENMARK
        TT_MS_LANGID_GERMAN_GERMANY
        TT_MS_LANGID_GERMAN_SWITZERLAND
        TT_MS_LANGID_GERMAN_AUSTRIA
        TT_MS_LANGID_GERMAN_LUXEMBOURG
        TT_MS_LANGID_GERMAN_LIECHTENSTEIN
        TT_MS_LANGID_GREEK_GREECE
        TT_MS_LANGID_ENGLISH_UNITED_STATES
        TT_MS_LANGID_ENGLISH_UNITED_KINGDOM
        TT_MS_LANGID_ENGLISH_AUSTRALIA
        TT_MS_LANGID_ENGLISH_CANADA
        TT_MS_LANGID_ENGLISH_NEW_ZEALAND
        TT_MS_LANGID_ENGLISH_IRELAND
        TT_MS_LANGID_ENGLISH_SOUTH_AFRICA
        TT_MS_LANGID_ENGLISH_JAMAICA
        TT_MS_LANGID_ENGLISH_CARIBBEAN
        TT_MS_LANGID_ENGLISH_BELIZE
        TT_MS_LANGID_ENGLISH_TRINIDAD
        TT_MS_LANGID_ENGLISH_ZIMBABWE
        TT_MS_LANGID_ENGLISH_PHILIPPINES
        TT_MS_LANGID_ENGLISH_INDIA
        TT_MS_LANGID_ENGLISH_MALAYSIA
        TT_MS_LANGID_ENGLISH_SINGAPORE
        TT_MS_LANGID_SPANISH_SPAIN_TRADITIONAL_SORT
        TT_MS_LANGID_SPANISH_MEXICO
        TT_MS_LANGID_SPANISH_SPAIN_MODERN_SORT
        TT_MS_LANGID_SPANISH_GUATEMALA
        TT_MS_LANGID_SPANISH_COSTA_RICA
        TT_MS_LANGID_SPANISH_PANAMA
        TT_MS_LANGID_SPANISH_DOMINICAN_REPUBLIC
        TT_MS_LANGID_SPANISH_VENEZUELA
        TT_MS_LANGID_SPANISH_COLOMBIA
        TT_MS_LANGID_SPANISH_PERU
        TT_MS_LANGID_SPANISH_ARGENTINA
        TT_MS_LANGID_SPANISH_ECUADOR
        TT_MS_LANGID_SPANISH_CHILE
        TT_MS_LANGID_SPANISH_URUGUAY
        TT_MS_LANGID_SPANISH_PARAGUAY
        TT_MS_LANGID_SPANISH_BOLIVIA
        TT_MS_LANGID_SPANISH_EL_SALVADOR
        TT_MS_LANGID_SPANISH_HONDURAS
        TT_MS_LANGID_SPANISH_NICARAGUA
        TT_MS_LANGID_SPANISH_PUERTO_RICO
        TT_MS_LANGID_SPANISH_UNITED_STATES
        TT_MS_LANGID_FINNISH_FINLAND
        TT_MS_LANGID_FRENCH_FRANCE
        TT_MS_LANGID_FRENCH_BELGIUM
        TT_MS_LANGID_FRENCH_CANADA
        TT_MS_LANGID_FRENCH_SWITZERLAND
        TT_MS_LANGID_FRENCH_LUXEMBOURG
        TT_MS_LANGID_FRENCH_MONACO
        TT_MS_LANGID_HEBREW_ISRAEL
        TT_MS_LANGID_HUNGARIAN_HUNGARY
        TT_MS_LANGID_ICELANDIC_ICELAND
        TT_MS_LANGID_ITALIAN_ITALY
        TT_MS_LANGID_ITALIAN_SWITZERLAND
        TT_MS_LANGID_JAPANESE_JAPAN
        TT_MS_LANGID_KOREAN_KOREA
        TT_MS_LANGID_DUTCH_NETHERLANDS
        TT_MS_LANGID_DUTCH_BELGIUM
        TT_MS_LANGID_NORWEGIAN_NORWAY_BOKMAL
        TT_MS_LANGID_NORWEGIAN_NORWAY_NYNORSK
        TT_MS_LANGID_POLISH_POLAND
        TT_MS_LANGID_PORTUGUESE_BRAZIL
        TT_MS_LANGID_PORTUGUESE_PORTUGAL
        TT_MS_LANGID_ROMANSH_SWITZERLAND
        TT_MS_LANGID_ROMANIAN_ROMANIA
        TT_MS_LANGID_RUSSIAN_RUSSIA
        TT_MS_LANGID_CROATIAN_CROATIA
        TT_MS_LANGID_SERBIAN_SERBIA_LATIN
        TT_MS_LANGID_SERBIAN_SERBIA_CYRILLIC
        TT_MS_LANGID_CROATIAN_BOSNIA_HERZEGOVINA
        TT_MS_LANGID_BOSNIAN_BOSNIA_HERZEGOVINA
        TT_MS_LANGID_SERBIAN_BOSNIA_HERZ_LATIN
        TT_MS_LANGID_SERBIAN_BOSNIA_HERZ_CYRILLIC
        TT_MS_LANGID_BOSNIAN_BOSNIA_HERZ_CYRILLIC
        TT_MS_LANGID_SLOVAK_SLOVAKIA
        TT_MS_LANGID_ALBANIAN_ALBANIA
        TT_MS_LANGID_SWEDISH_SWEDEN
        TT_MS_LANGID_SWEDISH_FINLAND
        TT_MS_LANGID_THAI_THAILAND
        TT_MS_LANGID_TURKISH_TURKEY
        TT_MS_LANGID_URDU_PAKISTAN
        TT_MS_LANGID_INDONESIAN_INDONESIA
        TT_MS_LANGID_UKRAINIAN_UKRAINE
        TT_MS_LANGID_BELARUSIAN_BELARUS
        TT_MS_LANGID_SLOVENIAN_SLOVENIA
        TT_MS_LANGID_ESTONIAN_ESTONIA
        TT_MS_LANGID_LATVIAN_LATVIA
        TT_MS_LANGID_LITHUANIAN_LITHUANIA
        TT_MS_LANGID_TAJIK_TAJIKISTAN
        TT_MS_LANGID_VIETNAMESE_VIET_NAM
        TT_MS_LANGID_ARMENIAN_ARMENIA
        TT_MS_LANGID_AZERI_AZERBAIJAN_LATIN
        TT_MS_LANGID_AZERI_AZERBAIJAN_CYRILLIC
        TT_MS_LANGID_BASQUE_BASQUE
        TT_MS_LANGID_UPPER_SORBIAN_GERMANY
        TT_MS_LANGID_LOWER_SORBIAN_GERMANY
        TT_MS_LANGID_MACEDONIAN_MACEDONIA
        TT_MS_LANGID_SETSWANA_SOUTH_AFRICA
        TT_MS_LANGID_ISIXHOSA_SOUTH_AFRICA
        TT_MS_LANGID_ISIZULU_SOUTH_AFRICA
        TT_MS_LANGID_AFRIKAANS_SOUTH_AFRICA
        TT_MS_LANGID_GEORGIAN_GEORGIA
        TT_MS_LANGID_FAEROESE_FAEROE_ISLANDS
        TT_MS_LANGID_HINDI_INDIA
        TT_MS_LANGID_MALTESE_MALTA
        TT_MS_LANGID_SAMI_NORTHERN_NORWAY
        TT_MS_LANGID_SAMI_NORTHERN_SWEDEN
        TT_MS_LANGID_SAMI_NORTHERN_FINLAND
        TT_MS_LANGID_SAMI_LULE_NORWAY
        TT_MS_LANGID_SAMI_LULE_SWEDEN
        TT_MS_LANGID_SAMI_SOUTHERN_NORWAY
        TT_MS_LANGID_SAMI_SOUTHERN_SWEDEN
        TT_MS_LANGID_SAMI_SKOLT_FINLAND
        TT_MS_LANGID_SAMI_INARI_FINLAND
        TT_MS_LANGID_IRISH_IRELAND
        TT_MS_LANGID_MALAY_MALAYSIA
        TT_MS_LANGID_MALAY_BRUNEI_DARUSSALAM
        TT_MS_LANGID_KAZAKH_KAZAKHSTAN
        TT_MS_LANGID_KYRGYZ_KYRGYZSTAN
        TT_MS_LANGID_KISWAHILI_KENYA
        TT_MS_LANGID_TURKMEN_TURKMENISTAN
        TT_MS_LANGID_UZBEK_UZBEKISTAN_LATIN
        TT_MS_LANGID_UZBEK_UZBEKISTAN_CYRILLIC
        TT_MS_LANGID_TATAR_RUSSIA
        TT_MS_LANGID_BENGALI_INDIA
        TT_MS_LANGID_BENGALI_BANGLADESH
        TT_MS_LANGID_PUNJABI_INDIA
        TT_MS_LANGID_GUJARATI_INDIA
        TT_MS_LANGID_ODIA_INDIA
        TT_MS_LANGID_TAMIL_INDIA
        TT_MS_LANGID_TELUGU_INDIA
        TT_MS_LANGID_KANNADA_INDIA
        TT_MS_LANGID_MALAYALAM_INDIA
        TT_MS_LANGID_ASSAMESE_INDIA
        TT_MS_LANGID_MARATHI_INDIA
        TT_MS_LANGID_SANSKRIT_INDIA
        TT_MS_LANGID_MONGOLIAN_MONGOLIA
        TT_MS_LANGID_MONGOLIAN_PRC
        TT_MS_LANGID_TIBETAN_PRC
        TT_MS_LANGID_WELSH_UNITED_KINGDOM
        TT_MS_LANGID_KHMER_CAMBODIA
        TT_MS_LANGID_LAO_LAOS
        TT_MS_LANGID_GALICIAN_GALICIAN
        TT_MS_LANGID_KONKANI_INDIA
        TT_MS_LANGID_SYRIAC_SYRIA
        TT_MS_LANGID_SINHALA_SRI_LANKA
        TT_MS_LANGID_INUKTITUT_CANADA
        TT_MS_LANGID_INUKTITUT_CANADA_LATIN
        TT_MS_LANGID_AMHARIC_ETHIOPIA
        TT_MS_LANGID_TAMAZIGHT_ALGERIA
        TT_MS_LANGID_NEPALI_NEPAL
        TT_MS_LANGID_FRISIAN_NETHERLANDS
        TT_MS_LANGID_PASHTO_AFGHANISTAN
        TT_MS_LANGID_FILIPINO_PHILIPPINES
        TT_MS_LANGID_DHIVEHI_MALDIVES
        TT_MS_LANGID_HAUSA_NIGERIA
        TT_MS_LANGID_YORUBA_NIGERIA
        TT_MS_LANGID_QUECHUA_BOLIVIA
        TT_MS_LANGID_QUECHUA_ECUADOR
        TT_MS_LANGID_QUECHUA_PERU
        TT_MS_LANGID_SESOTHO_SA_LEBOA_SOUTH_AFRICA
        TT_MS_LANGID_BASHKIR_RUSSIA
        TT_MS_LANGID_LUXEMBOURGISH_LUXEMBOURG
        TT_MS_LANGID_GREENLANDIC_GREENLAND
        TT_MS_LANGID_IGBO_NIGERIA
        TT_MS_LANGID_YI_PRC
        TT_MS_LANGID_MAPUDUNGUN_CHILE
        TT_MS_LANGID_MOHAWK_MOHAWK
        TT_MS_LANGID_BRETON_FRANCE
        TT_MS_LANGID_UIGHUR_PRC
        TT_MS_LANGID_MAORI_NEW_ZEALAND
        TT_MS_LANGID_OCCITAN_FRANCE
        TT_MS_LANGID_CORSICAN_FRANCE
        TT_MS_LANGID_ALSATIAN_FRANCE
        TT_MS_LANGID_YAKUT_RUSSIA
        TT_MS_LANGID_KICHE_GUATEMALA
        TT_MS_LANGID_KINYARWANDA_RWANDA
        TT_MS_LANGID_WOLOF_SENEGAL
        TT_MS_LANGID_DARI_AFGHANISTAN
    cdef enum:
        TT_MS_LANGID_ARABIC_GENERAL
        TT_MS_LANGID_CATALAN_SPAIN
        TT_MS_LANGID_CHINESE_GENERAL
        TT_MS_LANGID_CHINESE_MACAU
        TT_MS_LANGID_GERMAN_LIECHTENSTEI
        TT_MS_LANGID_ENGLISH_GENERAL
        TT_MS_LANGID_ENGLISH_INDONESIA
        TT_MS_LANGID_ENGLISH_HONG_KONG
        TT_MS_LANGID_SPANISH_SPAIN_INTERNATIONAL_SORT
        TT_MS_LANGID_SPANISH_LATIN_AMERICA
        TT_MS_LANGID_FRENCH_WEST_INDIES
        TT_MS_LANGID_FRENCH_REUNION
        TT_MS_LANGID_FRENCH_CONGO
        TT_MS_LANGID_FRENCH_ZAIRE
        TT_MS_LANGID_FRENCH_SENEGAL
        TT_MS_LANGID_FRENCH_CAMEROON
        TT_MS_LANGID_FRENCH_COTE_D_IVOIRE
        TT_MS_LANGID_FRENCH_MALI
        TT_MS_LANGID_FRENCH_MOROCCO
        TT_MS_LANGID_FRENCH_HAITI
        TT_MS_LANGID_FRENCH_NORTH_AFRICA
        TT_MS_LANGID_KOREAN_EXTENDED_WANSUNG_KOREA
        TT_MS_LANGID_KOREAN_JOHAB_KOREA
        TT_MS_LANGID_RHAETO_ROMANIC_SWITZERLAND
        TT_MS_LANGID_MOLDAVIAN_MOLDAVIA
        TT_MS_LANGID_RUSSIAN_MOLDAVIA
        TT_MS_LANGID_URDU_INDIA
        TT_MS_LANGID_CLASSIC_LITHUANIAN_LITHUANIA
        TT_MS_LANGID_SLOVENE_SLOVENIA
        TT_MS_LANGID_FARSI_IRAN
        TT_MS_LANGID_BASQUE_SPAIN
        TT_MS_LANGID_SORBIAN_GERMANY
        TT_MS_LANGID_SUTU_SOUTH_AFRICA
        TT_MS_LANGID_TSONGA_SOUTH_AFRICA
        TT_MS_LANGID_TSWANA_SOUTH_AFRICA
        TT_MS_LANGID_VENDA_SOUTH_AFRICA
        TT_MS_LANGID_XHOSA_SOUTH_AFRICA
        TT_MS_LANGID_ZULU_SOUTH_AFRICA
        TT_MS_LANGID_SAAMI_LAPONIA
        TT_MS_LANGID_IRISH_GAELIC_IRELAND
        TT_MS_LANGID_SCOTTISH_GAELIC_UNITED_KINGDOM
        TT_MS_LANGID_YIDDISH_GERMANY
        TT_MS_LANGID_KAZAK_KAZAKSTAN
        TT_MS_LANGID_KIRGHIZ_KIRGHIZ_REPUBLIC
        TT_MS_LANGID_KIRGHIZ_KIRGHIZSTAN
        TT_MS_LANGID_SWAHILI_KENYA
        TT_MS_LANGID_TATAR_TATARSTAN
        TT_MS_LANGID_PUNJABI_ARABIC_PAKISTAN
        TT_MS_LANGID_ORIYA_INDIA
        TT_MS_LANGID_MONGOLIAN_MONGOLIA_MONGOLIAN
        TT_MS_LANGID_TIBETAN_CHINA
        TT_MS_LANGID_DZONGHKA_BHUTAN
        TT_MS_LANGID_TIBETAN_BHUTAN
        TT_MS_LANGID_WELSH_WALES
        TT_MS_LANGID_BURMESE_MYANMAR
        TT_MS_LANGID_GALICIAN_SPAIN
        TT_MS_LANGID_MANIPURI_INDIA
        TT_MS_LANGID_SINDHI_INDIA
        TT_MS_LANGID_SINDHI_PAKISTAN
        TT_MS_LANGID_SINHALESE_SRI_LANKA
        TT_MS_LANGID_CHEROKEE_UNITED_STATES
        TT_MS_LANGID_TAMAZIGHT_MOROCCO
        TT_MS_LANGID_TAMAZIGHT_MOROCCO_LATIN
        TT_MS_LANGID_KASHMIRI_PAKISTAN
        TT_MS_LANGID_KASHMIRI_SASIA
        TT_MS_LANGID_KASHMIRI_INDIA
        TT_MS_LANGID_NEPALI_INDIA
        TT_MS_LANGID_DIVEHI_MALDIVES
        TT_MS_LANGID_EDO_NIGERIA
        TT_MS_LANGID_FULFULDE_NIGERIA
        TT_MS_LANGID_IBIBIO_NIGERIA
        TT_MS_LANGID_SEPEDI_SOUTH_AFRICA
        TT_MS_LANGID_SOTHO_SOUTHERN_SOUTH_AFRICA
        TT_MS_LANGID_KANURI_NIGERIA
        TT_MS_LANGID_OROMO_ETHIOPIA
        TT_MS_LANGID_TIGRIGNA_ETHIOPIA
        TT_MS_LANGID_TIGRIGNA_ERYTHREA
        TT_MS_LANGID_TIGRIGNA_ERYTREA
        TT_MS_LANGID_GUARANI_PARAGUAY
        TT_MS_LANGID_HAWAIIAN_UNITED_STATES
        TT_MS_LANGID_LATIN
        TT_MS_LANGID_SOMALI_SOMALIA
        TT_MS_LANGID_YI_CHINA
        TT_MS_LANGID_PAPIAMENTU_NETHERLANDS_ANTILLES
        TT_MS_LANGID_UIGHUR_CHINA
    cdef enum:
        TT_NAME_ID_COPYRIGHT
        TT_NAME_ID_FONT_FAMILY
        TT_NAME_ID_FONT_SUBFAMILY
        TT_NAME_ID_UNIQUE_ID
        TT_NAME_ID_FULL_NAME
        TT_NAME_ID_VERSION_STRING
        TT_NAME_ID_PS_NAME
        TT_NAME_ID_TRADEMARK
        TT_NAME_ID_MANUFACTURER
        TT_NAME_ID_DESIGNER
        TT_NAME_ID_DESCRIPTION
        TT_NAME_ID_VENDOR_URL
        TT_NAME_ID_DESIGNER_URL
        TT_NAME_ID_LICENSE
        TT_NAME_ID_LICENSE_URL
        TT_NAME_ID_TYPOGRAPHIC_FAMILY
        TT_NAME_ID_TYPOGRAPHIC_SUBFAMILY
        TT_NAME_ID_MAC_FULL_NAME
        TT_NAME_ID_SAMPLE_TEXT
        TT_NAME_ID_CID_FINDFONT_NAME
        TT_NAME_ID_WWS_FAMILY
        TT_NAME_ID_WWS_SUBFAMILY
        TT_NAME_ID_LIGHT_BACKGROUND
        TT_NAME_ID_DARK_BACKGROUND
        TT_NAME_ID_VARIATIONS_PREFIX
    cdef enum:
        TT_UCR_BASIC_LATIN
        TT_UCR_LATIN1_SUPPLEMENT
        TT_UCR_LATIN_EXTENDED_A
        TT_UCR_LATIN_EXTENDED_B
        TT_UCR_IPA_EXTENSIONS
        TT_UCR_SPACING_MODIFIER
        TT_UCR_COMBINING_DIACRITICAL_MARKS
        TT_UCR_GREEK
        TT_UCR_COPTIC
        TT_UCR_CYRILLIC
        TT_UCR_ARMENIAN
        TT_UCR_HEBREW
        TT_UCR_VAI
        TT_UCR_ARABIC
        TT_UCR_NKO
        TT_UCR_DEVANAGARI
        TT_UCR_BENGALI
        TT_UCR_GURMUKHI
        TT_UCR_GUJARATI
        TT_UCR_ORIYA
        TT_UCR_TAMIL
        TT_UCR_TELUGU
        TT_UCR_KANNADA
        TT_UCR_MALAYALAM
        TT_UCR_THAI
        TT_UCR_LAO
        TT_UCR_GEORGIAN
        TT_UCR_BALINESE
        TT_UCR_HANGUL_JAMO
        TT_UCR_LATIN_EXTENDED_ADDITIONAL
        TT_UCR_GREEK_EXTENDED
        TT_UCR_GENERAL_PUNCTUATION
        TT_UCR_SUPERSCRIPTS_SUBSCRIPTS
        TT_UCR_CURRENCY_SYMBOLS
        TT_UCR_COMBINING_DIACRITICAL_MARKS_SYMB
        TT_UCR_LETTERLIKE_SYMBOLS
        TT_UCR_NUMBER_FORMS
        TT_UCR_ARROWS
        TT_UCR_MATHEMATICAL_OPERATORS
        TT_UCR_MISCELLANEOUS_TECHNICAL
        TT_UCR_CONTROL_PICTURES
        TT_UCR_OCR
        TT_UCR_ENCLOSED_ALPHANUMERICS
        TT_UCR_BOX_DRAWING
        TT_UCR_BLOCK_ELEMENTS
        TT_UCR_GEOMETRIC_SHAPES
        TT_UCR_MISCELLANEOUS_SYMBOLS
        TT_UCR_DINGBATS
        TT_UCR_CJK_SYMBOLS
        TT_UCR_HIRAGANA
        TT_UCR_KATAKANA
        TT_UCR_BOPOMOFO
        TT_UCR_HANGUL_COMPATIBILITY_JAMO
        TT_UCR_CJK_MISC
        TT_UCR_KANBUN
        TT_UCR_PHAGSPA
        TT_UCR_ENCLOSED_CJK_LETTERS_MONTHS
        TT_UCR_CJK_COMPATIBILITY
        TT_UCR_HANGUL
        TT_UCR_SURROGATES
        TT_UCR_NON_PLANE_0
        TT_UCR_PHOENICIAN
        TT_UCR_CJK_UNIFIED_IDEOGRAPHS
        TT_UCR_PRIVATE_USE
        TT_UCR_CJK_COMPATIBILITY_IDEOGRAPHS
        TT_UCR_ALPHABETIC_PRESENTATION_FORMS
        TT_UCR_ARABIC_PRESENTATION_FORMS_A
        TT_UCR_COMBINING_HALF_MARKS
        TT_UCR_CJK_COMPATIBILITY_FORMS
        TT_UCR_SMALL_FORM_VARIANTS
        TT_UCR_ARABIC_PRESENTATION_FORMS_B
        TT_UCR_HALFWIDTH_FULLWIDTH_FORMS
        TT_UCR_SPECIALS
        TT_UCR_TIBETAN
        TT_UCR_SYRIAC
        TT_UCR_THAANA
        TT_UCR_SINHALA
        TT_UCR_MYANMAR
        TT_UCR_ETHIOPIC
        TT_UCR_CHEROKEE
        TT_UCR_CANADIAN_ABORIGINAL_SYLLABICS
        TT_UCR_OGHAM
        TT_UCR_RUNIC
        TT_UCR_KHMER
        TT_UCR_MONGOLIAN
        TT_UCR_BRAILLE
        TT_UCR_YI
        TT_UCR_PHILIPPINE
        TT_UCR_OLD_ITALIC
        TT_UCR_GOTHIC
        TT_UCR_DESERET
        TT_UCR_MUSICAL_SYMBOLS
        TT_UCR_MATH_ALPHANUMERIC_SYMBOLS
        TT_UCR_PRIVATE_USE_SUPPLEMENTARY
        TT_UCR_VARIATION_SELECTORS
        TT_UCR_TAGS
        TT_UCR_LIMBU
        TT_UCR_TAI_LE
        TT_UCR_NEW_TAI_LUE
        TT_UCR_BUGINESE
        TT_UCR_GLAGOLITIC
        TT_UCR_TIFINAGH
        TT_UCR_YIJING
        TT_UCR_SYLOTI_NAGRI
        TT_UCR_LINEAR_B
        TT_UCR_ANCIENT_GREEK_NUMBERS
        TT_UCR_UGARITIC
        TT_UCR_OLD_PERSIAN
        TT_UCR_SHAVIAN
        TT_UCR_OSMANYA
        TT_UCR_CYPRIOT_SYLLABARY
        TT_UCR_KHAROSHTHI
        TT_UCR_TAI_XUAN_JING
        TT_UCR_CUNEIFORM
        TT_UCR_COUNTING_ROD_NUMERALS
        TT_UCR_SUNDANESE
        TT_UCR_LEPCHA
        TT_UCR_OL_CHIKI
        TT_UCR_SAURASHTRA
        TT_UCR_KAYAH_LI
        TT_UCR_REJANG
        TT_UCR_CHAM
        TT_UCR_ANCIENT_SYMBOLS
        TT_UCR_PHAISTOS_DISC
        TT_UCR_OLD_ANATOLIAN
        TT_UCR_GAME_TILES
        TT_UCR_ARABIC_PRESENTATION_A
        TT_UCR_ARABIC_PRESENTATION_B
        TT_UCR_COMBINING_DIACRITICS
        TT_UCR_COMBINING_DIACRITICS_SYMB

cdef extern from "freetype/tttables.h" nogil:
    ctypedef struct TT_Header:
        FT_Fixed Table_Version 
        FT_Fixed Font_Revision 
        FT_Long CheckSum_Adjust 
        FT_Long Magic_Number 
        FT_UShort Flags 
        FT_UShort Units_Per_EM 
        FT_ULong Created [2] 
        FT_ULong Modified[2] 
        FT_Short xMin 
        FT_Short yMin 
        FT_Short xMax 
        FT_Short yMax 
        FT_UShort Mac_Style 
        FT_UShort Lowest_Rec_PPEM 
        FT_Short Font_Direction 
        FT_Short Index_To_Loc_Format 
        FT_Short Glyph_Data_Format 
    ctypedef struct TT_HoriHeader:
        FT_Fixed Version 
        FT_Short Ascender 
        FT_Short Descender 
        FT_Short Line_Gap 
        FT_UShort advance_Width_Max
        FT_Short min_Left_Side_Bearing 
        FT_Short min_Right_Side_Bearing 
        FT_Short xMax_Extent 
        FT_Short caret_Slope_Rise 
        FT_Short caret_Slope_Run 
        FT_Short caret_Offset 
        FT_Short Reserved[4] 
        FT_Short metric_Data_Format 
        FT_UShort number_Of_HMetrics 
        void *long_metrics 
        void *short_metrics 
    ctypedef struct TT_VertHeader:
        FT_Fixed Version 
        FT_Short Ascender 
        FT_Short Descender 
        FT_Short Line_Gap 
        FT_UShort advance_Height_Max 
        FT_Short min_Top_Side_Bearing 
        FT_Short min_Bottom_Side_Bearing 
        FT_Short yMax_Extent 
        FT_Short caret_Slope_Rise 
        FT_Short caret_Slope_Run 
        FT_Short caret_Offset 
        FT_Short Reserved[4] 
        FT_Short metric_Data_Format 
        FT_UShort number_Of_VMetrics 
        void *long_metrics 
        void *short_metrics 
    ctypedef struct TT_OS2:
        FT_UShort version 
        FT_Short xAvgCharWidth 
        FT_UShort usWeightClass 
        FT_UShort usWidthClass 
        FT_UShort fsType 
        FT_Short ySubscriptXSize 
        FT_Short ySubscriptYSize 
        FT_Short ySubscriptXOffset 
        FT_Short ySubscriptYOffset 
        FT_Short ySuperscriptXSize 
        FT_Short ySuperscriptYSize 
        FT_Short ySuperscriptXOffset 
        FT_Short ySuperscriptYOffset 
        FT_Short yStrikeoutSize 
        FT_Short yStrikeoutPosition 
        FT_Short sFamilyClass 
        FT_Byte panose[10] 
        FT_ULong ulUnicodeRange1 
        FT_ULong ulUnicodeRange2 
        FT_ULong ulUnicodeRange3 
        FT_ULong ulUnicodeRange4 
        FT_Char achVendID[4] 
        FT_UShort fsSelection 
        FT_UShort usFirstCharIndex 
        FT_UShort usLastCharIndex 
        FT_Short sTypoAscender 
        FT_Short sTypoDescender 
        FT_Short sTypoLineGap 
        FT_UShort usWinAscent 
        FT_UShort usWinDescent 
        FT_ULong ulCodePageRange1 
        FT_ULong ulCodePageRange2 
        FT_Short sxHeight 
        FT_Short sCapHeight 
        FT_UShort usDefaultChar 
        FT_UShort usBreakChar 
        FT_UShort usMaxContext 
        FT_UShort usLowerOpticalPointSize 
        FT_UShort usUpperOpticalPointSize
    ctypedef struct TT_Postscript:
        FT_Fixed FormatType 
        FT_Fixed italicAngle 
        FT_Short underlinePosition 
        FT_Short underlineThickness 
        FT_ULong isFixedPitch 
        FT_ULong minMemType42 
        FT_ULong maxMemType42 
        FT_ULong minMemType1 
        FT_ULong maxMemType1 
    ctypedef struct TT_PCLT:
        FT_Fixed Version 
        FT_ULong FontNumber 
        FT_UShort Pitch 
        FT_UShort xHeight 
        FT_UShort Style 
        FT_UShort TypeFamily 
        FT_UShort CapHeight 
        FT_UShort SymbolSet 
        FT_Char TypeFace[16] 
        FT_Char CharacterComplement[8] 
        FT_Char FileName[6] 
        FT_Char StrokeWeight 
        FT_Char WidthType 
        FT_Byte SerifStyle 
        FT_Byte Reserved 
    ctypedef struct TT_MaxProfile:
        FT_Fixed version 
        FT_UShort numGlyphs 
        FT_UShort maxPoints 
        FT_UShort maxContours 
        FT_UShort maxCompositePoints 
        FT_UShort maxCompositeContours 
        FT_UShort maxZones 
        FT_UShort maxTwilightPoints 
        FT_UShort maxStorage 
        FT_UShort maxFunctionDefs 
        FT_UShort maxInstructionDefs 
        FT_UShort maxStackElements 
        FT_UShort maxSizeOfInstructions 
        FT_UShort maxComponentElements 
        FT_UShort maxComponentDepth 
    ctypedef enum FT_Sfnt_Tag:
        FT_SFNT_HEAD
        FT_SFNT_MAXP
        FT_SFNT_OS2
        FT_SFNT_HHEA
        FT_SFNT_VHEA
        FT_SFNT_POST
        FT_SFNT_PCLT
        FT_SFNT_MAX
    void *FT_Get_Sfnt_Table(FT_Face face, FT_Sfnt_Tag tag) 
    FT_Error FT_Load_Sfnt_Table(FT_Face face, FT_ULong tag, FT_Long offset, FT_Byte *buffer, FT_ULong *length) 
    FT_Error FT_Sfnt_Table_Info(FT_Face face, FT_UInt table_index, FT_ULong *tag, FT_ULong *length) 
    FT_ULong FT_Get_CMap_Language_ID(FT_CharMap charmap)
    FT_Long FT_Get_CMap_Format(FT_CharMap charmap) 

cdef extern from "freetype/t1tables.h" nogil:
    ctypedef struct PS_FontInfoRec:
        FT_String *version
        FT_String *notice
        FT_String *full_name
        FT_String *family_name
        FT_String *weight
        FT_Long italic_angle
        FT_Bool is_fixed_pitch
        FT_Short underline_position
        FT_UShort underline_thickness
    ctypedef PS_FontInfoRec *PS_FontInfo
    ctypedef PS_FontInfoRec T1_FontInfo
    ctypedef struct PS_PrivateRec:
        FT_Int unique_id
        FT_Int lenIV
        FT_Byte num_blue_values
        FT_Byte num_other_blues
        FT_Byte num_family_blues
        FT_Byte num_family_other_blues
        FT_Short blue_values[14]
        FT_Short other_blues[10]
        FT_Short family_blues [14]
        FT_Short family_other_blues[10]
        FT_Fixed blue_scale
        FT_Int blue_shift
        FT_Int blue_fuzz
        FT_UShort standard_width[1]
        FT_UShort standard_height[1]
        FT_Byte num_snap_widths
        FT_Byte num_snap_heights
        FT_Bool force_bold
        FT_Bool round_stem_up
        FT_Short snap_widths [13]
        FT_Short snap_heights[13]
        FT_Fixed expansion_factor
        FT_Long language_group
        FT_Long password
        FT_Short min_feature[2]
    ctypedef PS_PrivateRec *PS_Private
    ctypedef PS_PrivateRec T1_Private
    ctypedef enum T1_Blend_Flags:
        T1_BLEND_UNDERLINE_POSITION
        T1_BLEND_UNDERLINE_THICKNESS
        T1_BLEND_ITALIC_ANGLE
        T1_BLEND_BLUE_VALUES
        T1_BLEND_OTHER_BLUES
        T1_BLEND_STANDARD_WIDTH
        T1_BLEND_STANDARD_HEIGHT
        T1_BLEND_STEM_SNAP_WIDTHS
        T1_BLEND_STEM_SNAP_HEIGHTS
        T1_BLEND_BLUE_SCALE
        T1_BLEND_BLUE_SHIFT
        T1_BLEND_FAMILY_BLUES
        T1_BLEND_FAMILY_OTHER_BLUES
        T1_BLEND_FORCE_BOLD
        T1_BLEND_MAX
    cdef enum:
        T1_MAX_MM_DESIGNS
        #T1_MAX_MM_AXIS#already declared earlier in pxd file
        T1_MAX_MM_MAP_POINTS
    ctypedef struct PS_DesignMapRec:
        FT_Byte num_points
        FT_Long *design_points
        FT_Fixed *blend_points
    ctypedef PS_DesignMapRec *PS_DesignMap
    ctypedef PS_DesignMapRec T1_DesignMap
    ctypedef struct PS_BlendRec:
        FT_UInt num_designs
        FT_UInt num_axis
        FT_String *axis_names[T1_MAX_MM_AXIS]
        FT_Fixed *design_pos[T1_MAX_MM_DESIGNS]
        PS_DesignMapRec design_map[T1_MAX_MM_AXIS]
        FT_Fixed *weight_vector
        FT_Fixed *default_weight_vector
        PS_FontInfo font_infos[T1_MAX_MM_DESIGNS + 1]
        PS_Private privates [T1_MAX_MM_DESIGNS + 1]
        FT_ULong blend_bitflags
        FT_BBox *bboxes [T1_MAX_MM_DESIGNS + 1]
        FT_UInt default_design_vector[T1_MAX_MM_DESIGNS]
        FT_UInt num_default_design_vector
    ctypedef PS_BlendRec *PS_Blend
    ctypedef PS_BlendRec T1_Blend
    ctypedef struct CID_FaceDictRec:
        PS_PrivateRec private_dict
        FT_UInt len_buildchar
        FT_Fixed forcebold_threshold
        FT_Pos stroke_width
        FT_Fixed expansion_factor
        FT_Byte paint_type
        FT_Byte font_type
        FT_Matrix font_matrix
        FT_Vector font_offset
        FT_UInt num_subrs
        FT_ULong subrmap_offset
        FT_Int sd_bytes
    ctypedef CID_FaceDictRec *CID_FaceDict
    ctypedef struct CID_FaceInfoRec:
        FT_String *cid_font_name
        FT_Fixed cid_version
        FT_Int cid_font_type
        FT_String *registry
        FT_String *ordering
        FT_Int supplement
        PS_FontInfoRec font_info
        FT_BBox font_bbox
        FT_ULong uid_base
        FT_Int num_xuid
        FT_ULong xuid[16]
        FT_ULong cidmap_offset
        FT_Int fd_bytes
        FT_Int gd_bytes
        FT_ULong cid_count
        FT_Int num_dicts
        CID_FaceDict font_dicts
        FT_ULong data_offset
    ctypedef CID_FaceInfoRec *CID_FaceInfo
    FT_Int FT_Has_PS_Glyph_Names(FT_Face face)
    FT_Error FT_Get_PS_Font_Info(FT_Face face, PS_FontInfo afont_info)
    FT_Error FT_Get_PS_Font_Private(FT_Face face, PS_Private afont_private)
    ctypedef enum T1_EncodingType:
        T1_ENCODING_TYPE_NONE
        T1_ENCODING_TYPE_ARRAY
        T1_ENCODING_TYPE_STANDARD
        T1_ENCODING_TYPE_ISOLATIN1
        T1_ENCODING_TYPE_EXPERT
    ctypedef enum PS_Dict_Keys:
        PS_DICT_FONT_TYPE
        PS_DICT_FONT_MATRIX
        PS_DICT_FONT_BBOX
        PS_DICT_PAINT_TYPE
        PS_DICT_FONT_NAME
        PS_DICT_UNIQUE_ID
        PS_DICT_NUM_CHAR_STRINGS
        PS_DICT_CHAR_STRING_KEY
        PS_DICT_CHAR_STRING
        PS_DICT_ENCODING_TYPE
        PS_DICT_ENCODING_ENTRY
        PS_DICT_NUM_SUBRS
        PS_DICT_SUBR
        PS_DICT_STD_HW
        PS_DICT_STD_VW
        PS_DICT_NUM_BLUE_VALUES
        PS_DICT_BLUE_VALUE
        PS_DICT_BLUE_FUZZ
        PS_DICT_NUM_OTHER_BLUES
        PS_DICT_OTHER_BLUE
        PS_DICT_NUM_FAMILY_BLUES
        PS_DICT_FAMILY_BLUE
        PS_DICT_NUM_FAMILY_OTHER_BLUES
        PS_DICT_FAMILY_OTHER_BLUE
        PS_DICT_BLUE_SCALE
        PS_DICT_BLUE_SHIFT
        PS_DICT_NUM_STEM_SNAP_H
        PS_DICT_STEM_SNAP_H
        PS_DICT_NUM_STEM_SNAP_V
        PS_DICT_STEM_SNAP_V
        PS_DICT_FORCE_BOLD
        PS_DICT_RND_STEM_UP
        PS_DICT_MIN_FEATURE
        PS_DICT_LEN_IV
        PS_DICT_PASSWORD
        PS_DICT_LANGUAGE_GROUP
        PS_DICT_VERSION
        PS_DICT_NOTICE
        PS_DICT_FULL_NAME
        PS_DICT_FAMILY_NAME
        PS_DICT_WEIGHT
        PS_DICT_IS_FIXED_PITCH
        PS_DICT_UNDERLINE_POSITION
        PS_DICT_UNDERLINE_THICKNESS
        PS_DICT_FS_TYPE
        PS_DICT_ITALIC_ANGLE
        PS_DICT_MAX
    FT_Long FT_Get_PS_Font_Value(FT_Face face, PS_Dict_Keys key, FT_UInt idx, void *value, FT_Long value_len)

cdef extern from "freetype/ftmoderr.h" nogil:
    cdef enum:
        FT_Mod_Err_Base
        FT_Mod_Err_Autofit
        FT_Mod_Err_BDF
        FT_Mod_Err_Bzip2
        FT_Mod_Err_Cache
        FT_Mod_Err_CFF
        FT_Mod_Err_CID
        FT_Mod_Err_Gzip
        FT_Mod_Err_LZW
        FT_Mod_Err_OTvalid
        FT_Mod_Err_PCF
        FT_Mod_Err_PFR
        FT_Mod_Err_PSaux
        FT_Mod_Err_PShinter
        FT_Mod_Err_PSnames
        FT_Mod_Err_Raster
        FT_Mod_Err_SFNT
        FT_Mod_Err_Smooth
        FT_Mod_Err_TrueType
        FT_Mod_Err_Type1
        FT_Mod_Err_Type42
        FT_Mod_Err_Winfonts
        FT_Mod_Err_GXvalid

cdef extern from "freetype/freetype.h" nogil:#really from fterrdef.h, but importing directly causes errors
    cdef enum:
        FT_Err_Ok
        FT_Err_Cannot_Open_Resource
        FT_Err_Unknown_File_Format
        FT_Err_Invalid_File_Format
        FT_Err_Invalid_Version
        FT_Err_Lower_Module_Version
        FT_Err_Invalid_Argument
        FT_Err_Unimplemented_Feature
        FT_Err_Invalid_Table
        FT_Err_Invalid_Offset
        FT_Err_Array_Too_Large
        FT_Err_Missing_Module
        FT_Err_Missing_Property
        FT_Err_Invalid_Glyph_Index
        FT_Err_Invalid_Character_Code
        FT_Err_Invalid_Glyph_Format
        FT_Err_Cannot_Render_Glyph
        FT_Err_Invalid_Outline
        FT_Err_Invalid_Composite
        FT_Err_Too_Many_Hints
        FT_Err_Invalid_Pixel_Size
    cdef enum:
        FT_Err_Invalid_Handle
        FT_Err_Invalid_Library_Handle
        FT_Err_Invalid_Driver_Handle
        FT_Err_Invalid_Face_Handle
        FT_Err_Invalid_Size_Handle
        FT_Err_Invalid_Slot_Handle
        FT_Err_Invalid_CharMap_Handle
        FT_Err_Invalid_Cache_Handle
        FT_Err_Invalid_Stream_Handle
    cdef enum:
        FT_Err_Too_Many_Drivers
        FT_Err_Too_Many_Extensions
    cdef enum:
        FT_Err_Out_Of_Memory
        FT_Err_Unlisted_Object
    cdef enum:
        FT_Err_Cannot_Open_Stream
        FT_Err_Invalid_Stream_Seek
        FT_Err_Invalid_Stream_Skip
        FT_Err_Invalid_Stream_Read
        FT_Err_Invalid_Stream_Operation
        FT_Err_Invalid_Frame_Operation
        FT_Err_Nested_Frame_Access
        FT_Err_Invalid_Frame_Read
    cdef enum:
        FT_Err_Raster_Uninitialized
        FT_Err_Raster_Corrupted
        FT_Err_Raster_Overflow
        FT_Err_Raster_Negative_Height
    cdef enum:
        FT_Err_Too_Many_Caches
        FT_Err_Invalid_Opcode
        FT_Err_Too_Few_Arguments
        FT_Err_Stack_Overflow
        FT_Err_Code_Overflow
        FT_Err_Bad_Argument
        FT_Err_Divide_By_Zero
        FT_Err_Invalid_Reference
        FT_Err_Debug_OpCode
        FT_Err_ENDF_In_Exec_Stream
        FT_Err_Nested_DEFS
        FT_Err_Invalid_CodeRange
        FT_Err_Execution_Too_Long
        FT_Err_Too_Many_Function_Defs
        FT_Err_Too_Many_Instruction_Defs
        FT_Err_Table_Missing
        FT_Err_Horiz_Header_Missing
        FT_Err_Locations_Missing
        FT_Err_Name_Table_Missing
        FT_Err_CMap_Table_Missing
        FT_Err_Hmtx_Table_Missing
        FT_Err_Post_Table_Missing
        FT_Err_Invalid_Horiz_Metrics
        FT_Err_Invalid_CharMap_Format
        FT_Err_Invalid_PPem
        FT_Err_Invalid_Vert_Metrics
        FT_Err_Could_Not_Find_Context
        FT_Err_Invalid_Post_Table_Format
        FT_Err_Invalid_Post_Table
        FT_Err_DEF_In_Glyf_Bytecode
        FT_Err_Missing_Bitmap
    cdef enum:
        FT_Err_Syntax_Error
        FT_Err_Stack_Underflow
        FT_Err_Ignore
        FT_Err_No_Unicode_Glyph_Name
        FT_Err_Glyph_Too_Big
    cdef enum:
        FT_Err_Missing_Startfont_Field
        FT_Err_Missing_Font_Field
        FT_Err_Missing_Size_Field
        FT_Err_Missing_Fontboundingbox_Field
        FT_Err_Missing_Chars_Field
        FT_Err_Missing_Startchar_Field
        FT_Err_Missing_Encoding_Field
        FT_Err_Missing_Bbx_Field
        FT_Err_Bbx_Too_Big
        FT_Err_Corrupted_Font_Header
        FT_Err_Corrupted_Font_Glyphs

cdef extern from "freetype/fterrors.h" nogil:
    const char *FT_Error_String(FT_Error error_code)