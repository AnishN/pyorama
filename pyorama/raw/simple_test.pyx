from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *

cdef void c_init_sdl2():
    global wmi
    global root_window
    SDL_InitSubSystem(SDL_INIT_VIDEO)
    SDL_InitSubSystem(SDL_INIT_EVENTS)
    wmi = bgfx_fetch_wmi()
    root_window = SDL_CreateWindow(
        b"", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
        width, height, SDL_WINDOW_HIDDEN | SDL_WINDOW_RESIZABLE,
    )

cdef void c_quit_sdl2():
    SDL_DestroyWindow(root_window)
    free(wmi)
    SDL_QuitSubSystem(SDL_INIT_EVENTS)
    SDL_QuitSubSystem(SDL_INIT_VIDEO)

cdef void c_init_bgfx():
    global init
    bgfx_get_platform_data_from_window(&pd, wmi, root_window)
    bgfx_set_platform_data(&pd)
    bgfx_init_ctor(&init)
    init.type = BGFX_RENDERER_TYPE_COUNT
    init.resolution.reset = BGFX_RESET_VSYNC
    bgfx_init(&init)

cdef void c_quit_bgfx():
    bgfx_shutdown()

cdef:
    uint16_t width = 800
    uint16_t height = 600
    char *title = "Hello, world!"
    SDL_SysWMinfo *wmi
    SDL_Window *root_window 
    bgfx_platform_data_t pd
    bgfx_init_t init
    SDL_Window *window
    bgfx_frame_buffer_handle_t frame_buffer
    SDL_Event event
    bint running = True

c_init_sdl2()
c_init_bgfx()

#init my actual app
window = SDL_CreateWindow(
    title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
    width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
)
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

while running:
    bgfx_touch(0)
    bgfx_frame(False)
    
    while SDL_PollEvent(&event):
        if event.type == SDL_WINDOWEVENT:
            if event.window.event == SDL_WINDOWEVENT_CLOSE:
                running = False

bgfx_destroy_frame_buffer(frame_buffer)
SDL_DestroyWindow(window)

c_quit_bgfx()
c_quit_sdl2()