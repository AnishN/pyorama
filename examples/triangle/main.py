import pyorama
from pyorama import app
from pyorama.math import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *

def on_window_event(event):
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        app.trigger_quit()

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

app.init()
window = Window.init_create(width, height, title)
frame_buffer = FrameBuffer.init_create_from_window(window)
view = View.init_create()
on_window_listener = Listener.init_create(EVENT_TYPE_WINDOW, on_window_event)

vertex_format = BufferFormat([(b"a_position", 3, BUFFER_FIELD_TYPE_F32)])
vertex_layout = VertexLayout.init_create(vertex_format, normalize={b"a_color0"})
vertices = Buffer(vertex_format)
vertices.init_from_list([(-1, -1, 0), (1, -1, 0), (0, 1, 0)])
#vertices.init_from_list([(-1, -1, 0), (0, 1, 0), (1, -1, 0)])
vertex_buffer = VertexBuffer.init_create(vertex_layout, vertices)

index_format = BufferFormat([(b"a_indices", 1, BUFFER_FIELD_TYPE_U16)])
indices = Buffer(index_format)
indices.init_from_list([0, 1, 2], is_flat=True)
index_layout = INDEX_LAYOUT_U16
index_buffer = IndexBuffer.init_create(index_layout, indices)

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