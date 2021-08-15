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
    Mat4.identity(mtx)
    Mat4.from_rotation_x(mtx_x, counter * 0.007)
    Mat4.from_rotation_y(mtx_y, counter * 0.01)
    Mat4.dot(mtx, mtx_x, mtx_y)
    
    pyorama.graphics.view_set_transform_model(view, mtx)
    pyorama.graphics.view_set_transform_view(view, view_mat)
    pyorama.graphics.view_set_transform_projection(view, proj_mat)
    pyorama.graphics.view_submit(view)

    Mat4.from_translation(mtx, shift)
    pyorama.graphics.view_set_transform_model(view, mtx)
    pyorama.graphics.view_submit(view)

    counter += 1

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

width = 800
height = 600
title = b"Hello, world!"
index_layout = pyorama.graphics.INDEX_LAYOUT_UINT16
vertices = Buffer()
indices = Buffer()

counter = 0
at = Vec3(0.0, 0.0, 0.0)
eye = Vec3()
up = Vec3(0.0, 1.0, 0.0)
shift = Vec3(3.0, 0.0, 0.0)
view_mat = Mat4()
proj_mat = Mat4()
mtx = Mat4()
mtx_x = Mat4()
mtx_y = Mat4()

pyorama.app.init()

vertex_layout = pyorama.graphics.vertex_layout_create([
    (pyorama.graphics.VERTEX_ATTRIBUTE_POSITION, 3, pyorama.graphics.VERTEX_ATTRIBUTE_TYPE_FLOAT, False, False),
    (pyorama.graphics.VERTEX_ATTRIBUTE_COLOR_0, 4, pyorama.graphics.VERTEX_ATTRIBUTE_TYPE_UINT8, True, False),
])
vertex_format = b"=fffI"
vertices_list = [
    (-1.0,  1.0,  1.0, 0xff888888),
    ( 1.0,  1.0,  1.0, 0xff8888ff),
    (-1.0, -1.0,  1.0, 0xff88ff88),
    ( 1.0, -1.0,  1.0, 0xff88ffff),
    (-1.0,  1.0, -1.0, 0xffff8888),
    ( 1.0,  1.0, -1.0, 0xffff88ff),
    (-1.0, -1.0, -1.0, 0xffffff88),
    ( 1.0, -1.0, -1.0, 0xffffffff),
]
vertices.init_and_set_items(vertex_format, vertices_list)
vertex_buffer = pyorama.graphics.vertex_buffer_create(vertex_layout, vertices)

index_format = b"=HHH"
indices_list = [
    (2, 1, 0),
    (2, 3, 1),
    (5, 6, 4),
    (7, 6, 5),
    (4, 2, 0),
    (6, 2, 4),
    (3, 5, 1),
    (3, 7, 5),
    (1, 4, 0),
    (1, 5, 4),
    (6, 3, 2),
    (7, 3, 6),
]
indices.init_and_set_items(index_format, indices_list)
index_buffer = pyorama.graphics.index_buffer_create(index_layout, indices)

runtime_compile_shaders()
vertex_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_VERTEX, b"./resources/shaders/vs_cubes.glsl")
fragment_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_FRAGMENT, b"./resources/shaders/fs_cubes.glsl")
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