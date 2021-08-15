cdef class UserSystem:

    def __cinit__(self, str name):
        self.name = name

    def __dealloc__(self):
        self.name = None

    def init(self):
        pass
        #print(self.name, "init")
    
    def quit(self):
        pass
        #print(self.name, "quit")

    def update(self):
        pass
        #print(self.name, "update")
