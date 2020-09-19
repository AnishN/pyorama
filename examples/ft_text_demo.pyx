import ctypes, glob
from pyorama.core.app cimport *
from pyorama.libs.freetype cimport *
from pyorama.libs.sdl2 cimport *

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
    uint8_t *buffer
    SDL_Surface *surface
    size_t i, j, k
    size_t src_index
    size_t dst_index

font_path = b"./resources/fonts/ttf/notosanstamil/NotoSansTamil-Regular.ttf"
#font_path = b"/usr/share/fonts/truetype/ubuntu.ttf"
error = FT_Init_FreeType(&library)
print(error, ft_get_error_string(error))
error = FT_New_Face(library, font_path, 0, &face)
print(error, ft_get_error_string(error))
print(face.num_glyphs)
error = FT_Set_Char_Size(face, 0, 16 * 64, 0, 0)
print(error, ft_get_error_string(error))
glyph_index = FT_Get_Char_Index(face, ord("இ"))
error = FT_Load_Glyph(face, glyph_index, FT_LOAD_DEFAULT)
print(error, ft_get_error_string(error))
for i in range(0x0000, 0x007F):
    print(i, chr(i), ord(chr(i)))

#need to map individual unicode code points into freetype glyphs for storage in a giant texture atlas
"""
font_path = b"./resources/fonts/pixel.fnt"
font = pyorama.graphics.bitmap_font_create_from_path(font_path)
text = pyorama.graphics.text_create(b"Hello World!", font)
"""

#error = FT_Get_Glyph(face.glyph, &glyph)
#print(error, ft_get_error_string(error))
error = FT_Render_Glyph(face.glyph, FT_RENDER_MODE_NORMAL)
print(error, ft_get_error_string(error))
bitmap = face.glyph.bitmap
width = bitmap.width
rows = bitmap.rows
byte_size = width * rows * 4

buffer = <uint8_t *>calloc(byte_size, sizeof(uint8_t))
if buffer == NULL:
    raise MemoryError()
for i in range(width):
    for j in range(rows):
        for k in range(4):
            buffer[dst_index] = bitmap.buffer[src_index]
            dst_index += 1
        src_index += 1

SDL_Init(SDL_INIT_EVERYTHING)
IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
surface = SDL_CreateRGBSurfaceFrom(
    buffer,
    width,
    rows,
    depth=32,
    pitch=4 * width,
    Rmask=0xFF000000,
    Gmask=0x00FF0000,
    Bmask=0x0000FF00,
    Amask=0x000000FF,
)
IMG_SavePNG(surface, b"e.png")