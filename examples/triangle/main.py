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
    view.submit()

width = 800
height = 600
title = b"Triangle"
clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
clear_color = 0x443355FF
clear_depth = 1.0
clear_stencil = 0

model_mat = Mat4()
view_mat = Mat4()
proj_mat = Mat4()
CameraUtils.orthographic(proj_mat, 0, width, 0, height, -1, 1)

app.init()
window = Window.init_create(width, height, title)
frame_buffer = FrameBuffer.init_create_from_window(window)
view = View.init_create()
on_window_listener = Listener.init_create(b"window", on_window_event)
on_enter_frame_listener = Listener.init_create(b"enter_frame", on_enter_frame_event)


vertex_layout = VertexLayout.init_create([
    (ATTRIBUTE_POSITION, ATTRIBUTE_TYPE_F32, 3, False, False),
])
vertex_buffer = VertexBuffer.init_create_static(
    vertex_layout, 
    #[(-1, -1, 0), (1, -1, 0), (0, 1, 0)],
    [(0, 0, 0), (400, 600, 0), (800, 0, 0)],
)

index_layout = INDEX_LAYOUT_U16
index_buffer = IndexBuffer.init_create_static(
    index_layout,
    [0, 1, 2],
)

base_path = b"./examples/triangle/"
vs_source_path = base_path + b"shaders/vs_triangle.sc"
fs_source_path = base_path + b"shaders/fs_triangle.sc"
vertex_shader = Shader.init_create_from_source_file(SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader.init_create_from_source_file(SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program.init_create(vertex_shader, fragment_shader)

view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
view.set_transform_model(model_mat)
view.set_transform_view(view_mat)
view.set_transform_projection(proj_mat)
view.submit()

app.run()

on_enter_frame_listener.delete()
on_window_listener.delete()
program.delete()
fragment_shader.delete()
vertex_shader.delete()
vertex_buffer.delete(); vertex_layout.delete()
index_buffer.delete()
view.delete()
frame_buffer.delete()
window.delete()
app.quit()