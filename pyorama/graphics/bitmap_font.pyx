"""
cpdef Handle bitmap_font_create_from_file(self, bytes file_path):
        cdef:
            Handle font
            BitmapFontC *font_ptr
            size_t num_pages
            size_t i
        font = self.bitmap_fonts.c_create()
        font_ptr = self.bitmap_font_get_ptr(font)
        self._bitmap_font_parse_file(font, file_path)
        num_pages = font_ptr.common.num_pages
        for i in range(num_pages):
            font_ptr.pages[i].texture = self.texture_create()
        return font

    cpdef void bitmap_font_delete(self, Handle font) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        free(font_ptr.pages)
        free(font_ptr.chars)
        free(font_ptr.kernings)
        self.bitmap_fonts.c_delete(font)

    cdef void _bitmap_font_parse_file(self, Handle font, bytes file_path) except *:
        cdef:
            BitmapFontC *font_ptr
            object in_file
            list lines
            bytes line
            list line_items
            bytes first
            bytes rest
            dict pairs
            size_t i_c = 0
            size_t i_k = 0
        
        font_ptr = self.bitmap_font_get_ptr(font)
        in_file = open(file_path, "rb")
        lines = in_file.readlines()
        for line in lines:
            line_items = line.split()
            first = line_items[0]
            rest = b" ".join(line_items[1:] + [b" "])
            pairs = self._bitmap_font_parse_pairs(rest)
            if first == b"info":
                self._bitmap_font_parse_info(font, pairs)
            elif first == b"common":
                self._bitmap_font_parse_common(font, pairs)
            elif first == b"page":
                self._bitmap_font_parse_page(font, pairs)
            elif first == b"chars":
                font_ptr.num_chars = int(pairs[b"count"])
            elif first == b"char":
                self._bitmap_font_parse_char(font, i_c, pairs)
                i_c += 1
            elif first == b"kernings":
                font_ptr.num_kernings = int(pairs[b"count"])
            elif first == b"kerning":
                self._bitmap_font_parse_kerning(font, i_k, pairs)
                i_k += 1
            else:
                raise ValueError("BitmapFont: invalid line tokens in .fnt file")

    cdef dict _bitmap_font_parse_pairs(self, bytes line):
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

    cdef void _bitmap_font_parse_info(self, Handle font, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        str_len = len(pairs[b"face"])
        if str_len > 255:
            raise ValueError("BitmapFont: face names > 255 characters are not supported")
        memcpy(font_ptr.info.face, <char *>pairs[b"face"], str_len)
        font_ptr.info.size = int(pairs[b"size"])
        font_ptr.info.bold = int(pairs[b"bold"])
        font_ptr.info.italic = int(pairs[b"italic"])
        str_len = len(pairs[b"charset"])
        if str_len > 255:
            raise ValueError("BitmapFont: charset names > 255 characters are not supported")
        memcpy(font_ptr.info.charset, <char *>pairs[b"charset"], str_len)
        font_ptr.info.unicode = int(pairs[b"unicode"])
        font_ptr.info.stretch_h = int(pairs[b"stretchH"])
        font_ptr.info.smooth = int(pairs[b"smooth"])
        font_ptr.info.aa = int(pairs[b"aa"])
        font_ptr.info.padding = [int(v) for v in pairs[b"padding"].split(b",")]
        font_ptr.info.spacing = [int(v) for v in pairs[b"spacing"].split(b",")]
        font_ptr.info.outline = int(pairs[b"outline"])

    cdef void _bitmap_font_parse_common(self, Handle font, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        font_ptr.common.line_height = int(pairs[b"lineHeight"])
        font_ptr.common.base = int(pairs[b"base"])
        font_ptr.common.scale_w = int(pairs[b"scaleW"])
        font_ptr.common.scale_h = int(pairs[b"scaleH"])
        font_ptr.common.num_pages = int(pairs[b"pages"])
        font_ptr.common.packed = int(pairs[b"packed"])
        font_ptr.common.alpha = int(pairs[b"alphaChnl"])
        font_ptr.common.red = int(pairs[b"redChnl"])
        font_ptr.common.green = int(pairs[b"greenChnl"])
        font_ptr.common.blue = int(pairs[b"blueChnl"])

    cdef void _bitmap_font_parse_page(self, Handle font, dict pairs) except *:
        cdef:
            BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
            size_t page_num
            size_t str_len
        
        if font_ptr.pages == NULL:
            font_ptr.pages = <BitmapFontPageC *>calloc(font_ptr.common.num_pages, sizeof(BitmapFontPageC))
            if font_ptr.pages == NULL:
                raise MemoryError("BitmapFont: cannot allocate pages")
        page_num = int(pairs[b"id"])
        font_ptr.pages[page_num].id = page_num
        str_len = len(pairs[b"file"])
        if str_len > 255:
            raise ValueError("BitmapFont: page file names > 255 characters are not supported")
        memcpy(font_ptr.pages[page_num].file_name, <char *>pairs[b"file"], str_len)

    cdef void _bitmap_font_parse_char(self, Handle font, size_t i, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        if font_ptr.chars == NULL:
            font_ptr.chars = <BitmapFontCharC *>calloc(font_ptr.num_chars, sizeof(BitmapFontCharC))
            if font_ptr.chars == NULL:
                raise MemoryError("BitmapFont: cannot allocate chars")
        if i >= font_ptr.num_chars:
            raise ValueError("BitmapFont: invalid char index")
        font_ptr.chars[i].id = int(pairs[b"id"])
        font_ptr.chars[i].x = int(pairs[b"x"])
        font_ptr.chars[i].y = int(pairs[b"y"])
        font_ptr.chars[i].width = int(pairs[b"width"])
        font_ptr.chars[i].height = int(pairs[b"height"])
        font_ptr.chars[i].offset_x = int(pairs[b"xoffset"])
        font_ptr.chars[i].offset_y = int(pairs[b"yoffset"])
        font_ptr.chars[i].advance_x = int(pairs[b"xadvance"])
        font_ptr.chars[i].page = int(pairs[b"page"])
        font_ptr.chars[i].channel = int(pairs[b"chnl"])

    cdef void _bitmap_font_parse_kerning(self, Handle font, size_t i, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        if font_ptr.kernings == NULL:
            font_ptr.kernings = <BitmapFontKerningC *>calloc(font_ptr.num_kernings, sizeof(BitmapFontKerningC))
            if font_ptr.kernings == NULL:
                raise MemoryError("BitmapFont: cannot allocate kernings")
        if i >= font_ptr.num_kernings:
            raise ValueError("BitmapFont: invalid kerning index")
        font_ptr.kernings[i].first = int(pairs[b"first"])
        font_ptr.kernings[i].second = int(pairs[b"second"])
        font_ptr.kernings[i].amount = int(pairs[b"amount"])

    cpdef Handle bitmap_font_get_page_texture(self, Handle font, size_t page_num) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        if page_num >= font_ptr.common.num_pages:
            raise ValueError("BitmapFont: invalid page number")
        return font_ptr.pages[page_num].texture
"""