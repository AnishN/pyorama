from pyorama.app cimport graphics#secret dependency fot the clipspace stuff for auto-detection

cdef class Mat4:

    @staticmethod
    cdef Mat4 c_from_data(Mat4C m):
        cdef Mat4 out = Mat4.__new__(Mat4)
        out.data = m
        return out
    
    #C wrappers
    @staticmethod
    cdef void c_copy(Mat4C out, Mat4C m) nogil:
        glm_mat4_copy(<mat4>&m, <mat4>&out)
    
    @staticmethod
    cdef void c_identity(Mat4C out) nogil:
        glm_mat4_identity(<mat4>&out)
    
    @staticmethod
    cdef void c_zero(Mat4C out) nogil:
        glm_mat4_zero(<mat4>&out)
    
    @staticmethod
    cdef void c_mul(Mat4C out, Mat4C a, Mat4C b) nogil:
        glm_mat4_mul(<mat4>&a, <mat4>&b, <mat4>&out)

    @staticmethod
    cdef void c_transpose_to(Mat4C out, Mat4C m) nogil:
        glm_mat4_transpose_to(<mat4>&m, <mat4>&out)

    @staticmethod
    cdef void c_transpose(Mat4C out) nogil:
        glm_mat4_transpose(<mat4>&out)

    @staticmethod
    cdef float c_trace(Mat4C m) nogil:
        return glm_mat4_trace(<mat4>&m)

    @staticmethod
    cdef float c_trace3(Mat4C m) nogil:
        return glm_mat4_trace3(<mat4>&m)

    @staticmethod
    cdef void c_scale(Mat4C out, float scale) nogil:
        glm_mat4_scale(<mat4>&out, scale)

    @staticmethod
    cdef float c_det(Mat4C m) nogil:
        return glm_mat4_det(<mat4>&m)

    @staticmethod
    cdef void c_inv(Mat4C out, Mat4C m) nogil:
        glm_mat4_inv(<mat4>&m, <mat4>&out)

    @staticmethod
    cdef void c_inv_fast(Mat4C out, Mat4C m) nogil:
        glm_mat4_inv_fast(<mat4>&m, <mat4>&out)

    @staticmethod
    cdef void c_swap_col(Mat4C m, size_t col_1, size_t col_2) nogil:
        glm_mat4_swap_col(<mat4>&m, col_1, col_2)

    @staticmethod
    cdef void c_swap_row(Mat4C m, size_t row_1, size_t row_2) nogil:
        glm_mat4_swap_row(<mat4>&m, row_1, row_2)

    @staticmethod
    cdef float c_row_mat_col(vec4 r, Mat4C m, vec4 c) nogil:
        return glm_mat4_rmc(r, <mat4>&m, c)

    @staticmethod
    cdef void c_orthographic(Mat4C out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_rh_no(left, right, bottom, top, near_z, far_z, <mat4>&out)
            else: glm_ortho_rh_zo(left, right, bottom, top, near_z, far_z, <mat4>&out)
        else:
            if homogeneous_depth: glm_ortho_lh_no(left, right, bottom, top, near_z, far_z, <mat4>&out)
            else: glm_ortho_lh_zo(left, right, bottom, top, near_z, far_z, <mat4>&out)
    
    @staticmethod
    cdef void c_orthographic_box(Mat4C out, Box3C box, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_aabb_rh_no(<vec3 *>&box, <mat4>&out)
            else: glm_ortho_aabb_rh_zo(<vec3 *>&box, <mat4>&out)
        else:
            if homogeneous_depth: glm_ortho_aabb_lh_no(<vec3 *>&box, <mat4>&out)
            else: glm_ortho_aabb_lh_zo(<vec3 *>&box, <mat4>&out)
    
    @staticmethod
    cdef void c_orthographic_box_pad(Mat4C out, Box3C box, float padding, bint pad_z, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if pad_z:
            if right_handed:
                if homogeneous_depth: glm_ortho_aabb_pz_rh_no(<vec3 *>&box, padding, <mat4>&out)
                else: glm_ortho_aabb_pz_rh_zo(<vec3 *>&box, padding, <mat4>&out)
            else:
                if homogeneous_depth: glm_ortho_aabb_pz_lh_no(<vec3 *>&box, padding, <mat4>&out)
                else: glm_ortho_aabb_pz_lh_zo(<vec3 *>&box, padding, <mat4>&out)
        else:
            if right_handed:
                if homogeneous_depth: glm_ortho_aabb_p_rh_no(<vec3 *>&box, padding, <mat4>&out)
                else: glm_ortho_aabb_p_rh_zo(<vec3 *>&box, padding, <mat4>&out)
            else:
                if homogeneous_depth: glm_ortho_aabb_p_lh_no(<vec3 *>&box, padding, <mat4>&out)
                else: glm_ortho_aabb_p_lh_zo(<vec3 *>&box, padding, <mat4>&out)
    
    @staticmethod
    cdef void c_orthographic_unit(Mat4C out, float aspect, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_default_rh_no(aspect, <mat4>&out)
            else: glm_ortho_default_rh_zo(aspect, <mat4>&out)
        else:
            if homogeneous_depth: glm_ortho_default_lh_no(aspect, <mat4>&out)
            else: glm_ortho_default_lh_zo(aspect, <mat4>&out)
    
    @staticmethod
    cdef void c_orthographic_cube(Mat4C out, float aspect, float size, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_default_s_rh_no(aspect, size, <mat4>&out)
            else: glm_ortho_default_s_rh_zo(aspect, size, <mat4>&out)
        else:
            if homogeneous_depth: glm_ortho_default_s_lh_no(aspect, size, <mat4>&out)
            else: glm_ortho_default_s_lh_zo(aspect, size, <mat4>&out)

    @staticmethod
    cdef void c_frustum(Mat4C out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_frustum_rh_no(left, right, bottom, top, near_z, far_z, <mat4>&out)
            else: glm_frustum_rh_zo(left, right, bottom, top, near_z, far_z, <mat4>&out)
        else:
            if homogeneous_depth: glm_frustum_lh_no(left, right, bottom, top, near_z, far_z, <mat4>&out)
            else: glm_frustum_lh_zo(left, right, bottom, top, near_z, far_z, <mat4>&out)

    @staticmethod
    cdef void c_perspective(Mat4C out, float fovy, float aspect, float near_z, float far_z, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_perspective_rh_no(fovy, aspect, near_z, far_z, <mat4>&out)
            else: glm_perspective_rh_zo(fovy, aspect, near_z, far_z, <mat4>&out)
        else:
            if homogeneous_depth: glm_perspective_lh_no(fovy, aspect, near_z, far_z, <mat4>&out)
            else: glm_perspective_lh_zo(fovy, aspect, near_z, far_z, <mat4>&out)

    @staticmethod
    cdef void c_perspective_unit(Mat4C out, float aspect, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_perspective_default_rh_no(aspect, <mat4>&out)
            else: glm_perspective_default_rh_zo(aspect, <mat4>&out)
        else:
            if homogeneous_depth: glm_perspective_default_lh_no(aspect, <mat4>&out)
            else: glm_perspective_default_lh_zo(aspect, <mat4>&out)

    @staticmethod
    cdef void c_perspective_resize(Mat4C out, float aspect, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_perspective_resize_rh_no(aspect, <mat4>&out)
            else: glm_perspective_resize_rh_zo(aspect, <mat4>&out)
        else:
            if homogeneous_depth: glm_perspective_resize_lh_no(aspect, <mat4>&out)
            else: glm_perspective_resize_lh_zo(aspect, <mat4>&out)

    @staticmethod
    cdef void c_perspective_move_far(Mat4C out, float delta_far, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_move_far_rh_no(<mat4>&out, delta_far)
            else: glm_persp_move_far_rh_zo(<mat4>&out, delta_far)
        else:
            if homogeneous_depth: glm_persp_move_far_lh_no(<mat4>&out, delta_far)
            else: glm_persp_move_far_lh_zo(<mat4>&out, delta_far)

    @staticmethod
    cdef void c_perspective_decompose(Mat4C m, Box3C box, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_rh_no(<mat4>&m, &box.min.z, &box.max.z, &box.min.y, &box.max.y, &box.min.x, &box.max.x)
            else: glm_persp_decomp_rh_zo(<mat4>&m, &box.min.z, &box.max.z, &box.min.y, &box.max.y, &box.min.x, &box.max.x)
        else:
            if homogeneous_depth: glm_persp_decomp_lh_no(<mat4>&m, &box.min.z, &box.max.z, &box.min.y, &box.max.y, &box.min.x, &box.max.x)
            else: glm_persp_decomp_lh_zo(<mat4>&m, &box.min.z, &box.max.z, &box.min.y, &box.max.y, &box.min.x, &box.max.x)

    @staticmethod
    cdef void c_perspective_decompose_x(Mat4C m, Vec2C v, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_x_rh_no(<mat4>&m, &v.x, &v.y)
            else: glm_persp_decomp_x_rh_zo(<mat4>&m, &v.x, &v.y)
        else:
            if homogeneous_depth: glm_persp_decomp_x_lh_no(<mat4>&m, &v.x, &v.y)
            else: glm_persp_decomp_x_lh_zo(<mat4>&m, &v.x, &v.y)
    
    @staticmethod
    cdef void c_perspective_decompose_y(Mat4C m, Vec2C v, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_y_rh_no(<mat4>&m, &v.x, &v.y)
            else: glm_persp_decomp_y_rh_zo(<mat4>&m, &v.x, &v.y)
        else:
            if homogeneous_depth: glm_persp_decomp_y_lh_no(<mat4>&m, &v.x, &v.y)
            else: glm_persp_decomp_y_lh_zo(<mat4>&m, &v.x, &v.y)

    @staticmethod
    cdef void c_perspective_decompose_z(Mat4C m, Vec2C v, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_z_rh_no(<mat4>&m, &v.x, &v.y)
            else: glm_persp_decomp_z_rh_zo(<mat4>&m, &v.x, &v.y)
        else:
            if homogeneous_depth: glm_persp_decomp_z_lh_no(<mat4>&m, &v.x, &v.y)
            else: glm_persp_decomp_z_lh_zo(<mat4>&m, &v.x, &v.y)

    @staticmethod
    cdef float c_perspective_decompose_far(Mat4C m, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        cdef float far_z
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_far_rh_no(<mat4>&m, &far_z)
            else: glm_persp_decomp_far_rh_zo(<mat4>&m, &far_z)
        else:
            if homogeneous_depth: glm_persp_decomp_far_lh_no(<mat4>&m, &far_z)
            else: glm_persp_decomp_far_lh_zo(<mat4>&m, &far_z)
        return far_z

    @staticmethod
    cdef float c_perspective_decompose_near(Mat4C m, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        cdef float near_z
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_near_rh_no(<mat4>&m, &near_z)
            else: glm_persp_decomp_near_rh_zo(<mat4>&m, &near_z)
        else:
            if homogeneous_depth: glm_persp_decomp_near_lh_no(<mat4>&m, &near_z)
            else: glm_persp_decomp_near_lh_zo(<mat4>&m, &near_z)
        return near_z

    @staticmethod
    cdef void c_perspective_plane_sizes(Mat4C m, float fovy, Vec2C near, Vec2C far, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        cdef Vec4C dest
        if right_handed:
            if homogeneous_depth: glm_persp_sizes_rh_no(<mat4>&m, fovy, <vec4>&dest)
            else: glm_persp_sizes_rh_zo(<mat4>&m, fovy, <vec4>&dest)
        else:
            if homogeneous_depth: glm_persp_sizes_lh_no(<mat4>&m, fovy, <vec4>&dest)
            else: glm_persp_sizes_lh_zo(<mat4>&m, fovy, <vec4>&dest)
        near.x = dest.x
        near.y = dest.y
        far.x = dest.z
        far.y = dest.w

    @staticmethod
    cdef void c_look_at(Mat4C out, Vec3C eye, Vec3C center, Vec3C up, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_lookat_rh_no(<vec3>&eye, <vec3>&center, <vec3>&up, <mat4>&out)
            else: glm_lookat_rh_zo(<vec3>&eye, <vec3>&center, <vec3>&up, <mat4>&out)
        else:
            if homogeneous_depth: glm_lookat_lh_no(<vec3>&eye, <vec3>&center, <vec3>&up, <mat4>&out)
            else: glm_lookat_lh_zo(<vec3>&eye, <vec3>&center, <vec3>&up, <mat4>&out)
        
    @staticmethod
    cdef void c_look(Mat4C out, Vec3C eye, Vec3C dir_, Vec3C up, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_look_rh_no(<vec3>&eye, <vec3>&dir_, <vec3>&up, <mat4>&out)
            else: glm_look_rh_zo(<vec3>&eye, <vec3>&dir_, <vec3>&up, <mat4>&out)
        else:
            if homogeneous_depth: glm_look_lh_no(<vec3>&eye, <vec3>&dir_, <vec3>&up, <mat4>&out)
            else: glm_look_lh_zo(<vec3>&eye, <vec3>&dir_, <vec3>&up, <mat4>&out)

    @staticmethod
    cdef void c_look_any_up(Mat4C out, Vec3C eye, Vec3C dir_, Vec3C up, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_look_anyup_rh_no(<vec3>&eye, <vec3>&dir_, <mat4>&out)
            else: glm_look_anyup_rh_zo(<vec3>&eye, <vec3>&dir_, <mat4>&out)
        else:
            if homogeneous_depth: glm_look_anyup_lh_no(<vec3>&eye, <vec3>&dir_, <mat4>&out)
            else: glm_look_anyup_lh_zo(<vec3>&eye, <vec3>&dir_, <mat4>&out)
    
    #python wrappers
    @staticmethod
    def copy(Mat4 out, Mat4 m):
        Mat4.c_copy(out.data, m.data)

    @staticmethod
    def identity(Mat4 out):
        Mat4.c_identity(out.data)
    
    @staticmethod
    def zero(Mat4 out):
        Mat4.c_zero(out.data)
    
    @staticmethod
    def mul(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_mul(out.data, a.data, b.data)

    @staticmethod
    def transpose_to(Mat4 out, Mat4 m):
        Mat4.c_transpose_to(out.data, m.data)

    @staticmethod
    def transpose(Mat4 out):
        Mat4.c_transpose(out.data)

    @staticmethod
    def trace(Mat4 m):
        Mat4.c_trace(m.data)

    @staticmethod
    def trace3(Mat4 m):
        Mat4.c_trace3(m.data)

    @staticmethod
    def scale(Mat4 out, float scale):
        Mat4.c_scale(out.data, scale)

    @staticmethod
    def det(Mat4 m):
        return Mat4.c_det(m.data)

    @staticmethod
    def inv(Mat4 out, Mat4 m):
        Mat4.c_inv(out.data, m.data)

    @staticmethod
    def inv_fast(Mat4 out, Mat4 m):
        Mat4.c_inv_fast(out.data, m.data)

    @staticmethod
    def swap_col(Mat4 m, size_t col_1, size_t col_2):
        Mat4.c_swap_col(m.data, col_1, col_2)

    @staticmethod
    def swap_row(Mat4 m, size_t row_1, size_t row_2):
        Mat4.c_swap_row(m.data, row_1, row_2)

    #@staticmethod
    #def row_mat_col(vec4 r, Mat4 m, vec4 c):
    #    return Mat4.c_row_mat_col(r.data, m.data, c.data)