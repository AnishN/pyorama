ctypedef CameraC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Camera:
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
        return Camera.get_ptr_by_handle(self.manager, self.handle)

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

    cpdef void create(self) except *:
        cdef:
            CameraC *camera_ptr
            ProjectionC proj
        self.handle = self.manager.create(ITEM_TYPE)
        camera_ptr = self.get_ptr()
        proj = camera_ptr.projection
        proj.mode = PROJECTION_MODE_3D
        proj.three_d.fovy = 90.0
        camera_ptr.position = Vec3C(0.0, 0.0, 0.0)
        camera_ptr.forward = Vec3C(0.0, 0.0, -1.0)
        camera_ptr.up = Vec3C(0.0, 1.0, 0.0)
        camera_ptr.right = Vec3C(1.0, 0.0, 0.0)
        camera_ptr.yaw = 0.0
        camera_ptr.pitch = 0.0
        camera_ptr.zoom = 1.0

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void get_projection_matrix(self, Mat4 matrix) except *:
        cdef:
            CameraC *camera_ptr
            ProjectionC proj
            Mat4C *matrix_ptr
        camera_ptr = self.get_ptr()
        matrix_ptr = &matrix.data
        proj = camera_ptr.projection
        if proj.mode == PROJECTION_MODE_2D:
            Mat4.c_ortho(
                matrix_ptr, 
                proj.two_d.left, proj.two_d.right, 
                proj.two_d.bottom, proj.two_d.top,
                proj.two_d.near, proj.two_d.far,
            )
        elif proj.mode == PROJECTION_MODE_3D:
            Mat4.c_perspective(
                matrix_ptr,
                proj.three_d.fovy, proj.three_d.aspect,
                proj.three_d.near, proj.three_d.far,
            )

    cpdef void set_projection_2d(self, float left, float right, float bottom, float top, float near, float far) except *:
        cdef:
            CameraC *camera_ptr
            ProjectionC proj
        camera_ptr = self.get_ptr()
        proj = camera_ptr.projection
        proj.mode = PROJECTION_MODE_2D
        proj.two_d.left = left
        proj.two_d.right = right
        proj.two_d.bottom = bottom
        proj.two_d.top = top
        proj.two_d.near = near
        proj.two_d.far = far

    cpdef void set_projection_3d(self, float fovy, float aspect, float near, float far) except *:
        cdef:
            CameraC *camera_ptr
            ProjectionC proj
        camera_ptr = self.get_ptr()
        proj = camera_ptr.projection
        proj.mode = PROJECTION_MODE_3D
        proj.three_d.fovy = fovy
        proj.three_d.aspect = aspect
        proj.three_d.near = near
        proj.three_d.far = far