from pyorama.core.handle cimport *
from pyorama.libs.chipmunk cimport *

ctypedef struct SpaceC:
    Handle handle
    cpSpace *cp

ctypedef struct BodyC:
    Handle handle
    cpBody *cp

"""
cdef union ShapeTypeC:
    cpSegmentShape *segment
    cpCircleShape *circle
    cpPolyShape *poly
    cpShape *shape
"""

ctypedef struct ShapeC:
    Handle handle
    cpShape *cp