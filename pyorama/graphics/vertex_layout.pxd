from pyorama.core.handle cimport *
from pyorama.graphics.graphics_system cimport *

cpdef enum AttributeName:
    ATTRIBUTE_POSITION = BGFX_ATTRIB_POSITION
    ATTRIBUTE_NORMAL = BGFX_ATTRIB_NORMAL
    ATTRIBUTE_TANGENT = BGFX_ATTRIB_TANGENT
    ATTRIBUTE_BITANGENT = BGFX_ATTRIB_BITANGENT
    ATTRIBUTE_COLOR0 = BGFX_ATTRIB_COLOR0
    ATTRIBUTE_COLOR1 = BGFX_ATTRIB_COLOR1
    ATTRIBUTE_COLOR2 = BGFX_ATTRIB_COLOR2
    ATTRIBUTE_COLOR3 = BGFX_ATTRIB_COLOR3
    ATTRIBUTE_INDICES = BGFX_ATTRIB_INDICES
    ATTRIBUTE_WEIGHT = BGFX_ATTRIB_WEIGHT
    ATTRIBUTE_TEXCOORD0 = BGFX_ATTRIB_TEXCOORD0
    ATTRIBUTE_TEXCOORD1 = BGFX_ATTRIB_TEXCOORD1
    ATTRIBUTE_TEXCOORD2 = BGFX_ATTRIB_TEXCOORD2
    ATTRIBUTE_TEXCOORD3 = BGFX_ATTRIB_TEXCOORD3
    ATTRIBUTE_TEXCOORD4 = BGFX_ATTRIB_TEXCOORD4
    ATTRIBUTE_TEXCOORD5 = BGFX_ATTRIB_TEXCOORD5
    ATTRIBUTE_TEXCOORD6 = BGFX_ATTRIB_TEXCOORD6
    ATTRIBUTE_TEXCOORD7 = BGFX_ATTRIB_TEXCOORD7

cpdef enum:
    MAX_ATTRIBUTES = 16#BGFX_ATTRIB_COUNT

cpdef enum AttributeType:
    ATTRIBUTE_TYPE_U8 = BGFX_ATTRIB_TYPE_UINT8
    #ATTRIBUTE_TYPE_U10 = BGFX_ATTRIB_TYPE_UINT10
    ATTRIBUTE_TYPE_I16 = BGFX_ATTRIB_TYPE_INT16
    #ATTRIBUTE_TYPE_HALF = BGFX_ATTRIB_TYPE_HALF
    ATTRIBUTE_TYPE_F32 = BGFX_ATTRIB_TYPE_FLOAT
    #ATTRIBUTE_TYPE_COUNT = BGFX_ATTRIB_TYPE_COUNT

ctypedef struct AttributeC:
    AttributeName name
    AttributeType type_
    size_t count
    bint normalize
    bint cast_to_int

ctypedef struct VertexLayoutC:
    Handle handle
    AttributeC[MAX_ATTRIBUTES] attributes
    size_t num_attributes
    size_t vertex_size
    bgfx_vertex_layout_t bgfx_id
    char[MAX_ATTRIBUTES * 2 + 1] format_

cdef class VertexLayout(HandleObject):
    @staticmethod
    cdef VertexLayout c_from_handle(Handle handle)
    cdef VertexLayoutC *c_get_ptr(self) except *
    cpdef void create(self, list attributes) except *
    cpdef void delete(self) except *