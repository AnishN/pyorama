cdef class UserSystem(object):

    def __cinit__(self, str name):
        self.name = name

    def __dealloc__(self):
        self.name = None

    def init(self):
        pass
    
    def quit(self):
        pass

    def update(self):
        pass
