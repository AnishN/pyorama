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
#window = Window.init_create(width, height, title)
#frame_buffer = FrameBuffer.init_create_from_window(window)
#view = View.init_create()

#on_window_listener = Listener.init_create(b"window", on_window_event)
#on_enter_frame_listener = Listener.init_create(b"enter_frame", on_enter_frame_event)

base_path = b"./examples/sprites/"
image_path = base_path + b"images/python-powered-h-140x182.png"

image = Image.init_create_from_file(image_path)
texture = Texture.init_create_from_image(image)
sprite = Sprite.init_create(texture)
sprite_batch = SpriteBatch.init_create([sprite])

"""
vertex_format = VertexFormat([
    (b"a_position", 3, ATTRIBUTE_TYPE_FLOAT, False, False)
    (b"color", 4, ATTRIBUTE_TYPE_UINT8, False, False),
])

#static
vertex_buffer = VertexBuffer.create_static(vertex_format, vertices)

#dynamic
vertex_buffer = VertexBuffer.create_dynamic(vertex_format, max_vertices=0)

#if dynamic and resizable, use add_vertex and set_vertex
vertex_buffer.add_vertices()
vertex_buffer.add_vertex(1, 2, 3, 4, 0xFF)
vertex_buffer.add_vertex()
vertex_buffer.add_vertex()
vertex_buffer.add_vertex()
vertex_buffer.set_vertex()
#vertex_buffer.c_get_vertex_ptr(i)

#if dynamic and not resizable, use just set_vertex (the memory has already been allocated
vertex_buffer.set_vertex()
vertex_buffer.set_vertices([vertices], offset)
vertex_buffer.update()

vertex_buffer = VertexBuffer.create_transient(vertex_format)
#if transient, just add vertex, should not need to set, since the data is just going to be cleared next frame
#here, add should not allocate more memory, but the ptr should just rollover

vertex_buffer.set_data(
vertex_buffer.set_data(
vertex_buffer.update(
"""

#vertex_buffer = sprite_batch.get_vertex_buffer()
#index_buffer = sprite_batch.get_index_buffer()

"""
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
"""

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