from pyorama.libs.sdl2 cimport *
from pyorama.libs.bgfx cimport *

cdef extern from "test_header.h" nogil:
    bint bgfx_get_platform_data_from_window(SDL_Window* _window)

cdef:
    bint running = True
    SDL_Window *window
    SDL_Renderer *renderer
    SDL_Event event
    SDL_WindowEvent wev
    int counter = 0
    uint32_t width = 800
    uint32_t height = 620
    uint32_t debug = BGFX_DEBUG_TEXT
    uint32_t reset = BGFX_RESET_VSYNC
    bgfx_init_t init
    bgfx_encoder_t *encoder

SDL_Init(SDL_INIT_EVERYTHING)
IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0)
SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")
SDL_SetHint(SDL_HINT_VIDEO_EXTERNAL_CONTEXT, "1")
window = SDL_CreateWindow("Hello, world!", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_HIDDEN | SDL_WINDOW_RESIZABLE)

#SDL_SetWindowPosition(window, 0, 0);
bgfx_get_platform_data_from_window(window)
bgfx_init_ctor(&init)
bgfx_init(&init)

bgfx_reset(width, height, reset, init.resolution.format)
bgfx_set_debug(debug)
bgfx_set_view_clear(
    0,
    BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH,
    0x303030FF,
    1.0, 
    0,
)
bgfx_frame(False)
SDL_ShowWindow(window)

while running:
    while SDL_PollEvent(&event):
        if event.type == SDL_QUIT:
            running = False
        elif event.type == SDL_WINDOWEVENT:
            wev = event.window
            if wev.event == SDL_WINDOWEVENT_RESIZED:
                break
            elif wev.event == SDL_WINDOWEVENT_SIZE_CHANGED:
                break
            elif wev.event == SDL_WINDOWEVENT_CLOSE:
                running = False
                break
        break
    
    bgfx_set_view_rect(0, 0, 0, <uint16_t>width, <uint16_t>height)
    encoder = bgfx_encoder_begin(True)
    bgfx_encoder_touch(encoder, 0)
    bgfx_encoder_end(encoder)
    bgfx_dbg_text_clear(0, False)
    bgfx_dbg_text_printf(2, 1, 0x0f, "Hello, world!")
    bgfx_dbg_text_printf(2, 2, 0x0f, "This is an example window created with BGFX in pyorama.")
    bgfx_frame(False)

bgfx_shutdown()
SDL_DestroyWindow(window)
SDL_Quit()