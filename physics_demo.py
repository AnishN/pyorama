import time
from pyorama.physics.physics_manager import *
from pyorama.physics.physics_enums import *
from pyorama.math3d.vec2 import *

time_step = 1.0/60.0
total_time = 0.0
base_out = "t: {0}, pos_x: {1}, pos_y: {2}, vel_x: {3}, vel_y: {4}"
physics = PhysicsManager()
space = physics.space_create()
gravity = Vec2(0.0, -10.0)
physics.space_set_gravity(space, gravity)

a = Vec2(-20.0, -5.0)
b = Vec2(20.0, -5.0)
ground_body = physics.body_create(type=BODY_TYPE_STATIC)
physics.space_add_body(space, ground_body)
ground_shape = physics.shape_create_segment(ground_body, a, b, 0)
physics.shape_set_friction(ground_shape, 0.5)
physics.space_add_shape(space, ground_shape)

radius = 5.0
mass = 1.0
pos = Vec2(0.0, 15.0)
offset = Vec2()
ball_friction = 0.7
moment = physics.moment_for_circle(mass, 0, radius, offset)
ball_body = physics.body_create(mass, moment)
physics.space_add_body(space, ball_body)
physics.body_set_position(ball_body, pos)
ball_shape = physics.shape_create_circle(ball_body, radius, offset)
physics.shape_set_friction(ball_shape, ball_friction)
physics.space_add_shape(space, ball_shape)

while True:
    physics.update(time_step)
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