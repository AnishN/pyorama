from pyorama.libs.c cimport *
from pyorama.libs.gles2 cimport *

cpdef enum BufferUsage:
    BUFFER_USAGE_STATIC
    BUFFER_USAGE_DYNAMIC
    BUFFER_USAGE_STREAM

cpdef enum VertexCompType:
    VERTEX_COMP_TYPE_F32
    VERTEX_COMP_TYPE_I8
    VERTEX_COMP_TYPE_U8
    VERTEX_COMP_TYPE_I16
    VERTEX_COMP_TYPE_U16

cpdef enum IndexFormat:
    INDEX_FORMAT_U8
    INDEX_FORMAT_U16
    INDEX_FORMAT_U32

cdef uint32_t c_buffer_usage_to_gl(BufferUsage usage) nogil