from pyorama.core.app import *
from pyorama.graphics import *
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4
import time
import numpy as np

def setup_program(graphics):
    vs_source = b"""
    #version 330 core
    layout (location = 0) in vec3 vertices;
    layout (location = 1) in vec3 colors;
    out vec3 out_colors;
    uniform mat4 model_view;
    void main()
    {
        gl_Position = model_view * vec4(vertices, 1.0);
        out_colors = colors;
    }
    """
    vs = graphics.shader_create()
    graphics.shader_init(vs, SHADER_TYPE_VERTEX, vs_source)
    graphics.shader_compile(vs)

    fs_source = b"""
    #version 330 core
    in vec3 out_colors;
    out vec4 frag_color;
    uniform vec4 base_color;
    void main()
    {
        frag_color = vec4(out_colors, 1.0) + base_color;
    }
    """
    fs = graphics.shader_create()
    graphics.shader_init(fs, SHADER_TYPE_FRAGMENT, fs_source)
    graphics.shader_compile(fs)

    program = graphics.program_create()
    graphics.program_init(program, vs, fs)
    graphics.program_compile(program)
    return vs, fs, program

def cleanup_program(graphics, vs, fs, program):
    graphics.program_free(program)
    graphics.program_delete(program)
    graphics.shader_free(vs)
    graphics.shader_delete(vs)
    graphics.shader_free(fs)
    graphics.shader_delete(fs)

def setup_batch(graphics):
    #Mesh Setup
    mesh_format = graphics.mesh_format_create()
    graphics.mesh_format_init(mesh_format, [
        (0, b"vertices", MATH_TYPE_VEC3), 
        (1, b"tex_coords", MATH_TYPE_VEC3),
    ])

    mesh = graphics.mesh_create()
    graphics.mesh_init(mesh, mesh_format)
    mesh_data = np.array([
        #triangle 1
        -1, -1, 0, 0, 1, 0,
        1, 1, 0, 1, 0, 1,
        1, -1, 0, 1, 1, 1,
        #triangle 2
        -1, -1, 0, 0, 1, 1,
        1, 1, 0, 1, 0, 0, 
        -1, 1, 0, 1, 1, 1,
    ], dtype=np.float32)
    graphics.mesh_set_data(mesh, mesh_data)
    batch = graphics.mesh_batch_create()
    meshes = np.array([mesh], dtype=np.uint64)
    graphics.mesh_batch_init(batch, mesh_format, meshes)
    return meshes, mesh_format, batch

def cleanup_batch(graphics, meshes, mesh_format, batch):
    graphics.mesh_batch_free(batch)
    graphics.mesh_batch_delete(batch)
    graphics.mesh_format_free(mesh_format)
    graphics.mesh_format_delete(mesh_format)
    for mesh in meshes:
        graphics.mesh_free(mesh)
        graphics.mesh_delete(mesh)

if __name__ == "__main__":
    app = App()
    app.init()
    graphics = GraphicsManager()
    width = 800
    height = 600
    title = b"Test"
    window = graphics.window_create()
    graphics.window_init(window, width, height, title)

    """
    #Texture Setup
    image = graphics.image_create()
    graphics.image_init_from_file(image, b"./resources/images/science.jpg")
    image_width = graphics.image_get_width(image)
    image_height = graphics.image_get_height(image)
    sampler = graphics.sampler_create()
    texture = graphics.texture_create()
    graphics.sampler_init(sampler)
    graphics.texture_init(texture, sampler, image)
    graphics.texture_bind(texture, upload_sampler=True, upload_image=True)
    graphics.texture_unbind()
    """

    model_view = Mat4()
    Mat4.translate(model_view, model_view, Vec3(0, 0, 0))
    meshes, mesh_format, batch = setup_batch(graphics)
    vs, fs, program = setup_program(graphics)

    base_color = Vec4(0.5, 0.0, 0.0, 1.0)

    while True:
        start = time.time()
        graphics.window_bind(window)
        graphics.window_clear()
        graphics.program_bind(program)
        graphics.program_set_uniform(program, b"model_view", model_view)
        #graphics.program_set_uniform(program, b"base_color", base_color)
        graphics.mesh_batch_render(batch)
        graphics.program_unbind()
        graphics.window_swap_buffers(window)
        graphics.window_unbind()
        end = time.time()
        #print(end - start)
        #break

    cleanup_program(graphics, vs, fs, program)
    cleanup_batch(graphics, meshes, mesh_format, batch)
    """
    graphics.image_free(image)
    graphics.sampler_free(sampler)
    graphics.texture_free(texture)
    graphics.window_free(window)
    graphics.image_delete(image)
    graphics.sampler_delete(sampler)
    graphics.texture_delete(texture)
    graphics.window_delete(window)
    """