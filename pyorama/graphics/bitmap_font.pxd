from pyorama.core.handle cimport *
from pyorama.math3d cimport *

ctypedef enum BitmapFontCommonChannel:
    BITMAP_FONT_COMMON_CHANNEL_GLYPH = 0
    BITMAP_FONT_COMMON_CHANNEL_line_itemsLINE = 1
    BITMAP_FONT_COMMON_CHANNEL_GLYPH_line_itemsLINE = 2
    BITMAP_FONT_COMMON_CHANNEL_ZERO = 3
    BITMAP_FONT_COMMON_CHANNEL_ONE = 4

ctypedef enum BitmapFontCharChannel:
    BITMAP_FONT_CHAR_CHANNEL_BLUE = 1
    BITMAP_FONT_CHAR_CHANNEL_GREEN = 2
    BITMAP_FONT_CHAR_CHANNEL_RED = 4
    BITMAP_FONT_CHAR_CHANNEL_ALPHA = 8
    BITMAP_FONT_CHAR_CHANNEL_ALL = 15

ctypedef struct BitmapFontInfoC:
    char[256] face
    int size
    bint bold
    bint italic
    char[256] charset
    bint unicode
    int stretch_h
    bint smooth
    int aa
    int[4] padding
    int[2] spacing
    int outline

ctypedef struct BitmapFontCommonC:
    int line_height
    int base
    int scale_w, scale_h
    int num_pages
    bint packed
    BitmapFontCommonChannel alpha
    BitmapFontCommonChannel red
    BitmapFontCommonChannel green
    BitmapFontCommonChannel blue

ctypedef struct BitmapFontPageC:
    int id
    char[256] file_name
    Handle texture

ctypedef struct BitmapFontCharC:
    int id
    int x, y
    int width, height
    int offset_x, offset_y
    int advance_x
    int page
    BitmapFontCharChannel channel

ctypedef struct BitmapFontKerningC:
    int first
    int second
    int amount

ctypedef struct BitmapFontC:
    Handle handle
    BitmapFontInfoC info
    BitmapFontCommonC common
    BitmapFontPageC *pages
    size_t num_chars
    BitmapFontCharC *chars
    size_t num_kernings
    BitmapFontKerningC *kernings

"""
    cpdef Handle bitmap_font_create_from_file(self, bytes file_path)
    cpdef void bitmap_font_delete(self, Handle font) except *
    cdef void _bitmap_font_parse_file(self, Handle font, bytes file_path) except *
    cdef dict _bitmap_font_parse_pairs(self, bytes line)
    cdef void _bitmap_font_parse_info(self, Handle font, dict pairs) except *
    cdef void _bitmap_font_parse_common(self, Handle font, dict pairs) except *
    cdef void _bitmap_font_parse_page(self, Handle font, dict pairs) except *
    cdef void _bitmap_font_parse_char(self, Handle font, size_t i, dict pairs) except *
    cdef void _bitmap_font_parse_kerning(self, Handle font, size_t i, dict pairs) except *
    cpdef Handle bitmap_font_get_page_texture(self, Handle font, size_t page_num) except *
"""