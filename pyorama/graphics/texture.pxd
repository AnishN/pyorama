from cpython.object cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.image cimport *
from pyorama.graphics.texture_enums cimport *

ctypedef struct TextureC:
    Handle handle
    uint32_t gl_id
    bint mipmaps
    TextureFilter filter
    TextureWrap wrap_s
    TextureWrap wrap_t
    TextureFormat format
    bint cubemap

cdef uint32_t c_texture_filter_to_gl(TextureFilter filter, bint mipmaps) nogil
cdef uint32_t c_texture_wrap_to_gl(TextureWrap wrap) nogil
cdef uint32_t c_texture_unit_to_gl(TextureUnit unit)
cdef uint32_t c_texture_format_to_internal_format_gl(TextureFormat format) nogil
cdef uint32_t c_texture_format_to_format_gl(TextureFormat format) nogil
cdef uint32_t c_texture_format_to_type_gl(TextureFormat format) nogil

cdef class Texture:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    cdef TextureC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, TextureFormat format=*, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*, bint cubemap=*) except *
    cpdef void delete(self) except *
    cpdef void set_parameters(self, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*) except *
    cpdef void set_data_2d_from_image(self, Image image) except *
    cpdef void set_data_cubemap_from_images(self, 
            Image pos_x, Image neg_x, Image pos_y,
            Image neg_y, Image pos_z, Image neg_z) except *
    cpdef void clear(self, uint16_t width, uint16_t height) except *