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

    cpdef float moment_for_circle(self, float mass, float inner_radius, float outer_radius, Vec2 offset) except *:
        cdef cpVect *offset_ptr = <cpVect *>&offset.data
        return cpMomentForCircle(mass, inner_radius, outer_radius, offset_ptr[0])

    cpdef float area_for_circle(self, float inner_radius, float outer_radius) except *:
        return cpAreaForCircle(inner_radius, outer_radius)

    cpdef float moment_for_segment(self, float mass, Vec2 a, Vec2 b, float radius) except *:
        cdef:
            cpVect *a_ptr = <cpVect *>&a.data
            cpVect *b_ptr = <cpVect *>&b.data
        return cpMomentForSegment(mass, a_ptr[0], b_ptr[0], radius)

    cpdef float area_for_segment(self, Vec2 a, Vec2 b, float radius) except *:
        cdef:
            cpVect *a_ptr = <cpVect *>&a.data
            cpVect *b_ptr = <cpVect *>&b.data
        return cpAreaForSegment(a_ptr[0], b_ptr[0], radius)

    cpdef float moment_for_poly(self, float mass, float[:, :] vertices, Vec2 offset, float radius) except *:
        cdef:
            int count = vertices.shape[0]
            cpVect *vertices_ptr = <cpVect *>&vertices[0, 0]
            cpVect *offset_ptr = <cpVect *>&offset.data
        cpMomentForPoly(mass, count, vertices_ptr, offset_ptr[0], radius)

    cpdef float area_for_poly(self, float[:, :] vertices, float radius) except *:
        cdef:
            int count = vertices.shape[0]
            cpVect *vertices_ptr = <cpVect *>&vertices[0, 0]
        cpAreaForPoly(count, vertices_ptr, radius)

    cpdef float centroid_for_poly(self, float[:, :] vertices) except *:
        cdef:
            int count = vertices.shape[0]
            cpVect *vertices_ptr = <cpVect *>&vertices[0, 0]
        cpCentroidForPoly(count, vertices_ptr)

    cpdef float moment_for_box(self, float mass, float width, float height) except *:
        return cpMomentForBox(mass, width, height)

    cpdef float moment_for_box_2(self, float mass, float left, float bottom, float right, float top) except *:
        cdef cpBB box = cpBB(left, bottom, right, top)
        return cpMomentForBox2(mass, box)

    cdef SpaceC *space_get_ptr(self, Handle space) except *:
        return <SpaceC *>self.spaces.c_get_ptr(space)

    cpdef Handle space_create(self) except *:
        cdef:
            Handle space
            SpaceC *space_ptr
        space = self.spaces.c_create()
        space_ptr = self.space_get_ptr(space)
        space_ptr.cp = cpSpaceNew()
        if space_ptr.cp == NULL:
            raise MemoryError("Physics Space: cannot allocate memory")
        cpSpaceSetUserData(space_ptr.cp, <void *>space)
        return space

    cpdef void space_delete(self, Handle space) except *:
        cdef SpaceC *space_ptr
        space_ptr = self.space_get_ptr(space)
        cpSpaceFree(space_ptr.cp)
        self.spaces.c_delete(space)

    cpdef Vec2 space_get_gravity(self, Handle space):
        cdef:
            SpaceC *space_ptr
            cpVect g
            Vec2 gravity
        space_ptr = self.space_get_ptr(space)
        g = cpSpaceGetGravity(space_ptr.cp)
        gravity = Vec2(g.x, g.y)
        return gravity

    cpdef void space_set_gravity(self, Handle space, Vec2 gravity) except *:
        cdef:
            SpaceC *space_ptr
            cpVect *gravity_ptr
        space_ptr = self.space_get_ptr(space)
        gravity_ptr = <cpVect *>(&gravity.data)
        cpSpaceSetGravity(space_ptr.cp, gravity_ptr[0])
    
    cpdef float space_get_damping(self, Handle space) except *:
        cdef SpaceC *space_ptr = self.space_get_ptr(space)
        return cpSpaceGetDamping(space_ptr.cp)

    cpdef void space_set_damping(self, Handle space, float damping) except *:
        cdef SpaceC *space_ptr = self.space_get_ptr(space)
        cpSpaceSetDamping(space_ptr.cp, damping)

    cpdef void space_add_body(self, Handle space, Handle body) except *:
        cdef:
            SpaceC *space_ptr
            BodyC *body_ptr
        space_ptr = self.space_get_ptr(space)
        body_ptr = self.body_get_ptr(body)
        cpSpaceAddBody(space_ptr.cp, body_ptr.cp)

    cpdef void space_remove_body(self, Handle space, Handle body) except *:
        cdef:
            SpaceC *space_ptr
            BodyC *body_ptr
        space_ptr = self.space_get_ptr(space)
        body_ptr = self.body_get_ptr(body)
        cpSpaceRemoveBody(space_ptr.cp, body_ptr.cp)

    cpdef void space_add_shape(self, Handle space, Handle shape) except *:
        cdef:
            SpaceC *space_ptr
            ShapeC *shape_ptr
        space_ptr = self.space_get_ptr(space)
        shape_ptr = self.shape_get_ptr(shape)
        cpSpaceAddShape(space_ptr.cp, shape_ptr.cp)

    cpdef void space_remove_shape(self, Handle space, Handle shape) except *:
        cdef:
            SpaceC *space_ptr
            ShapeC *shape_ptr
        space_ptr = self.space_get_ptr(space)
        shape_ptr = self.shape_get_ptr(shape)
        cpSpaceRemoveShape(space_ptr.cp, shape_ptr.cp)

    cpdef void space_step(self, Handle space, float delta) except *:
        cdef SpaceC *space_ptr
        space_ptr = self.space_get_ptr(space)
        cpSpaceStep(space_ptr.cp, delta)

    cdef BodyC *body_get_ptr(self, Handle body) except *:
        return <BodyC *>self.bodies.c_get_ptr(body)

    cpdef Handle body_create(self, float mass=0.0, float moment=0.0, BodyType type=BODY_TYPE_DYNAMIC) except *:
        cdef:
            Handle body
            BodyC *body_ptr
        body = self.bodies.c_create()
        body_ptr = self.body_get_ptr(body)
        body_ptr.cp = cpBodyNew(mass, moment)
        if body_ptr.cp == NULL:
            raise MemoryError("Physics Body: cannot allocate memory")
        cpBodySetUserData(body_ptr.cp, <void *>body)
        cpBodySetType(body_ptr.cp, <cpBodyType>type)
        return body

    cpdef void body_delete(self, Handle body) except *:
        cdef BodyC *body_ptr
        body_ptr = self.body_get_ptr(body)
        cpBodyFree(body_ptr.cp)
        self.bodies.c_delete(body)

    cpdef Handle body_get_space(self, Handle body) except *:
        cdef:
            BodyC *body_ptr
            cpSpace *space_cp
        body_ptr = self.body_get_ptr(body)
        space_cp = cpBodyGetSpace(body_ptr.cp)
        return <Handle>cpSpaceGetUserData(space_cp)
    
    cpdef float body_get_mass(self, Handle body) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        return cpBodyGetMass(body_ptr.cp)

    cpdef void body_set_mass(self, Handle body, float mass) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        cpBodySetMass(body_ptr.cp, mass)
    
    cpdef float body_get_moment(self, Handle body) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        return cpBodyGetMoment(body_ptr.cp)

    cpdef void body_set_moment(self, Handle body, float moment) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        cpBodySetMoment(body_ptr.cp, moment)

    cpdef Vec2 body_get_position(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect position_data
            Vec2 position
        body_ptr = self.body_get_ptr(body)
        position_data = cpBodyGetPosition(body_ptr.cp)
        position = Vec2(position_data.x, position_data.y)
        return position

    cpdef void body_set_position(self, Handle body, Vec2 position) except *:
        cdef:
            BodyC *body_ptr
            cpVect *position_ptr
        body_ptr = self.body_get_ptr(body)
        position_ptr = <cpVect *>&position.data
        cpBodySetPosition(body_ptr.cp, position_ptr[0])

    cpdef Vec2 body_get_center_of_gravity(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect center_of_gravity_data
            Vec2 center_of_gravity
        body_ptr = self.body_get_ptr(body)
        center_of_gravity_data = cpBodyGetCenterOfGravity(body_ptr.cp)
        center_of_gravity = Vec2(center_of_gravity_data.x, center_of_gravity_data.y)
        return center_of_gravity

    cpdef void body_set_center_of_gravity(self, Handle body, Vec2 center_of_gravity) except *:
        cdef:
            BodyC *body_ptr
            cpVect *center_of_gravity_ptr
        body_ptr = self.body_get_ptr(body)
        center_of_gravity_ptr = <cpVect *>&center_of_gravity.data
        cpBodySetCenterOfGravity(body_ptr.cp, center_of_gravity_ptr[0])

    cpdef Vec2 body_get_velocity(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect velocity_data
            Vec2 velocity
        body_ptr = self.body_get_ptr(body)
        velocity_data = cpBodyGetVelocity(body_ptr.cp)
        velocity = Vec2(velocity_data.x, velocity_data.y)
        return velocity

    cpdef void body_set_velocity(self, Handle body, Vec2 velocity) except *:
        cdef:
            BodyC *body_ptr
            cpVect *velocity_ptr
        body_ptr = self.body_get_ptr(body)
        velocity_ptr = <cpVect *>&velocity.data
        cpBodySetVelocity(body_ptr.cp, velocity_ptr[0])

    cpdef Vec2 body_get_force(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect force_data
            Vec2 force
        body_ptr = self.body_get_ptr(body)
        force_data = cpBodyGetForce(body_ptr.cp)
        force = Vec2(force_data.x, force_data.y)
        return force

    cpdef void body_set_force(self, Handle body, Vec2 force) except *:
        cdef:
            BodyC *body_ptr
            cpVect *force_ptr
        body_ptr = self.body_get_ptr(body)
        force_ptr = <cpVect *>&force.data
        cpBodySetForce(body_ptr.cp, force_ptr[0])

    cpdef float body_get_angle(self, Handle body) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        return cpBodyGetAngle(body_ptr.cp)

    cpdef void body_set_angle(self, Handle body, float angle) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        cpBodySetAngle(body_ptr.cp, angle)

    cpdef float body_get_angular_velocity(self, Handle body) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        return cpBodyGetAngularVelocity(body_ptr.cp)

    cpdef void body_set_angular_velocity(self, Handle body, float angular_velocity) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        cpBodySetAngularVelocity(body_ptr.cp, angular_velocity)

    cpdef float body_get_torque(self, Handle body) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        return cpBodyGetTorque(body_ptr.cp)

    cpdef void body_set_torque(self, Handle body, float torque) except *:
        cdef BodyC *body_ptr = self.body_get_ptr(body)
        cpBodySetTorque(body_ptr.cp, torque)
    
    cpdef Vec2 body_get_rotation(self, Handle body):
        cdef:
            BodyC *body_ptr
            cpVect rotation_data
            Vec2 rotation
        body_ptr = self.body_get_ptr(body)
        rotation_data = cpBodyGetRotation(body_ptr.cp)
        rotation = Vec2(rotation_data.x, rotation_data.y)
        return rotation

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
        shape_ptr.cp = cpCircleShapeNew(body_ptr.cp, radius, offset_ptr[0])
        if shape_ptr.cp == NULL:
            raise MemoryError("Physics Shape: cannot allocate memory")
        cpShapeSetUserData(shape_ptr.cp, <void *>shape)
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
        shape_ptr.cp = cpSegmentShapeNew(body_ptr.cp, a_ptr[0], b_ptr[0], radius)
        if shape_ptr.cp == NULL:
            raise MemoryError("Physics Shape: cannot allocate memory")
        cpShapeSetUserData(shape_ptr.cp, <void *>shape)
        return shape

    #cpdef Handle shape_create_poly_line(self) except *
    #cpdef Handle shape_create_poly_shape(self) except *
    #cpdef Handle shape_create_poly_box(self) except *
    cpdef void shape_delete(self, Handle shape) except *:
        cdef ShapeC *shape_ptr
        shape_ptr = self.shape_get_ptr(shape)
        cpShapeFree(shape_ptr.cp)
        self.shapes.c_delete(shape)

    cpdef void shape_set_friction(self, Handle shape, float friction) except *:
        cdef ShapeC *shape_ptr
        shape_ptr = self.shape_get_ptr(shape)
        cpShapeSetFriction(shape_ptr.cp, friction)

    cpdef void update(self, float delta) except *:
        cdef:
            SpaceC *space_ptr
            size_t i
        for i in range(self.spaces.items.num_items):
            space_ptr = <SpaceC *>self.spaces.items.c_get_ptr(i)
            self.space_step(space_ptr.handle, delta)