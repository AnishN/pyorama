cdef class System:
    
    cpdef void init(self, dict args={}) except *:
        pass

    cpdef void free(self) except *:
        pass

    cpdef void update(self) except *:
        pass