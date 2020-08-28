from pyorama.core.handle cimport *
from pyorama.libs.chipmunk cimport *

ctypedef struct SpaceC:
    Handle handle
    cpSpace cp

ctypedef struct BodyC:
    Handle handle
    cpBody cp

ctypedef struct ShapeC:
    Handle handle
    cpShape cp