from pyorama cimport app
from pyorama.graphics.mesh cimport *
from pyorama.graphics.graphics_system cimport *

cpdef void utils_runtime_compile_mesh(
        bytes in_file_path, 
        bytes out_file_path, 
        float scale=*,
        bint ccw=*,
        bint flip_v=*,
        int num_obb_steps=*,
        bint pack_normals=*,
        bint pack_uvs=*,
        bint calc_tangents=*,
        bint calc_barycentrics=*,
        bint compress_indices=*,
        bytes coord_system=*) except *

cdef void mesh_create_from_binary_file(Mesh mesh, bytes file_path) except *