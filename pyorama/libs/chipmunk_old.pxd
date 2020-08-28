from libc.stdint cimport uintptr_t, uint32_t

#Basic/Core Chipmunk Types
cdef extern from "chipmunk/chipmunk.h":    
    ctypedef double cpFloat
    ctypedef struct cpVect:
        cpFloat x,y
    cpVect cpv(cpFloat x, cpFloat y)
    ctypedef void * cpDataPointer

#Body
cdef extern from "chipmunk/chipmunk.h":   
    ctypedef enum cpBodyType:
        CP_BODY_TYPE_DYNAMIC
        CP_BODY_TYPE_KINEMATIC
        CP_BODY_TYPE_STATIC

    ctypedef struct cpBody:
        pass

    cpBody * cpBodyNew(cpFloat mass, cpFloat moment)
    cpBody * cpBodyNewKinematic()
    cpBody * cpBodyNewStatic()
    void cpBodyFree(cpBody *body)

    cpFloat cpBodyGetMass(const cpBody *body)
    void cpBodySetMass(cpBody *body, cpFloat m)
    cpFloat cpBodyGetMoment(const cpBody *body)
    void cpBodySetMoment(cpBody *body, cpFloat i)
    cpVect cpBodyGetPos(const cpBody *body)
    void cpBodySetPos(cpBody *body, cpVect pos)
    cpVect cpBodyGetVel(const cpBody *body)
    void cpBodySetVel(cpBody *body, const cpVect value)
    cpVect cpBodyGetForce(const cpBody *body)
    void cpBodySetForce(cpBody *body, const cpVect value)
    cpFloat cpBodyGetAngle(const cpBody *body)
    void cpBodySetAngle(cpBody *body, cpFloat a)
    cpFloat cpBodyGetAngVel(const cpBody *body)
    void cpBodySetAngVel(cpBody *body, const cpFloat value)
    cpFloat cpBodyGetTorque(const cpBody *body)
    void cpBodySetTorque(cpBody *body, const cpFloat value)
    cpVect cpBodyGetRot(const cpBody *body)
    cpFloat cpBodyGetVelLimit(const cpBody *body)
    void cpBodySetVelLimit(cpBody *body, const cpFloat value)
    cpFloat cpBodyGetAngVelLimit(const cpBody *body)
    void cpBodySetAngVelLimit(cpBody *body, const cpFloat value)
    cpDataPointer cpBodyGetUserData(const cpBody *body)
    void cpBodySetUserData(cpBody *body, const cpDataPointer value)

#Space
cdef extern from "chipmunk/chipmunk.h":
    ctypedef struct cpSpace:
        pass
    
    cpSpace * cpSpaceNew()
    void cpSpaceFree(cpSpace *space)
    cpVect cpSpaceGetGravity(cpSpace *space)
    void cpSpaceSetGravity(cpSpace *space, cpVect value)
    
    cpShape * cpSpaceAddShape(cpSpace *space, cpShape *shape)
    cpBody * cpSpaceAddBody(cpSpace *space, cpBody *body)
    void cpSpaceRemoveShape(cpSpace *space, cpShape *shape)
    void cpSpaceRemoveBody(cpSpace *space, cpBody *body)
    void cpSpaceStep(cpSpace *space, cpFloat dt)
    
#Shape
cdef extern from "chipmunk/chipmunk.h":
    ctypedef struct cpShape:
        pass
    
    #Helper functions
    cpFloat cpMomentForCircle(cpFloat m, cpFloat r1, cpFloat r2, cpVect offset)
    cpFloat cpMomentForSegment(cpFloat m, cpVect a, cpVect b)
    cpFloat cpMomentForPoly(cpFloat m, int numVerts, cpVect *verts, cpVect offset)
    cpFloat cpMomentForBox(cpFloat m, cpFloat width, cpFloat height)
    
    cpShape * cpSegmentShapeNew(cpBody *body, cpVect a, cpVect b, cpFloat radius)
    cpShape * cpCircleShapeNew (cpBody *body, cpFloat radius, cpVect offset)
    void cpShapeFree(cpShape *shape)
    cpFloat cpShapeGetFriction(cpShape *shape)
    void cpShapeSetFriction(cpShape *shape, cpFloat friction)