import math
import numpy as np
from pyorama.core.app import *
from pyorama.event.event_enums import *
from pyorama.graphics.graphics_enums import *
from pyorama.math3d.vec2 import Vec2
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4

class Game(App):
    
    def init(self):
        super().init()
        self.setup_window()
        self.setup_uniforms()
        self.setup_shaders()
        self.setup_triangle()
        self.setup_view()
        self.setup_listeners()
        
    def quit(self):
        super().quit()
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.title = b"Sprite Test"
        self.window = self.graphics.window_create(self.width, self.height, self.title)

    def setup_uniforms(self):
        self.u_proj = self.graphics.uniform_create(self.graphics.u_fmt_proj)
        self.proj_mat = Mat4()
        Mat4.ortho(self.proj_mat, -1, 1, -1, 1, -1, 1)
        self.graphics.uniform_set_data(self.u_proj, self.proj_mat)
        self.view_mat = Mat4()
        self.u_view = self.graphics.uniform_create(self.graphics.u_fmt_view)
        self.graphics.uniform_set_data(self.u_view, self.view_mat)
        self.uniforms = np.array([self.u_proj, self.u_view], dtype=np.uint64)

    def setup_shaders(self):
        vs_path = b"./resources/shaders/triangle.vert"
        fs_path = b"./resources/shaders/triangle.frag"
        self.vs = self.graphics.shader_create_from_file(SHADER_TYPE_VERTEX, vs_path)
        self.fs = self.graphics.shader_create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = self.graphics.program_create(self.vs, self.fs)

    def setup_triangle(self):
        self.vertex_data = np.array(
            [
                -1.0, -1.0, +0.0,
                +0.0, +1.0, +0.0,
                +1.0, -1.0, +0.0,
            ],
            dtype=np.float32,
        )
        self.vertex_data = self.vertex_data.view(np.uint8)
        self.v_fmt = self.graphics.vertex_format_create(
            [
                (b"a_position", VERTEX_COMP_TYPE_F32, 3, False),
            ],
        )
        self.vbo = self.graphics.vertex_buffer_create(self.v_fmt)
        self.graphics.vertex_buffer_set_data(self.vbo, self.vertex_data)
        self.index_data = np.array([0, 1, 2], dtype=np.uint32)
        self.index_data = self.index_data.view(np.uint8)
        self.i_fmt = INDEX_FORMAT_U32
        self.ibo = self.graphics.index_buffer_create(self.i_fmt)
        self.graphics.index_buffer_set_data(self.ibo, self.index_data)

    def setup_view(self):
        self.out_color = self.graphics.texture_create()
        self.graphics.texture_clear(self.out_color, 800, 600)
        self.graphics.window_set_texture(self.window, self.out_color)
        self.fbo = self.graphics.frame_buffer_create()
        self.graphics.frame_buffer_attach_textures(self.fbo, {
            FRAME_BUFFER_ATTACHMENT_COLOR_0: self.out_color,
        })
        self.view = self.graphics.view_create()
        self.graphics.view_set_clear_flags(self.view, VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL)
        self.graphics.view_set_clear_color(self.view, Vec4(0.0, 0.0, 0.0, 1.0))
        self.graphics.view_set_clear_depth(self.view, 1.0)
        self.graphics.view_set_rect(self.view, 0, 0, self.width, self.height)
        self.graphics.view_set_program(self.view, self.program)
        self.graphics.view_set_uniforms(self.view, self.uniforms)
        self.graphics.view_set_vertex_buffer(self.view, self.vbo)
        self.graphics.view_set_index_buffer(self.view, self.ibo)
        self.graphics.view_set_frame_buffer(self.view, self.fbo)
    
    def setup_listeners(self):
        window_listener = self.event.listener_create(EVENT_TYPE_WINDOW, self.on_window)
    
    def on_window(self, event_data, *args, **kwargs):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()

if __name__ == "__main__":
    game = Game()
    game.run()