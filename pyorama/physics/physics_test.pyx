"""
import os
import math
from pyorama.physics.physics_manager import *
from pyorama.math3d.vec2 import Vec2
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4

width = 800
height = 600
physics = PhysicsManager()
radius = 25.0
center = Vec2(width / 2.0, height / 2.0)
inner_offset = Vec2(2.0 * radius, 0.0)
outer_corner_offset = Vec2(4.0 * radius, 0.0)
outer_edge_offset = Vec2(
    math.sqrt(8 * radius * radius * (1 - math.cos(math.radians(120)))), 
    0.0,
)#law of cosines
red_positions = [Vec2(center.x, center.y)]
white_positions = []
black_positions = []
base_offset = Vec2()
Vec2.add(base_offset, center, inner_offset)

#white inner
for i in range(3):
    offset = Vec2()
    angle = math.radians(30 + i * 120)
    Vec2.rotate(offset, base_offset, center, angle)
    white_positions.append(offset)

#black inner
for i in range(3):
    offset = Vec2()
    angle = math.radians(90 + i * 120)
    Vec2.rotate(offset, base_offset, center, angle)
    black_positions.append(offset)

#white outer
Vec2.add(base_offset, center, outer_corner_offset)
for i in range(6):
    offset = Vec2()
    angle = math.radians(30 + 60 * i)
    Vec2.rotate(offset, base_offset, center, angle)
    white_positions.append(offset)

#black outer
Vec2.add(base_offset, center, outer_edge_offset)
for i in range(6):
    offset = Vec2()
    angle = math.radians(60 * i)
    Vec2.rotate(offset, base_offset, center, angle)
    black_positions.append(offset)

num_pieces = 19

from pyorama.core.item_vector cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.chipmunk cimport *
from pyorama.physics.physics_structs cimport *

cdef:
    SpaceC space
    #ItemVector bodies
    ItemSlotMap bodies
    #BodyC *body = <BodyC *>calloc(1, sizeof(BodyC))
    Handle body
    BodyC *body_ptr
    int n = 1900

cpSpaceInit(&space.cp)
bodies = ItemSlotMap(sizeof(BodyC), 5)

for i in range(n):
    body = bodies.c_create()
    print(i, n, body)

for i in range(n):
    #body_ptr = <BodyC *>bodies.items
    #body_ptr = <BodyC *>bodies.c_get_ptr(body)
    body_ptr = <BodyC *>bodies.items.c_get_ptr(i)
    #body = (<BodyC *>bodies.c_get_ptr(i))[0]
    cpBodyInit(&body_ptr.cp, 1.0, 500)
    cpSpaceAddBody(&space.cp, &body_ptr.cp)
    print(i, n, <uintptr_t>body_ptr)

print("done")
cpSpaceStep(&space.cp, 1/60.0)
print("done")
"""

"""
from pyorama.physics.physics_manager import *
physics = PhysicsManager()
space = physics.space_create()
piece_mass = 1.0
piece_moment = 100
n = 19
for i in range(n):
    body = physics.body_create(piece_mass, piece_moment)
    physics.space_add_body(space, body)
physics.update(1/60.0)
"""

"""
from pyorama.physics.physics_manager cimport *
from pyorama.physics.physics_structs cimport *

cdef:
    PhysicsManager physics
    SpaceC *space_ptr
    BodyC *body_ptr

physics = PhysicsManager()
space = physics.space_create()
space_ptr = physics.space_get_ptr(space)
piece_mass = 1.0
piece_moment = 100
n = 5
for i in range(n):
    body = physics.body_create(piece_mass, piece_moment)
    body_ptr = physics.body_get_ptr(body)
    cpSpaceAddBody(&space_ptr.cp, &body_ptr.cp)
    #physics.space_add_body(space, body)
#physics.update(1/60.0)
cpSpaceStep(&space_ptr.cp, 1/60.0)
"""

"""
#this does NOT work!
from pyorama.physics.physics_manager cimport *
from pyorama.physics.physics_structs cimport *
cdef:
    PhysicsManager physics
    SpaceC *space_ptr
    BodyC *body_ptr
physics = PhysicsManager()
space = physics.space_create()
print("s", space)
space_ptr = physics.space_get_ptr(space)
piece_mass = 1.0
piece_moment = 100
n = 5
for i in range(n):
    body = physics.bodies.c_create()
    body_ptr = physics.body_get_ptr(body)
    cpBodyInit(&body_ptr.cp, piece_mass, piece_moment)
    cpSpaceAddBody(&space_ptr.cp, &body_ptr.cp)
    print("b", body)
cpSpaceStep(&space_ptr.cp, 1/60.0)
"""

"""
#this works!
from pyorama.libs.chipmunk cimport *
from pyorama.physics.physics_structs cimport *
cdef:
    size_t i
    size_t n = 10
    float piece_mass = 1.0
    float piece_moment = 100
    SpaceC *space_ptr = <SpaceC *>calloc(sizeof(SpaceC), 1)
    BodyC *body_ptr = <BodyC *>calloc(sizeof(BodyC), n)
    BodyC *curr_body_ptr
    cpBody *cp_body_ptr
print(sizeof(BodyC), sizeof(cpBody))
cpSpaceInit(&space_ptr.cp)
for i in range(n):
    curr_body_ptr = body_ptr + i
    cp_body_ptr = &curr_body_ptr.cp
    print(i, <uintptr_t>body_ptr, <uintptr_t>curr_body_ptr, <uintptr_t>cp_body_ptr)
    cpBodyInit(cp_body_ptr, piece_mass, piece_moment)
    cpSpaceAddBody(&space_ptr.cp, cp_body_ptr)
cpSpaceStep(&space_ptr.cp, 1/60.0)
"""

"""
#this works!
from pyorama.libs.chipmunk cimport *
from pyorama.physics.physics_structs cimport *
from pyorama.core.item_vector cimport *
cdef:
    size_t i
    size_t n = 10
    float piece_mass = 1.0
    float piece_moment = 100
    ItemVector spaces
    ItemVector bodies
    SpaceC *space_ptr
    BodyC *curr_body_ptr
    cpBody *cp_body_ptr

spaces = ItemVector(sizeof(SpaceC))
spaces.c_push_empty()
space_ptr = <SpaceC *>spaces.c_get_ptr(0)
cpSpaceInit(&space_ptr.cp)
bodies = ItemVector(sizeof(BodyC))
for i in range(n):
    bodies.c_push_empty()
for i in range(n):
    curr_body_ptr = <BodyC *>bodies.c_get_ptr(i)
    cp_body_ptr = &curr_body_ptr.cp
    print(i, <uintptr_t>curr_body_ptr, <uintptr_t>cp_body_ptr)
    cpBodyInit(cp_body_ptr, piece_mass, piece_moment)
    cpSpaceAddBody(&space_ptr.cp, cp_body_ptr)
cpSpaceStep(&space_ptr.cp, 1/60.0)
"""