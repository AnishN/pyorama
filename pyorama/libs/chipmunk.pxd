#Based on chipmunk version 7.0.3
from pyorama.libs.c cimport *

cdef extern from "chipmunk/chipmunk_types.h" nogil:
    ctypedef float cpFloat
    cpFloat cpfmax(cpFloat a, cpFloat b)
    cpFloat cpfmin(cpFloat a, cpFloat b)
    cpFloat cpfabs(cpFloat f)
    cpFloat cpfclamp(cpFloat f, cpFloat min, cpFloat max)
    cpFloat cpfclamp01(cpFloat f)
    cpFloat cpflerp(cpFloat f1, cpFloat f2, cpFloat t)
    cpFloat cpflerpconst(cpFloat f1, cpFloat f2, cpFloat d)
    ctypedef uintptr_t cpHashValue
    ctypedef uint32_t cpCollisionID
    ctypedef unsigned char cpBool
    cdef enum: cpTrue = 1
    cdef enum: cpFalse = 0
    ctypedef void *cpDataPointer
    ctypedef uintptr_t cpCollisionType
    ctypedef uintptr_t cpGroup
    ctypedef unsigned int cpBitmask
    ctypedef unsigned int cpTimestamp
    ctypedef struct cpVect:
        cpFloat x
        cpFloat y
    ctypedef struct cpTransform:
        cpFloat a
        cpFloat b
        cpFloat c
        cpFloat d
        cpFloat tx
        cpFloat ty
    ctypedef struct cpMat2x2:
        cpFloat a
        cpFloat b
        cpFloat c
        cpFloat d

cdef extern from "chipmunk/cpVect.h" nogil:
    const cpVect cpvzero = {0.0, 0.0}
    cpVect cpv(const cpFloat x, const cpFloat y)
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
    cpVect cpvslerp(const cpVect v1, const cpVect v2, const cpFloat t)
    cpVect cpvslerpconst(const cpVect v1, const cpVect v2, const cpFloat a)
    cpVect cpvclamp(const cpVect v, const cpFloat len)
    cpVect cpvlerpconst(cpVect v1, cpVect v2, cpFloat d)
    cpFloat cpvdist(const cpVect v1, const cpVect v2)
    cpFloat cpvdistsq(const cpVect v1, const cpVect v2)
    cpBool cpvnear(const cpVect v1, const cpVect v2, const cpFloat dist)
    cpMat2x2 cpMat2x2New(cpFloat a, cpFloat b, cpFloat c, cpFloat d)
    cpVect cpMat2x2Transform(cpMat2x2 m, cpVect v)

cdef extern from "chipmunk/cpBB.h" nogil:
    ctypedef struct cpBB:
        cpFloat l
        cpFloat b
        cpFloat r
        cpFloat t
    cpBB cpBBNew(const cpFloat l, const cpFloat b, const cpFloat r, const cpFloat t)
    cpBB cpBBNewForExtents(const cpVect c, const cpFloat hw, const cpFloat hh)
    cpBB cpBBNewForCircle(const cpVect p, const cpFloat r)
    cpBool cpBBIntersects(const cpBB a, const cpBB b)
    cpBool cpBBContainsBB(const cpBB bb, const cpBB other)
    cpBool cpBBContainsVect(const cpBB bb, const cpVect v)
    cpBB cpBBMerge(const cpBB a, const cpBB b)
    cpBB cpBBExpand(const cpBB bb, const cpVect v)
    cpVect cpBBCenter(cpBB bb)
    cpFloat cpBBArea(cpBB bb)
    cpFloat cpBBMergedArea(cpBB a, cpBB b)
    cpFloat cpBBSegmentQuery(cpBB bb, cpVect a, cpVect b)
    cpBool cpBBIntersectsSegment(cpBB bb, cpVect a, cpVect b)
    cpVect cpBBClampVect(const cpBB bb, const cpVect v)
    cpVect cpBBWrapVect(const cpBB bb, const cpVect v)
    cpBB cpBBOffset(const cpBB bb, const cpVect v)


cdef extern from "chipmunk/cpTransform.h" nogil:
    const cpTransform cpTransformIdentity = {1.0, 0.0, 0.0, 1.0, 0.0, 0.0}
    cpTransform cpTransformNew(cpFloat a, cpFloat b, cpFloat c, cpFloat d, cpFloat tx, cpFloat ty)
    cpTransform cpTransformNewTranspose(cpFloat a, cpFloat c, cpFloat tx, cpFloat b, cpFloat d, cpFloat ty)
    cpTransform cpTransformInverse(cpTransform t)
    cpTransform cpTransformMult(cpTransform t1, cpTransform t2)
    cpVect cpTransformPoint(cpTransform t, cpVect p)
    cpVect cpTransformVect(cpTransform t, cpVect v)
    cpBB cpTransformbBB(cpTransform t, cpBB bb)
    cpTransform cpTransformTranslate(cpVect translate)
    cpTransform cpTransformScale(cpFloat scaleX, cpFloat scaleY)
    cpTransform cpTransformRotate(cpFloat radians)
    cpTransform cpTransformRigid(cpVect translate, cpFloat radians)
    cpTransform cpTransformRigidInverse(cpTransform t)
    cpTransform cpTransformWrap(cpTransform outer, cpTransform inner)
    cpTransform cpTransformWrapInverse(cpTransform outer, cpTransform inner)
    cpTransform cpTransformOrtho(cpBB bb)
    cpTransform cpTransformBoneScale(cpVect v0, cpVect v1)
    cpTransform cpTransformAxialScale(cpVect axis, cpVect pivot, cpFloat scale)

