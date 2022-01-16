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
    Mat4 m = Mat4()

print(m.data)
Mat4.identity(m)
print(m.data)
Mat4.rotate_x(m, m, 0.007)
Mat4.rotate_y(m, m, 0.01)
print(m.data)