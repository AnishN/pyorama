from pyorama.data.handle cimport *

ctypedef struct ProgramC:
    Handle handle
    int a