ctypedef NodeC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Node:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return Node.get_ptr_by_handle(self.manager, self.handle)

    @staticmethod
    cdef uint8_t c_get_type() nogil:
        return ITEM_TYPE
    
    @staticmethod
    def get_type():
        return ITEM_TYPE

    @staticmethod
    cdef size_t c_get_size() nogil:
        return ITEM_SIZE

    @staticmethod
    def get_size():
        return ITEM_SIZE

    cpdef void create_empty(self, NodeType type) except *:
        cdef:
            NodeC *node_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        node_ptr = self.get_ptr()
        node_ptr.type = type
        node_ptr.object = 0
        node_ptr.is_dirty = True
        Mat4.c_identity(&node_ptr.local)
        Mat4.c_identity(&node_ptr.world)

    cpdef void create_from_camera(self, Camera camera) except *:
        cdef:
            NodeC *node_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        node_ptr = self.get_ptr()
        node_ptr.type = NODE_TYPE_CAMERA
        node_ptr.object = camera.handle
        node_ptr.is_dirty = True
        Mat4.c_identity(&node_ptr.local)
        Mat4.c_identity(&node_ptr.world)
    
    cpdef void create_from_mesh(self, Mesh mesh) except *:
        cdef:
            NodeC *node_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        node_ptr = self.get_ptr()
        node_ptr.type = NODE_TYPE_MESH
        node_ptr.object = mesh.handle
        node_ptr.is_dirty = True
        Mat4.c_identity(&node_ptr.local)
        Mat4.c_identity(&node_ptr.world)

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void get_translation(self, Vec3 translation) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        translation.data = node_ptr.translation

    cpdef void set_translation(self, Vec3 translation) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        node_ptr.translation = translation.data
        node_ptr.is_dirty = True

    cpdef void get_rotation(self, Quat rotation) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        rotation.data = node_ptr.rotation

    cpdef void set_rotation(self, Quat rotation) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        node_ptr.rotation = rotation.data
        node_ptr.is_dirty = True

    cpdef void get_scale(self, Vec3 scale) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        scale.data = node_ptr.scale

    cpdef void set_scale(self, Vec3 scale) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        node_ptr.scale = scale.data
        node_ptr.is_dirty = True

    cpdef void get_local(self, Mat4 transform) except *:
        cdef:
            NodeC *node_ptr
        node_ptr = self.get_ptr()
        if node_ptr.is_dirty:
            self.update_local()
        transform.data = node_ptr.local

    cpdef void set_local(self, Mat4 transform) except *:
        cdef:
            NodeC *node_ptr
            Mat4C *mat_ptr
            Vec3C scale_x, scale_y, scale_z
            Vec3C scale
            Mat3C rotation_mat

        node_ptr = self.get_ptr()
        node_ptr.local = transform.data
        node_ptr.is_dirty = True

        #decompose translation
        mat_ptr = &transform.data
        node_ptr.translation = Vec3C(mat_ptr.m03, mat_ptr.m13, mat_ptr.m23)

        #decompose scale
        scale_x = Vec3C(mat_ptr.m00, mat_ptr.m10, mat_ptr.m20)
        scale_y = Vec3C(mat_ptr.m01, mat_ptr.m11, mat_ptr.m21)
        scale_z = Vec3C(mat_ptr.m02, mat_ptr.m12, mat_ptr.m22)
        scale = Vec3C(
            Vec3.c_length(&scale_x),
            Vec3.c_length(&scale_y),
            Vec3.c_length(&scale_z),
        )
        node_ptr.scale = scale

        #decompose rotation
        rotation_mat = Mat3C(
            mat_ptr.m00 / scale.x,  mat_ptr.m01 / scale.y, mat_ptr.m02 / scale.z,
            mat_ptr.m10 / scale.x,  mat_ptr.m11 / scale.y, mat_ptr.m12 / scale.z,
            mat_ptr.m20 / scale.x,  mat_ptr.m21 / scale.y, mat_ptr.m22 / scale.z,
        )
        Quat.c_from_mat3(&node_ptr.rotation, &rotation_mat)

    cdef void c_update_local(self) except *:
        cdef:
            NodeC *node_ptr
            Mat4C *local_ptr
        node_ptr = self.get_ptr()
        local_ptr = &node_ptr.local
        Mat4.c_from_translation(local_ptr, &node_ptr.translation)
        Mat4.c_rotate_quat(local_ptr, local_ptr, &node_ptr.rotation)
        Mat4.c_scale(local_ptr, local_ptr, &node_ptr.scale)