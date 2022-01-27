import math
import random
import time

import pyorama
from pyorama import app
from pyorama.math import *
from pyorama.core import *
from pyorama.event import *
from pyorama.graphics import *

def on_window_event(event):
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        app.trigger_quit()

def on_enter_frame_event(event):
    start = time.time()

    """
    for i in range(num_sprites):
        sprite = sprites[i]
        rotation = sprite.get_rotation()
        rotation += rotation_speed
        sprite.set_rotation(rotation)
    end = time.time()
    get_set_delta = end - start

    start = time.time()
    for i in range(num_sprites):
        sprite = sprites[i]
        sprite.rotation -= rotation_speed
    end = time.time()
    property_delta = end - start
    print("rotation", get_set_delta, property_delta)

    start = time.time()
    p = Vec3()
    for i in range(num_sprites):
        sprite = sprites[i]
        sprite.get_position(p)
        p.x += 10
        sprite.set_position(p)
    end = time.time()
    get_set_delta = end - start

    start = time.time()
    for i in range(num_sprites):
        sprite = sprites[i]
        p = sprite.position
        p.x -= 10
        sprite.position = p
    end = time.time()
    property_delta = end - start
    print("position", get_set_delta, property_delta)
    """

    """
    for i in range(num_sprites):
        sprite = sprites[i]
        t = sprite.color_texture
        print(t, t.handle)
    """

    #surprised that property syntax is 2x faster despite "avoiding allocations" with getter/setter
    #python "overhead" in cython annotations sure are misleading
    #the syntax is also nicer to boot and almost mirrors the cython struct accessors
    
    sprite_batch.update()
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

sprites = []
num_sprites = 100000
random_position = Vec3()
random_rotation = 0
rotation_speed = 0.1
random_scale = Vec2()
sprite_size = Vec2(32, 32)
sprite_offset = Vec2(0.5, 0.5)

for i in range(num_sprites):
    random_position.x = random.random() * width
    random_position.y = random.random() * height
    random_rotation = random.random() * 2 * MATH_PI
    random_scale.x = random.random() + 0.5
    random_scale.y = random.random() + 0.5

    sprite = Sprite.init_create(
        texture, 
        position=random_position, 
        rotation=random_rotation,
        scale=random_scale,
        size=sprite_size,
        offset=sprite_offset,
    )
    sprites.append(sprite)

sprite_batch = SpriteBatch.init_create()
sprite_batch.set_sprites(sprites)

vertex_buffer = VertexBuffer(); sprite_batch.get_vertex_buffer(vertex_buffer)
index_buffer = IndexBuffer(); sprite_batch.get_index_buffer(index_buffer)

vertex_shader = Shader.init_create_from_source_file(SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader.init_create_from_source_file(SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program.init_create(vertex_shader, fragment_shader)

CameraUtils.orthographic(proj_mat, 0, width, 0, height, -1, 1)

sampler = Uniform.init_create(b"s_color", UNIFORM_TYPE_SAMPLER)

view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
view.set_transform_model(model_mat)
view.set_transform_view(view_mat)
view.set_transform_projection(proj_mat)
view.set_texture(sampler, texture, 0)
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