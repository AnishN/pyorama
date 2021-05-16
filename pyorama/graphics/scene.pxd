from pyorama.core.handle cimport *
from pyorama.core.item_vector cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.node cimport *
from pyorama.math3d cimport *

ctypedef struct SceneC:
    Handle handle
    Handle root

cdef class Scene:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef SceneC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void get_root_node(self, Node root) except *
    cpdef void add_child(self, Node parent, Node child) except *
    cpdef void add_children(self, Node parent, list children) except *
    cdef void c_update_node_transform(self, Handle node, bint is_dirty) except *
    cdef void c_update_node_transforms(self) except *