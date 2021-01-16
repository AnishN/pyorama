cdef class PhysicsManager:

    def __cinit__(self):
        cdef:
            dict item_types_info
        item_types_info = {
            PHYSICS_ITEM_TYPE_SPACE: sizeof(SpaceC),
            PHYSICS_ITEM_TYPE_BODY: sizeof(BodyC),
            PHYSICS_ITEM_TYPE_SHAPE: sizeof(ShapeC),
        }
        self.register_item_types(item_types_info)

    def __dealloc__(self):
        pass

    cpdef void update(self, float delta) except *:
        cdef:
            ItemSlotMap slot_map
            SpaceC *space_ptr
            Space space
            size_t i

        space = Space(self)
        slot_map = self.get_slot_map(PHYSICS_ITEM_TYPE_SPACE)
        for i in range(slot_map.items.num_items):
            space_ptr = Space.get_ptr_by_index(self, i)
            space.handle = space_ptr.handle
            space.step(delta)