import math
import pyorama
from pyorama import app
from pyorama.asset import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *
from pyorama.math import *

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        app.trigger_quit()

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

counter = 0
at = Vec3(0.0, 0.0, 0.0)
eye = Vec3()
up = Vec3(0.0, 1.0, 0.0)
view_mat = Mat4()
proj_mat = Mat4()
model_mat = Mat4()
mtx_x = Mat4()
mtx_y = Mat4()

pyorama.app.init()

mesh_name = b"helmet"
mesh_ext = b".glb"
base_path = b"./examples/mesh/"
mesh_path =  base_path + b"meshes/" + mesh_name + mesh_ext
mesh_2_path = base_path + b"meshes/" + b"box" + mesh_ext
bin_mesh_path = base_path + b"meshes/" + mesh_name + b".bin"
vs_source_path = base_path + b"shaders/vs_mesh.sc"
fs_source_path = base_path + b"shaders/fs_mesh.sc"

mesh = Mesh()
#pyorama.graphics.mesh_utils.mesh_create_from_binary_file(mesh, bin_mesh_path)
#mesh = Mesh()#; mesh.create_from_file(mesh_path, load_texcoords=False, load_normals=False)
#mesh.create_from_binary_file(bin_mesh_path)
#pyorama.asset.queue(ASSET_TYPE_MESH, b"helmet", b"./examples/004_mesh/helmet.glb")
#pyorama.asset.queue(ASSET_TYPE_TEXTURE, b"helmet_texture",

queue = AssetQueue()
queue.create()
queue.add_asset(ASSET_TYPE_MESH, b"helmet", base_patjmeshes/helmet.glb") 
queue.add_asset(ASSET_TYPE_MESH, b"box", b"./examples/004_mesh/meshes/box.glb")
queue.add_asset(ASSET_TYPE_IMAGE, b"capsule", b"./examples/005_texture/textures/capsule.jpg")
queue.add_asset(ASSET_TYPE_IMAGE, b"cube", b"./examples/005_texture/textures/cube.png")
#queue.add_asset(ASSET_TYPE_SHADER, b"vs", b"./examples/005_texture/shaders/test.py")
#queue.add_asset(b"Sphere", b"path/to/sphere.obj", ASSET_TYPE_MESH)

import time

start = time.time()
queue.load()
end = time.time()
print(end - start)

image = Image()
pyorama.app.get_asset_system().get_asset(b"cube", image)
print(image.get_width(), image.get_height())
print(image.get_pixels())

pixels = image.get_shaped_pixels()
start = time.time()
for i in range(100000):
    r = pixels[0, 0, 0]
end = time.time()
print(end - start)

start = time.time()
for i in range(100000):
    pixels[0, 0, 0] = 5
end = time.time()
print(end - start)

"""
queue = AssetQueue()
#queue.add_asset(
    type=ASSET_TYPE_MESH, 
    name=b"helmet", 
    path=b"./examples/004_mesh/helmet.glb", 
    options=None,
)
#queue.add_assets( list of asset dicts )
#queue.load() # better be multithreaded (why not?)

def on_asset_queue_item_complete_event(event, *args, **kwargs):
    queue = event["queue"]
    item = event["item"]

def on_asset_queue_all_complete_event(event, *args, **kwargs):
    queue = event["queue"]
"""

"""
assets_info = {
    "assets": [
        {
            "type": "mesh",
            "name": "helmet",
            "path": "./examples/004_mesh/helmet.glb",
        },

        (ASSET_TYPE_MESH, b"helmet", b"./examples/004_mesh/helmet.glb"),
        (ASSET_TYPE_TEXTURE, b"helmet_texture", b"./examples/004_mesh/helmet.png"),
    ]
}
#pyorama.asset.queue_multi(assets_info)
#pyorama.asset.load()
"""

"""
vertex_format = BufferFormat([
    (b"a_position", 3, BUFFER_FIELD_TYPE_F32),
])
vertices = Buffer(vertex_format)
vertex_layout = VertexLayout(); vertex_layout.create(vertex_format)
pyorama.graphics.mesh_get_vertices(mesh, vertices)
vertex_buffer = VertexBuffer(); vertex_buffer.create(vertex_layout, vertices)

index_layout = pyorama.graphics.INDEX_LAYOUT_U32
index_format = BufferFormat([
    (b"a_indices", 1, BUFFER_FIELD_TYPE_U32),
])
indices = Buffer(index_format)
pyorama.graphics.mesh_get_indices(mesh, indices)
index_buffer = IndexBuffer(); index_buffer.create(index_layout, indices)

vertex_shader = Shader(); vertex_shader.create_from_source_file(pyorama.graphics.SHADER_TYPE_VERTEX, vs_source_path)
fragment_shader = Shader(); fragment_shader.create_from_source_file(pyorama.graphics.SHADER_TYPE_FRAGMENT, fs_source_path)
program = Program(); program.create(vertex_shader, fragment_shader)
window = Window(); window.create(width, height, title)
frame_buffer = FrameBuffer(); frame_buffer.create_from_window(window)
view = View(); view.create()
on_window_listener = Listener(); on_window_listener.create(pyorama.event.EventType._WINDOW, on_window_event, None, None)
on_enter_frame_listener = Listener(); on_enter_frame_listener.create(pyorama.event.EventType._ENTER_FRAME, on_enter_frame_event, None, None)

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

pyorama.graphics.mesh_delete(mesh)
pyorama.app.quit()
"""