"""
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.cimgui cimport *
from pyorama.libs.sdl2 cimport *

cdef bint ImGui_ImplSDL2_Init(SDL_Window *window)
cdef void ImGui_ImplSDL2_Shutdown()
cdef void ImGui_ImplSDL2_NewFrame(SDL_Window *window)
cdef bint ImGui_ImplSDL2_ProcessEvent(SDL_Event *event)
"""