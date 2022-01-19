import math

import pyorama
from pyorama import app
from pyorama.asset import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *
from pyorama.math import *

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        app.trigger_quit()

width = 800
height = 600
title = b"Cubes"

base_path = b"./examples/005_texture/"
vs_source_path = base_path + b"shaders/vs_mesh.sc"
fs_source_path = base_path + b"shaders/fs_mesh.sc"
image_path = base_path + b"textures/capsule.jpg"

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

app.init()

vertex_format = BufferFormat([
    (b"a_position", 3, BUFFER_FIELD_TYPE_F32),
    (b"a_texcoord0", 2, BUFFER_FIELD_TYPE_F32),
])
vertex_layout = VertexLayout.init_create(
    vertex_format, 
    normalize={b"a_color0",},
)
vertices = Buffer(vertex_format)
vertices.init_from_list([
    (0.0, 0.0, 100.0, 0.0, 0.0),
    (300.0, 0.0, 100.0, 1.0, 0.0),
    (0.0, 400.0, 100.0, 0.0, 1.0),
])
vertex_buffer = VertexBuffer.init_create(vertex_layout, vertices)

index_format = BufferFormat([
    (b"a_indices", 1, BUFFER_FIELD_TYPE_U16),
])
indices = Buffer(index_format)
indices.init_from_list([
    0, 1, 2,
], is_flat=True)
index_layout = INDEX_LAYOUT_U16
index_buffer = IndexBuffer.init_create(index_layout, indices)

queue = AssetQueue.init_create()
queue.add_asset(ASSET_TYPE_IMAGE, b"capsule", image_path)
queue.load()

asset_manager = app.get_asset_system()
image = Image()
asset_manager.get_asset(b"capsule", image)
texture = Texture.init_create_2d_from_image(image)
sampler = Uniform.init_create(b"s_tex0", UNIFORM_TYPE_SAMPLER)

vertex_shader = Shader.init_create_from_source_file(SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader.init_create_from_source_file(SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program.init_create(vertex_shader, fragment_shader)


window = Window.init_create(width, height, title)
frame_buffer = FrameBuffer.init_create_from_window(window)
view = View.init_create()
on_window_listener = Listener.init_create(b"window", on_window_event, None, None)

camera = Camera.init_create_orthographic(width/2.0, height/2.0, 0, 1000)
proj_mat = Mat4()
identity_mat = Mat4()
camera.get_proj_mat(proj_mat)

clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
view.set_clear(clear_flags, 0x443355FF, 1.0, 0)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
view.set_texture(sampler, texture, 0)
view.set_transform_projection(proj_mat)
view.set_transform_view(identity_mat)
view.set_transform_model(identity_mat)
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