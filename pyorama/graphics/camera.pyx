cdef CameraC *c_camera_get_ptr(Handle handle) except *:
    cdef:
        CameraC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.cameras, handle, <void **>&ptr))
    return ptr

cdef Handle c_camera_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.cameras, &handle))
    return handle

cdef void c_camera_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.cameras, handle)

cdef class Camera(HandleObject):

    @staticmethod
    cdef Camera c_from_handle(Handle handle):
        cdef Camera obj
        if handle == 0:
            raise ValueError("Camera: invalid handle")
        obj = Camera.__new__(Camera)
        obj.handle = handle
        return obj

    cdef CameraC *c_get_ptr(self) except *:
        return c_camera_get_ptr(self.handle)

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

        self.handle = c_camera_create()
        camera_ptr = self.c_get_ptr()
        proj_info = &camera_ptr.proj_info.orthographic
        camera_ptr.proj_type = CAMERA_PROJ_TYPE_ORTHOGRAPHIC
        proj_info.x_mag = x_mag
        proj_info.y_mag = y_mag
        proj_info.z_near = z_near
        proj_info.z_far = z_far
        #CameraUtils.c_orthographic(&camera_ptr.proj_mat, x_mag, y_mag, z_near, z_far)

    cpdef void create_perspective(self, float aspect_ratio, float y_fov, float z_near, float z_far) except *:
        cdef:
            CameraC *camera_ptr
            CameraProjInfoPerspectiveC *proj_info

        self.handle = c_camera_create()
        camera_ptr = self.c_get_ptr()
        camera_ptr.proj_type = CAMERA_PROJ_TYPE_PERSPECTIVE
        proj_info = &camera_ptr.proj_info.perspective
        proj_info.aspect_ratio = aspect_ratio
        proj_info.y_fov = y_fov
        proj_info.z_near = z_near
        proj_info.z_far = z_far
        #CameraUtils.c_perspective(&camera_ptr.proj_mat, aspect_ratio, y_fov, z_near, z_far)

    cpdef void delete(self) except *:
        c_camera_delete(self.handle)
        self.handle = 0

    cpdef void get_proj_mat(self, Mat4 proj_mat) except *:
        cdef:
            CameraC *camera_ptr
        
        camera_ptr = self.c_get_ptr()
        Mat4.c_copy(&proj_mat.data, &camera_ptr.proj_mat)