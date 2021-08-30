from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.cimgui cimport *
from pyorama.libs.sdl2 cimport *

cdef bint ImGui_ImplSDL2_InitForOpenGL(SDL_Window *window, void *sdl_gl_context)
cdef bint ImGui_ImplSDL2_InitForVulkan(SDL_Window *window)
cdef bint ImGui_ImplSDL2_InitForD3D(SDL_Window *window)
cdef bint ImGui_ImplSDL2_InitForMetal(SDL_Window *window)
cdef void ImGui_ImplSDL2_Shutdown()
cdef void ImGui_ImplSDL2_NewFrame(SDL_Window *window)
cdef bint ImGui_ImplSDL2_ProcessEvent(SDL_Event *event)