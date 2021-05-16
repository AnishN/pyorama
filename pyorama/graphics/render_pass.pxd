from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.camera cimport *
from pyorama.graphics.scene cimport *

ctypedef struct RenderPassC:
    Handle handle
    Handle positions
    Handle colors
    Handle depths
    Handle scene
    Handle camera

cdef class RenderPass:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef RenderPassC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, Scene scene, Camera camera, Texture positions, Texture colors, Texture depths) except *
    cpdef void delete(self) except *