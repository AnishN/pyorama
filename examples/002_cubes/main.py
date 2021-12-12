import pyorama
from pyorama.math import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *
import math

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
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
    
    view.set_transform_model(model_mat)
    view.set_transform_view(view_mat)
    view.set_transform_projection(proj_mat)
    view.submit()

    Mat4.from_translation(model_mat, shift)
    view.set_transform_model(model_mat)
    view.submit()

    counter += 1

width = 800
height = 600
title = b"Cubes"

base_path = b"./examples/002_cubes/"
vs_source_path = base_path + b"shaders/vs_cubes.sc"
fs_source_path = base_path + b"shaders/fs_cubes.sc"

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

pyorama.app.init()

vertex_format = BufferFormat([
    (b"a_position", 3, BUFFER_FIELD_TYPE_F32),
    (b"a_color0", 4, BUFFER_FIELD_TYPE_U8),
])
vertex_layout = VertexLayout(); vertex_layout.create(
    vertex_format, 
    normalize={b"a_color0",},
)
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
vertex_buffer = VertexBuffer(); vertex_buffer.create(vertex_layout, vertices)

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
index_layout = pyorama.graphics.INDEX_LAYOUT_U16
index_buffer = IndexBuffer(); index_buffer.create(index_layout, indices)

vertex_shader = Shader(); vertex_shader.create_from_source_file(pyorama.graphics.SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader(); fragment_shader.create_from_source_file(pyorama.graphics.SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program(); program.create(vertex_shader, fragment_shader)

window = Window(); window.create(width, height, title)
frame_buffer = FrameBuffer(); frame_buffer.create_from_window(window)
view = View(); view.create()
on_window_listener = Listener(); on_window_listener.create(pyorama.event.EVENT_TYPE_WINDOW, on_window_event, None, None)
on_enter_frame_listener = Listener(); on_enter_frame_listener.create(pyorama.event.EVENT_TYPE_ENTER_FRAME, on_enter_frame_event, None, None)

clear_flags = pyorama.graphics.VIEW_CLEAR_COLOR | pyorama.graphics.VIEW_CLEAR_DEPTH
view.set_clear(clear_flags, 0x443355FF, 1.0, 0)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
pyorama.app.run()

on_enter_frame_listener.delete()
on_window_listener.delete()
program.delete()
fragment_shader.delete()
vertex_shader.delete()
vertex_buffer.delete(); vertex_layout.delete(); vertices.free()
index_buffer.delete(); indices.free()
view.delete()
frame_buffer.delete()
window.delete()
pyorama.app.quit()