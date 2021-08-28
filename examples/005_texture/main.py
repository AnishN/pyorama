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
    counter += 1

width = 800
height = 600
title = b"Mesh"

clear_color = 0x443355FF
counter = 0
at = Vec3(0.0, 0.0, 0.0)
eye = Vec3()
up = Vec3(0.0, 1.0, 0.0)
view_mat = Mat4()
proj_mat = Mat4()
model_mat = Mat4()
mtx_x = Mat4()
mtx_y = Mat4()

base_path = b"./examples/005_texture/"
image_path = base_path + b"textures/cube.png"
mesh_path =  base_path + b"meshes/cube.obj"
vs_source_path = base_path + b"shaders/vs_mesh.sc"
fs_source_path = base_path + b"shaders/fs_mesh.sc"
vs_bin_path = base_path + b"shaders/vs_mesh.sc_bin"
fs_bin_path = base_path + b"shaders/fs_mesh.sc_bin"

pyorama.app.init()

sampler = pyorama.graphics.uniform_create(b"s_tex0", pyorama.graphics.UNIFORM_TYPE_SAMPLER)

mesh = pyorama.graphics.mesh_create_from_file(mesh_path, load_normals=False)
vertex_format = BufferFormat([
    (b"a_position", 3, BUFFER_FIELD_TYPE_F32),
    (b"a_texcoord0", 2, BUFFER_FIELD_TYPE_F32),
])

vertices = Buffer(vertex_format)
vertex_layout = pyorama.graphics.vertex_layout_create(vertex_format)
pyorama.graphics.mesh_get_vertices(mesh, vertices)
vertex_buffer = pyorama.graphics.vertex_buffer_create(vertex_layout, vertices)

index_layout = pyorama.graphics.INDEX_LAYOUT_UINT32
index_format = BufferFormat([
    (b"a_indices", 1, BUFFER_FIELD_TYPE_U32),
])
indices = Buffer(index_format)
pyorama.graphics.mesh_get_indices(mesh, indices)
index_buffer = pyorama.graphics.index_buffer_create(index_layout, indices)

image = pyorama.graphics.image_create_from_file(image_path)
texture = pyorama.graphics.texture_create_2d_from_image(image)

pyorama.graphics.utils_runtime_compile_shader(vs_source_path, vs_bin_path, pyorama.graphics.SHADER_TYPE_VERTEX)
pyorama.graphics.utils_runtime_compile_shader(fs_source_path, fs_bin_path, pyorama.graphics.SHADER_TYPE_FRAGMENT)
vertex_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_VERTEX, vs_bin_path)
fragment_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_FRAGMENT,fs_bin_path)
program = pyorama.graphics.program_create(vertex_shader, fragment_shader)
window = pyorama.graphics.window_create(width, height, title)
frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
view = pyorama.graphics.view_create()
on_window_listener = pyorama.event.listener_create(pyorama.event.EVENT_TYPE_WINDOW, on_window_event, None, None)
on_enter_frame_listener = pyorama.event.listener_create(pyorama.event.EVENT_TYPE_ENTER_FRAME, on_enter_frame_event, None, None)

clear_flags = pyorama.graphics.VIEW_CLEAR_COLOR | pyorama.graphics.VIEW_CLEAR_DEPTH
pyorama.graphics.view_set_clear(view, clear_flags, clear_color, 1.0, 0)
pyorama.graphics.view_set_rect(view, 0, 0, width, height)
pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
pyorama.graphics.view_set_vertex_buffer(view, vertex_buffer)
pyorama.graphics.view_set_index_buffer(view, index_buffer)
pyorama.graphics.view_set_program(view, program)
pyorama.graphics.view_set_texture(view, sampler, texture, 0)

pyorama.app.run()

pyorama.event.listener_delete(on_enter_frame_listener)
pyorama.event.listener_delete(on_window_listener)
pyorama.graphics.uniform_delete(sampler)
pyorama.graphics.texture_delete(texture)
pyorama.graphics.image_delete(image)
pyorama.graphics.program_delete(program)
pyorama.graphics.shader_delete(fragment_shader)
pyorama.graphics.shader_delete(vertex_shader)
pyorama.graphics.index_buffer_delete(index_buffer)
pyorama.graphics.vertex_buffer_delete(vertex_buffer)
pyorama.graphics.mesh_delete(mesh)
pyorama.graphics.view_delete(view)
pyorama.graphics.frame_buffer_delete(frame_buffer)
pyorama.graphics.window_delete(window)
pyorama.app.quit()