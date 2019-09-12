from OpenGL.GL import *

import glob
import time
import numpy as np
from pyorama.core.app import *
from pyorama.graphics.common import *
from pyorama.graphics.graphics_manager import *
from pyorama.graphics.window import *
from pyorama.graphics.image import *
from pyorama.graphics.sampler import *
from pyorama.graphics.texture import *
from pyorama.graphics.shader import *
from pyorama.graphics.program import *

class Game(App):
        
    def init(self):
        super().init()
        self.prev_time = time.time()
        self.curr_time = self.prev_time
        self.graphics = GraphicsManager()
        self.create_graphics()
        self.init_graphics()
        
    def create_graphics(self):
        self.graphics.init()
        self.window = self.graphics.create_window()
        self.image = self.graphics.create_image()
        self.sampler = self.graphics.create_sampler()
        self.texture = self.graphics.create_texture()
        self.vs = self.graphics.create_shader()
        self.fs = self.graphics.create_shader()
        self.program = self.graphics.create_program()
    
    def quit_graphics(self):
        self.graphics.delete_window(self.window)
        self.graphics.delete_image(self.image)
        self.graphics.delete_sampler(self.sampler)
        self.graphics.delete_texture(self.texture)
        self.graphics.delete_shader(self.vs)
        self.graphics.delete_shader(self.fs)
        self.graphics.delete_program(self.program)
        self.graphics.quit()

    def init_graphics(self):
        self.window.init(800, 600, "Hello, world!")
        self.image.init_from_file("test.png")
        self.sampler.init()
        self.texture.init(self.sampler, self.image)

        self.vs_source = b"""
        #version 120
        void main()
        {
            gl_Position = gl_Vertex;
        }
        """
        self.vs.init(ShaderType.SHADER_TYPE_VERTEX, self.vs_source)
        self.vs.compile()
        self.fs_source = b"""
        #version 120
        void main()
        {
            gl_FragColor = vec4(0.3, 0.3, 0.3, 1.0);
        }
        """
        self.fs.init(ShaderType.SHADER_TYPE_FRAGMENT, self.fs_source)
        self.fs.compile()
        self.program.init(self.vs, self.fs)
        self.program.compile()
        self.program.setup_attributes()

    def clear_graphics(self):
        self.window.clear()
        self.image.clear()
        self.sampler.clear()
        self.texture.clear()
        self.vs.clear()
        self.fs.clear()
        self.program.clear()

    def quit(self):
        self.clear_graphics()
        self.quit_graphics()
        super().quit()

    def update(self):
        self.curr_time = time.time()
        self.window.bind()
        self.program.bind()
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        #self.program.set_attribute(
        #self.program.set_uniform(
        
        glBegin(GL_TRIANGLES)
        glVertex3f(-1, -1, 0)
        glVertex3f(0, 1, 0)
        glVertex3f(1, -1, 0)
        glEnd()
        
        self.window.swap_buffers()
        self.program.unbind()
        self.window.unbind()
        print(self.curr_time - self.prev_time)
        self.prev_time = self.curr_time

#game = Game(use_sleep=False, use_vsync=True, ms_per_update=1000.0/60.0)
game = Game(use_sleep=True, use_vsync=False, ms_per_update=1000.0/60.0)
game.run()