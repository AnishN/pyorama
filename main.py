import glob
import time
import numpy as np
from pyorama.core.app import *
from pyorama.graphics.common import *
from pyorama.graphics.graphics_manager import *
from pyorama.graphics.image import *
from pyorama.graphics.sampler import *
from pyorama.graphics.texture import *
from pyorama.graphics.shader import *


class Game(App):
        
    def init(self):
        super().init()
        self.prev_time = time.time()
        self.curr_time = self.prev_time
        
    def quit(self):
        super().quit()

    def update(self):
        self.curr_time = time.time()
        print(self.curr_time - self.prev_time)
        self.prev_time = self.curr_time

game = Game(use_sleep=True, use_vsync=False, ms_per_update=1000.0/60.0)
game.init()

graphics = GraphicsManager()
graphics.init()

img = graphics.create_image()
img.init_from_file("test.png")
img.clear()
graphics.delete_image(img)

samp = graphics.create_sampler()
samp.init()
samp.clear()
graphics.delete_sampler(samp)

tex = graphics.create_texture()
tex.init(samp, img)
graphics.delete_texture(tex)

vs = graphics.create_shader()
vs_source = b"""
#version 120
void main()
{
    gl_Position = gl_Vertex;
}
"""
vs.init(ShaderType.SHADER_TYPE_VERTEX, vs_source)
vs.compile()
vs.clear()
graphics.delete_shader(vs)

fs = graphics.create_shader()
fs_source = b"""
#version 120
void main()
{
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
"""
fs.init(ShaderType.SHADER_TYPE_FRAGMENT, fs_source)
fs.compile()
fs.clear()
graphics.delete_shader(fs)

"""
render_pass = RenderPass.create(graphics)
RenderPass.init(graphics, render_pass)
RenderPass.set_attribute(
RenderPass.set_uniform(
"""

"""
ctypedef struct RenderPassC:
    uint32_t id
    ItemVectorC attributes
    ItemVectorC uniforms
    ItemVectorC textures
    Handle vertex_shader
    Handle fragment_shader

RenderPass.get_uniform_loc(graphics, rp, "POSITION")
RenderPass.get_attribute_loc(graphics, rp, "MVP")
RenderPass.attach_attribute(0, x)
"""

graphics.free()
game.quit()