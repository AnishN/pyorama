import pyorama
import time

def runtime_compile_shaders():
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./resources/shaders/vs_cubes.sc",
        out_file_path=b"./resources/shaders/vs_cubes.glsl",
        shader_type=pyorama.graphics.SHADER_TYPE_VERTEX,
    )
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./resources/shaders/fs_cubes.sc",
        out_file_path=b"./resources/shaders/fs_cubes.glsl",
        shader_type=pyorama.graphics.SHADER_TYPE_FRAGMENT,
    )

pyorama.app.init()
runtime_compile_shaders()

vs = pyorama.graphics.shader_create_from_file(
    pyorama.graphics.SHADER_TYPE_VERTEX, 
    b"./resources/shaders/vs_cubes.glsl",
)

fs = pyorama.graphics.shader_create_from_file(
    pyorama.graphics.SHADER_TYPE_FRAGMENT, 
    b"./resources/shaders/fs_cubes.glsl",
)

program = pyorama.graphics.program_create(vs, fs)

"""
vertex_layout = pyorama.graphics.vertex_layout_create([
    (pyorama.graphics.VERTEX_ATTRIBUTE_POSITION, 3, pyorama.graphics.VERTEX_ATTRIBUTE_TYPE_FLOAT),
    (pyorama.graphics.VERTEX_ATTRIBUTE_COLOR_0, 4, pyorama.graphics.VERTEX_ATTRIBUTE_TYPE_UINT8),
])
"""

#vertex_layout = pyorama.graphics.vertex_layout_create([
#    ("a_position", 3, "float"),
#    ("a_color_0", 4, "uint8"),
#])

"""
vertex_layout_str = pyorama.graphics.vertex_layout_get_str(vertex_layout)
cube_vertices = np.array(
    [
        [-1.0, +1.0, +1.0, 0xFF000000],
        [+1.0, +1.0, +1.0, 0xFF0000FF],
        [-1.0, -1.0, +1.0, 0xFF00FF00],
        [+1.0, -1.0, +1.0, 0xFF00FFFF],
        [-1.0, +1.0, -1.0, 0xFFFF0000],
        [+1.0, +1.0, -1.0, 0xFFFF00FF],
        [-1.0, -1.0, -1.0, 0xFFFFFF00],
        [+1.0, -1.0, -1.0, 0xFFFFFFFF],
    ],
    dtype=vertex_layout_str,
)
"""

#pyorama.graphics.vertex_layout_delete(vertex_layout)
pyorama.graphics.program_delete(program)
pyorama.graphics.shader_delete(vs)
pyorama.graphics.shader_delete(fs)

import numpy as np

cube_vertices = np.array(
    [
        [0, 1, 2],
        [1, 3, 2],
        [4, 6, 5],
        [5, 6, 7],
        [0, 2, 4],
        [4, 2, 6],
        [1, 5, 3],
        [5, 7, 3],
        [0, 4, 1],
        [4, 5, 1],
        [2, 3, 6],
        [6, 3, 7],
    ],
    dtype=np.uint32,
)
pyorama.app.quit()