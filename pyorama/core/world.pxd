from cpython.bytes cimport *
from cpython.ref cimport *
from pyorama.core.comp_map cimport *
from pyorama.core.comp_mask cimport *
from pyorama.core.ecs_types cimport *
from pyorama.core.system cimport *
from pyorama.libs.c cimport *

ctypedef struct EntityInfo:
    CompMask comp_mask
    Comp comps[256]

ctypedef struct CompInfo:
    bint is_registered
    size_t size
    char *format
    size_t format_length
    PyObject *comp_map

ctypedef struct CompGroupInfo:
    bint is_registered
    bint comp_types[256]#stores the index of the comp_types
    Comp *comps#maps a 2d array of data, abc, abc, abc ... layout
    size_t num_comp_types
    size_t num_matches

cdef class World:

    cdef:
        size_t max_entities
        CompMap entities
        CompInfo comps[256]
        CompGroupInfo comp_groups[65536]
        list systems

    cpdef void init(self, size_t max_entities) except *
    cpdef void free(self) except *
    
    cpdef void register_comp_type(self, CompType comp_type, size_t max_comps, size_t comp_size, bytes comp_format) except *
    cpdef size_t get_comp_type_size(self, CompType comp_type) except 0
    cpdef bytes get_comp_type_format(self, CompType comp_type)
    cpdef bint is_comp_type_registered(self, CompType comp_type)
    cpdef void register_comp_group_type(self, CompGroupType comp_group_type, list comp_types) except *
    cpdef Comp create_comp(self, CompType comp_type) except 0
    cpdef int delete_comp(self, Comp comp) except -1
    cpdef list get_comp_group(self, CompGroupType comp_group_type)
    cpdef Comp[:, ::1] get_comp_group_data(self, CompGroupType comp_group_type) except *

    cpdef Entity create_entity(self) except 0
    cpdef int delete_entity(self, Entity entity) except -1
    cpdef int attach_comp(self, Entity entity, Comp comp) except -1
    cpdef int detach_comp(self, Entity entity, Comp comp) except -1

    cpdef void attach_system(self, System system, dict comp_group_types) except *
    cpdef void detach_system(self, System system) except *
    cpdef void set_system_update_order(self, list systems) except *

    cpdef void update(self) except *