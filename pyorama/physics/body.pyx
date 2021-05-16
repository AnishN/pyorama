cdef uint8_t ITEM_TYPE = PHYSICS_ITEM_TYPE_BODY
ctypedef BodyC ItemTypeC

cdef class Body:
    def __cinit__(self, PhysicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *c_get_ptr_by_index(PhysicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *c_get_ptr_by_handle(PhysicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.c_get_ptr(handle)

    cdef ItemTypeC *c_get_ptr(self) except *:
        return Body.c_get_ptr_by_handle(self.manager, self.handle)

    cpdef void create(self, float mass=0.0, float moment=0.0, BodyType type=BODY_TYPE_DYNAMIC) except *:
        cdef BodyC *body_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        body_ptr = self.c_get_ptr()
        body_ptr.cp = cpBodyNew(mass, moment)
        if body_ptr.cp == NULL:
            raise MemoryError("Physics Body: cannot allocate memory")
        cpBodySetUserData(body_ptr.cp, <void *>self.handle)
        cpBodySetType(body_ptr.cp, <cpBodyType>type)

    cpdef void delete(self) except *:
        cdef BodyC *body_ptr
        body_ptr = self.c_get_ptr()
        cpBodyFree(body_ptr.cp)
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef Space get_space(self):
        cdef:
            BodyC *body_ptr
            cpSpace *space_cp
            Space space = Space(self.manager)
        body_ptr = self.c_get_ptr()
        space_cp = cpBodyGetSpace(body_ptr.cp)
        space.handle = <Handle>cpSpaceGetUserData(space_cp)
        return space

    cpdef float get_mass(self) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        return cpBodyGetMass(body_ptr.cp)

    cpdef void set_mass(self, float mass) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        cpBodySetMass(body_ptr.cp, mass)

    cpdef float get_moment(self) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        return cpBodyGetMoment(body_ptr.cp)

    cpdef void set_moment(self, float moment) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        cpBodySetMoment(body_ptr.cp, moment)

    cpdef Vec2 get_position(self):
        cdef:
            BodyC *body_ptr
            cpVect position_data
            Vec2 position
        body_ptr = self.c_get_ptr()
        position_data = cpBodyGetPosition(body_ptr.cp)
        position = Vec2(position_data.x, position_data.y)
        return position

    cpdef void set_position(self, Vec2 position) except *:
        cdef:
            BodyC *body_ptr
            cpVect *position_ptr
        body_ptr = self.c_get_ptr()
        position_ptr = <cpVect *>&position.data
        cpBodySetPosition(body_ptr.cp, position_ptr[0])
        
    cpdef Vec2 get_center_of_gravity(self):
        cdef:
            BodyC *body_ptr
            cpVect center_of_gravity_data
            Vec2 center_of_gravity
        body_ptr = self.c_get_ptr()
        center_of_gravity_data = cpBodyGetCenterOfGravity(body_ptr.cp)
        center_of_gravity = Vec2(center_of_gravity_data.x, center_of_gravity_data.y)
        return center_of_gravity

    cpdef void set_center_of_gravity(self, Vec2 center_of_gravity) except *:
        cdef:
            BodyC *body_ptr
            cpVect *center_of_gravity_ptr
        body_ptr = self.c_get_ptr()
        center_of_gravity_ptr = <cpVect *>&center_of_gravity.data
        cpBodySetCenterOfGravity(body_ptr.cp, center_of_gravity_ptr[0])

    cpdef Vec2 get_velocity(self):
        cdef:
            BodyC *body_ptr
            cpVect velocity_data
            Vec2 velocity
        body_ptr = self.c_get_ptr()
        velocity_data = cpBodyGetVelocity(body_ptr.cp)
        velocity = Vec2(velocity_data.x, velocity_data.y)
        return velocity
    
    cpdef void set_velocity(self, Vec2 velocity) except *:
        cdef:
            BodyC *body_ptr
            cpVect *velocity_ptr
        body_ptr = self.c_get_ptr()
        velocity_ptr = <cpVect *>&velocity.data
        cpBodySetVelocity(body_ptr.cp, velocity_ptr[0])

    cpdef Vec2 get_force(self):
        cdef:
            BodyC *body_ptr
            cpVect force_data
            Vec2 force
        body_ptr = self.c_get_ptr()
        force_data = cpBodyGetForce(body_ptr.cp)
        force = Vec2(force_data.x, force_data.y)
        return force

    cpdef void set_force(self, Vec2 force) except *:
        cdef:
            BodyC *body_ptr
            cpVect *force_ptr
        body_ptr = self.c_get_ptr()
        force_ptr = <cpVect *>&force.data
        cpBodySetForce(body_ptr.cp, force_ptr[0])
    
    cpdef float get_angle(self) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        return cpBodyGetAngle(body_ptr.cp)

    cpdef void set_angle(self, float angle) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        cpBodySetAngle(body_ptr.cp, angle)

    cpdef float get_angular_velocity(self) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        return cpBodyGetAngularVelocity(body_ptr.cp)

    cpdef void set_angular_velocity(self, float angular_velocity) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        cpBodySetAngularVelocity(body_ptr.cp, angular_velocity)

    cpdef float get_torque(self) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        return cpBodyGetTorque(body_ptr.cp)

    cpdef void set_torque(self, float torque) except *:
        cdef BodyC *body_ptr = self.c_get_ptr()
        cpBodySetTorque(body_ptr.cp, torque)

    cpdef Vec2 get_rotation(self):
        cdef:
            BodyC *body_ptr
            cpVect rotation_data
            Vec2 rotation
        body_ptr = self.c_get_ptr()
        rotation_data = cpBodyGetRotation(body_ptr.cp)
        rotation = Vec2(rotation_data.x, rotation_data.y)
        return rotation