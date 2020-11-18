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

    cdef BodyC *body_get_ptr(self, Handle body) except *:
        return <BodyC *>self.bodies.c_get_ptr(body)

    cdef ShapeC *shape_get_ptr(self, Handle shape) except *:
        return <ShapeC *>self.shapes.c_get_ptr(shape)

    cdef SpaceC *space_get_ptr(self, Handle space) except *:
        return <SpaceC *>self.spaces.c_get_ptr(space)

    cpdef void update(self, float delta) except *:
        cdef:
            SpaceC *space_ptr
            Space space
            size_t i
        space = Space(self)
        for i in range(self.spaces.items.num_items):
            space_ptr = <SpaceC *>self.spaces.items.c_get_ptr(i)
            space.handle = space_ptr.handle
            space.step(delta)