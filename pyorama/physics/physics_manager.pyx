cdef class PhysicsManager:
    def __cinit__(self):
        self.c_create_slot_maps()

    def __dealloc__(self):
        self.c_delete_slot_maps()

    cdef void c_create_slot_maps(self) except *:
        self.spaces = ItemSlotMap(sizeof(SpaceC), PHYSICS_ITEM_TYPE_SPACE)
        self.bodies = ItemSlotMap(sizeof(BodyC), PHYSICS_ITEM_TYPE_BODY)
        self.shapes = ItemSlotMap(sizeof(ShapeC), PHYSICS_ITEM_TYPE_SHAPE)

    cdef void c_delete_slot_maps(self) except *:
        self.spaces = None
        self.bodies = None
        self.shapes = None

    cdef SpaceC *space_get_ptr(self, Handle space) except *:
        return <SpaceC *>self.spaces.c_get_ptr(space)

    cpdef Handle space_create(self) except *:
        cdef:
            Handle space
            SpaceC *space_ptr
        space = self.spaces.c_create()
        space_ptr = self.space_get_ptr(space)
        cpSpaceInit(&space_ptr.cp)
        return space

    cpdef void space_delete(self, Handle space) except *:
        cdef SpaceC *space_ptr
        space_ptr = self.space_get_ptr(space)
        cpSpaceDestroy(&space_ptr.cp)
        self.spaces.c_delete(space)

import time

cdef:
    cpVect gravity = cpv(0, -10)
    cpSpace space
    cpSegmentShape ground
    cpFloat ground_friction = 1.0
    cpBody ball_body
    cpCircleShape ball_shape
    cpVect pos = cpv(0, 15)
    cpVect vel
    cpFloat radius = 5
    cpFloat mass = 1
    cpFloat moment = cpMomentForCircle(mass, 0, radius, cpvzero) 
    cpFloat ball_friction = 0.7
    cpFloat time_step = 1.0/60.0
    cpFloat i
    cpFloat total_time = 0.0
    str base_out = "t: {0}, pos_x: {1}, pos_y: {2}, vel_x: {3}, vel_y: {4}"
    str out

cpSpaceInit(&space)
cpSpaceSetGravity(&space, gravity)
cpSegmentShapeInit(&ground, cpSpaceGetStaticBody(&space), cpv(-20, -5), cpv(20, -5), 0)
cpShapeSetFriction(&ground.shape, ground_friction)
cpSpaceAddShape(&space, &ground.shape)

cpBodyInit(&ball_body, mass, moment)
cpSpaceAddBody(&space, &ball_body)
cpBodySetPosition(&ball_body, pos)

cpCircleShapeInit(&ball_shape, &ball_body, radius, cpvzero)
cpShapeSetFriction(&ball_shape.shape, ball_friction)
cpSpaceAddShape(&space, &ball_shape.shape)

while True:
    cpSpaceStep(&space, time_step)
    pos = cpBodyGetPosition(&ball_body)
    vel = cpBodyGetVelocity(&ball_body)
    out = base_out.format(
        round(total_time, 3), 
        round(pos.x, 3), 
        round(pos.y, 3), 
        round(vel.x, 3), 
        round(vel.y, 3),
    )
    print(out)
    total_time += time_step
    time.sleep(time_step)

cpShapeDestroy(&ball_shape.shape)
cpBodyDestroy(&ball_body)
cpShapeDestroy(&ground.shape)