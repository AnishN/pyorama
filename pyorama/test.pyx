from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.math cimport *
import pyorama

ctypedef struct Vertex:
    float x
    float y
    float z
    uint32_t abgr

def runtime_compile_shaders():
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./resources/shaders/vs_cubes.sc",
        out_file_path=b"./resources/shaders/vs_cubes.glsl",
        shader_type=pyorama.graphics.SHADER_TYPE_VERTEX,
    )
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./resources/shaders/fs_cubes.sc",
        out_file_path=b"./resources/shaders/fs_cubes.glsl",
        shader_type=pyorama.graphics.SHADER_TYPE_FRAGMENT,
    )

def load_shader(bytes file_path):
    cdef:
        object in_file
        bytes file_data
        size_t file_size
        bgfx_memory_t *file_memory
        bgfx_shader_handle_t shader
    
    in_file = open(file_path, "rb")
    file_data = in_file.read()
    in_file.close()
    file_size = <size_t>len(file_data)
    file_memory = bgfx_copy(<char *>file_data, file_size)
    shader = bgfx_create_shader(file_memory)
    return shader

def on_window_event(event, *args, **kwargs):
    global num_windows
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = event["window"]
        pyorama.graphics.window_delete(window)
        num_windows -= 1
        if num_windows == 0:
            pyorama.app.trigger_quit()

cdef:
    Vertex cube_vertices[8]
    uint16_t cube_indices[36]
    uint16_t width = 800
    uint16_t height = 600
    char *title = b"Hello, world!"
    SDL_SysWMinfo *wmi
    SDL_Window *window
    bgfx_frame_buffer_handle_t frame_buffer
    bgfx_init_t init
    bgfx_vertex_layout_t layout
    bgfx_memory_t *vbm
    bgfx_vertex_buffer_handle_t vbh
    bgfx_memory_t *ibm
    bgfx_index_buffer_handle_t ibh
    bgfx_shader_handle_t vsh
    bgfx_shader_handle_t fsh
    bgfx_program_handle_t program
    #bgfx_platform_data_t pd

cube_vertices = [
    [-1.0,  1.0,  1.0, 0xff888888],
    [ 1.0,  1.0,  1.0, 0xff8888ff],
    [-1.0, -1.0,  1.0, 0xff88ff88],
    [ 1.0, -1.0,  1.0, 0xff88ffff],
    [-1.0,  1.0, -1.0, 0xffff8888],
    [ 1.0,  1.0, -1.0, 0xffff88ff],
    [-1.0, -1.0, -1.0, 0xffffff88],
    [ 1.0, -1.0, -1.0, 0xffffffff],
]

cube_indices = [
    2, 1, 0,
    2, 3, 1,
    5, 6, 4,
    7, 6, 5,
    4, 2, 0,
    6, 2, 4,
    3, 5, 1,
    3, 7, 5,
    1, 4, 0,
    1, 5, 4,
    6, 3, 2,
    7, 3, 6,
]

SDL_InitSubSystem(SDL_INIT_VIDEO)
SDL_InitSubSystem(SDL_INIT_EVENTS)
SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")

wmi = bgfx_fetch_wmi()
bgfx_init_ctor(&init)
init.type = BGFX_RENDERER_TYPE_COUNT
init.resolution.reset = BGFX_RESET_VSYNC
bgfx_init(&init)

bgfx_vertex_layout_begin(&layout, bgfx_get_renderer_type())
bgfx_vertex_layout_add(&layout, BGFX_ATTRIB_POSITION, 3, BGFX_ATTRIB_TYPE_FLOAT, False, False)
bgfx_vertex_layout_add(&layout, BGFX_ATTRIB_COLOR0, 4, BGFX_ATTRIB_TYPE_UINT8, True, False)
bgfx_vertex_layout_end(&layout)

vbm = bgfx_copy(cube_vertices, sizeof(Vertex) * 8)
vbh = bgfx_create_vertex_buffer(vbm, &layout, BGFX_BUFFER_NONE)

ibm = bgfx_copy(cube_indices, sizeof(uint16_t) * 12 * 3)
ibh = bgfx_create_index_buffer(ibm, BGFX_BUFFER_NONE)

runtime_compile_shaders()
vsh = load_shader(b"./resources/shaders/vs_cubes.glsl")
fsh = load_shader(b"./resources/shaders/fs_cubes.glsl")
program = bgfx_create_program(vsh, fsh, False)

window = SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE)
frame_buffer = bgfx_create_frame_buffer_from_nwh(
    bgfx_get_window_nwh(wmi, window),
    width,
    height,
    BGFX_TEXTURE_FORMAT_BGRA8, 
    BGFX_TEXTURE_FORMAT_D24S8,
)
bgfx_set_view_clear(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH, 0x443355FF, 1.0, 0)
bgfx_set_view_rect(0, 0, 0, width, height)
bgfx_set_view_frame_buffer(0, frame_buffer)

cdef:
    uint32_t counter = 0
    SDL_Event event
    bint running = True
    Vec3 at = Vec3(0.0, 0.0, 0.0)
    Vec3 eye = Vec3()
    Vec3 up = Vec3(0.0, 1.0, 0.0)
    Vec3 shift = Vec3(3.0, 0.0, 0.0)
    Mat4 view = Mat4()
    Mat4 proj = Mat4()
    Mat4 mtx = Mat4()
    Mat4 mtx_x = Mat4()
    Mat4 mtx_y = Mat4()

import math

while running:
    while SDL_PollEvent(&event):
        if event.type == SDL_WINDOWEVENT:
            if event.window.event == SDL_WINDOWEVENT_CLOSE:
                    running = False

    Vec3.set_data(
        eye, 
        c_math.sin(<float>counter/100)*8, 
        2,
        c_math.cos(<float>counter/100)*8,
    )
    Mat4.look_at(view, eye, at, up)
    Mat4.perspective(proj, math.radians(60.0), <float>width / <float>height,  0.01, 1000.0)
    Mat4.identity(mtx)
    Mat4.from_rotation_x(mtx_x, counter * 0.007)
    Mat4.from_rotation_y(mtx_y, counter * 0.01)
    Mat4.dot(mtx, mtx_x, mtx_y)

    bgfx_set_view_rect(0, 0, 0, width, height)
    bgfx_set_view_transform(0, &view.data, &proj.data)
    bgfx_set_transform(&mtx.data, 1)
    bgfx_set_vertex_buffer(0, vbh, 0, 8)
    bgfx_set_index_buffer(ibh, 0, 12*3)
    bgfx_submit(0, program, 0, BGFX_DISCARD_ALL)

    Mat4.from_translation(mtx, shift)
    bgfx_set_transform(&mtx.data, 1)
    bgfx_set_vertex_buffer(0, vbh, 0, 8)
    bgfx_set_index_buffer(ibh, 0, 12*3)
    bgfx_submit(0, program, 0, BGFX_DISCARD_ALL)

    bgfx_touch(0)
    bgfx_frame(False)
    counter += 1

bgfx_destroy_shader(vsh)
bgfx_destroy_shader(fsh)
bgfx_destroy_program(program)
bgfx_destroy_index_buffer(ibh)
bgfx_destroy_vertex_buffer(vbh)
bgfx_destroy_frame_buffer(frame_buffer)

bgfx_shutdown()
SDL_DestroyWindow(window)
SDL_Quit()