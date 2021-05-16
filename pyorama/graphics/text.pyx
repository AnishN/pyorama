"""
    cpdef Handle text_create(self, Handle font, bytes data, Vec2 position, Vec4 color) except *:
        cdef:
            Handle text
            TextC *text_ptr
        text = self.texts.c_create()
        text_ptr = self.text_c_get_ptr(text)
        text_ptr.font = font
        text_ptr.data_length = len(data)
        text_ptr.data = <char *>calloc(text_ptr.data_length, sizeof(char))
        if text_ptr.data == NULL:
            raise MemoryError("Text: cannot allocate character data")
        memcpy(text_ptr.data, <char *>data, text_ptr.data_length * sizeof(char))
        text_ptr.position = position.data
        text_ptr.color = color.data
        self._text_update(text)
        return text

    cpdef void text_delete(self, Handle text) except *:
        cdef TextC *text_ptr = self.text_c_get_ptr(text)
        free(text_ptr.data)
        self.texts.c_delete(text)

    cdef void _text_update(self, Handle text) except *:
        cdef:
            TextC *text_ptr
            BitmapFontC *font_ptr
            size_t i, j
            char *c
            BitmapFontCharC *char_ptr
            Vec2C cursor
        pass
"""