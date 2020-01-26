from pyorama.core.app import App
from pyorama.event import *
from pyorama.keyboard import *
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
        super().init(use_vsync=False, use_sleep=True)
        #super().init(use_vsync=True, use_sleep=False)
        self.setup_window()
        self.setup_program()
        self.setup_batch()
        self.setup_texture()
        self.setup_listeners()
        self.setup_camera()

    def quit(self):
        self.cleanup_window()
        self.cleanup_program()
        self.cleanup_batch()
        self.cleanup_texture()
        self.cleanup_listeners()
        self.cleanup_camera()
        super().quit()
    
    def on_key_down(self, event_data, user_data):
        scan_code = event_data["scan_code"]
        shift = Vec3()
        if scan_code == SCAN_CODE_LEFT:
            shift = Vec3(-1.0, 0.0, 0.0)
        elif scan_code == SCAN_CODE_RIGHT:
            shift = Vec3(+1.0, 0.0, 0.0)
        elif scan_code == SCAN_CODE_UP:
            shift = Vec3(0.0, +1.0, 0.0)
        elif scan_code == SCAN_CODE_DOWN:
            shift = Vec3(0.0, -1.0, 0.0)
        
        position = self.graphics.camera_3d_get_position(self.camera)
        target = self.graphics.camera_3d_get_target(self.camera)
        Vec3.add(position, position, shift)
        self.graphics.camera_3d_set_position(self.camera, position)
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.title = b"Test"
        self.window = self.graphics.window_create()
        self.graphics.window_init(self.window, self.width, self.height, self.title)

    def cleanup_widow(self):
        self.graphics.window_free(self.window)
        self.graphics.window_delete(self.window)

    def setup_program(self):
        vs_file = open("./resources/shaders/basic.vert", "rb")
        vs_source = vs_file.read()
        vs_file.close()
        self.vs = self.graphics.shader_create()
        self.graphics.shader_init(self.vs, SHADER_TYPE_VERTEX, vs_source)
        self.graphics.shader_compile(self.vs)

        fs_file = open("./resources/shaders/basic.frag", "rb")
        fs_source = fs_file.read()
        fs_file.close()
        self.fs = self.graphics.shader_create()
        self.graphics.shader_init(self.fs, SHADER_TYPE_FRAGMENT, fs_source)
        self.graphics.shader_compile(self.fs)

        self.program = self.graphics.program_create()
        self.graphics.program_init(self.program, self.vs, self.fs)
        self.graphics.program_compile(self.program)

    def cleanup_program(self):
        self.graphics.program_free(self.program)
        self.graphics.program_delete(self.program)
        self.graphics.shader_free(self.vs)
        self.graphics.shader_delete(self.vs)
        self.graphics.shader_free(self.fs)
        self.graphics.shader_delete(self.fs)

    def setup_batch(self):
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
        self.graphics.mesh_set_vertices_data(mesh, v_data)
        self.graphics.mesh_set_indices_data(mesh, i_data)
        
        model = self.graphics.model_create()
        self.graphics.model_init(model, mesh, Vec3(0.5, 0.0, 0.0), Quat(), Vec3())

        self.meshes = np.array([mesh], dtype=np.uint64)
        self.models = np.array([model], dtype=np.uint64)
        self.batch = self.graphics.model_batch_create()
        self.graphics.model_batch_init(self.batch, self.models)

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
        self.image = self.graphics.image_create()
        #self.graphics.image_init_from_file(image, b"../gltfJsonStructure.png")
        #self.graphics.image_init_from_file(image, b"../monkey/albedo.png")
        self.graphics.image_init_from_file(self.image, b"../dog/dog.jpg")
        #self.graphics.image_init_from_file(image, b"../monkey/Suzanne.jpg")
        #self.graphics.image_init_from_file(image, b"../banana/tex/Banana.jpg")
        self.sampler = self.graphics.sampler_create()
        self.texture = self.graphics.texture_create()
        self.graphics.sampler_init(self.sampler)
        self.graphics.texture_init(self.texture, self.sampler, self.image)
        self.graphics.texture_bind(self.texture)
        self.graphics.texture_upload(self.texture)
        self.graphics.texture_unbind()
    
    def cleanup_texture(self):
        self.graphics.image_free(self.image)
        self.graphics.sampler_free(self.sampler)
        self.graphics.texture_free(self.texture)
        self.graphics.image_delete(self.image)
        self.graphics.sampler_delete(self.sampler)
        self.graphics.texture_delete(self.texture)

    def setup_listeners(self):
        key_down = self.events.listener_create()
        self.events.listener_init(key_down, EVENT_TYPE_KEY_DOWN, self.on_key_down, None)
        self.listeners = np.array([key_down], dtype=np.uint64)

    def cleanup_listeners(self):
        for listener in self.listeners:
            self.events.listener_free(listener)
            self.events.listener_delete(listener)

    def setup_camera(self):
        self.camera = self.graphics.camera_3d_create()
        self.graphics.camera_3d_init(self.camera, math.radians(90.0), float(self.width)/self.height, 0.0, 1000)
    
    def cleanup_camera(self):
        self.graphics.camera_3d_delete(self.camera)
        self.camera = None
    
    def update(self, delta):
        fps = round(1.0/delta, 1)
        fps_title = "{0} (FPS: {1})".format(self.title.decode("utf-8"), fps).encode("utf-8")
        self.graphics.window_set_title(self.window, fps_title)
        self.events.update()

        self.graphics.window_bind(self.window)
        self.graphics.window_clear()
        self.graphics.program_bind(self.program)

        projection = self.graphics.camera_3d_get_projection(self.camera)
        self.graphics.program_set_uniform(self.program, b"projection", projection)
        view = self.graphics.camera_3d_get_view(self.camera)
        self.graphics.program_set_uniform(self.program, b"view", view)
        self.graphics.program_set_uniform(self.program, b"sampler", 0)

        self.graphics.texture_bind(self.texture)
        self.graphics.model_batch_render(self.batch)
        self.graphics.texture_unbind()
        
        self.graphics.program_unbind()
        self.graphics.window_swap_buffers(self.window)
        self.graphics.window_unbind()

if __name__ == "__main__":
    game = Game()
    game.run()