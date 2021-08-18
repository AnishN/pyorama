from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *
import pyorama
from pyorama.app cimport graphics

cdef:
    uint16_t width = 800
    uint16_t height = 600
    char *title = "Hello, world!"
    SDL_Window *window
    bgfx_frame_buffer_handle_t frame_buffer
    SDL_Event event
    bint running = True

pyorama.app.init()

#init my actual app
window = SDL_CreateWindow(
    title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
    width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
)
frame_buffer = bgfx_create_frame_buffer_from_nwh(
    bgfx_get_window_nwh(graphics.wmi, window),
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

pyorama.app.quit()