from pyorama.libs.c cimport *

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
    BitmapFontInfoC info
    BitmapFontCommonC common
    BitmapFontPageC *pages
    size_t num_chars
    BitmapFontCharC *chars
    size_t num_kernings
    BitmapFontKerningC *kernings

def bitmap_font_load_from_path(file_path):
    cdef:
        object in_file
        object splitter
        list lines
        bytes line
        list line_items
        bytes first
        bytes rest
        BitmapFontC font
        dict pairs
        size_t i_c = 0
        size_t i_k = 0

    memset(&font, 0, sizeof(BitmapFontC))
    in_file = open(file_path, "rb")
    lines = in_file.readlines()
    for line in lines:
        line_items = line.split()
        first = line_items[0]
        rest = b" ".join(line_items[1:] + [b" "])
        pairs = bitmap_font_parse_pairs(rest)
        if first == b"info":
            bitmap_font_parse_info(&font, pairs)
        elif first == b"common":
            bitmap_font_parse_common(&font, pairs)
        elif first == b"page":
            bitmap_font_parse_page(&font, pairs)
        elif first == b"chars":
            font.num_chars = int(pairs[b"count"])
        elif first == b"char":
            bitmap_font_parse_char(&font, i_c, pairs)
            i_c += 1
        elif first == b"kernings":
            font.num_kernings = int(pairs[b"count"])
        elif first == b"kerning":
            bitmap_font_parse_kerning(&font, i_k, pairs)
            i_k += 1
        else:
            raise ValueError("BitmapFont: invalid line tokens in .fnt file")

cdef dict bitmap_font_parse_pairs(bytes line):
    cdef:
        size_t i
        size_t start = 0
        size_t end = 0
        char c
        char *line_ptr = &(<char *>line)[0]
        size_t line_len = len(line)
        bint in_quotes = False
        bytes key
        bytes value
        dict out = {}

    for i in range(line_len - 1):
        c = line_ptr[i]
        if c == b" " and not in_quotes:
            end = i
            key, value = line[start:end].replace(b"\"", b"").split(b"=")
            out[key] = value
            start = end + 1
        elif c == b"\"":
            in_quotes = not in_quotes
    return out

cdef void bitmap_font_parse_info(BitmapFontC *font, dict pairs) except *:
    str_len = len(pairs[b"face"])
    if str_len > 255:
        raise ValueError("BitmapFont: face names > 255 characters are not supported")
    memcpy(font.info.face, <char *>pairs[b"face"], str_len)
    font.info.size = int(pairs[b"size"])
    font.info.bold = int(pairs[b"bold"])
    font.info.italic = int(pairs[b"italic"])
    str_len = len(pairs[b"charset"])
    if str_len > 255:
        raise ValueError("BitmapFont: charset names > 255 characters are not supported")
    memcpy(font.info.charset, <char *>pairs[b"charset"], str_len)
    font.info.unicode = int(pairs[b"unicode"])
    font.info.stretch_h = int(pairs[b"stretchH"])
    font.info.smooth = int(pairs[b"smooth"])
    font.info.aa = int(pairs[b"aa"])
    font.info.padding = [int(v) for v in pairs[b"padding"].split(b",")]
    font.info.spacing = [int(v) for v in pairs[b"spacing"].split(b",")]
    font.info.outline = int(pairs[b"outline"])

cdef void bitmap_font_parse_common(BitmapFontC *font, dict pairs) except *:
    font.common.line_height = int(pairs[b"lineHeight"])
    font.common.base = int(pairs[b"base"])
    font.common.scale_w = int(pairs[b"scaleW"])
    font.common.scale_h = int(pairs[b"scaleH"])
    font.common.num_pages = int(pairs[b"pages"])
    font.common.packed = int(pairs[b"packed"])
    font.common.alpha = int(pairs[b"alphaChnl"])
    font.common.red = int(pairs[b"redChnl"])
    font.common.green = int(pairs[b"greenChnl"])
    font.common.blue = int(pairs[b"blueChnl"])

cdef void bitmap_font_parse_page(BitmapFontC *font, dict pairs) except *:
    cdef:
        size_t page_num
        size_t str_len 
    if font.pages == NULL:
        font.pages = <BitmapFontPageC *>calloc(font.common.num_pages, sizeof(BitmapFontPageC))
        if font.pages == NULL:
            raise MemoryError("BitmapFont: cannot allocate pages")
    page_num = int(pairs[b"id"])
    font.pages[page_num].id = page_num
    str_len = len(pairs[b"file"])
    if str_len > 255:
        raise ValueError("BitmapFont: page file names > 255 characters are not supported")
    memcpy(&font.pages[page_num].file_name, <char *>pairs[b"file"], str_len)

cdef void bitmap_font_parse_char(BitmapFontC *font, size_t i, dict pairs) except *:
    if font.chars == NULL:
        font.chars = <BitmapFontCharC *>calloc(font.num_chars, sizeof(BitmapFontCharC))
        if font.chars == NULL:
            raise MemoryError("BitmapFont: cannot allocate chars")
    if i >= font.num_chars:
        raise ValueError("BitmapFont: invalid char index")
    font.chars[i].id = int(pairs[b"id"])
    font.chars[i].x = int(pairs[b"x"])
    font.chars[i].y = int(pairs[b"y"])
    font.chars[i].width = int(pairs[b"width"])
    font.chars[i].height = int(pairs[b"height"])
    font.chars[i].offset_x = int(pairs[b"xoffset"])
    font.chars[i].offset_y = int(pairs[b"yoffset"])
    font.chars[i].advance_x = int(pairs[b"xadvance"])
    font.chars[i].page = int(pairs[b"page"])
    font.chars[i].channel = int(pairs[b"chnl"])

cdef void bitmap_font_parse_kerning(BitmapFontC *font, size_t i, dict pairs) except *:
    if font.kernings == NULL:
        font.kernings = <BitmapFontKerningC *>calloc(font.num_kernings, sizeof(BitmapFontKerningC))
        if font.kernings == NULL:
            raise MemoryError("BitmapFont: cannot allocate kernings")
    if i >= font.num_kernings:
        raise ValueError("BitmapFont: invalid kerning index")
    font.kernings[i].first = int(pairs[b"first"])
    font.kernings[i].second = int(pairs[b"second"])
    font.kernings[i].amount = int(pairs[b"amount"])