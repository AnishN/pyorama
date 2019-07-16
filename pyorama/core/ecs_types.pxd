from pyorama.core.handle cimport *
from pyorama.libs.c cimport *

ctypedef Handle Entity
ctypedef Handle Comp
ctypedef uint8_t CompType
ctypedef struct CompMask:
    uint8_t[32] bits
ctypedef struct CompIds:
    Comp[256] comps
ctypedef uint16_t CompGroupType