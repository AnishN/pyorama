from pyorama.core.app import *
from pyorama.graphics import *
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4
import time
import numpy as np

class Game(App):

    def init(self):
        super().init()
        self.graphics = GraphicsManager()
        self.window = self.setup_window()
        self.vs, self.fs, self.program = self.setup_program()
        self.meshes, self.mesh_format, self.batch = self.setup_batch()
        self.image, self.sampler, self.texture = self.setup_texture()

        self.model_view = Mat4()
        Mat4.translate(self.model_view, self.model_view, Vec3(0, 0, 0))

    def quit(self):
        super().quit()
        self.cleanup_program()
        self.cleanup_batch()
        self.cleanup_texture()

    def setup_window(self):
        width = 800
        height = 600
        title = b"Test"
        window = self.graphics.window_create()
        self.graphics.window_init(window, width, height, title)
        return window

    def cleanup_widow(self):
        self.graphics.window_free(self.window)
        self.graphics.window_delete(self.window)

    def setup_program(self):
        vs_source = b"""
        #version 330 core
        layout (location = 0) in vec3 vertices;
        layout (location = 1) in vec2 tex_coords;
        out vec2 v_tex_coords;
        uniform mat4 model_view;
        void main()
        {
            gl_Position = model_view * vec4(vertices, 1.0);
            v_tex_coords = tex_coords;
        }
        """
        vs = self.graphics.shader_create()
        self.graphics.shader_init(vs, SHADER_TYPE_VERTEX, vs_source)
        self.graphics.shader_compile(vs)

        fs_source = b"""
        #version 330 core
        uniform sampler2D sampler;
        in vec2 v_tex_coords;
        out vec4 frag_color;
        void main()
        {
            frag_color = texture2D(sampler, v_tex_coords);
        }
        """
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
        mesh_format = self.graphics.mesh_format_create()
        self.graphics.mesh_format_init(mesh_format, [
            (0, b"vertices", MATH_TYPE_VEC3), 
            (1, b"tex_coords", MATH_TYPE_VEC2),
        ])

        mesh = self.graphics.mesh_create()
        self.graphics.mesh_init(mesh, mesh_format)
        mesh_data = np.array([
            #triangle 1
            -1, -1, 0, 0, 1,
            1, 1, 0, 1, 0,
            1, -1, 0, 1, 1,
            #triangle 2
            -1, -1, 0, 0, 1,
            1, 1, 0, 1, 0, 
            -1, 1, 0, 1, 1,
        ], dtype=np.float32)
        self.graphics.mesh_set_data(mesh, mesh_data)
        batch = self.graphics.mesh_batch_create()
        meshes = np.array([mesh], dtype=np.uint64)
        self.graphics.mesh_batch_init(batch, mesh_format, meshes)
        return meshes, mesh_format, batch

    def cleanup_batch(self):
        self.graphics.mesh_batch_free(self.batch)
        self.graphics.mesh_batch_delete(self.batch)
        self.graphics.mesh_format_free(self.mesh_format)
        self.graphics.mesh_format_delete(self.mesh_format)
        for mesh in self.meshes:
            self.graphics.mesh_free(mesh)
            self.graphics.mesh_delete(mesh)

    def setup_texture(self):
        image = self.graphics.image_create()
        self.graphics.image_init_from_file(image, b"./resources/images/science.jpg")
        image_width = self.graphics.image_get_width(image)
        image_height = self.graphics.image_get_height(image)
        sampler = self.graphics.sampler_create()
        texture = self.graphics.texture_create()
        self.graphics.sampler_init(sampler)
        self.graphics.texture_init(texture, sampler, image)
        self.graphics.texture_bind(texture, upload_sampler=True, upload_image=True)
        self.graphics.texture_unbind()
        return image, sampler, texture

    def cleanup_texture(self):
        self.graphics.image_free(self.image)
        self.graphics.sampler_free(self.sampler)
        self.graphics.texture_free(self.texture)
        self.graphics.image_delete(self.image)
        self.graphics.sampler_delete(self.sampler)
        self.graphics.texture_delete(self.texture)

    def update(self):
        start = time.time()
        self.graphics.window_bind(self.window)
        self.graphics.window_clear()
        self.graphics.program_bind(self.program)
        self.graphics.program_set_uniform(self.program, b"model_view", self.model_view)
        self.graphics.program_set_uniform(self.program, b"sampler", 0)
        self.graphics.texture_bind(self.texture)
        self.graphics.mesh_batch_render(self.batch)
        self.graphics.texture_unbind()
        self.graphics.program_unbind()
        self.graphics.window_swap_buffers(self.window)
        self.graphics.window_unbind()
        end = time.time()
        print(end - start)

if __name__ == "__main__":
    game = Game()
    game.run()