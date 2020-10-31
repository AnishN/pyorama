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