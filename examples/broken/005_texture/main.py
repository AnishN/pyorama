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
view_mat = Mat4()
proj_mat = Mat4()
model_mat = Mat4()

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
    (-400, -300, 0.0, 0.0, 0.0),
    (+400, -300, 0.0, 1.0, 0.0),
    (+400, +300, 0.0, 1.0, 1.0),
    (-400, +300, 0.0, 0.0, 1.0),
])
vertex_buffer = VertexBuffer.init_create(vertex_layout, vertices)

index_format = BufferFormat([
    (b"a_indices", 1, BUFFER_FIELD_TYPE_U16),
])
indices = Buffer(index_format)
indices.init_from_list([
    0, 1, 2, 0, 2, 3
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
on_window_listener = Listener.init_create(EventType._WINDOW, on_window_event, None, None)


Vec3.set_data(eye, 0, 0, 1000)
Mat4.look_at(view_mat, eye, at, up)
Mat4.orthographic(proj_mat, 1.0/2.0, 1.0/2.0, 0.01, 1000.0)

"""
void mtxOrtho(float* _result, float _left, float _right, float _bottom, float _top, float _near, float _far, float _offset, bool _homogeneousNdc, Handness::Enum _handness)
	{
		const float aa = 2.0f/(_right - _left);
		const float bb = 2.0f/(_top - _bottom);
		const float cc = (_homogeneousNdc ? 2.0f : 1.0f) / (_far - _near);
		const float dd = (_left + _right )/(_left   - _right);
		const float ee = (_top  + _bottom)/(_bottom - _top  );
		const float ff = _homogeneousNdc
			? (_near + _far)/(_near - _far)
			:  _near        /(_near - _far)
			;

		memSet(_result, 0, sizeof(float)*16);
		_result[ 0] = aa;
		_result[ 5] = bb;
		_result[10] = cc;
		_result[12] = dd + _offset;
		_result[13] = ee;
		_result[14] = ff;
		_result[15] = 1.0f;
	}

@staticmethod
cdef void c_orthographic(Mat4C *out, float x_mag, float y_mag, float z_near, float z_far) nogil:
    out.m00 = 1.0/x_mag
    out.m01 = 0
    out.m02 = 0
    out.m03 = 0
    out.m10 = 0
    out.m11 = 1.0/y_mag
    out.m12 = 0
    out.m13 = 0
    out.m20 = 0
    out.m21 = 0
    out.m22 = 2.0/(z_near - z_far)
    out.m23 = 0
    out.m30 = 0
    out.m31 = 0
    out.m32 = (z_far + z_near) / (z_near - z_far)
    out.m33 = 1
"""

#print(proj_mat.data)
#Mat4.orthographic_alt(proj_mat, 0, width, 0, height, 0.01, 1000.0)
#print(proj_mat.data)
Mat4.perspective(proj_mat, math.radians(60.0), float(width) / float(height),  0.01, 1000.0)
print(proj_mat.data)
#print("")

clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
view.set_clear(clear_flags, 0x443355FF, 1.0, 0)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.set_vertex_buffer(vertex_buffer)
view.set_index_buffer(index_buffer)
view.set_program(program)
view.set_texture(sampler, texture, 0)
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