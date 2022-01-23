from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.graphics.image cimport *
from pyorama.libs.c cimport *

cpdef enum TextureType:
    TEXTURE_TYPE_2D
    TEXTURE_TYPE_3D
    TEXTURE_TYPE_CUBE

ctypedef struct TextureC:
    Handle handle
    bgfx_texture_handle_t bgfx_id
    #bint use_mipmaps
    #size_t num_layers
    #TextureFormat format_
    #TextureType type_
    #TextureFlags texture_flags
    #TextureSamplerFlags sampler_flags

cdef class Texture(HandleObject):

    cdef TextureC *get_ptr(self) except *
    cpdef void create_from_image(self, Image image) except *
    cpdef void delete(self) except *