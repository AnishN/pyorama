"""
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.libs.cimgui cimport *
from pyorama.debug_ui.cimgui_bgfx_backend cimport *
from pyorama.debug_ui.cimgui_sdl2_backend cimport *

cdef:
    uint16_t width = 1600
    uint16_t height = 900
    char *title = "Hello, world!"
    SDL_SysWMinfo *wmi
    SDL_Window *window
    bgfx_init_t init
    SDL_Event event
    bint running = True
    bgfx_platform_data_t pd

SDL_InitSubSystem(SDL_INIT_VIDEO)
SDL_InitSubSystem(SDL_INIT_EVENTS)
SDL_InitSubSystem(SDL_INIT_GAMECONTROLLER)
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0)
SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")

wmi = bgfx_fetch_wmi()
window = SDL_CreateWindow(
    title, 
    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
    width, height, 
    SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
)
bgfx_get_platform_data_from_window(&pd, wmi, window)
bgfx_set_platform_data(&pd)
bgfx_init_ctor(&init)
init.type = BGFX_RENDERER_TYPE_COUNT
#init.type = BGFX_RENDERER_TYPE_VULKAN
init.resolution.width = width
init.resolution.height = height
init.resolution.reset = BGFX_RESET_VSYNC
bgfx_init(&init)

bgfx_set_view_clear(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH, 0x443355FF, 1.0, 0)
bgfx_set_view_rect(0, 0, 0, width, height)

cdef:
    ImGuiContext *context
    ImGuiIO *io

context = igCreateContext(NULL)
io = igGetIO()
io.DisplaySize = [width, height]
ImGui_Implbgfx_Init(255)
ImGui_ImplSDL2_Init(window)

while running:
    
    while SDL_PollEvent(&event):
        ImGui_ImplSDL2_ProcessEvent(&event)
        if event.type == SDL_WINDOWEVENT:
            if event.window.event == SDL_WINDOWEVENT_CLOSE:
                running = False

    ImGui_Implbgfx_NewFrame()
    ImGui_ImplSDL2_NewFrame(window)

    igNewFrame()
    #igShowDemoWindow(&running)
    igBegin(b"Hello, World!", &running, 0)
    igEnd()

    igRender()
    ImGui_Implbgfx_RenderDrawLists(igGetDrawData())
    bgfx_touch(0)

    bgfx_frame(False)

bgfx_shutdown()
SDL_DestroyWindow(window)
SDL_Quit()
"""