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
    view.submit()

width = 800
height = 600
title = b"Sprites"
clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
clear_color = 0x443355FF
clear_depth = 1.0
clear_stencil = 0

base_path = b"./examples/sprites/"
image_path = base_path + b"images/python-powered-h-140x182.png"
vs_source_path = base_path + b"shaders/vs_sprites.sc"
fs_source_path = base_path + b"shaders/fs_sprites.sc"

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
on_window_listener = Listener.init_create(b"window", on_window_event)
on_enter_frame_listener = Listener.init_create(b"enter_frame", on_enter_frame_event)

image = Image.init_create_from_file(image_path)
texture = Texture.init_create_from_image(image)
sprite_1 = Sprite.init_create(texture, position=Vec3(50, 100, 0), rotation=math.radians(45), scale=Vec2(1, 1), size=Vec2(32, 32))
sprite_2 = Sprite.init_create(texture, position=Vec3(400, 300, 0), scale=Vec2(2, 0.5), size=Vec2(32, 32))
sprite_batch = SpriteBatch.init_create([sprite_1, sprite_2])
vertex_buffer = VertexBuffer(); sprite_batch.get_vertex_buffer(vertex_buffer)
index_buffer = IndexBuffer(); sprite_batch.get_index_buffer(index_buffer)

import numpy as np
print(np.array(vertex_buffer.get_view_array()))
print(np.array(index_buffer.get_view_array()))

vertex_shader = Shader.init_create_from_source_file(SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader.init_create_from_source_file(SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program.init_create(vertex_shader, fragment_shader)

CameraUtils.orthographic(proj_mat, 0, width, 0, height, -1, 1)

view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
#view.set_cull_state(VIEW_CULL_STATE_NONE)
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
vertex_buffer.delete()
index_buffer.delete()
view.delete()
frame_buffer.delete()
window.delete()
app.quit()