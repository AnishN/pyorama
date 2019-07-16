cdef class GraphicsSystem(System):

    def __init__(self):
        pass

    cpdef void update(self) except *:
        print("amazing graphics")