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

    cpdef Vec2 space_get_gravity(self, Handle space):
        cdef:
            SpaceC *space_ptr
            cpVect g
            Vec2 gravity
        space_ptr = self.space_get_ptr(space)
        g = cpSpaceGetGravity(&space_ptr.cp)
        gravity = Vec2(g.x, g.y)
        return gravity

    cpdef void space_set_gravity(self, Handle space, Vec2 gravity) except *:
        cdef:
            SpaceC *space_ptr
            cpVect *gravity_ptr
        space_ptr = self.space_get_ptr(space)
        gravity_ptr = <cpVect *>(&gravity.data)
        cpSpaceSetGravity(&space_ptr.cp, gravity_ptr[0])
    
    cpdef void space_add_body(self, Handle space, Handle body) except *:
        cdef:
            SpaceC *space_ptr
            BodyC *body_ptr
        space_ptr = self.space_get_ptr(space)
        body_ptr = self.body_get_ptr(body)
        cpSpaceAddBody(&space_ptr.cp, &body_ptr.cp)

    cpdef void space_remove_body(self, Handle space, Handle body) except *:
        cdef:
            SpaceC *space_ptr
            BodyC *body_ptr
        space_ptr = self.space_get_ptr(space)
        body_ptr = self.body_get_ptr(body)
        cpSpaceRemoveBody(&space_ptr.cp, &body_ptr.cp)

    cpdef void space_add_shape(self, Handle space, Handle shape) except *:
        cdef:
            SpaceC *space_ptr
            ShapeC *shape_ptr
        space_ptr = self.space_get_ptr(space)
        shape_ptr = self.shape_get_ptr(shape)
        cpSpaceAddShape(&space_ptr.cp, &shape_ptr.cp.shape)

    cpdef void space_remove_shape(self, Handle space, Handle shape) except *:
        cdef:
            SpaceC *space_ptr
            ShapeC *shape_ptr
        space_ptr = self.space_get_ptr(space)
        shape_ptr = self.shape_get_ptr(shape)
        cpSpaceRemoveShape(&space_ptr.cp, &shape_ptr.cp.shape)

    cpdef void space_step(self, Handle space, float delta) except *:
        cdef SpaceC *space_ptr
        space_ptr = self.space_get_ptr(space)
        cpSpaceStep(&space_ptr.cp, delta)

    cdef BodyC *body_get_ptr(self, Handle body) except *:
        return <BodyC *>self.bodies.c_get_ptr(body)

    cpdef Handle body_create(self, float mass=0.0, float moment=0.0, BodyType type=BODY_TYPE_DYNAMIC) except *:
        cdef:
            Handle body
            BodyC *body_ptr
        body = self.bodies.c_create()
        body_ptr = self.body_get_ptr(body)
        cpBodyInit(&body_ptr.cp, mass, moment)
        cpBodySetType(&body_ptr.cp, <cpBodyType>type)
        return body

    cpdef void body_delete(self, Handle body) except *:
        cdef BodyC *body_ptr
        body_ptr = self.body_get_ptr(body)
        cpBodyDestroy(&body_ptr.cp)
        self.bodies.c_delete(body)

    cpdef Vec2 body_get_position(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect position_data
            Vec2 position
        body_ptr = self.body_get_ptr(body)
        position_data = cpBodyGetPosition(&body_ptr.cp)
        position = Vec2(position_data.x, position_data.y)
        return position

    cpdef void body_set_position(self, Handle body, Vec2 position) except *:
        cdef:
            BodyC *body_ptr
            cpVect *position_ptr
        body_ptr = self.body_get_ptr(body)
        position_ptr = <cpVect *>&position.data
        cpBodySetPosition(&body_ptr.cp, position_ptr[0])

    cpdef Vec2 body_get_velocity(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect velocity_data
            Vec2 velocity
        body_ptr = self.body_get_ptr(body)
        velocity_data = cpBodyGetVelocity(&body_ptr.cp)
        velocity = Vec2(velocity_data.x, velocity_data.y)
        return velocity

    cdef ShapeC *shape_get_ptr(self, Handle shape) except *:
        return <ShapeC *>self.shapes.c_get_ptr(shape)

    cpdef Handle shape_create_circle(self, Handle body, float radius, Vec2 offset) except *:
        cdef:
            Handle shape
            ShapeC *shape_ptr
            BodyC *body_ptr
            cpVect *offset_ptr
        
        shape = self.shapes.c_create()
        shape_ptr = self.shape_get_ptr(shape)
        body_ptr = self.body_get_ptr(body)
        offset_ptr = <cpVect *>&offset.data
        cpCircleShapeInit(&shape_ptr.cp.circle, &body_ptr.cp, radius, offset_ptr[0])
        return shape

    cpdef Handle shape_create_segment(self, Handle body, Vec2 a, Vec2 b, float radius) except *:
        cdef:
            Handle shape
            ShapeC *shape_ptr
            BodyC *body_ptr
            cpVect *a_ptr
            cpVect *b_ptr
        
        shape = self.shapes.c_create()
        shape_ptr = self.shape_get_ptr(shape)
        body_ptr = self.body_get_ptr(body)
        a_ptr = <cpVect *>&a.data
        b_ptr = <cpVect *>&b.data
        cpSegmentShapeInit(&shape_ptr.cp.segment, &body_ptr.cp, a_ptr[0], b_ptr[0], radius)
        return shape

    #cpdef Handle shape_create_poly_line(self) except *
    #cpdef Handle shape_create_poly_shape(self) except *
    #cpdef Handle shape_create_poly_box(self) except *
    cpdef void shape_delete(self, Handle shape) except *:
        cdef ShapeC *shape_ptr
        shape_ptr = self.shape_get_ptr(shape)
        cpShapeDestroy(&shape_ptr.cp.shape)
        self.shapes.c_delete(shape)

    cpdef void shape_set_friction(self, Handle shape, float friction) except *:
        cdef ShapeC *shape_ptr
        shape_ptr = self.shape_get_ptr(shape)
        cpShapeSetFriction(&shape_ptr.cp.shape, friction)

import time

cdef:
    PhysicsManager physics
    Handle space
    float time_step = 1.0/60.0
    float total_time = 0.0
    str base_out = "t: {0}, pos_x: {1}, pos_y: {2}, vel_x: {3}, vel_y: {4}"
    str out

    Handle ground_body
    Handle ground_shape
    Vec2 a = Vec2(-20.0, -5.0)
    Vec2 b = Vec2(20.0, -5.0)

    Handle ball_body
    Handle ball_shape
    float radius = 5.0
    float mass = 1.0
    float moment = cpMomentForCircle(mass, 0, radius, cpvzero)
    Vec2 pos = Vec2(0.0, 15.0)
    Vec2 offset = Vec2()
    cpFloat ball_friction = 0.7

physics = PhysicsManager()
space = physics.space_create()
physics.space_set_gravity(space, Vec2(0.0, -10.0))

ground_body = physics.body_create(type=BODY_TYPE_STATIC)
physics.space_add_body(space, ground_body)
ground_shape = physics.shape_create_segment(ground_body, a, b, 0)
physics.shape_set_friction(ground_shape, 0.5)
physics.space_add_shape(space, ground_shape)

ball_body = physics.body_create(mass, moment)
physics.space_add_body(space, ball_body)
physics.body_set_position(ball_body, pos)
ball_shape = physics.shape_create_circle(ball_body, radius, offset)
physics.shape_set_friction(ball_shape, ball_friction)
physics.space_add_shape(space, ball_shape)

while True:
    physics.space_step(space, time_step)
    pos = physics.body_get_position(ball_body)
    vel = physics.body_get_velocity(ball_body)
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

physics.space_delete(space)
physics.body_delete(ground_body)
physics.shape_delete(ground_shape)
physics.body_delete(ball_body)
physics.shape_delete(ball_shape)