import math
import numpy as np
from pyorama.core import *
from pyorama.event import *
from pyorama.graphics import *
from pyorama.math3d import *

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
        self.window = Window(self.graphics)
        self.window.create(self.width, self.height, self.title)

    def setup_uniforms(self):
        self.proj_mat = Mat4()
        self.u_proj = Uniform(self.graphics)
        self.u_proj.create(self.graphics.u_fmt_proj)
        Mat4.ortho(self.proj_mat, -1, 1, -1, 1, -1, 1)
        self.u_proj.set_data(self.proj_mat)

        self.view_mat = Mat4()
        self.u_view = Uniform(self.graphics)
        self.u_view.create(self.graphics.u_fmt_view)
        self.u_view.set_data(self.view_mat)

        self.uniforms = [self.u_proj, self.u_view]

    def setup_shaders(self):
        vs_path = b"./resources/shaders/triangle.vert"
        self.vs = Shader(self.graphics)
        self.vs.create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/triangle.frag"
        self.fs = Shader(self.graphics)
        self.fs.create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = Program(self.graphics)
        self.program.create(self.vs, self.fs)

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
        self.v_fmt = VertexFormat(self.graphics)
        self.v_fmt.create(
            [
                (b"a_position", VERTEX_COMP_TYPE_F32, 3, False),
            ],
        )
        self.vbo = VertexBuffer(self.graphics)
        self.vbo.create(self.v_fmt)
        self.vbo.set_data(self.vertex_data)

        self.index_data = np.array([0, 1, 2], dtype=np.uint32)
        self.index_data = self.index_data.view(np.uint8)
        self.i_fmt = INDEX_FORMAT_U32
        self.ibo = IndexBuffer(self.graphics)
        self.ibo.create(self.i_fmt)
        self.ibo.set_data(self.index_data)

    def setup_view(self):
        self.out_color = Texture(self.graphics)
        self.out_color.create()
        self.out_color.clear(800, 600)
        self.window.set_texture(self.out_color)
        self.fbo = FrameBuffer(self.graphics)
        self.fbo.create()
        self.fbo.attach_textures({
            FRAME_BUFFER_ATTACHMENT_COLOR_0: self.out_color,
        })
        self.view = View(self.graphics)
        self.view.create()
        self.view.set_clear_flags(VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL)
        self.view.set_clear_color(Vec4(0.0, 0.0, 0.0, 1.0))
        self.view.set_clear_depth(1.0)
        self.view.set_rect(0, 0, self.width, self.height)
        self.view.set_program(self.program)
        self.view.set_uniforms(self.uniforms)
        self.view.set_vertex_buffer(self.vbo)
        self.view.set_index_buffer(self.ibo)
        self.view.set_frame_buffer(self.fbo)
    
    def setup_listeners(self):
        window_listener = Listener(self.event)
        window_listener.create(EVENT_TYPE_WINDOW, self.on_window)
    
    def on_window(self, event_data, *args, **kwargs):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()

if __name__ == "__main__":
    game = Game()
    game.run()