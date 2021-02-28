cdef uint32_t c_buffer_usage_to_gl(BufferUsage usage) nogil:
    if usage == BUFFER_USAGE_STATIC:
        return GL_STATIC_DRAW
    elif usage == BUFFER_USAGE_DYNAMIC:
        return GL_DYNAMIC_DRAW
    elif usage == BUFFER_USAGE_STREAM:
        return GL_STREAM_DRAW