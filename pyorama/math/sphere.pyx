cdef class Sphere:

    @staticmethod
    cdef float c_get_radius(SphereC *s) nogil:
        return glm_sphere_radii(<vec4>s)

    @staticmethod
    cdef void c_transform(SphereC *out, SphereC *s, Mat4C *m) nogil:
        glm_sphere_transform(<vec4>s, <mat4>m, <vec4>out)

    @staticmethod
    cdef void c_merge(SphereC *out, SphereC *a, SphereC *b) nogil:
        glm_sphere_merge(<vec4>a, <vec4>b, <vec4?>out)

    @staticmethod
    cdef bint c_intersects_sphere(SphereC *a, SphereC *b) nogil:
        return glm_sphere_sphere(<vec4>a, <vec4>b)

    @staticmethod
    cdef bint c_intersects_point(SphereC *s, Vec3C *p) nogil:
        return glm_sphere_point(<vec4>s, <vec3>p)