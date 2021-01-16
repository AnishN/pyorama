cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_manager cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.chipmunk cimport *
from pyorama.math3d cimport *
from pyorama.physics.physics_enums cimport *
from pyorama.physics.physics_structs cimport *
from pyorama.physics.physics_utils cimport *
from pyorama.physics.space cimport *

@cython.final
cdef class PhysicsManager(ItemManager):
    """
    cdef void c_create_slot_maps(self) except *
    cdef void c_delete_slot_maps(self) except *
    cdef BodyC *body_get_ptr(self, Handle body) except *
    cdef ShapeC *shape_get_ptr(self, Handle shape) except *
    cdef SpaceC *space_get_ptr(self, Handle space) except *
    """
    cpdef void update(self, float delta) except *