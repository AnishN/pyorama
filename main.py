from pyorama.core.app import App
from pyorama.event import *
from pyorama.graphics import *
from pyorama.loaders.obj import *
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.quat import Quat
from pyorama.math3d.mat4 import Mat4
import time
import math
import numpy as np

class Game(App):

    def init(self):
        #super().init(use_vsync=False, use_sleep=True)
        super().init(use_vsync=True, use_sleep=False)
        self.graphics = GraphicsManager()
        self.events = EventManager()

        self.width = 800
        self.height = 600
        self.title = b"Test"
        self.window = self.setup_window()
        
        self.vs, self.fs, self.program = self.setup_program()
        self.meshes, self.models, self.batch = self.setup_batch()
        self.image, self.sampler, self.texture = self.setup_texture()
        self.projection = Mat4()

        """
        listener = self.events.listener_create()
        self.events.listener_init(listener, WINDOW_QUIT, self.quit, None)
        self.events.listener_init(
        """
        
        #Mat4.ortho(self.projection, -5, 5, -5, 5, -5, 5)
        Mat4.ortho(self.projection, -50, 50, -50, 50, -50, 50)
        #Mat4.ortho(self.projection, -500, 500, -500, 500, -500, 500)
        #Mat4.perspective(self.projection, math.radians(90.0), float(width)/height, -100, 100)
        #self.renderer = Renderer(self.graphics)
    
    def quit(self, event):
        self.cleanup_program()
        self.cleanup_batch()
        self.cleanup_texture()
        super().quit()

    def setup_window(self):
        window = self.graphics.window_create()
        self.graphics.window_init(window, self.width, self.height, self.title)
        return window

    def cleanup_widow(self):
        self.graphics.window_free(self.window)
        self.graphics.window_delete(self.window)

    def setup_program(self):
        vs_file = open("./resources/shaders/basic.vert", "rb")
        vs_source = vs_file.read()
        vs_file.close()
        vs = self.graphics.shader_create()
        self.graphics.shader_init(vs, SHADER_TYPE_VERTEX, vs_source)
        self.graphics.shader_compile(vs)

        fs_file = open("./resources/shaders/basic.frag", "rb")
        fs_source = fs_file.read()
        fs_file.close()
        fs = self.graphics.shader_create()
        self.graphics.shader_init(fs, SHADER_TYPE_FRAGMENT, fs_source)
        self.graphics.shader_compile(fs)

        program = self.graphics.program_create()
        self.graphics.program_init(program, vs, fs)
        self.graphics.program_compile(program)
        return vs, fs, program

    def cleanup_program(self):
        self.graphics.program_free(self.program)
        self.graphics.program_delete(self.program)
        self.graphics.shader_free(self.vs)
        self.graphics.shader_delete(self.vs)
        self.graphics.shader_free(self.fs)
        self.graphics.shader_delete(self.fs)
    
    def setup_batch(self):
        #Mesh Setup
        mesh = self.graphics.mesh_create()
        self.graphics.mesh_init(mesh)
        """
        v_data = np.array([
            -1, -1, 0, 0, 1, 0, 0, 0,
            1, 1, 0, 1, 0, 0, 0, 0,
            1, -1, 0, 1, 1, 0, 0, 0,
        ], dtype=np.float32)
        i_data = np.array([0, 1, 2], dtype=np.uint32)
        """
        #v_data, i_data = OBJLoader.load_file(b"../sphere.obj")
        #v_data, i_data = OBJLoader.load_file(b"../cube.obj")
        #v_data, i_data = OBJLoader.load_file(b"../banana/Banana.obj")
        #v_data, i_data = OBJLoader.load_file(b"../monkey/monkey.obj")
        v_data, i_data = OBJLoader.load_file(b"../dog/dog.obj")
        #v_data, i_data = OBJLoader.load_file(b"../jburkardt/airboat.obj")
        #v_data, i_data = OBJLoader.load_file(b"../obj_files/teapot.obj")
        #print(np.asarray(v_data))
        #print(np.asarray(i_data))

        self.graphics.mesh_set_vertices_data(mesh, v_data)
        self.graphics.mesh_set_indices_data(mesh, i_data)
        
        model = self.graphics.model_create()
        self.graphics.model_init(model, mesh, Vec3(0.5, 0.0, 0.0), Quat(), Vec3())
        meshes = np.array([mesh], dtype=np.uint64)
        models = np.array([model], dtype=np.uint64)
        batch = self.graphics.model_batch_create()

        self.graphics.model_batch_init(batch, models)
        return meshes, models, batch

    def cleanup_batch(self):
        self.graphics.model_batch_free(self.batch)
        self.graphics.model_batch_delete(self.batch)
        for mesh in self.meshes:
            self.graphics.mesh_free(mesh)
            self.graphics.mesh_delete(mesh)
        for model in self.models:
            self.graphics.mesh_free(mesh)
            self.graphics.mesh_delete(mesh)

    def setup_texture(self):
        image = self.graphics.image_create()
        #self.graphics.image_init_from_file(image, b"../gltfJsonStructure.png")
        #self.graphics.image_init_from_file(image, b"../monkey/albedo.png")
        self.graphics.image_init_from_file(image, b"../dog/dog.jpg")
        #self.graphics.image_init_from_file(image, b"../monkey/Suzanne.jpg")
        #self.graphics.image_init_from_file(image, b"../banana/tex/Banana.jpg")
        image_width = self.graphics.image_get_width(image)
        image_height = self.graphics.image_get_height(image)
        sampler = self.graphics.sampler_create()
        texture = self.graphics.texture_create()
        self.graphics.sampler_init(sampler)
        self.graphics.texture_init(texture, sampler, image)
        self.graphics.texture_bind(texture)
        self.graphics.texture_upload(texture)
        self.graphics.texture_unbind()
        return image, sampler, texture
    
    def cleanup_texture(self):
        self.graphics.image_free(self.image)
        self.graphics.sampler_free(self.sampler)
        self.graphics.texture_free(self.texture)
        self.graphics.image_delete(self.image)
        self.graphics.sampler_delete(self.sampler)
        self.graphics.texture_delete(self.texture)
    
    def pre_update(self):
        pass
    
    def update(self, delta):
        fps = round(1.0/delta, 1)
        fps_title = "{0} (FPS: {1})".format(self.title.decode("utf-8"), fps).encode("utf-8")
        self.graphics.window_set_title(self.window, fps_title)
        
        self.graphics.window_bind(self.window)
        self.graphics.window_clear()
        self.graphics.program_bind(self.program)
        self.graphics.program_set_uniform(self.program, b"projection", self.projection)
        self.graphics.program_set_uniform(self.program, b"sampler", 0)
        self.graphics.texture_bind(self.texture)
        self.graphics.model_batch_render(self.batch)
        self.graphics.texture_unbind()
        self.graphics.program_unbind()
        self.graphics.window_swap_buffers(self.window)
        self.graphics.window_unbind()

    def post_update(self):
        pass
    
if __name__ == "__main__":
    game = Game()
    game.run()