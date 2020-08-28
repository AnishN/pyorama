#Based on chipmunk version 6.1.4
from pyorama.libs.c cimport *

cdef extern from "chipmunk/chipmunk_types.h" nogil:
    ctypedef double cpFloat
    cpFloat cpfmax(cpFloat a, cpFloat b)
    cpFloat cpfmin(cpFloat a, cpFloat b)
    cpFloat cpfabs(cpFloat f)
    cpFloat cpfclamp(cpFloat f, cpFloat min, cpFloat max)
    cpFloat cpfclamp01(cpFloat f)
    cpFloat cpflerp(cpFloat f1, cpFloat f2, cpFloat t)
    cpFloat cpflerpconst(cpFloat f1, cpFloat f2, cpFloat d)
    ctypedef uintptr_t cpHashValue
    ctypedef int cpBool
    cdef enum: 
        cpFalse = 0
        cpTrue = 1
    ctypedef void *cpDataPointer
    ctypedef uintptr_t cpCollisionType
    ctypedef uintptr_t cpGroup
    ctypedef unsigned int cpLayers
    ctypedef unsigned int cpTimestamp
    ctypedef struct cpVect:
        cpFloat x, y
    ctypedef struct cpMat2x2:
        cpFloat a, b, c, d

cdef extern from "chipmunk/cpVect.h" nogil:
    const cpVect cpvzero = {0.0, 0.0}
    cpVect cpv(const cpFloat x, const cpFloat y)
    cpVect cpvslerp(const cpVect v1, const cpVect v2, const cpFloat t)
    cpVect cpvslerpconst(const cpVect v1, const cpVect v2, const cpFloat a)
    char* cpvstr(const cpVect v)
    cpBool cpveql(const cpVect v1, const cpVect v2)
    cpVect cpvadd(const cpVect v1, const cpVect v2)
    cpVect cpvsub(const cpVect v1, const cpVect v2)
    cpVect cpvneg(const cpVect v)
    cpVect cpvmult(const cpVect v, const cpFloat s)
    cpFloat cpvdot(const cpVect v1, const cpVect v2)
    cpFloat cpvcross(const cpVect v1, const cpVect v2)
    cpVect cpvperp(const cpVect v)
    cpVect cpvrperp(const cpVect v)
    cpVect cpvproject(const cpVect v1, const cpVect v2)
    cpVect cpvforangle(const cpFloat a)
    cpFloat cpvtoangle(const cpVect v)
    cpVect cpvrotate(const cpVect v1, const cpVect v2)
    cpVect cpvunrotate(const cpVect v1, const cpVect v2)
    cpFloat cpvlengthsq(const cpVect v)
    cpFloat cpvlength(const cpVect v)
    cpVect cpvlerp(const cpVect v1, const cpVect v2, const cpFloat t)
    cpVect cpvnormalize(const cpVect v)
    cpVect cpvnormalize_safe(const cpVect v)
    cpVect cpvclamp(const cpVect v, const cpFloat len)
    cpVect cpvlerpconst(cpVect v1, cpVect v2, cpFloat d)
    cpFloat cpvdist(const cpVect v1, const cpVect v2)
    cpFloat cpvdistsq(const cpVect v1, const cpVect v2)
    cpBool cpvnear(const cpVect v1, const cpVect v2, const cpFloat dist)
    cpMat2x2 cpMat2x2New(cpFloat a, cpFloat b, cpFloat c, cpFloat d)
    cpVect cpMat2x2Transform(cpMat2x2 m, cpVect v)

cdef extern from "chipmunk/cpBB.h" nogil:
    ctypedef struct cpBB:
        cpFloat l, b, r, t
    cpBB cpBBNew(const cpFloat l, const cpFloat b, const cpFloat r, const cpFloat t)
    cpBB cpBBNewForCircle(const cpVect p, const cpFloat r)
    cpBool cpBBIntersects(const cpBB a, const cpBB b)
    cpBool cpBBContainsBB(const cpBB bb, const cpBB other)
    cpBool cpBBContainsVect(const cpBB bb, const cpVect v)
    cpBB cpBBMerge(const cpBB a, const cpBB b)
    cpBB cpBBExpand(const cpBB bb, const cpVect v)
    cpFloat cpBBArea(cpBB bb)
    cpFloat cpBBMergedArea(cpBB a, cpBB b)
    cpFloat cpBBSegmentQuery(cpBB bb, cpVect a, cpVect b)
    cpBool cpBBIntersectsSegment(cpBB bb, cpVect a, cpVect b)
    cpVect cpBBClampVect(const cpBB bb, const cpVect v)
    cpVect cpBBWrapVect(const cpBB bb, const cpVect v)

"""
cdef extern from "chipmunk/chipmunk.h" nogil:
    void cpMessage(const char *condition, const char *file, int line, int isError, int isHardError, const char *message, ...)
    ctypedef struct cpArray
    ctypedef struct cpHashSet
    ctypedef struct cpBody
    ctypedef struct cpShape
    ctypedef struct cpConstraint
    ctypedef struct cpCollisionHandler
    ctypedef struct cpArbiter
    ctypedef struct cpSpace
    cdef enum:
        CP_VERSION_MAJOR = 6
        CP_VERSION_MINOR = 1
        CP_VERSION_RELEASE = 4
    const char *cpVersionString
"""
 
