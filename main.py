import sys
import numpy as np
from pyorama.core.app import App
from pyorama.graphics import *

class Game(App):

    def init(self):
        super().init()
        self.graphics = GraphicsManager()
        self.v_fmt = self.graphics.vertex_format_create([
            (ATTRIBUTE_POSITION, VERTEX_COMP_TYPE_F32, 3, False),#vertices
            (ATTRIBUTE_TEX_COORD_0, VERTEX_COMP_TYPE_F32, 2, False),#tex_coords
        ])
        self.v_data = np.array([
            -1.0, -1.0, 0.0, 0.0, 0.0,
             0.0, 1.0, 0.0, 0.5, 1.0, 
             1.0, -1.0, 0.0, 1.0, 0.0,
            ], dtype=np.float32,
        )
        self.vbo = self.graphics.vertex_buffer_create(self.v_fmt, BUFFER_USAGE_STATIC)
        self.graphics.vertex_buffer_set_data(self.vbo, self.v_data.view(np.uint8))
        self.i_data = np.array([0, 1, 2], dtype=np.int32)
        self.ibo = self.graphics.index_buffer_create(INDEX_FORMAT_U32, BUFFER_USAGE_STATIC)
        self.graphics.index_buffer_set_data(self.ibo, self.i_data.view(np.uint8))
        out = self.i_data.view(np.uint8)
        vs_path = b"./resources/shaders/basic.vert"
        self.vs = self.graphics.shader_create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/basic.frag"
        self.fs = self.graphics.shader_create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = self.graphics.program_create(self.vs, self.fs)
        image_path = b"./resources/textures/test.png"
        self.image = self.graphics.image_create_from_file(image_path)
        self.texture = self.graphics.texture_create()
        self.graphics.texture_set_image(self.texture, self.image)
    
    def quit(self):
        self.graphics.vertex_format_delete(self.v_fmt)
        self.graphics.vertex_buffer_delete(self.vbo)
        self.graphics.index_buffer_delete(self.ibo)
        self.graphics.shader_delete(self.vs)
        self.graphics.shader_delete(self.fs)
        self.graphics.program_delete(self.program)
        super().quit()
    
    def update(self, delta):
        print(delta)
        self.graphics.update()

if __name__ == "__main__":
    game = Game()
    game.run()

"""
def program_compile(self, Handle program):
    cdef:
        int max_u_name_length
        int u_name_length
        int u_size
        size_t i
        GLenum u_type
        char *u_name
        UniformC *info
        dict uniform_map

    #Setup uniform dict mapping
    uniform_map = {}
    glGetProgramiv(program_ptr.id, GL_ACTIVE_UNIFORMS, <int *>&program_ptr.num_uniforms)
    glGetProgramiv(program_ptr.id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &max_u_name_length)
    #print("max_len", max_u_name_length)
    if program_ptr.num_uniforms > 16:
        raise ValueError("Program: > 16 uniforms is not supported")
    for i in range(program_ptr.num_uniforms):
        u_name = <char *>calloc(max_u_name_length, sizeof(char))
        if u_name == NULL:
            raise MemoryError("Program: cannot allocate uniform name")
        glGetActiveUniform(program_ptr.id, i, max_u_name_length, &u_name_length, &u_size, &u_type, u_name);
        info = &program_ptr.uniform_info[i]
        info.index = glGetUniformLocation(program_ptr.id, u_name)
        info.type = <MathType>u_type
        info.size = u_size
        uniform_map[u_name] = i
    program_ptr.uniform_map = <PyObject *>uniform_map
    Py_XINCREF(program_ptr.uniform_map)#TODO: need decompile decref equivalent

def program_set_uniform(self, Handle program, bytes name, value):
    cdef:
        ProgramC *program_ptr
        size_t i
        UniformC *info
        uint32_t type
    
    program_ptr = <ProgramC *>self.programs.c_get_ptr(program)
    i = (<dict>program_ptr.uniform_map)[name]
    info = &program_ptr.uniform_info[i]
    if info.type == MATH_TYPE_FLOAT:
        glUniform1f(info.index, <float>value)
    elif info.type == MATH_TYPE_VEC2:
        glUniform2fv(info.index, 1, <float *>(<Vec2>value).ptr)
    elif info.type == MATH_TYPE_VEC3:
        glUniform3fv(info.index, 1, <float *>(<Vec3>value).ptr)
    elif info.type == MATH_TYPE_VEC4:
        glUniform4fv(info.index, 1, <float *>(<Vec4>value).ptr)
    elif info.type == MATH_TYPE_MAT2:
        glUniformMatrix2fv(info.index, 1, False, <float *>(<Mat2>value).ptr)
    elif info.type == MATH_TYPE_MAT3:
        glUniformMatrix3fv(info.index, 1, False, <float *>(<Mat3>value).ptr)
    elif info.type == MATH_TYPE_MAT4:
        glUniformMatrix4fv(info.index, 1, False, <float *>(<Mat4>value).ptr)
"""