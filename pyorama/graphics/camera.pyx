cdef class Camera(HandleObject):

    cdef CameraC *get_ptr(self) except *:
        return <CameraC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create_orthographic(float x_mag, float y_mag, float z_near, float z_far):
        cdef:
            Camera camera
        camera = Camera.__new__(Camera)
        camera.create_orthographic(x_mag, y_mag, z_near, z_far)
        return camera

    @staticmethod
    def init_create_perspective(float aspect_ratio, float y_fov, float z_near, float z_far):
        cdef:
            Camera camera
        camera = Camera.__new__(Camera)
        camera.create_perspective(aspect_ratio, y_fov, z_near, z_far)
        return camera

    cpdef void create_orthographic(self, float x_mag, float y_mag, float z_near, float z_far) except *:
        cdef:
            CameraC *camera_ptr
            CameraProjInfoOrthographicC *proj_info

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_CAMERA)
        camera_ptr = self.get_ptr()
        proj_info = &camera_ptr.proj_info.orthographic
        camera_ptr.proj_type = CAMERA_PROJ_TYPE_ORTHOGRAPHIC
        proj_info.x_mag = x_mag
        proj_info.y_mag = y_mag
        proj_info.z_near = z_near
        proj_info.z_far = z_far
        #Mat4.c_orthographic(&camera_ptr.proj_mat, x_mag, y_mag, z_near, z_far)

    cpdef void create_perspective(self, float aspect_ratio, float y_fov, float z_near, float z_far) except *:
        cdef:
            CameraC *camera_ptr
            CameraProjInfoPerspectiveC *proj_info

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_CAMERA)
        camera_ptr = self.get_ptr()
        camera_ptr.proj_type = CAMERA_PROJ_TYPE_PERSPECTIVE
        proj_info = &camera_ptr.proj_info.perspective
        proj_info.aspect_ratio = aspect_ratio
        proj_info.y_fov = y_fov
        proj_info.z_near = z_near
        proj_info.z_far = z_far
        #Mat4.c_perspective(&camera_ptr.proj_mat, aspect_ratio, y_fov, z_near, z_far)

    cpdef void delete(self) except *:
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void get_proj_mat(self, Mat4 proj_mat) except *:
        cdef:
            CameraC *camera_ptr
        
        camera_ptr = self.get_ptr()
        #Mat4.c_copy(proj_mat.data, &camera_ptr.proj_mat)