"""
/// @deprecated
void cpInitChipmunk(void);

/// Enables segment to segment shape collisions.
void cpEnableSegmentToSegmentCollisions(void);


/// Calculate the moment of inertia for a circle.
/// @c r1 and @c r2 are the inner and outer diameters. A solid circle has an inner diameter of 0.
cpFloat cpMomentForCircle(cpFloat m, cpFloat r1, cpFloat r2, cpVect offset);

/// Calculate area of a hollow circle.
/// @c r1 and @c r2 are the inner and outer diameters. A solid circle has an inner diameter of 0.
cpFloat cpAreaForCircle(cpFloat r1, cpFloat r2);

/// Calculate the moment of inertia for a line segment.
/// Beveling radius is not supported.
cpFloat cpMomentForSegment(cpFloat m, cpVect a, cpVect b);

/// Calculate the area of a fattened (capsule shaped) line segment.
cpFloat cpAreaForSegment(cpVect a, cpVect b, cpFloat r);

/// Calculate the moment of inertia for a solid polygon shape assuming it's center of gravity is at it's centroid. The offset is added to each vertex.
cpFloat cpMomentForPoly(cpFloat m, int numVerts, const cpVect *verts, cpVect offset);

/// Calculate the signed area of a polygon. A Clockwise winding gives positive area.
/// This is probably backwards from what you expect, but matches Chipmunk's the winding for poly shapes.
cpFloat cpAreaForPoly(const int numVerts, const cpVect *verts);

/// Calculate the natural centroid of a polygon.
cpVect cpCentroidForPoly(const int numVerts, const cpVect *verts);

/// Center the polygon on the origin. (Subtracts the centroid of the polygon from each vertex)
void cpRecenterPoly(const int numVerts, cpVect *verts);

/// Calculate the moment of inertia for a solid box.
cpFloat cpMomentForBox(cpFloat m, cpFloat width, cpFloat height);

/// Calculate the moment of inertia for a solid box.
cpFloat cpMomentForBox2(cpFloat m, cpBB box);

/// Calculate the convex hull of a given set of points. Returns the count of points in the hull.
/// @c result must be a pointer to a @c cpVect array with at least @c count elements. If @c result is @c NULL, then @c verts will be reduced instead.
/// @c first is an optional pointer to an integer to store where the first vertex in the hull came from (i.e. verts[first] == result[0])
/// @c tol is the allowed amount to shrink the hull when simplifying it. A tolerance of 0.0 creates an exact hull.
int cpConvexHull(int count, cpVect *verts, cpVect *result, int *first, cpFloat tol);

#ifdef _MSC_VER
#include "malloc.h"
#endif

/// Convenience macro to work with cpConvexHull.
/// @c count and @c verts is the input array passed to cpConvexHull().
/// @c count_var and @c verts_var are the names of the variables the macro creates to store the result.
/// The output vertex array is allocated on the stack using alloca() so it will be freed automatically, but cannot be returned from the current scope.
#define CP_CONVEX_HULL(__count__, __verts__, __count_var__, __verts_var__) \
cpVect *__verts_var__ = (cpVect *)alloca(__count__*sizeof(cpVect)); \
int __count_var__ = cpConvexHull(__count__, __verts__, __verts_var__, NULL, 0.0); \

#if defined(__has_extension)
#if __has_extension(blocks)
// Define alternate block based alternatives for a few of the callback heavy functions.
// Collision handlers are post-step callbacks are not included to avoid memory management issues.
// If you want to use blocks for those and are aware of how to correctly manage the memory, the implementation is trivial. 

void cpSpaceEachBody_b(cpSpace *space, void (^block)(cpBody *body));
void cpSpaceEachShape_b(cpSpace *space, void (^block)(cpShape *shape));
void cpSpaceEachConstraint_b(cpSpace *space, void (^block)(cpConstraint *constraint));

void cpBodyEachShape_b(cpBody *body, void (^block)(cpShape *shape));
void cpBodyEachConstraint_b(cpBody *body, void (^block)(cpConstraint *constraint));
void cpBodyEachArbiter_b(cpBody *body, void (^block)(cpArbiter *arbiter));

typedef void (^cpSpaceNearestPointQueryBlock)(cpShape *shape, cpFloat distance, cpVect point);
void cpSpaceNearestPointQuery_b(cpSpace *space, cpVect point, cpFloat maxDistance, cpLayers layers, cpGroup group, cpSpaceNearestPointQueryBlock block);

typedef void (^cpSpaceSegmentQueryBlock)(cpShape *shape, cpFloat t, cpVect n);
void cpSpaceSegmentQuery_b(cpSpace *space, cpVect start, cpVect end, cpLayers layers, cpGroup group, cpSpaceSegmentQueryBlock block);

typedef void (^cpSpaceBBQueryBlock)(cpShape *shape);
void cpSpaceBBQuery_b(cpSpace *space, cpBB bb, cpLayers layers, cpGroup group, cpSpaceBBQueryBlock block);

typedef void (^cpSpaceShapeQueryBlock)(cpShape *shape, cpContactPointSet *points);
cpBool cpSpaceShapeQuery_b(cpSpace *space, cpShape *shape, cpSpaceShapeQueryBlock block);

#endif
#endif


//@}

#ifdef __cplusplus
}

static inline cpVect operator *(const cpVect v, const cpFloat s){return cpvmult(v, s);}
static inline cpVect operator +(const cpVect v1, const cpVect v2){return cpvadd(v1, v2);}
static inline cpVect operator -(const cpVect v1, const cpVect v2){return cpvsub(v1, v2);}
static inline cpBool operator ==(const cpVect v1, const cpVect v2){return cpveql(v1, v2);}
static inline cpVect operator -(const cpVect v){return cpvneg(v);}

#endif
#endif
"""