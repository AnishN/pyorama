from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.cimgui cimport *
from pyorama.libs.sdl2 cimport *

from pyorama.asset.shader_loader cimport *

cdef void ImGui_Implbgfx_Init(uint8_t view)
cdef void ImGui_Implbgfx_Shutdown()
cdef void ImGui_Implbgfx_NewFrame()
cdef void ImGui_Implbgfx_RenderDrawLists(ImDrawData *draw_data)
cdef bint ImGui_Implbgfx_CreateDeviceObjects()
cdef void ImGui_Implbgfx_InvalidateDeviceObjects()