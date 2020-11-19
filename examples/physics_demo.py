import time
from pyorama.physics import *
from pyorama.math3d import *

time_step = 1.0/60.0
total_time = 0.0
base_out = "t: {0}, pos_x: {1}, pos_y: {2}, vel_x: {3}, vel_y: {4}"
gravity = Vec2(0.0, -10.0)
physics = PhysicsManager()
space = Space(physics)
space.create()
space.set_gravity(gravity)

a = Vec2(-20.0, -5.0)
b = Vec2(20.0, -5.0)
ground_friction = 0.5
ground_body = Body(physics)
ground_body.create(type=BODY_TYPE_STATIC)
space.add_body(ground_body)
ground_shape = Shape(physics)
ground_shape.create_segment(ground_body, a, b, 0)
ground_shape.set_friction(ground_friction)
space.add_shape(ground_shape)

radius = 5.0
mass = 1.0
pos = Vec2(0.0, 15.0)
offset = Vec2()
ball_friction = 0.7
moment = Shape.moment_for_circle(mass, 0, radius, offset)
for i in range(10):
    ball_body = Body(physics)
    ball_body.create(mass, moment)
    space.add_body(ball_body)

while True:
    physics.update(time_step)
    pos = ball_body.get_position()
    vel = ball_body.get_velocity()
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

space.delete()
ground_body.delete()
ground_shape.delete()
ball_body.delete()
ball_shape.delete()