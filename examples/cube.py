import pyorama
from pyorama.math import *
import time

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = event["window"]
        pyorama.graphics.window_delete(window)
        pyorama.app.trigger_quit()

def on_enter_frame_event(event, *args, **kwargs):
    global clear_color

    pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
    pyorama.graphics.view_set_clear(view, clear_flags, clear_color, 0.0, 1.0)
    pyorama.graphics.view_set_rect(view, 0, 0, width, height)
    pyorama.graphics.view_set_transform(view, view_mat, proj_mat)
    pyorama.graphics.view_set_vertex_buffer(view, vertex_buffer)
    pyorama.graphics.view_set_index_buffer(view, index_buffer)
    pyorama.graphics.view_submit(view, program)

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

vertex_layout = pyorama.graphics.vertex_layout_create([
    (pyorama.graphics.VERTEX_ATTRIBUTE_POSITION, 3, pyorama.graphics.VERTEX_ATTRIBUTE_TYPE_FLOAT),
    (pyorama.graphics.VERTEX_ATTRIBUTE_COLOR_0, 4, pyorama.graphics.VERTEX_ATTRIBUTE_TYPE_UINT8),
])

import numpy as np

vertices_dtype = np.dtype(
    [
        ("a_position", np.float32, (3,)), 
        ("a_color", np.uint32, (1,)),
    ],
)

vertices = np.array(
    [
        [-0.5, +1.0, +1.0, 0xFFFFFFFF],
        [+1.0, +1.0, +1.0, 0xFFFFFFFF],
        [-1.0, -1.0, +1.0, 0xFFFFFFFF],
        [+1.0, -1.0, +1.0, 0xFFFFFFFF],
        [-1.0, +1.0, -1.0, 0xFFFFFFFF],
        [+1.0, +1.0, -1.0, 0xFFFFFFFF],
        [-1.0, -1.0, -1.0, 0xFFFFFFFF],
        [+1.0, -1.0, -1.0, 0xFFFFFFFF],
    ],
    dtype=vertices_dtype,
)
vertices_view = vertices.view(dtype=np.uint8).ravel()
vertex_buffer = pyorama.graphics.vertex_buffer_create(vertex_layout, vertices_view)

indices = np.array(
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
    dtype=np.uint16,
)
indices_view = indices.view(dtype=np.uint8).ravel()
index_layout = pyorama.graphics.INDEX_LAYOUT_UINT16
index_buffer = pyorama.graphics.index_buffer_create(index_layout, indices_view)

on_window_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_WINDOW, 
    on_window_event, None, None,
)

on_enter_frame_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_ENTER_FRAME,
    on_enter_frame_event, None, None,
)

width = 800
height = 600
title = b"Cube"
clear_color = 0x222222FF
clear_flags = pyorama.graphics.VIEW_CLEAR_COLOR | pyorama.graphics.VIEW_CLEAR_DEPTH | pyorama.graphics.VIEW_CLEAR_STENCIL
window = pyorama.graphics.window_create(width, height, title)
frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
view = pyorama.graphics.view_create()

view_mat = Mat4()
proj_mat = Mat4()
center = Vec3(0.0, 0.0, 0.0)
eye = Vec3(10.0, 10.0, 10.0)
up = Vec3(0.0, 1.0, 0.0)
Mat4.look_at(view_mat, eye, center, up)
Mat4.perspective(proj_mat, fovy=60.0, aspect=width/height, near=0.01, far=1000)

pyorama.app.run()

pyorama.event.listener_delete(on_enter_frame_listener)
pyorama.event.listener_delete(on_window_listener)
pyorama.graphics.index_buffer_delete(index_buffer)
pyorama.graphics.vertex_buffer_delete(vertex_buffer)
pyorama.graphics.vertex_layout_delete(vertex_layout)
pyorama.graphics.program_delete(program)
pyorama.graphics.shader_delete(vs)
pyorama.graphics.shader_delete(fs)
pyorama.app.quit()