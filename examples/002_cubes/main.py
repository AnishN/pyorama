import pyorama
from pyorama.math import *
from pyorama.data import *
import math

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = event["window"]
        pyorama.app.trigger_quit()

def on_enter_frame_event(event, *args, **kwargs):
    global counter

    Vec3.set_data(eye, math.sin(float(counter) / 100) * 8, 2, math.cos(float(counter) / 100) * 8)
    Mat4.look_at(view_mat, eye, at, up)
    Mat4.perspective(proj_mat, math.radians(60.0), float(width) / float(height),  0.01, 1000.0)
    Mat4.identity(model_mat)
    Mat4.from_rotation_x(mtx_x, counter * 0.007)
    Mat4.from_rotation_y(mtx_y, counter * 0.01)
    Mat4.dot(model_mat, mtx_x, mtx_y)
    
    pyorama.graphics.view_set_transform_model(view, model_mat)
    pyorama.graphics.view_set_transform_view(view, view_mat)
    pyorama.graphics.view_set_transform_projection(view, proj_mat)
    pyorama.graphics.view_submit(view)

    Mat4.from_translation(model_mat, shift)
    pyorama.graphics.view_set_transform_model(view, model_mat)
    pyorama.graphics.view_submit(view)

    counter += 1

def runtime_compile_shaders():
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./examples/002_cubes/vs_cubes.sc",
        out_file_path=b"./examples/002_cubes/vs_cubes.sc_bin",
        shader_type=pyorama.graphics.SHADER_TYPE_VERTEX,
    )
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./examples/002_cubes/fs_cubes.sc",
        out_file_path=b"./examples/002_cubes/fs_cubes.sc_bin",
        shader_type=pyorama.graphics.SHADER_TYPE_FRAGMENT,
    )

width = 800
height = 600
title = b"Cubes"

counter = 0
at = Vec3(0.0, 0.0, 0.0)
eye = Vec3()
up = Vec3(0.0, 1.0, 0.0)
shift = Vec3(3.0, 0.0, 0.0)
view_mat = Mat4()
proj_mat = Mat4()
model_mat = Mat4()
mtx_x = Mat4()
mtx_y = Mat4()

pyorama.app.init({
    "use_sleep": False,
    "graphics": {
        "renderer_type": pyorama.graphics.GRAPHICS_RENDERER_TYPE_OPENGLES
    }
})

vertex_format = BufferFormat([
    (b"a_position", 3, BUFFER_FIELD_TYPE_F32),
    (b"a_color_0", 4, BUFFER_FIELD_TYPE_U8),
])
vertex_layout = pyorama.graphics.vertex_layout_create(vertex_format, [False, True], [False, False])
vertices = Buffer(vertex_format)
vertices.init_from_list([
    (-1.0,  1.0,  1.0, 0x00, 0x00, 0x00, 0xff),
    ( 1.0,  1.0,  1.0, 0xff, 0x00, 0x00, 0xff),
    (-1.0, -1.0,  1.0, 0x00, 0xff, 0x00, 0xff),
    ( 1.0, -1.0,  1.0, 0x00, 0x00, 0xff, 0xff),
    (-1.0,  1.0, -1.0, 0xff, 0xff, 0x00, 0xff),
    ( 1.0,  1.0, -1.0, 0xff, 0x00, 0xff, 0xff),
    (-1.0, -1.0, -1.0, 0x00, 0xff, 0xff, 0xff),
    ( 1.0, -1.0, -1.0, 0xff, 0xff, 0xff, 0xff),
])
vertex_buffer = pyorama.graphics.vertex_buffer_create(vertex_layout, vertices)

index_format = BufferFormat([
    (b"a_indices", 1, BUFFER_FIELD_TYPE_U16),
])
indices = Buffer(index_format)
indices.init_from_list([
    2, 1, 0,
    2, 3, 1,
    5, 6, 4,
    7, 6, 5,
    4, 2, 0,
    6, 2, 4,
    3, 5, 1,
    3, 7, 5,
    1, 4, 0,
    1, 5, 4,
    6, 3, 2,
    7, 3, 6,
], is_flat=True)
index_layout = pyorama.graphics.INDEX_LAYOUT_UINT16
index_buffer = pyorama.graphics.index_buffer_create(index_layout, indices)

runtime_compile_shaders()
vertex_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_VERTEX, b"./examples/002_cubes/vs_cubes.sc_bin")
fragment_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_FRAGMENT, b"./examples/002_cubes/fs_cubes.sc_bin")
program = pyorama.graphics.program_create(vertex_shader, fragment_shader)
window = pyorama.graphics.window_create(width, height, title)
frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
view = pyorama.graphics.view_create()
on_window_listener = pyorama.event.listener_create(pyorama.event.EVENT_TYPE_WINDOW, on_window_event, None, None)
on_enter_frame_listener = pyorama.event.listener_create(pyorama.event.EVENT_TYPE_ENTER_FRAME, on_enter_frame_event, None, None)

clear_flags = pyorama.graphics.VIEW_CLEAR_COLOR | pyorama.graphics.VIEW_CLEAR_DEPTH
pyorama.graphics.view_set_clear(view, clear_flags, 0x443355FF, 1.0, 0)
pyorama.graphics.view_set_rect(view, 0, 0, width, height)
pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
pyorama.graphics.view_set_vertex_buffer(view, vertex_buffer)
pyorama.graphics.view_set_index_buffer(view, index_buffer)
pyorama.graphics.view_set_program(view, program)
pyorama.app.run()

pyorama.event.listener_delete(on_enter_frame_listener)
pyorama.event.listener_delete(on_window_listener)
pyorama.graphics.program_delete(program)
pyorama.graphics.shader_delete(fragment_shader)
pyorama.graphics.shader_delete(vertex_shader)
pyorama.graphics.index_buffer_delete(index_buffer); indices.free()
pyorama.graphics.vertex_buffer_delete(vertex_buffer); vertices.free()
pyorama.graphics.view_delete(view)
pyorama.graphics.frame_buffer_delete(frame_buffer)
pyorama.graphics.window_delete(window)
pyorama.app.quit()