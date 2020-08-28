cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.chipmunk cimport *
#from pyorama.math3d cimport *
from pyorama.physics.physics_enums cimport *
from pyorama.physics.physics_structs cimport *
from pyorama.physics.physics_utils cimport *

@cython.final
cdef class PhysicsManager:
    cdef:
        ItemSlotMap spaces
        ItemSlotMap bodies
        ItemSlotMap shapes

    cdef void c_create_slot_maps(self) except *
    cdef void c_delete_slot_maps(self) except *

    cdef SpaceC *space_get_ptr(self, Handle space) except *
    cpdef Handle space_create(self) except *
    cpdef void space_delete(self, Handle space) except *
    #cpdef void space_add_body(self, Handle space, Handle body) except *
    #cpdef void space_remove_body(self, Handle space, Handle body) except *