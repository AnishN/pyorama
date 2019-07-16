from cpython.ref cimport *
from pyorama.core.world cimport *

cdef class System:
    cdef dict __dict__
    cdef public World world
    cdef public comp_group_types
    
    cpdef void init(self, dict args=*) except *
    cpdef void free(self) except *
    cpdef void update(self) except *