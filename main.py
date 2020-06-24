import math
import numpy as np
from pyorama.core.app import App
from pyorama.event.event_enums import *
from pyorama.event.event_manager import *
from pyorama.graphics.graphics_enums import *
from pyorama.graphics.graphics_manager import GraphicsManager
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4

class Game(App):

    def init(self):
        super().init()

        #setup uniforms
        self.u_texture = self.graphics.uniform_create(self.graphics.u_fmt_texture_0)
        self.graphics.uniform_set_data(self.u_texture, TEXTURE_UNIT_0)
        self.u_proj = self.graphics.uniform_create(self.graphics.u_fmt_proj)
        self.proj_mat = Mat4()
        #Mat4.ortho(self.proj_mat, -5, 5, -5, 5, -5, 5)
        #Mat4.perspective(self.proj_mat, math.radians(90), 800/600.0, 0.001, 1000)
        Mat4.perspective(self.proj_mat, math.radians(90), 1.0, 0.001, 1000)
        self.graphics.uniform_set_data(self.u_proj, self.proj_mat)
        self.view_mat = Mat4()
        self.view_velocity = Vec3(0.0, 0.0, 0.1)
        Mat4.from_translation(self.view_mat, Vec3(0, 0, -100))
        self.u_view = self.graphics.uniform_create(self.graphics.u_fmt_view)
        self.graphics.uniform_set_data(self.u_view, self.view_mat)
        self.uniforms = np.array([self.u_texture, self.u_proj, self.u_view], dtype=np.uint64)

        #setup mesh
        #mesh_path = b"./resources/meshes/teapot.obj"
        #mesh_path = b"./resources/meshes/cube/cube.obj"
        #mesh_path = b"./resources/meshes/cube/cube.dae"
        mesh_path = b"./resources/meshes/dog/dog.obj"
        self.mesh = self.graphics.mesh_create_from_file(mesh_path)
        self.vbo = self.graphics.vertex_buffer_create(self.graphics.v_fmt_mesh)
        self.ibo = self.graphics.index_buffer_create(self.graphics.i_fmt_mesh)
        self.graphics.vertex_buffer_set_data_from_mesh(self.vbo, self.mesh)
        self.graphics.index_buffer_set_data_from_mesh(self.ibo, self.mesh)
        
        #setup shader program
        vs_path = b"./resources/shaders/basic.vert"
        self.vs = self.graphics.shader_create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/basic.frag"
        self.fs = self.graphics.shader_create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = self.graphics.program_create(self.vs, self.fs)

        #setup texture
        #image_path = b"./resources/textures/image_0.png"
        image_path = b"./resources/meshes/dog/dog.jpg"
        self.image = self.graphics.image_create_from_file(image_path)
        self.texture = self.graphics.texture_create()
        self.graphics.texture_set_data_2d_from_image(self.texture, self.image)
        
        #setup window/fbo/view
        self.window = self.graphics.window_create(800, 600, b"Hello World!")
        self.out_color = self.graphics.texture_create()
        self.out_depth = self.graphics.texture_create(format=TEXTURE_FORMAT_DEPTH_32U, filter=TEXTURE_FILTER_NEAREST, mipmaps=False)
        self.graphics.texture_clear(self.out_color, 800, 600)
        self.graphics.texture_clear(self.out_depth, 800, 600)
        self.graphics.window_set_texture(self.window, self.out_color)
        #self.graphics.window_set_texture(self.window, self.out_depth)
        self.fbo = self.graphics.frame_buffer_create()
        self.graphics.frame_buffer_attach_textures(self.fbo, {
            FRAME_BUFFER_ATTACHMENT_COLOR_0: self.out_color,
            FRAME_BUFFER_ATTACHMENT_DEPTH: self.out_depth,
        })
        self.view = self.graphics.view_create()
        self.update_view()

        mouse_down_listener = self.event.listener_create(EVENT_TYPE_MOUSE_BUTTON_DOWN, self.on_mouse_down)
        mouse_up_listener = self.event.listener_create(EVENT_TYPE_MOUSE_BUTTON_UP, self.on_mouse_up)
        enter_frame_listener = self.event.listener_create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)
        #flarg = self.event.event_type_register()
        #self.event.event_type_emit(flarg, {"flargle": "flargleson"})
        #flarg_listener = self.event.listener_create(flarg, self.on_flarg)
    
    def quit(self):
        #really should call *_delete methods on all created graphics handles
        #in testing so far, this function is never called, so am lazy with clean up here.
        #self.graphics.quit()
        super().quit()
    
    def update_view(self):
        self.graphics.view_set_clear_flags(self.view, VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL)
        self.graphics.view_set_clear_color(self.view, Vec4(0.0, 0.0, 0.0, 1.0))
        self.graphics.view_set_clear_depth(self.view, 1.0)
        self.graphics.view_set_rect(self.view, 0, 0, 800, 600)
        self.graphics.view_set_program(self.view, self.program)
        self.graphics.view_set_uniforms(self.view, self.uniforms)
        self.graphics.view_set_vertex_buffer(self.view, self.vbo)
        self.graphics.view_set_index_buffer(self.view, self.ibo)
        self.graphics.view_set_textures(self.view, {
            TEXTURE_UNIT_0: self.texture,
        })
        self.graphics.view_set_frame_buffer(self.view, self.fbo)

    def on_enter_frame(self, event_data, *args, **kwargs):
        Mat4.translate(self.view_mat, self.view_mat, self.view_velocity)
        self.graphics.uniform_set_data(self.u_view, self.view_mat)
        self.graphics.view_set_uniforms(self.view, self.uniforms)
    
    def on_mouse_down(self, event_data, *args, **kwargs):
        print("MOUSE DOWN")
        print("event data", event_data)
        print("event args", args)
        print("event kwargs", kwargs)
        print("")

    def on_mouse_up(self, event_data, *args, **kwargs):
        print("MOUSE UP")
        print("event data", event_data)
        print("event args", args)
        print("event kwargs", kwargs)
        print("")

    """
    def on_flarg(self, event_data, *args, **kwargs):
        print("FLARG!!!")
        print("event data", event_data)
        print("event args", args)
        print("event kwargs", kwargs)
        print("")
    """
    
if __name__ == "__main__":
    game = Game()
    game.run()