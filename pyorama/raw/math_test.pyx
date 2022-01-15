from pyorama.libs.cglm cimport *
from pyorama.app cimport *
from pyorama.math.mat2 cimport *
from pyorama.math.sphere cimport *

print("math_test") 
#print(GLM_BEZIER_MAT)
#print(GLM_HERMITE_MAT)
#print(CGLM_DECASTEL_EPS, CGLM_DECASTEL_MAX, CGLM_DECASTEL_SMALL)

cdef int testing(int renderer_type=graphics.renderer_type) nogil:
    return renderer_type

cdef:
    Vec3C eye = [0, 0, 1000]
    Vec3C at = [0, 0, 0]
    Vec3C up = [0, 1, 0]
    mat4 proj
    float width = 800
    float height = 600
    float near = 0
    float far = 1
    Mat2C m
    Mat2 m_obj
    Mat2 a
    Mat2 b
    SphereC s = [[1, 2, 3], 10]
    float r

Mat2.c_identity(&m)
m_obj = Mat2.c_from_data(&m)
print(m)
print(m_obj.data)

r = Sphere.c_get_radius(&s)
print(s)
print(r)
print("eye", Sphere.c_intersects_point(&s, &eye))
print("up", Sphere.c_intersects_point(&s, &up))

"""
glm_ortho(0, width, 0, height, near, far, proj)
print(eye, at, up)
print(proj, proj[3][1])
glm_ortho_lh_no(0, width, 0, height, near, far, proj)
print("lh_no", proj)
glm_ortho_lh_zo(0, width, 0, height, near, far, proj)
print("lh_zo", proj)
glm_ortho_rh_no(0, width, 0, height, near, far, proj)
print("rh_no", proj)
glm_ortho_rh_zo(0, width, 0, height, near, far, proj)
print("rh_zo", proj)
print(testing())
"""

"""
a = Mat2.c_from_data(m)
b = Mat2()
print(a.data, b.data)
Mat2.c_copy(b.data, a.data)
#Mat2.copy(b, a)
print(a.data, b.data)
"""