from cpython.object cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.image cimport *

cdef class Texture:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef TextureC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef TextureC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef TextureC *get_ptr(self) except *
    cpdef void create(self, TextureFormat format=*, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*, bint cubemap=*) except *
    cpdef void delete(self) except *
    cpdef void set_parameters(self, bint mipmaps=*, TextureFilter filter=*, TextureWrap wrap_s=*, TextureWrap wrap_t=*) except *
    cpdef void set_data_2d_from_image(self, Image image) except *
    cpdef void set_data_cubemap_from_images(self, 
            Image pos_x, Image neg_x, Image pos_y,
            Image neg_y, Image pos_z, Image neg_z) except *
    cpdef void clear(self, uint16_t width, uint16_t height) except *