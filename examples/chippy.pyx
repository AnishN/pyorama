from pyorama.libs.chipmunk cimport *
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

print(sizeof(cpFloat), sizeof(float), sizeof(double))
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
