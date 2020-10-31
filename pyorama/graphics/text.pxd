"""
    cpdef Handle text_create(self, Handle font, bytes data, Vec2 position, Vec4 color) except *
    cpdef void text_delete(self, Handle text) except *
    cdef void _text_update(self, Handle text) except *
"""