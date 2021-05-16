cdef uint8_t ITEM_TYPE = PHYSICS_ITEM_TYPE_SHAPE
ctypedef ShapeC ItemTypeC

cdef class Shape:
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
        return Shape.c_get_ptr_by_handle(self.manager, self.handle)

    @staticmethod
    cdef float c_moment_for_circle(float mass, float inner_radius, float outer_radius, Vec2 offset) except *:
        cdef cpVect *offset_ptr = <cpVect *>&offset.data
        return cpMomentForCircle(mass, inner_radius, outer_radius, offset_ptr[0])

    @staticmethod
    def moment_for_circle(float mass, float inner_radius, float outer_radius, Vec2 offset):
        return Shape.c_moment_for_circle(mass, inner_radius, outer_radius, offset)

    @staticmethod
    cdef float c_area_for_circle(float inner_radius, float outer_radius) except *:
        return cpAreaForCircle(inner_radius, outer_radius)

    def area_for_circle(float inner_radius, float outer_radius):
        return Shape.c_area_for_circle(inner_radius, outer_radius)

    @staticmethod
    cdef float c_moment_for_segment(float mass, Vec2 a, Vec2 b, float radius) except *:
        cdef:
            cpVect *a_ptr = <cpVect *>&a.data
            cpVect *b_ptr = <cpVect *>&b.data
        return cpMomentForSegment(mass, a_ptr[0], b_ptr[0], radius)

    @staticmethod
    def moment_for_segment(float mass, Vec2 a, Vec2 b, float radius):
        return Shape.c_moment_for_segment(mass, a, b, radius)

    @staticmethod
    cdef float c_area_for_segment(Vec2 a, Vec2 b, float radius) except *:
        cdef:
            cpVect *a_ptr = <cpVect *>&a.data
            cpVect *b_ptr = <cpVect *>&b.data
        return cpAreaForSegment(a_ptr[0], b_ptr[0], radius)

    @staticmethod
    def area_for_segment(Vec2 a, Vec2 b, float radius):
        return Shape.c_area_for_segment(a, b, radius)

    @staticmethod
    cdef float c_moment_for_poly(float mass, float[:, :] vertices, Vec2 offset, float radius) except *:
        cdef:
            int count = vertices.shape[0]
            cpVect *vertices_ptr = <cpVect *>&vertices[0, 0]
            cpVect *offset_ptr = <cpVect *>&offset.data
        cpMomentForPoly(mass, count, vertices_ptr, offset_ptr[0], radius)

    @staticmethod
    def moment_for_poly(float mass, float[:, :] vertices, Vec2 offset, float radius):
        return Shape.c_moment_for_poly(mass, vertices, offset, radius)

    @staticmethod
    cdef float c_area_for_poly(float[:, :] vertices, float radius) except *:
        cdef:
            int count = vertices.shape[0]
            cpVect *vertices_ptr = <cpVect *>&vertices[0, 0]
        cpAreaForPoly(count, vertices_ptr, radius)

    @staticmethod
    def area_for_poly(float[:, :] vertices, float radius):
        return Shape.c_area_for_poly(vertices, radius)

    @staticmethod
    cdef float c_centroid_for_poly(float[:, :] vertices) except *:
        cdef:
            int count = vertices.shape[0]
            cpVect *vertices_ptr = <cpVect *>&vertices[0, 0]
        cpCentroidForPoly(count, vertices_ptr)

    @staticmethod
    def centroid_for_poly(float[:, :] vertices):
        return Shape.c_centroid_for_poly(vertices)

    @staticmethod
    cdef float c_moment_for_box(float mass, float width, float height) except *:
        return cpMomentForBox(mass, width, height)

    @staticmethod
    def moment_for_box(float mass, float width, float height):
        return Shape.c_moment_for_box(mass, width, height)

    @staticmethod
    cdef float c_moment_for_box_2(float mass, float left, float bottom, float right, float top) except *:
        cdef cpBB box = cpBB(left, bottom, right, top)
        return cpMomentForBox2(mass, box)

    @staticmethod
    def moment_for_box_2(float mass, float left, float bottom, float right, float top):
        return Shape.moment_for_box_2(mass, left, bottom, right, top)

    cpdef void create_circle(self, Body body, float radius, Vec2 offset) except *:
        cdef:
            ShapeC *shape_ptr
            BodyC *body_ptr
            cpVect *offset_ptr
        
        self.handle = self.manager.create(ITEM_TYPE)
        shape_ptr = self.c_get_ptr()
        body_ptr = body.c_get_ptr()
        offset_ptr = <cpVect *>&offset.data
        shape_ptr.cp = cpCircleShapeNew(body_ptr.cp, radius, offset_ptr[0])
        if shape_ptr.cp == NULL:
            raise MemoryError("Physics Shape: cannot allocate memory")
        cpShapeSetUserData(shape_ptr.cp, <void *>self.handle)

    cpdef void create_segment(self, Body body, Vec2 a, Vec2 b, float radius) except *:
        cdef:
            ShapeC *shape_ptr
            BodyC *body_ptr
            cpVect *a_ptr
            cpVect *b_ptr
        
        self.handle = self.manager.create(ITEM_TYPE)
        shape_ptr = self.c_get_ptr()
        body_ptr = body.c_get_ptr()
        a_ptr = <cpVect *>&a.data
        b_ptr = <cpVect *>&b.data
        shape_ptr.cp = cpSegmentShapeNew(body_ptr.cp, a_ptr[0], b_ptr[0], radius)
        if shape_ptr.cp == NULL:
            raise MemoryError("Physics Shape: cannot allocate memory")
        cpShapeSetUserData(shape_ptr.cp, <void *>self.handle)

    #cpdef void create_poly_line(self) except *
    #cpdef void create_poly_shape(self) except *
    #cpdef void create_poly_box(self) except *
    cpdef void delete(self) except *:
        cdef ShapeC *shape_ptr = self.c_get_ptr()
        cpShapeFree(shape_ptr.cp)
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void set_elasticity(self, float elasticity) except *:
        cdef ShapeC *shape_ptr = self.c_get_ptr()
        cpShapeSetElasticity(shape_ptr.cp, elasticity)

    cpdef void set_friction(self, float friction) except *:
        cdef ShapeC *shape_ptr = self.c_get_ptr()
        cpShapeSetFriction(shape_ptr.cp, friction)