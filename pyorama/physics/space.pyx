cdef uint8_t ITEM_TYPE = PHYSICS_ITEM_TYPE_SPACE
ctypedef SpaceC ItemTypeC

cdef class Space:
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
        return Space.c_get_ptr_by_handle(self.manager, self.handle)
    
    cpdef void create(self) except *:
        cdef:
            SpaceC *space_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        space_ptr = self.c_get_ptr()
        space_ptr.cp = cpSpaceNew()
        if space_ptr.cp == NULL:
            raise MemoryError("Physics Space: cannot allocate memory")
        cpSpaceSetUserData(space_ptr.cp, <void *>self.handle)

    cpdef void delete(self) except *:
        cdef SpaceC *space_ptr
        space_ptr = self.c_get_ptr()
        cpSpaceFree(space_ptr.cp)
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef Vec2 get_gravity(self):
        cdef:
            SpaceC *space_ptr
            cpVect g
            Vec2 gravity
        space_ptr = self.c_get_ptr()
        g = cpSpaceGetGravity(space_ptr.cp)
        gravity = Vec2(g.x, g.y)
        return gravity
    
    cpdef void set_gravity(self, Vec2 gravity) except *:
        cdef:
            SpaceC *space_ptr
            cpVect *gravity_ptr
        space_ptr = self.c_get_ptr()
        gravity_ptr = <cpVect *>(&gravity.data)
        cpSpaceSetGravity(space_ptr.cp, gravity_ptr[0])

    cpdef float get_damping(self) except *:
        cdef SpaceC *space_ptr = self.c_get_ptr()
        return cpSpaceGetDamping(space_ptr.cp)

    cpdef void set_damping(self, float damping) except *:
        cdef SpaceC *space_ptr = self.c_get_ptr()
        cpSpaceSetDamping(space_ptr.cp, damping)

    cpdef void add_body(self, Body body) except *:
        cdef:
            SpaceC *space_ptr = self.c_get_ptr()
            BodyC *body_ptr = body.c_get_ptr()
        cpSpaceAddBody(space_ptr.cp, body_ptr.cp)

    cpdef void remove_body(self, Body body) except *:
        cdef:
            SpaceC *space_ptr = self.c_get_ptr()
            BodyC *body_ptr = body.c_get_ptr()
        cpSpaceRemoveBody(space_ptr.cp, body_ptr.cp)

    cpdef void add_shape(self, Shape shape) except *:
        cdef:
            SpaceC *space_ptr = self.c_get_ptr()
            ShapeC *shape_ptr = shape.c_get_ptr()
        cpSpaceAddShape(space_ptr.cp, shape_ptr.cp)

    cpdef void remove_shape(self, Shape shape) except *:
        cdef:
            SpaceC *space_ptr = self.c_get_ptr()
            ShapeC *shape_ptr = shape.c_get_ptr()
        cpSpaceRemoveShape(space_ptr.cp, shape_ptr.cp)

    cpdef void step(self, float delta) except *:
        cdef SpaceC *space_ptr = self.c_get_ptr()
        cpSpaceStep(space_ptr.cp, delta)