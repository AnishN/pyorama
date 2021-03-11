from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.camera cimport *
from pyorama.graphics.mesh cimport *
from pyorama.math3d cimport *

#can contain mesh, skin camera, weights?

cpdef enum NodeType:
    NODE_TYPE_ROOT
    NODE_TYPE_CAMERA
    NODE_TYPE_MESH

ctypedef struct NodeC:
    Handle handle
    NodeType type
    Handle object
    Vec3C translation
    QuatC rotation
    Vec3C scale
    Mat4C local
    Mat4C world
    bint is_dirty
    Handle parent
    Handle first_child
    Handle next_sibling
    Handle prev_sibling

cdef class Node:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef NodeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef NodeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef NodeC *get_ptr(self) except *
    
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create_empty(self, NodeType type) except *
    cpdef void create_from_camera(self, Camera camera) except *
    cpdef void create_from_mesh(self, Mesh mesh) except *
    cpdef void delete(self) except *
    cpdef void get_translation(self, Vec3 translation) except *
    cpdef void set_translation(self, Vec3 translation) except *
    cpdef void get_rotation(self, Quat rotation) except *
    cpdef void set_rotation(self, Quat rotation) except *
    cpdef void get_scale(self, Vec3 scale) except *
    cpdef void set_scale(self, Vec3 scale) except *
    cpdef void get_local(self, Mat4 transform) except *
    cpdef void set_local(self, Mat4 transform) except *
    cdef void c_update_local(self) except *