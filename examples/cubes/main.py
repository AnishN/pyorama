import math
import pyorama
from pyorama import app
from pyorama.math import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *

def on_window_event(event):
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        app.trigger_quit()

def on_enter_frame_event(event):
    global counter
    
    Vec3.set_data(eye, math.sin(float(counter) / 100) * 8, 2, math.cos(float(counter) / 100) * 8)
    CameraUtils.look_at(view_mat, eye, at, up)
    CameraUtils.perspective(proj_mat, math.radians(60.0), float(width) / float(height), 0.01, 1000.0)
    
    Mat4.identity(model_mat)
    Mat4.rotate_x(model_mat, model_mat, counter * 0.007)
    Mat4.rotate_y(model_mat, model_mat, counter * 0.01)
    
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
clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
clear_color = 0x443355FF
clear_depth = 1.0
clear_stencil = 0

counter = 0
at = Vec3()
eye = Vec3()
up = Vec3(0.0, 1.0, 0.0)
shift = Vec4(3.0, 0.0, 0.0, 1.0)
view_mat = Mat4()
proj_mat = Mat4()
model_mat = Mat4()

app.init()
window = Window.init_create(width, height, title)
frame_buffer = FrameBuffer.init_create_from_window(window)
view = View.init_create()

on_window_listener = Listener.init_create(EventType.WINDOW, on_window_event)
on_enter_frame_listener = Listener.init_create(EventType.ENTER_FRAME, on_enter_frame_event)

vertex_format = BufferFormat([
    (b"a_position", 3, BUFFER_FIELD_TYPE_F32),
    (b"a_color0", 4, BUFFER_FIELD_TYPE_U8),
])
vertex_layout = VertexLayout.init_create(
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
vertex_buffer = VertexBuffer.init_create(vertex_layout, vertices)

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
index_layout = INDEX_LAYOUT_U16
index_buffer = IndexBuffer.init_create(index_layout, indices)

base_path = b"./examples/cubes/"
vs_source_path = base_path + b"shaders/vs_cubes.sc"
fs_source_path = base_path + b"shaders/fs_cubes.sc"
vertex_shader = Shader.init_create_from_source_file(SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader.init_create_from_source_file(SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program.init_create(vertex_shader, fragment_shader)

view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
view.submit()

app.run()

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
app.quit()