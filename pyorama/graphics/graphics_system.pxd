from pyorama.core.ecs_types cimport *
from pyorama.core.system cimport *

cdef class GraphicsSystem(System):

    cpdef void update(self) except *