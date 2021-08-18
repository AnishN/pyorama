from pyorama.core.slot_manager cimport *
from pyorama.data.hash_map cimport *
from pyorama.data.vector cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *

from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.vertex_layout cimport *
from pyorama.graphics.view cimport *
from pyorama.graphics.window cimport *

DEF GRAPHICS_MAX_VIEWS = 2**16

cpdef enum GraphicsRendererType:
    GRAPHICS_RENDERER_TYPE_NONE = BGFX_RENDERER_TYPE_NOOP
    GRAPHICS_RENDERER_TYPE_DIRECT3D9 = BGFX_RENDERER_TYPE_DIRECT3D9
    GRAPHICS_RENDERER_TYPE_DIRECT3D11 = BGFX_RENDERER_TYPE_DIRECT3D11
    GRAPHICS_RENDERER_TYPE_DIRECT3D12 = BGFX_RENDERER_TYPE_DIRECT3D12
    GRAPHICS_RENDERER_TYPE_GNM = BGFX_RENDERER_TYPE_GNM
    GRAPHICS_RENDERER_TYPE_METAL = BGFX_RENDERER_TYPE_METAL
    GRAPHICS_RENDERER_TYPE_NVN = BGFX_RENDERER_TYPE_NVN
    GRAPHICS_RENDERER_TYPE_OPENGLES = BGFX_RENDERER_TYPE_OPENGLES
    GRAPHICS_RENDERER_TYPE_OPENGL = BGFX_RENDERER_TYPE_OPENGL
    GRAPHICS_RENDERER_TYPE_VULKAN = BGFX_RENDERER_TYPE_VULKAN
    GRAPHICS_RENDERER_TYPE_WEBGPU = BGFX_RENDERER_TYPE_WEBGPU
    GRAPHICS_RENDERER_TYPE_DEFAULT = BGFX_RENDERER_TYPE_COUNT

cpdef enum GraphicsSlot:
    GRAPHICS_SLOT_WINDOW
    GRAPHICS_SLOT_FRAME_BUFFER
    GRAPHICS_SLOT_VIEW
    GRAPHICS_SLOT_SHADER
    GRAPHICS_SLOT_PROGRAM
    GRAPHICS_SLOT_VERTEX_LAYOUT
    GRAPHICS_SLOT_VERTEX_BUFFER
    GRAPHICS_SLOT_INDEX_BUFFER

cdef class GraphicsSystem:
    cdef:
        str name
        GraphicsRendererType renderer_type
        SlotManager slots
        dict slot_sizes
        SDL_SysWMinfo *wmi
        SDL_Window *root_window
        bgfx_platform_data_t pd
        bgfx_init_t bgfx_init
        bint[GRAPHICS_MAX_VIEWS] used_views
        uint16_t[GRAPHICS_MAX_VIEWS] free_views
        size_t free_view_index
        HashMap window_ids

    cdef void c_init_sdl2(self) except *
    cdef void c_quit_sdl2(self) except *
    cdef void c_init_bgfx(self) except *
    cdef void c_quit_bgfx(self) except *
    cdef uint16_t c_get_next_view_index(self) except *