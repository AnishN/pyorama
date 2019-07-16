from cpython.buffer cimport *
from pyorama.core.ecs_types cimport *
from pyorama.core.comp_array cimport *
from pyorama.libs.c cimport *

cdef class CompMap:
    cdef readonly size_t max_comps
    cdef readonly size_t comp_size
    cdef readonly bytes comp_format
    cdef readonly CompType comp_type
    
    cdef readonly CompArray comps
    cdef readonly size_t num_comps
    cdef CompArray indices
    cdef size_t num_indices
    cdef CompArray erase
    cdef uint32_t free_list_head
    cdef uint32_t free_list_tail
    
    cpdef void init(self, size_t max_comps, CompType comp_type, size_t comp_size, bytes comp_format) except *
    cpdef void free(self)

    cpdef Comp create(self) except 0
    cpdef int delete(self, Comp comp) except -1

    cdef void *c_get(self, Comp comp) nogil
    cdef uint32_t c_get_index(self, Comp comp) nogil
    cdef bint c_is_free_list_empty(self) nogil
    cdef bint c_is_comp_valid(self, Comp comp) nogil