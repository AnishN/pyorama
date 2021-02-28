from pyorama.core.handle cimport *
from pyorama.math3d cimport *

ctypedef struct TextC:
    Handle handle
    Handle font
    char *data
    size_t data_length
    Vec2C position
    Vec4C color

"""
    cpdef Handle text_create(self, Handle font, bytes data, Vec2 position, Vec4 color) except *
    cpdef void text_delete(self, Handle text) except *
    cdef void _text_update(self, Handle text) except *
"""