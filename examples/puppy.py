import math
import numpy as np
from pyorama.core import *
from pyorama.event import *
from pyorama.graphics import *
from pyorama.physics import *
from pyorama.math3d import *

class Game(App):
    
    def init(self):
        super().init()
        self.setup_window()
        self.setup_uniforms()
        self.setup_mesh()
        self.setup_shader()
        self.setup_texture()
        self.setup_view()
        self.setup_listeners()

        
    
    def setup_window(self):
        #setup window/fbo/view
        self.width = 800
        self.height = 600
        self.title = b"Hello World!"
        self.window = Window(self.graphics)
        self.window.create(self.width, self.height, self.title)

    def setup_uniforms(self):
        self.u_texture = Uniform(self.graphics)
        self.u_texture.create(self.graphics.u_fmt_texture_0)
        self.u_texture.set_data(TEXTURE_UNIT_0)

        self.proj_mat = Mat4()
        Mat4.perspective(self.proj_mat, math.radians(90), 1.0, 0.001, 1000)
        self.u_proj = Uniform(self.graphics)
        self.u_proj.create(self.graphics.u_fmt_proj)
        self.u_proj.set_data(self.proj_mat)

        self.view_mat = Mat4()
        self.view_velocity = Vec3(0.0, 0.0, 0.2)
        Mat4.from_translation(self.view_mat, Vec3(0, 0, -100))
        self.u_view = Uniform(self.graphics)
        self.u_view.create(self.graphics.u_fmt_view)
        self.u_view.set_data(self.view_mat)

        self.uniforms = [self.u_texture, self.u_proj, self.u_view]

    def setup_mesh(self):
        #setup mesh
        #mesh_path = b"./resources/meshes/teapot.obj"
        #mesh_path = b"./resources/meshes/cube/cube.obj"
        #mesh_path = b"./resources/meshes/cube/cube.dae"
        mesh_path = b"./resources/meshes/dog/dog.obj"
        self.mesh = Mesh(self.graphics)
        self.mesh.create_from_file(mesh_path)
        self.vbo = VertexBuffer(self.graphics)
        self.vbo.create(self.graphics.v_fmt_mesh)
        self.vbo.set_data_from_mesh(self.mesh)
        self.ibo = IndexBuffer(self.graphics)
        self.ibo.create(self.graphics.i_fmt_mesh)
        self.ibo.set_data_from_mesh(self.mesh)

    def setup_shader(self):
        vs_path = b"./resources/shaders/basic.vert"
        self.vs = Shader(self.graphics)
        self.vs.create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/basic.frag"
        self.fs = Shader(self.graphics)
        self.fs.create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = Program(self.graphics)
        self.program.create(self.vs, self.fs)

    def setup_texture(self):
        image_path = b"./resources/meshes/dog/dog.jpg"
        self.image = Image(self.graphics)
        self.image.create_from_file(image_path)
        self.texture = Texture(self.graphics)
        self.texture.create()
        self.texture.set_data_2d_from_image(self.image)

    def setup_view(self):
        self.out_color = Texture(self.graphics)
        self.out_color.create()
        self.out_color.clear(self.width, self.height)
        self.window.set_texture(self.out_color)

        self.out_depth = Texture(self.graphics)
        self.out_depth.create(format=TEXTURE_FORMAT_DEPTH_32U, filter=TEXTURE_FILTER_NEAREST, mipmaps=False)
        self.out_depth.clear(self.width, self.height)

        self.fbo = FrameBuffer(self.graphics)
        self.fbo.create()
        self.fbo.attach_textures({
            FRAME_BUFFER_ATTACHMENT_COLOR_0: self.out_color,
            FRAME_BUFFER_ATTACHMENT_DEPTH: self.out_depth,
        })
        self.view = View(self.graphics)
        self.view.create()

    def setup_listeners(self):
        enter_frame_listener = Listener(self.event)
        enter_frame_listener.create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)
        window_listener = Listener(self.event)
        window_listener.create(EVENT_TYPE_WINDOW, self.on_window)

    def quit(self):
        super().quit()
    
    def update_view(self):
        self.view.set_clear_flags(VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL)
        self.view.set_clear_color(Vec4(0.0, 0.0, 0.0, 1.0))
        self.view.set_clear_depth(1.0)
        self.view.set_rect(0, 0, 800, 600)
        self.view.set_program(self.program)
        self.view.set_uniforms(self.uniforms)
        self.view.set_vertex_buffer(self.vbo)
        self.view.set_index_buffer(self.ibo)
        self.view.set_textures({
            TEXTURE_UNIT_0: self.texture,
        })
        self.view.set_frame_buffer(self.fbo)

    def on_enter_frame(self, event_data, *args, **kwargs):
        Mat4.translate(self.view_mat, self.view_mat, self.view_velocity)
        self.u_view.set_data(self.view_mat)
        self.update_view()

    def on_window(self, event_data, *args, **kwargs):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()
    
if __name__ == "__main__":
    game = Game()
    game.run()