import ctypes, glob
from pyorama.core.app cimport *
from pyorama.libs.freetype cimport *

cdef extern from *:
    """
    #include <ft2build.h>
    #include FT_FREETYPE_H

    const char *ft_get_error_string(FT_Error err)
    {
        #undef FTERRORS_H_
        #define FT_ERRORDEF( e, v, s )  case e: return s;
        #define FT_ERROR_START_LIST     switch (err) {
        #define FT_ERROR_END_LIST       }
        #include FT_ERRORS_H
        return "(Unknown error)";
    }
    """
    const char *ft_get_error_string(FT_Error err)

cdef:
    FT_Library library
    FT_Face face
    #FT_Glyph glyph
    bytes font_path
    size_t width
    FT_Bitmap bitmap
    size_t rows
    size_t byte_size
    uint8_t[:, :] buffer

font_path = b"./resources/fonts/notosanstamil/NotoSansTamil-Regular.ttf"
#font_path = b"/usr/share/fonts/truetype/ubuntu.ttf"
error = FT_Init_FreeType(&library)
print(error, ft_get_error_string(error))
error = FT_New_Face(library, font_path, 0, &face)
print(error, ft_get_error_string(error))
print(face.num_glyphs)
error = FT_Set_Char_Size(face, 0, 16 * 64, 300, 300)
print(error, ft_get_error_string(error))
glyph_index = FT_Get_Char_Index(face, ord(u"இ"))
error = FT_Load_Glyph(face, glyph_index, FT_LOAD_DEFAULT)
print(error, ft_get_error_string(error))
#error = FT_Get_Glyph(face.glyph, &glyph)
#print(error, ft_get_error_string(error))
error = FT_Render_Glyph(face.glyph, FT_RENDER_MODE_NORMAL)
print(error, ft_get_error_string(error))
bitmap = face.glyph.bitmap
width = bitmap.width
rows = bitmap.rows
byte_size = width * rows * 4
buffer = <uint8_t[:rows, :width]>bitmap.buffer

import numpy as np
import imageio
print(
    width,
    rows,
    np.array(buffer),
)
imageio.imwrite("a.png", np.array(buffer))