cdef extern from "chipmunk/chipmunk.h" nogil:
    void cpMessage(const char *condition, const char *file, int line, int isError, int isHardError, const char *message, ...)
    ctypedef struct cpArray
    ctypedef struct cpHashSet
    ctypedef struct cpBody
    ctypedef struct cpShape
    ctypedef struct cpCircleShape
    ctypedef struct cpSegmentShape
    ctypedef struct cpPolyShape
    ctypedef struct cpConstraint
    ctypedef struct cpPinJoint
    ctypedef struct cpSlideJoint
    ctypedef struct cpPivotJoint
    ctypedef struct cpGrooveJoint
    ctypedef struct cpDampedSpring
    ctypedef struct cpDampedRotarySpring
    ctypedef struct cpRotaryLimitJoint
    ctypedef struct cpRatchetJoint
    ctypedef struct cpGearJoint
    ctypedef struct cpSimpleMotorJoint
    ctypedef struct cpCollisionHandler
    ctypedef struct cpContactPointSet
    ctypedef struct cpArbiter
    ctypedef struct cpSpace
    cdef enum: CP_VERSION_MAJOR = 7
    cdef enum: CP_VERSION_MINOR = 0
    cdef enum: CP_VERSION_RELEASE = 3
    const char *cpVersionString
    cpFloat cpMomentForCircle(cpFloat m, cpFloat r1, cpFloat r2, cpVect offset)
    cpFloat cpAreaForCircle(cpFloat r1, cpFloat r2)
    cpFloat cpMomentForSegment(cpFloat m, cpVect a, cpVect b, cpFloat radius)
    cpFloat cpAreaForSegment(cpVect a, cpVect b, cpFloat radius)
    cpFloat cpMomentForPoly(cpFloat m, int count, const cpVect *verts, cpVect offset, cpFloat radius)
    cpFloat cpAreaForPoly(const int count, const cpVect *verts, cpFloat radius)
    cpVect cpCentroidForPoly(const int count, const cpVect *verts)
    cpFloat cpMomentForBox(cpFloat m, cpFloat width, cpFloat height)
    cpFloat cpMomentForBox2(cpFloat m, cpBB box)
    int cpConvexHull(int count, const cpVect *verts, cpVect *result, int *first, cpFloat tol)
    cpVect cpClosetPointOnSegment(const cpVect p, const cpVect a, const cpVect b)

    #cpSpatialIndex.h
    ctypedef cpBB (*cpSpatialIndexBBFunc)(void *obj)
    ctypedef void (*cpSpatialIndexIteratorFunc)(void *obj, void *data)
    ctypedef cpCollisionID (*cpSpatialIndexQueryFunc)(void *obj1, void *obj2, cpCollisionID id, void *data)
    ctypedef cpFloat (*cpSpatialIndexSegmentQueryFunc)(void *obj1, void *obj2, void *data)
    ctypedef struct cpSpatialIndexClass
    ctypedef struct cpSpatialIndex
    ctypedef struct cpSpatialIndex:
        cpSpatialIndexClass *klass
        cpSpatialIndexBBFunc bbfunc
        cpSpatialIndex *staticIndex
        cpSpatialIndex *dynamicIndex
    ctypedef struct cpSpaceHash
    cpSpaceHash* cpSpaceHashAlloc()
    cpSpatialIndex* cpSpaceHashInit(cpSpaceHash *hash, cpFloat celldim, int numcells, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    cpSpatialIndex* cpSpaceHashNew(cpFloat celldim, int cells, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    void cpSpaceHashResize(cpSpaceHash *hash, cpFloat celldim, int numcells)
    ctypedef struct cpBBTree
    cpBBTree* cpBBTreeAlloc()
    cpSpatialIndex* cpBBTreeInit(cpBBTree *tree, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    cpSpatialIndex* cpBBTreeNew(cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    void cpBBTreeOptimize(cpSpatialIndex *index)
    ctypedef cpVect (*cpBBTreeVelocityFunc)(void *obj)
    void cpBBTreeSetVelocityFunc(cpSpatialIndex *index, cpBBTreeVelocityFunc func)
    ctypedef struct cpSweep1D
    cpSweep1D* cpSweep1DAlloc()
    cpSpatialIndex* cpSweep1DInit(cpSweep1D *sweep, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    cpSpatialIndex* cpSweep1DNew(cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    ctypedef void (*cpSpatialIndexDestroyImpl)(cpSpatialIndex *index)
    ctypedef int (*cpSpatialIndexCountImpl)(cpSpatialIndex *index)
    ctypedef void (*cpSpatialIndexEachImpl)(cpSpatialIndex *index, cpSpatialIndexIteratorFunc func, void *data)
    ctypedef cpBool (*cpSpatialIndexContainsImpl)(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    ctypedef void (*cpSpatialIndexInsertImpl)(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    ctypedef void (*cpSpatialIndexRemoveImpl)(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    ctypedef void (*cpSpatialIndexReindexImpl)(cpSpatialIndex *index)
    ctypedef void (*cpSpatialIndexReindexObjectImpl)(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    ctypedef void (*cpSpatialIndexReindexQueryImpl)(cpSpatialIndex *index, cpSpatialIndexQueryFunc func, void *data)
    ctypedef void (*cpSpatialIndexQueryImpl)(cpSpatialIndex *index, void *obj, cpBB bb, cpSpatialIndexQueryFunc func, void *data)
    ctypedef void (*cpSpatialIndexSegmentQueryImpl)(cpSpatialIndex *index, void *obj, cpVect a, cpVect b, cpFloat t_exit, cpSpatialIndexSegmentQueryFunc func, void *data)
    ctypedef struct cpSpatialIndexClass:
        cpSpatialIndexDestroyImpl destroy
        cpSpatialIndexCountImpl count
        cpSpatialIndexEachImpl each
        cpSpatialIndexContainsImpl contains
        cpSpatialIndexInsertImpl insert
        cpSpatialIndexRemoveImpl remove
        cpSpatialIndexReindexImpl reindex
        cpSpatialIndexReindexObjectImpl reindexObject
        cpSpatialIndexReindexQueryImpl reindexQuery
        cpSpatialIndexQueryImpl query
        cpSpatialIndexSegmentQueryImpl segmentQuery
    void cpSpatialIndexFree(cpSpatialIndex *index)
    void cpSpatialIndexCollideStatic(cpSpatialIndex *dynamicIndex, cpSpatialIndex *staticIndex, cpSpatialIndexQueryFunc func, void *data)
    void cpSpatialIndexDestroy(cpSpatialIndex *index)
    int cpSpatialIndexCount(cpSpatialIndex *index)
    void cpSpatialIndexEach(cpSpatialIndex *index, cpSpatialIndexIteratorFunc func, void *data)
    cpBool cpSpatialIndexContains(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    void cpSpatialIndexInsert(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    void cpSpatialIndexRemove(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    void cpSpatialIndexReindex(cpSpatialIndex *index)
    void cpSpatialIndexReindexObject(cpSpatialIndex *index, void *obj, cpHashValue hashid)
    void cpSpatialIndexQuery(cpSpatialIndex *index, void *obj, cpBB bb, cpSpatialIndexQueryFunc func, void *data)
    void cpSpatialIndexSegmentQuery(cpSpatialIndex *index, void *obj, cpVect a, cpVect b, cpFloat t_exit, cpSpatialIndexSegmentQueryFunc func, void *data)
    void cpSpatialIndexReindexQuery(cpSpatialIndex *index, cpSpatialIndexQueryFunc func, void *data)

    #cpArbiter.h
    cdef enum: CP_MAX_CONTACTS_PER_ARBITER = 2
    cpFloat cpArbiterGetRestitution(const cpArbiter *arb)
    void cpArbiterSetRestitution(cpArbiter *arb, cpFloat restitution)
    cpFloat cpArbiterGetFriction(const cpArbiter *arb)
    void cpArbiterSetFriction(cpArbiter *arb, cpFloat friction)
    cpVect cpArbiterGetSurfaceVelocity(cpArbiter *arb)
    void cpArbiterSetSurfaceVelocity(cpArbiter *arb, cpVect vr)
    cpDataPointer cpArbiterGetUserData(const cpArbiter *arb)
    void cpArbiterSetUserData(cpArbiter *arb, cpDataPointer userData)
    cpVect cpArbiterTotalImpulse(const cpArbiter *arb)
    cpFloat cpArbiterTotalKE(const cpArbiter *arb)
    cpBool cpArbiterIgnore(cpArbiter *arb)
    void cpArbiterGetShapes(const cpArbiter *arb, cpShape **a, cpShape **b)
    void cpArbiterGetBodies(const cpArbiter *arb, cpBody **a, cpBody **b)
    ctypedef struct cpContactPointSetSub:
        cpVect pointA
        cpVect pointB
        cpFloat distance
    ctypedef struct cpContactPointSet:
        int count
        cpVect normal
        cpContactPointSetSub points[CP_MAX_CONTACTS_PER_ARBITER]
    cpContactPointSet cpArbiterGetContactPointSet(const cpArbiter *arb)
    void cpArbiterSetContactPointSet(cpArbiter *arb, cpContactPointSet *set)
    cpBool cpArbiterIsFirstContact(const cpArbiter *arb)
    cpBool cpArbiterIsRemoval(const cpArbiter *arb)
    int cpArbiterGetCount(const cpArbiter *arb)
    cpVect cpArbiterGetNormal(const cpArbiter *arb)
    cpVect cpArbiterGetPointA(const cpArbiter *arb, int i)
    cpVect cpArbiterGetPointB(const cpArbiter *arb, int i)
    cpFloat cpArbiterGetDepth(const cpArbiter *arb, int i)
    cpBool cpArbiterCallWildcardBeginA(cpArbiter *arb, cpSpace *space)
    cpBool cpArbiterCallWildcardBeginB(cpArbiter *arb, cpSpace *space)
    cpBool cpArbiterCallWildcardPreSolveA(cpArbiter *arb, cpSpace *space)
    cpBool cpArbiterCallWildcardPreSolveB(cpArbiter *arb, cpSpace *space)
    void cpArbiterCallWildcardPostSolveA(cpArbiter *arb, cpSpace *space)
    void cpArbiterCallWildcardPostSolveB(cpArbiter *arb, cpSpace *space)
    void cpArbiterCallWildcardSeparateA(cpArbiter *arb, cpSpace *space)
    void cpArbiterCallWildcardSeparateB(cpArbiter *arb, cpSpace *space)

    #cpBody.h
    ctypedef enum cpBodyType:
        CP_BODY_TYPE_DYNAMIC
        CP_BODY_TYPE_KINEMATIC
        CP_BODY_TYPE_STATIC
    ctypedef void (*cpBodyVelocityFunc)(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
    ctypedef void (*cpBodyPositionFunc)(cpBody *body, cpFloat dt)
    cpBody* cpBodyAlloc()
    cpBody* cpBodyInit(cpBody *body, cpFloat mass, cpFloat moment)
    cpBody* cpBodyNew(cpFloat mass, cpFloat moment)
    cpBody* cpBodyNewKinematic()
    cpBody* cpBodyNewStatic()
    void cpBodyDestroy(cpBody *body)
    void cpBodyFree(cpBody *body)
    void cpBodyActivate(cpBody *body)
    void cpBodyActivateStatic(cpBody *body, cpShape *filter)
    void cpBodySleep(cpBody *body)
    void cpBodySleepWithGroup(cpBody *body, cpBody *group)
    cpBool cpBodyIsSleeping(const cpBody *body)
    cpBodyType cpBodyGetType(cpBody *body)
    void cpBodySetType(cpBody *body, cpBodyType type)
    cpSpace* cpBodyGetSpace(const cpBody *body)
    cpFloat cpBodyGetMass(const cpBody *body)
    void cpBodySetMass(cpBody *body, cpFloat m)
    cpFloat cpBodyGetMoment(const cpBody *body)
    void cpBodySetMoment(cpBody *body, cpFloat i)
    cpVect cpBodyGetPosition(const cpBody *body)
    void cpBodySetPosition(cpBody *body, cpVect pos)
    cpVect cpBodyGetCenterOfGravity(const cpBody *body)
    void cpBodySetCenterOfGravity(cpBody *body, cpVect cog)
    cpVect cpBodyGetVelocity(const cpBody *body)
    void cpBodySetVelocity(cpBody *body, cpVect velocity)
    cpVect cpBodyGetForce(const cpBody *body)
    void cpBodySetForce(cpBody *body, cpVect force)
    cpFloat cpBodyGetAngle(const cpBody *body)
    void cpBodySetAngle(cpBody *body, cpFloat a)
    cpFloat cpBodyGetAngularVelocity(const cpBody *body)
    void cpBodySetAngularVelocity(cpBody *body, cpFloat angularVelocity)
    cpFloat cpBodyGetTorque(const cpBody *body)
    void cpBodySetTorque(cpBody *body, cpFloat torque)
    cpVect cpBodyGetRotation(const cpBody *body)
    cpDataPointer cpBodyGetUserData(const cpBody *body)
    void cpBodySetUserData(cpBody *body, cpDataPointer userData)
    void cpBodySetVelocityUpdateFunc(cpBody *body, cpBodyVelocityFunc velocityFunc)
    void cpBodySetPositionUpdateFunc(cpBody *body, cpBodyPositionFunc positionFunc)
    void cpBodyUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
    void cpBodyUpdatePosition(cpBody *body, cpFloat dt)
    cpVect cpBodyLocalToWorld(const cpBody *body, const cpVect point)
    cpVect cpBodyWorldToLocal(const cpBody *body, const cpVect point)
    void cpBodyApplyForceAtWorldPoint(cpBody *body, cpVect force, cpVect point)
    void cpBodyApplyForceAtLocalPoint(cpBody *body, cpVect force, cpVect point)
    void cpBodyApplyImpulseAtWorldPoint(cpBody *body, cpVect impulse, cpVect point)
    void cpBodyApplyImpulseAtLocalPoint(cpBody *body, cpVect impulse, cpVect point)
    cpVect cpBodyGetVelocityAtWorldPoint(const cpBody *body, cpVect point)
    cpVect cpBodyGetVelocityAtLocalPoint(const cpBody *body, cpVect point)
    cpFloat cpBodyKineticEnergy(const cpBody *body)
    ctypedef void (*cpBodyShapeIteratorFunc)(cpBody *body, cpShape *shape, void *data)
    void cpBodyEachShape(cpBody *body, cpBodyShapeIteratorFunc func, void *data)
    ctypedef void (*cpBodyConstraintIteratorFunc)(cpBody *body, cpConstraint *constraint, void *data)
    void cpBodyEachConstraint(cpBody *body, cpBodyConstraintIteratorFunc func, void *data)
    ctypedef void (*cpBodyArbiterIteratorFunc)(cpBody *body, cpArbiter *arbiter, void *data)
    void cpBodyEachArbiter(cpBody *body, cpBodyArbiterIteratorFunc func, void *data)

    #cpShape.h
    ctypedef struct cpPointQueryInfo:
        const cpShape *shape
        cpVect point
        cpFloat distance
        cpVect gradient
    ctypedef struct cpSegmentQueryInfo:
        const cpShape *shape
        cpVect point
        cpVect normal
        cpFloat alpha
    ctypedef struct cpShapeFilter:
        cpGroup group
        cpBitmask categories
        cpBitmask mask
    const cpShapeFilter CP_SHAPE_FILTER_ALL = {CP_NO_GROUP, CP_ALL_CATEGORIES, CP_ALL_CATEGORIES}
    const cpShapeFilter CP_SHAPE_FILTER_NONE = {CP_NO_GROUP, not CP_ALL_CATEGORIES, not CP_ALL_CATEGORIES}
    cpShapeFilter cpShapeFilterNew(cpGroup group, cpBitmask categories, cpBitmask mask)
    void cpShapeDestroy(cpShape *shape)
    void cpShapeFree(cpShape *shape)
    cpBB cpShapeCacheBB(cpShape *shape)
    cpBB cpShapeUpdate(cpShape *shape, cpTransform transform)
    cpFloat cpShapePointQuery(const cpShape *shape, cpVect p, cpPointQueryInfo *out)
    cpBool cpShapeSegmentQuery(const cpShape *shape, cpVect a, cpVect b, cpFloat radius, cpSegmentQueryInfo *info)
    cpContactPointSet cpShapesCollide(const cpShape *a, const cpShape *b)
    cpSpace* cpShapeGetSpace(const cpShape *shape)
    cpBody* cpShapeGetBody(const cpShape *shape)
    void cpShapeSetBody(cpShape *shape, cpBody *body)
    cpFloat cpShapeGetMass(cpShape *shape)
    void cpShapeSetMass(cpShape *shape, cpFloat mass)
    cpFloat cpShapeGetDensity(cpShape *shape)
    void cpShapeSetDensity(cpShape *shape, cpFloat density)
    cpFloat cpShapeGetMoment(cpShape *shape)
    cpFloat cpShapeGetArea(cpShape *shape)
    cpVect cpShapeGetCenterOfGravity(cpShape *shape)
    cpBB cpShapeGetBB(const cpShape *shape)
    cpBool cpShapeGetSensor(const cpShape *shape)
    void cpShapeSetSensor(cpShape *shape, cpBool sensor)
    cpFloat cpShapeGetElasticity(const cpShape *shape)
    void cpShapeSetElasticity(cpShape *shape, cpFloat elasticity)
    cpFloat cpShapeGetFriction(const cpShape *shape)
    void cpShapeSetFriction(cpShape *shape, cpFloat friction)
    cpVect cpShapeGetSurfaceVelocity(const cpShape *shape)
    void cpShapeSetSurfaceVelocity(cpShape *shape, cpVect surfaceVelocity)
    cpDataPointer cpShapeGetUserData(const cpShape *shape)
    void cpShapeSetUserData(cpShape *shape, cpDataPointer userData)
    cpCollisionType cpShapeGetCollisionType(const cpShape *shape)
    void cpShapeSetCollisionType(cpShape *shape, cpCollisionType collisionType)
    cpShapeFilter cpShapeGetFilter(const cpShape *shape)
    void cpShapeSetFilter(cpShape *shape, cpShapeFilter filter)
    cpCircleShape* cpCircleShapeAlloc()
    cpCircleShape* cpCircleShapeInit(cpCircleShape *circle, cpBody *body, cpFloat radius, cpVect offset)
    cpShape* cpCircleShapeNew(cpBody *body, cpFloat radius, cpVect offset)
    cpVect cpCircleShapeGetOffset(const cpShape *shape)
    cpFloat cpCircleShapeGetRadius(const cpShape *shape)
    cpSegmentShape* cpSegmentShapeAlloc()
    cpSegmentShape* cpSegmentShapeInit(cpSegmentShape *seg, cpBody *body, cpVect a, cpVect b, cpFloat radius)
    cpShape* cpSegmentShapeNew(cpBody *body, cpVect a, cpVect b, cpFloat radius)
    void cpSegmentShapeSetNeighbors(cpShape *shape, cpVect prev, cpVect next)
    cpVect cpSegmentShapeGetA(const cpShape *shape)
    cpVect cpSegmentShapeGetB(const cpShape *shape)
    cpVect cpSegmentShapeGetNormal(const cpShape *shape)
    cpFloat cpSegmentShapeGetRadius(const cpShape *shape)

    #cpPolyline.h
    ctypedef struct cpPolyline:
        int count
        int capacity
        cpVect *verts
    void cpPolylineFree(cpPolyline *line)
    cpBool cpPolylineIsClosed(cpPolyline *line)
    cpPolyline *cpPolylineSimplifyCurves(cpPolyline *line, cpFloat tol)
    cpPolyline *cpPolylineSimplifyVertexes(cpPolyline *line, cpFloat tol)
    cpPolyline *cpPolylineToConvexHull(cpPolyline *line, cpFloat tol)
    ctypedef struct cpPolylineSet:
        int count
        int capacity
        cpPolyline **lines
    cpPolylineSet *cpPolylineSetAlloc()
    cpPolylineSet *cpPolylineSetInit(cpPolylineSet *set)
    cpPolylineSet *cpPolylineSetNew()
    void cpPolylineSetDestroy(cpPolylineSet *set, cpBool freePolylines)
    void cpPolylineSetFree(cpPolylineSet *set, cpBool freePolylines)
    void cpPolylineSetCollectSegment(cpVect v0, cpVect v1, cpPolylineSet *lines)
    cpPolylineSet *cpPolylineConvexDecomposition(cpPolyline *line, cpFloat tol)

    #cpPolyShape.h
    cpPolyShape* cpPolyShapeAlloc()
    cpPolyShape* cpPolyShapeInit(cpPolyShape *poly, cpBody *body, int count, const cpVect *verts, cpTransform transform, cpFloat radius)
    cpPolyShape* cpPolyShapeInitRaw(cpPolyShape *poly, cpBody *body, int count, const cpVect *verts, cpFloat radius)
    cpShape* cpPolyShapeNew(cpBody *body, int count, const cpVect *verts, cpTransform transform, cpFloat radius)
    cpShape* cpPolyShapeNewRaw(cpBody *body, int count, const cpVect *verts, cpFloat radius)
    cpPolyShape* cpBoxShapeInit(cpPolyShape *poly, cpBody *body, cpFloat width, cpFloat height, cpFloat radius)
    cpPolyShape* cpBoxShapeInit2(cpPolyShape *poly, cpBody *body, cpBB box, cpFloat radius)
    cpShape* cpBoxShapeNew(cpBody *body, cpFloat width, cpFloat height, cpFloat radius)
    cpShape* cpBoxShapeNew2(cpBody *body, cpBB box, cpFloat radius)
    int cpPolyShapeGetCount(const cpShape *shape)
    cpVect cpPolyShapeGetVert(const cpShape *shape, int index)
    cpFloat cpPolyShapeGetRadius(const cpShape *shape)

    #cpConstraint.h
    ctypedef void (*cpConstraintPreSolveFunc)(cpConstraint *constraint, cpSpace *space)
    ctypedef void (*cpConstraintPostSolveFunc)(cpConstraint *constraint, cpSpace *space)
    void cpConstraintDestroy(cpConstraint *constraint)
    void cpConstraintFree(cpConstraint *constraint)
    cpSpace* cpConstraintGetSpace(const cpConstraint *constraint)
    cpBody* cpConstraintGetBodyA(const cpConstraint *constraint)
    cpBody* cpConstraintGetBodyB(const cpConstraint *constraint)
    cpFloat cpConstraintGetMaxForce(const cpConstraint *constraint)
    void cpConstraintSetMaxForce(cpConstraint *constraint, cpFloat maxForce)
    cpFloat cpConstraintGetErrorBias(const cpConstraint *constraint)
    void cpConstraintSetErrorBias(cpConstraint *constraint, cpFloat errorBias)
    cpFloat cpConstraintGetMaxBias(const cpConstraint *constraint)
    void cpConstraintSetMaxBias(cpConstraint *constraint, cpFloat maxBias)
    cpBool cpConstraintGetCollideBodies(const cpConstraint *constraint)
    void cpConstraintSetCollideBodies(cpConstraint *constraint, cpBool collideBodies)
    cpConstraintPreSolveFunc cpConstraintGetPreSolveFunc(const cpConstraint *constraint)
    void cpConstraintSetPreSolveFunc(cpConstraint *constraint, cpConstraintPreSolveFunc preSolveFunc)
    cpConstraintPostSolveFunc cpConstraintGetPostSolveFunc(const cpConstraint *constraint)
    void cpConstraintSetPostSolveFunc(cpConstraint *constraint, cpConstraintPostSolveFunc postSolveFunc)
    cpDataPointer cpConstraintGetUserData(const cpConstraint *constraint)
    void cpConstraintSetUserData(cpConstraint *constraint, cpDataPointer userData)
    cpFloat cpConstraintGetImpulse(cpConstraint *constraint)

    #cpPinJoint.h
    cpBool cpConstraintIsPinJoint(const cpConstraint *constraint)
    cpPinJoint* cpPinJointAlloc()
    cpPinJoint* cpPinJointInit(cpPinJoint *joint, cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB)
    cpConstraint* cpPinJointNew(cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB)
    cpVect cpPinJointGetAnchorA(const cpConstraint *constraint)
    void cpPinJointSetAnchorA(cpConstraint *constraint, cpVect anchorA)
    cpVect cpPinJointGetAnchorB(const cpConstraint *constraint)
    void cpPinJointSetAnchorB(cpConstraint *constraint, cpVect anchorB)
    cpFloat cpPinJointGetDist(const cpConstraint *constraint)
    void cpPinJointSetDist(cpConstraint *constraint, cpFloat dist)

    #cpSlideJoint.h
    cpBool cpConstraintIsSlideJoint(const cpConstraint *constraint)
    cpSlideJoint* cpSlideJointAlloc()
    cpSlideJoint* cpSlideJointInit(cpSlideJoint *joint, cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB, cpFloat min, cpFloat max)
    cpConstraint* cpSlideJointNew(cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB, cpFloat min, cpFloat max)
    cpVect cpSlideJointGetAnchorA(const cpConstraint *constraint)
    void cpSlideJointSetAnchorA(cpConstraint *constraint, cpVect anchorA)
    cpVect cpSlideJointGetAnchorB(const cpConstraint *constraint)
    void cpSlideJointSetAnchorB(cpConstraint *constraint, cpVect anchorB)
    cpFloat cpSlideJointGetMin(const cpConstraint *constraint)
    void cpSlideJointSetMin(cpConstraint *constraint, cpFloat min)
    cpFloat cpSlideJointGetMax(const cpConstraint *constraint)
    void cpSlideJointSetMax(cpConstraint *constraint, cpFloat max)

    #cpPivotJoint.h
    cpBool cpConstraintIsPivotJoint(const cpConstraint *constraint)
    cpPivotJoint* cpPivotJointAlloc()
    cpPivotJoint* cpPivotJointInit(cpPivotJoint *joint, cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB)
    cpConstraint* cpPivotJointNew(cpBody *a, cpBody *b, cpVect pivot)
    cpConstraint* cpPivotJointNew2(cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB)
    cpVect cpPivotJointGetAnchorA(const cpConstraint *constraint)
    void cpPivotJointSetAnchorA(cpConstraint *constraint, cpVect anchorA)
    cpVect cpPivotJointGetAnchorB(const cpConstraint *constraint)
    void cpPivotJointSetAnchorB(cpConstraint *constraint, cpVect anchorB)

    #cpGrooveJoint.h
    cpBool cpConstraintIsGrooveJoint(const cpConstraint *constraint)
    cpGrooveJoint* cpGrooveJointAlloc()
    cpGrooveJoint* cpGrooveJointInit(cpGrooveJoint *joint, cpBody *a, cpBody *b, cpVect groove_a, cpVect groove_b, cpVect anchorB)
    cpConstraint* cpGrooveJointNew(cpBody *a, cpBody *b, cpVect groove_a, cpVect groove_b, cpVect anchorB)
    cpVect cpGrooveJointGetGrooveA(const cpConstraint *constraint)
    void cpGrooveJointSetGrooveA(cpConstraint *constraint, cpVect grooveA)
    cpVect cpGrooveJointGetGrooveB(const cpConstraint *constraint)
    void cpGrooveJointSetGrooveB(cpConstraint *constraint, cpVect grooveB)
    cpVect cpGrooveJointGetAnchorB(const cpConstraint *constraint)
    void cpGrooveJointSetAnchorB(cpConstraint *constraint, cpVect anchorB)

    #cpDampedSpring.h
    cpBool cpConstraintIsDampedSpring(const cpConstraint *constraint)
    ctypedef cpFloat (*cpDampedSpringForceFunc)(cpConstraint *spring, cpFloat dist)
    cpDampedSpring* cpDampedSpringAlloc()
    cpDampedSpring* cpDampedSpringInit(cpDampedSpring *joint, cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB, cpFloat restLength, cpFloat stiffness, cpFloat damping)
    cpConstraint* cpDampedSpringNew(cpBody *a, cpBody *b, cpVect anchorA, cpVect anchorB, cpFloat restLength, cpFloat stiffness, cpFloat damping)
    cpVect cpDampedSpringGetAnchorA(const cpConstraint *constraint)
    void cpDampedSpringSetAnchorA(cpConstraint *constraint, cpVect anchorA)
    cpVect cpDampedSpringGetAnchorB(const cpConstraint *constraint)
    void cpDampedSpringSetAnchorB(cpConstraint *constraint, cpVect anchorB)
    cpFloat cpDampedSpringGetRestLength(const cpConstraint *constraint)
    void cpDampedSpringSetRestLength(cpConstraint *constraint, cpFloat restLength)
    cpFloat cpDampedSpringGetStiffness(const cpConstraint *constraint)
    void cpDampedSpringSetStiffness(cpConstraint *constraint, cpFloat stiffness)
    cpFloat cpDampedSpringGetDamping(const cpConstraint *constraint)
    void cpDampedSpringSetDamping(cpConstraint *constraint, cpFloat damping)
    cpDampedSpringForceFunc cpDampedSpringGetSpringForceFunc(const cpConstraint *constraint)
    void cpDampedSpringSetSpringForceFunc(cpConstraint *constraint, cpDampedSpringForceFunc springForceFunc)

    #cpDampedRotarySpring.h
    cpBool cpConstraintIsDampedRotarySpring(const cpConstraint *constraint)
    ctypedef cpFloat (*cpDampedRotarySpringTorqueFunc)(cpConstraint *spring, cpFloat relativeAngle)
    cpDampedRotarySpring* cpDampedRotarySpringAlloc()
    cpDampedRotarySpring* cpDampedRotarySpringInit(cpDampedRotarySpring *joint, cpBody *a, cpBody *b, cpFloat restAngle, cpFloat stiffness, cpFloat damping)
    cpConstraint* cpDampedRotarySpringNew(cpBody *a, cpBody *b, cpFloat restAngle, cpFloat stiffness, cpFloat damping)
    cpFloat cpDampedRotarySpringGetRestAngle(const cpConstraint *constraint)
    void cpDampedRotarySpringSetRestAngle(cpConstraint *constraint, cpFloat restAngle)
    cpFloat cpDampedRotarySpringGetStiffness(const cpConstraint *constraint)
    void cpDampedRotarySpringSetStiffness(cpConstraint *constraint, cpFloat stiffness)
    cpFloat cpDampedRotarySpringGetDamping(const cpConstraint *constraint)
    void cpDampedRotarySpringSetDamping(cpConstraint *constraint, cpFloat damping)
    cpDampedRotarySpringTorqueFunc cpDampedRotarySpringGetSpringTorqueFunc(const cpConstraint *constraint)
    void cpDampedRotarySpringSetSpringTorqueFunc(cpConstraint *constraint, cpDampedRotarySpringTorqueFunc springTorqueFunc)

    #cpRotaryLimitJoint.h
    cpBool cpConstraintIsRotaryLimitJoint(const cpConstraint *constraint)
    cpRotaryLimitJoint* cpRotaryLimitJointAlloc()
    cpRotaryLimitJoint* cpRotaryLimitJointInit(cpRotaryLimitJoint *joint, cpBody *a, cpBody *b, cpFloat min, cpFloat max)
    cpConstraint* cpRotaryLimitJointNew(cpBody *a, cpBody *b, cpFloat min, cpFloat max)
    cpFloat cpRotaryLimitJointGetMin(const cpConstraint *constraint)
    void cpRotaryLimitJointSetMin(cpConstraint *constraint, cpFloat min)
    cpFloat cpRotaryLimitJointGetMax(const cpConstraint *constraint)
    void cpRotaryLimitJointSetMax(cpConstraint *constraint, cpFloat max)

    #cpRatchetJoint.h
    cpBool cpConstraintIsRatchetJoint(const cpConstraint *constraint)
    cpRatchetJoint* cpRatchetJointAlloc()
    cpRatchetJoint* cpRatchetJointInit(cpRatchetJoint *joint, cpBody *a, cpBody *b, cpFloat phase, cpFloat ratchet)
    cpConstraint* cpRatchetJointNew(cpBody *a, cpBody *b, cpFloat phase, cpFloat ratchet)
    cpFloat cpRatchetJointGetAngle(const cpConstraint *constraint)
    void cpRatchetJointSetAngle(cpConstraint *constraint, cpFloat angle)
    cpFloat cpRatchetJointGetPhase(const cpConstraint *constraint)
    void cpRatchetJointSetPhase(cpConstraint *constraint, cpFloat phase)
    cpFloat cpRatchetJointGetRatchet(const cpConstraint *constraint)
    void cpRatchetJointSetRatchet(cpConstraint *constraint, cpFloat ratchet)

    #cpGearJoint.h
    cpBool cpConstraintIsGearJoint(const cpConstraint *constraint)
    cpGearJoint* cpGearJointAlloc()
    cpGearJoint* cpGearJointInit(cpGearJoint *joint, cpBody *a, cpBody *b, cpFloat phase, cpFloat ratio)
    cpConstraint* cpGearJointNew(cpBody *a, cpBody *b, cpFloat phase, cpFloat ratio)
    cpFloat cpGearJointGetPhase(const cpConstraint *constraint)
    void cpGearJointSetPhase(cpConstraint *constraint, cpFloat phase)
    cpFloat cpGearJointGetRatio(const cpConstraint *constraint)
    void cpGearJointSetRatio(cpConstraint *constraint, cpFloat ratio)

    #cpSimpleMotor.h
    ctypedef struct cpSimpleMotor
    cpBool cpConstraintIsSimpleMotor(const cpConstraint *constraint)
    cpSimpleMotor* cpSimpleMotorAlloc()
    cpSimpleMotor* cpSimpleMotorInit(cpSimpleMotor *joint, cpBody *a, cpBody *b, cpFloat rate)
    cpConstraint* cpSimpleMotorNew(cpBody *a, cpBody *b, cpFloat rate)
    cpFloat cpSimpleMotorGetRate(const cpConstraint *constraint)
    void cpSimpleMotorSetRate(cpConstraint *constraint, cpFloat rate)

    #cpSpace.h
    ctypedef cpBool (*cpCollisionBeginFunc)(cpArbiter *arb, cpSpace *space, cpDataPointer userData)
    ctypedef cpBool (*cpCollisionPreSolveFunc)(cpArbiter *arb, cpSpace *space, cpDataPointer userData)
    ctypedef void (*cpCollisionPostSolveFunc)(cpArbiter *arb, cpSpace *space, cpDataPointer userData)
    ctypedef void (*cpCollisionSeparateFunc)(cpArbiter *arb, cpSpace *space, cpDataPointer userData)
    ctypedef struct cpCollisionHandler:
        const cpCollisionType typeA
        const cpCollisionType typeB
        cpCollisionBeginFunc beginFunc
        cpCollisionPreSolveFunc preSolveFunc
        cpCollisionPostSolveFunc postSolveFunc
        cpCollisionSeparateFunc separateFunc
        cpDataPointer userData
    cpSpace* cpSpaceAlloc()
    cpSpace* cpSpaceInit(cpSpace *space)
    cpSpace* cpSpaceNew()
    void cpSpaceDestroy(cpSpace *space)
    void cpSpaceFree(cpSpace *space)
    int cpSpaceGetIterations(const cpSpace *space)
    void cpSpaceSetIterations(cpSpace *space, int iterations)
    cpVect cpSpaceGetGravity(const cpSpace *space)
    void cpSpaceSetGravity(cpSpace *space, cpVect gravity)
    cpFloat cpSpaceGetDamping(const cpSpace *space)
    void cpSpaceSetDamping(cpSpace *space, cpFloat damping)
    cpFloat cpSpaceGetIdleSpeedThreshold(const cpSpace *space)
    void cpSpaceSetIdleSpeedThreshold(cpSpace *space, cpFloat idleSpeedThreshold)
    cpFloat cpSpaceGetSleepTimeThreshold(const cpSpace *space)
    void cpSpaceSetSleepTimeThreshold(cpSpace *space, cpFloat sleepTimeThreshold)
    cpFloat cpSpaceGetCollisionSlop(const cpSpace *space)
    void cpSpaceSetCollisionSlop(cpSpace *space, cpFloat collisionSlop)
    cpFloat cpSpaceGetCollisionBias(const cpSpace *space)
    void cpSpaceSetCollisionBias(cpSpace *space, cpFloat collisionBias)
    cpTimestamp cpSpaceGetCollisionPersistence(const cpSpace *space)
    void cpSpaceSetCollisionPersistence(cpSpace *space, cpTimestamp collisionPersistence)
    cpDataPointer cpSpaceGetUserData(const cpSpace *space)
    void cpSpaceSetUserData(cpSpace *space, cpDataPointer userData)
    cpBody* cpSpaceGetStaticBody(const cpSpace *space)
    cpFloat cpSpaceGetCurrentTimeStep(const cpSpace *space)
    cpBool cpSpaceIsLocked(cpSpace *space)
    cpCollisionHandler *cpSpaceAddDefaultCollisionHandler(cpSpace *space)
    cpCollisionHandler *cpSpaceAddCollisionHandler(cpSpace *space, cpCollisionType a, cpCollisionType b)
    cpCollisionHandler *cpSpaceAddWildcardHandler(cpSpace *space, cpCollisionType type)
    cpShape* cpSpaceAddShape(cpSpace *space, cpShape *shape)
    cpBody* cpSpaceAddBody(cpSpace *space, cpBody *body)
    cpConstraint* cpSpaceAddConstraint(cpSpace *space, cpConstraint *constraint)
    void cpSpaceRemoveShape(cpSpace *space, cpShape *shape)
    void cpSpaceRemoveBody(cpSpace *space, cpBody *body)
    void cpSpaceRemoveConstraint(cpSpace *space, cpConstraint *constraint)
    cpBool cpSpaceContainsShape(cpSpace *space, cpShape *shape)
    cpBool cpSpaceContainsBody(cpSpace *space, cpBody *body)
    cpBool cpSpaceContainsConstraint(cpSpace *space, cpConstraint *constraint)
    ctypedef void (*cpPostStepFunc)(cpSpace *space, void *key, void *data)
    cpBool cpSpaceAddPostStepCallback(cpSpace *space, cpPostStepFunc func, void *key, void *data)
    ctypedef void (*cpSpacePointQueryFunc)(cpShape *shape, cpVect point, cpFloat distance, cpVect gradient, void *data)
    void cpSpacePointQuery(cpSpace *space, cpVect point, cpFloat maxDistance, cpShapeFilter filter, cpSpacePointQueryFunc func, void *data)
    cpShape *cpSpacePointQueryNearest(cpSpace *space, cpVect point, cpFloat maxDistance, cpShapeFilter filter, cpPointQueryInfo *out)
    ctypedef void (*cpSpaceSegmentQueryFunc)(cpShape *shape, cpVect point, cpVect normal, cpFloat alpha, void *data)
    void cpSpaceSegmentQuery(cpSpace *space, cpVect start, cpVect end, cpFloat radius, cpShapeFilter filter, cpSpaceSegmentQueryFunc func, void *data)
    cpShape *cpSpaceSegmentQueryFirst(cpSpace *space, cpVect start, cpVect end, cpFloat radius, cpShapeFilter filter, cpSegmentQueryInfo *out)
    ctypedef void (*cpSpaceBBQueryFunc)(cpShape *shape, void *data)
    void cpSpaceBBQuery(cpSpace *space, cpBB bb, cpShapeFilter filter, cpSpaceBBQueryFunc func, void *data)
    ctypedef void (*cpSpaceShapeQueryFunc)(cpShape *shape, cpContactPointSet *points, void *data)
    cpBool cpSpaceShapeQuery(cpSpace *space, cpShape *shape, cpSpaceShapeQueryFunc func, void *data)
    ctypedef void (*cpSpaceBodyIteratorFunc)(cpBody *body, void *data)
    void cpSpaceEachBody(cpSpace *space, cpSpaceBodyIteratorFunc func, void *data)
    ctypedef void (*cpSpaceShapeIteratorFunc)(cpShape *shape, void *data)
    void cpSpaceEachShape(cpSpace *space, cpSpaceShapeIteratorFunc func, void *data)
    ctypedef void (*cpSpaceConstraintIteratorFunc)(cpConstraint *constraint, void *data)
    void cpSpaceEachConstraint(cpSpace *space, cpSpaceConstraintIteratorFunc func, void *data)
    void cpSpaceReindexStatic(cpSpace *space)
    void cpSpaceReindexShape(cpSpace *space, cpShape *shape)
    void cpSpaceReindexShapesForBody(cpSpace *space, cpBody *body)
    void cpSpaceUseSpatialHash(cpSpace *space, cpFloat dim, int count)
    void cpSpaceStep(cpSpace *space, cpFloat dt)
    ctypedef struct cpSpaceDebugColor:
        float r
        float g
        float b
        float a
    ctypedef void (*cpSpaceDebugDrawCircleImpl)(cpVect pos, cpFloat angle, cpFloat radius, cpSpaceDebugColor outlineColor, cpSpaceDebugColor fillColor, cpDataPointer data)
    ctypedef void (*cpSpaceDebugDrawSegmentImpl)(cpVect a, cpVect b, cpSpaceDebugColor color, cpDataPointer data)
    ctypedef void (*cpSpaceDebugDrawFatSegmentImpl)(cpVect a, cpVect b, cpFloat radius, cpSpaceDebugColor outlineColor, cpSpaceDebugColor fillColor, cpDataPointer data)
    ctypedef void (*cpSpaceDebugDrawPolygonImpl)(int count, const cpVect *verts, cpFloat radius, cpSpaceDebugColor outlineColor, cpSpaceDebugColor fillColor, cpDataPointer data)
    ctypedef void (*cpSpaceDebugDrawDotImpl)(cpFloat size, cpVect pos, cpSpaceDebugColor color, cpDataPointer data)
    ctypedef cpSpaceDebugColor (*cpSpaceDebugDrawColorForShapeImpl)(cpShape *shape, cpDataPointer data)
    ctypedef enum cpSpaceDebugDrawFlags:
        CP_SPACE_DEBUG_DRAW_SHAPES = 1<<0
        CP_SPACE_DEBUG_DRAW_CONSTRAINTS = 1<<1
        CP_SPACE_DEBUG_DRAW_COLLISION_POINTS = 1<<2
    ctypedef struct cpSpaceDebugDrawOptions:
        cpSpaceDebugDrawCircleImpl drawCircle
        cpSpaceDebugDrawSegmentImpl drawSegment
        cpSpaceDebugDrawFatSegmentImpl drawFatSegment
        cpSpaceDebugDrawPolygonImpl drawPolygon
        cpSpaceDebugDrawDotImpl drawDot
        cpSpaceDebugDrawFlags flags
        cpSpaceDebugColor shapeOutlineColor
        cpSpaceDebugDrawColorForShapeImpl colorForShape
        cpSpaceDebugColor constraintColor
        cpSpaceDebugColor collisionPointColor
        cpDataPointer data
    void cpSpaceDebugDraw(cpSpace *space, cpSpaceDebugDrawOptions *options)

cdef extern from "chipmunk/cpRobust.h" nogil:
    cpBool cpCheckPointGreater(const cpVect a, const cpVect b, const cpVect c)
    cpBool cpCheckAxis(cpVect v0, cpVect v1, cpVect p, cpVect n)

cdef extern from "chipmunk/cpHastySpace.h" nogil:
    ctypedef struct cpHastySpace
    cpSpace *cpHastySpaceNew()
    void cpHastySpaceFree(cpSpace *space)
    void cpHastySpaceSetThreads(cpSpace *space, unsigned long threads)
    unsigned long cpHastySpaceGetThreads(cpSpace *space)
    void cpHastySpaceStep(cpSpace *space, cpFloat dt)

cdef extern from "chipmunk/cpMarch.h" nogil:
    ctypedef cpFloat (*cpMarchSampleFunc)(cpVect point, void *data)
    ctypedef void (*cpMarchSegmentFunc)(cpVect v0, cpVect v1, void *data)
    void cpMarchSoft(
        cpBB bb, unsigned long x_samples, unsigned long y_samples, cpFloat threshold,
        cpMarchSegmentFunc segment, void *segment_data,
        cpMarchSampleFunc sample, void *sample_data,
    )
    void cpMarchHard(
        cpBB bb, unsigned long x_samples, unsigned long y_samples, cpFloat threshold,
        cpMarchSegmentFunc segment, void *segment_data,
        cpMarchSampleFunc sample, void *sample_data,
    )

cdef extern from "chipmunk/chipmunk_structs.h" nogil:
    ctypedef struct cpArray:
        int num
        int max
        void **arr 
    ctypedef struct cpBodySub:
        cpBody *root
        cpBody *next
        cpFloat idleTime
    ctypedef struct cpBody:
        cpBodyVelocityFunc velocity_func
        cpBodyPositionFunc position_func
        cpFloat m
        cpFloat m_inv
        cpFloat i
        cpFloat i_inv
        cpVect cog
        cpVect p
        cpVect v
        cpVect f
        cpFloat a
        cpFloat w
        cpFloat t
        cpTransform transform
        cpDataPointer userData
        cpVect v_bias
        cpFloat w_bias
        cpSpace *space
        cpShape *shapeList
        cpArbiter *arbiterList
        cpConstraint *constraintList
        cpBodySub sleeping
    ctypedef enum cpArbiterState:
        CP_ARBITER_STATE_FIRST_COLLISION
        CP_ARBITER_STATE_NORMAL
        CP_ARBITER_STATE_IGNORE
        CP_ARBITER_STATE_CACHED
        CP_ARBITER_STATE_INVALIDATED
    ctypedef struct cpArbiterThread:
        cpArbiter *next
        cpArbiter *prev
    ctypedef struct cpContact:
        cpVect r1
        cpVect r2
        cpFloat nMass
        cpFloat tMass
        cpFloat bounce
        cpFloat jnAcc
        cpFloat jtAcc
        cpFloat jBias
        cpFloat bias
        cpHashValue hash
    ctypedef struct cpCollisionInfo:
        const cpShape *a
        const cpShape *b
        cpCollisionID id
        cpVect n
        int count
        cpContact *arr
    ctypedef struct cpArbiter:
        cpFloat e
        cpFloat u
        cpVect surface_vr
        cpDataPointer data
        const cpShape *a
        const cpShape *b
        cpBody *body_a
        cpBody *body_b
        cpArbiterThread thread_a
        cpArbiterThread thread_b
        int count
        cpContact *contacts
        cpVect n
        cpCollisionHandler *handler
        cpCollisionHandler *handlerA
        cpCollisionHandler *handlerB
        cpBool swapped
        cpTimestamp stamp
        cpArbiterState state
    ctypedef struct cpShapeMassInfo:
        cpFloat m
        cpFloat i
        cpVect cog
        cpFloat area
    ctypedef enum cpShapeType:
        CP_CIRCLE_SHAPE
        CP_SEGMENT_SHAPE
        CP_POLY_SHAPE
        CP_NUM_SHAPES
    ctypedef cpBB (*cpShapeCacheDataImpl)(cpShape *shape, cpTransform transform)
    ctypedef void (*cpShapeDestroyImpl)(cpShape *shape)
    ctypedef void (*cpShapePointQueryImpl)(const cpShape *shape, cpVect p, cpPointQueryInfo *info)
    ctypedef void (*cpShapeSegmentQueryImpl)(const cpShape *shape, cpVect a, cpVect b, cpFloat radius, cpSegmentQueryInfo *info)
    ctypedef struct cpShapeClass
    ctypedef struct cpShapeClass:
        cpShapeType type
        cpShapeCacheDataImpl cacheData
        cpShapeDestroyImpl destroy
        cpShapePointQueryImpl pointQuery
        cpShapeSegmentQueryImpl segmentQuery
    ctypedef struct cpShape:
        const cpShapeClass *klass
        cpSpace *space
        cpBody *body
        cpShapeMassInfo massInfo
        cpBB bb
        cpBool sensor	
        cpFloat e
        cpFloat u
        cpVect surfaceV
        cpDataPointer userData
        cpCollisionType type
        cpShapeFilter filter
        cpShape *next
        cpShape *prev
        cpHashValue hashid
    ctypedef struct cpCircleShape:
        cpShape shape
        cpVect c
        cpVect tc
        cpFloat r
    ctypedef struct cpSegmentShape:
        cpShape shape
        cpVect a
        cpVect b
        cpVect n
        cpVect ta
        cpVect tb
        cpVect tn
        cpFloat r
        cpVect a_tangent
        cpVect b_tangent
    ctypedef struct cpSplittingPlane:
        cpVect v0
        cpVect n
    cdef enum: CP_POLY_SHAPE_INLINE_ALLOC = 6
    ctypedef struct cpPolyShape:
        cpShape shape
        cpFloat r
        int count
        cpSplittingPlane *planes
        cpSplittingPlane _planes[2*CP_POLY_SHAPE_INLINE_ALLOC]
    ctypedef void (*cpConstraintPreStepImpl)(cpConstraint *constraint, cpFloat dt)
    ctypedef void (*cpConstraintApplyCachedImpulseImpl)(cpConstraint *constraint, cpFloat dt_coef)
    ctypedef void (*cpConstraintApplyImpulseImpl)(cpConstraint *constraint, cpFloat dt)
    ctypedef cpFloat (*cpConstraintGetImpulseImpl)(cpConstraint *constraint)
    ctypedef struct cpConstraintClass:
        cpConstraintPreStepImpl preStep
        cpConstraintApplyCachedImpulseImpl applyCachedImpulse
        cpConstraintApplyImpulseImpl applyImpulse
        cpConstraintGetImpulseImpl getImpulse
    ctypedef struct cpConstraint:
        const cpConstraintClass *klass
        cpSpace *space
        cpBody *a
        cpBody *b
        cpConstraint *next_a
        cpConstraint *next_b
        cpFloat maxForce
        cpFloat errorBias
        cpFloat maxBias
        cpBool collideBodies
        cpConstraintPreSolveFunc preSolve
        cpConstraintPostSolveFunc postSolve
        cpDataPointer userData
    ctypedef struct cpPinJoint:
        cpConstraint constraint
        cpVect anchorA
        cpVect anchorB
        cpFloat dist
        cpVect r1
        cpVect r2
        cpVect n
        cpFloat nMass
        cpFloat jnAcc
        cpFloat bias
    ctypedef struct cpSlideJoint:
        cpConstraint constraint
        cpVect anchorA
        cpVect anchorB
        cpFloat min
        cpFloat max
        cpVect r1
        cpVect r2
        cpVect n
        cpFloat nMass
        cpFloat jnAcc
        cpFloat bias
    ctypedef struct cpPivotJoint:
        cpConstraint constraint
        cpVect anchorA
        cpVect anchorB
        cpVect r1
        cpVect r2
        cpMat2x2 k
        cpVect jAcc
        cpVect bias
    ctypedef struct cpGrooveJoint:
        cpConstraint constraint
        cpVect grv_n
        cpVect grv_a
        cpVect grv_b
        cpVect anchorB
        cpVect grv_tn
        cpFloat clamp
        cpVect r1
        cpVect r2
        cpMat2x2 k
        cpVect jAcc
        cpVect bias
    ctypedef struct cpDampedSpring:
        cpConstraint constraint
        cpVect anchorA
        cpVect anchorB
        cpFloat restLength
        cpFloat stiffness
        cpFloat damping
        cpDampedSpringForceFunc springForceFunc
        cpFloat target_vrn
        cpFloat v_coef
        cpVect r1
        cpVect r2
        cpFloat nMass
        cpVect n
        cpFloat jAcc
    ctypedef struct cpDampedRotarySpring:
        cpConstraint constraint
        cpFloat restAngle
        cpFloat stiffness
        cpFloat damping
        cpDampedRotarySpringTorqueFunc springTorqueFunc
        cpFloat target_wrn
        cpFloat w_coef
        cpFloat iSum
        cpFloat jAcc
    ctypedef struct cpRotaryLimitJoint:
        cpConstraint constraint
        cpFloat min
        cpFloat max
        cpFloat iSum
        cpFloat bias
        cpFloat jAcc
    ctypedef struct cpRatchetJoint:
        cpConstraint constraint
        cpFloat angle
        cpFloat phase
        cpFloat ratchet
        cpFloat iSum
        cpFloat bias
        cpFloat jAcc
    ctypedef struct cpGearJoint:
        cpConstraint constraint
        cpFloat phase
        cpFloat ratio
        cpFloat ratio_inv
        cpFloat iSum
        cpFloat bias
        cpFloat jAcc
    ctypedef struct cpSimpleMotor:
        cpConstraint constraint
        cpFloat rate
        cpFloat iSum
        cpFloat jAcc
    ctypedef struct cpContactBufferHeader
    ctypedef void (*cpSpaceArbiterApplyImpulseFunc)(cpArbiter *arb)
    ctypedef struct cpSpace:
        int iterations
        cpVect gravity
        cpFloat damping
        cpFloat idleSpeedThreshold
        cpFloat sleepTimeThreshold
        cpFloat collisionSlop
        cpFloat collisionBias
        cpTimestamp collisionPersistence
        cpDataPointer userData
        cpTimestamp stamp
        cpFloat curr_dt
        cpArray *dynamicBodies
        cpArray *staticBodies
        cpArray *rousedBodies
        cpArray *sleepingComponents
        cpHashValue shapeIDCounter
        cpSpatialIndex *staticShapes
        cpSpatialIndex *dynamicShapes
        cpArray *constraints
        cpArray *arbiters
        cpContactBufferHeader *contactBuffersHead
        cpHashSet *cachedArbiters
        cpArray *pooledArbiters
        cpArray *allocatedBuffers
        unsigned int locked
        cpBool usesWildcards
        cpHashSet *collisionHandlers
        cpCollisionHandler defaultHandler
        cpBool skipPostStep
        cpArray *postStepCallbacks	
        cpBody *staticBody
        cpBody _staticBody
    ctypedef struct cpPostStepCallback:
        cpPostStepFunc func
        void *key
        void *data

cdef extern from "chipmunk/chipmunk_private.h" nogil:
    cpArray *cpArrayNew(int size)
    void cpArrayFree(cpArray *arr)
    void cpArrayPush(cpArray *arr, void *object)
    void *cpArrayPop(cpArray *arr)
    void cpArrayDeleteObj(cpArray *arr, void *obj)
    cpBool cpArrayContains(cpArray *arr, void *ptr)
    ctypedef void (*cpArrayFreeFunc)(void *)
    void cpArrayFreeEach(cpArray *arr, cpArrayFreeFunc freeFunc)
    ctypedef cpBool (*cpHashSetEqlFunc)(const void *ptr, const void *elt)
    ctypedef void *(*cpHashSetTransFunc)(const void *ptr, void *data)
    cpHashSet *cpHashSetNew(int size, cpHashSetEqlFunc eqlFunc)
    void cpHashSetSetDefaultValue(cpHashSet *set, void *default_value)
    void cpHashSetFree(cpHashSet *set)
    int cpHashSetCount(cpHashSet *set)
    const void *cpHashSetInsert(cpHashSet *set, cpHashValue hash, const void *ptr, cpHashSetTransFunc trans, void *data)
    const void *cpHashSetRemove(cpHashSet *set, cpHashValue hash, const void *ptr)
    const void *cpHashSetFind(cpHashSet *set, cpHashValue hash, const void *ptr)
    ctypedef void (*cpHashSetIteratorFunc)(void *elt, void *data)
    void cpHashSetEach(cpHashSet *set, cpHashSetIteratorFunc func, void *data)
    ctypedef cpBool (*cpHashSetFilterFunc)(void *elt, void *data)
    void cpHashSetFilter(cpHashSet *set, cpHashSetFilterFunc func, void *data)
    void cpBodyAddShape(cpBody *body, cpShape *shape)
    void cpBodyRemoveShape(cpBody *body, cpShape *shape)
    void cpBodyAccumulateMassFromShapes(cpBody *body)
    void cpBodyRemoveConstraint(cpBody *body, cpConstraint *constraint)
    cpSpatialIndex *cpSpatialIndexInit(cpSpatialIndex *index, cpSpatialIndexClass *klass, cpSpatialIndexBBFunc bbfunc, cpSpatialIndex *staticIndex)
    cpArbiter* cpArbiterInit(cpArbiter *arb, cpShape *a, cpShape *b)
    cpArbiterThread *cpArbiterThreadForBody(cpArbiter *arb, cpBody *body)
    void cpArbiterUnthread(cpArbiter *arb)
    void cpArbiterUpdate(cpArbiter *arb, cpCollisionInfo *info, cpSpace *space)
    void cpArbiterPreStep(cpArbiter *arb, cpFloat dt, cpFloat bias, cpFloat slop)
    void cpArbiterApplyCachedImpulse(cpArbiter *arb, cpFloat dt_coef)
    void cpArbiterApplyImpulse(cpArbiter *arb)
    cpShape *cpShapeInit(cpShape *shape, const cpShapeClass *klass, cpBody *body, cpShapeMassInfo massInfo)
    cpBool cpShapeActive(cpShape *shape)
    cpCollisionInfo cpCollide(const cpShape *a, const cpShape *b, cpCollisionID id, cpContact *contacts)
    void CircleSegmentQuery(cpShape *shape, cpVect center, cpFloat r1, cpVect a, cpVect b, cpFloat r2, cpSegmentQueryInfo *info)
    cpBool cpShapeFilterReject(cpShapeFilter a, cpShapeFilter b)
    void cpLoopIndexes(const cpVect *verts, int count, int *start, int *end)
    void cpConstraintInit(cpConstraint *constraint, const cpConstraintClass *klass, cpBody *a, cpBody *b)
    void cpConstraintActivateBodies(cpConstraint *constraint)
    cpVect relative_velocity(cpBody *a, cpBody *b, cpVect r1, cpVect r2)
    cpFloat normal_relative_velocity(cpBody *a, cpBody *b, cpVect r1, cpVect r2, cpVect n)
    void apply_impulse(cpBody *body, cpVect j, cpVect r)
    void apply_impulses(cpBody *a , cpBody *b, cpVect r1, cpVect r2, cpVect j)
    void apply_bias_impulse(cpBody *body, cpVect j, cpVect r)
    void apply_bias_impulses(cpBody *a , cpBody *b, cpVect r1, cpVect r2, cpVect j)
    cpFloat k_scalar_body(cpBody *body, cpVect r, cpVect n)
    cpFloat k_scalar(cpBody *a, cpBody *b, cpVect r1, cpVect r2, cpVect n)
    cpMat2x2 k_tensor(cpBody *a, cpBody *b, cpVect r1, cpVect r2)
    cpFloat bias_coef(cpFloat errorBias, cpFloat dt)
    void cpSpaceSetStaticBody(cpSpace *space, cpBody *body)
    void cpSpaceProcessComponents(cpSpace *space, cpFloat dt)
    void cpSpacePushFreshContactBuffer(cpSpace *space)
    cpContact *cpContactBufferGetArray(cpSpace *space)
    void cpSpacePushContacts(cpSpace *space, int count)
    cpPostStepCallback *cpSpaceGetPostStepCallback(cpSpace *space, void *key)
    cpBool cpSpaceArbiterSetFilter(cpArbiter *arb, cpSpace *space)
    void cpSpaceFilterArbiters(cpSpace *space, cpBody *body, cpShape *filter)
    void cpSpaceActivateBody(cpSpace *space, cpBody *body)
    void cpSpaceLock(cpSpace *space)
    void cpSpaceUnlock(cpSpace *space, cpBool runPostStep)
    void cpSpaceUncacheArbiter(cpSpace *space, cpArbiter *arb)
    cpArray *cpSpaceArrayForBodyType(cpSpace *space, cpBodyType type)
    void cpShapeUpdateFunc(cpShape *shape, void *unused)
    cpCollisionID cpSpaceCollideShapes(cpShape *a, cpShape *b, cpCollisionID id, cpSpace *space)
    cpConstraint *cpConstraintNext(cpConstraint *node, cpBody *body)
    cpArbiter *cpArbiterNext(cpArbiter *node, cpBody *body)

cdef extern from "chipmunk/chipmunk_unsafe.h" nogil:
    void cpCircleShapeSetRadius(cpShape *shape, cpFloat radius)
    void cpCircleShapeSetOffset(cpShape *shape, cpVect offset)
    void cpSegmentShapeSetEndpoints(cpShape *shape, cpVect a, cpVect b)
    void cpSegmentShapeSetRadius(cpShape *shape, cpFloat radius)
    void cpPolyShapeSetVerts(cpShape *shape, int count, cpVect *verts, cpTransform transform)
    void cpPolyShapeSetVertsRaw(cpShape *shape, int count, cpVect *verts)
    void cpPolyShapeSetRadius(cpShape *shape, cpFloat radius)