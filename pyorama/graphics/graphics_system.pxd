from pyorama.core.slot_manager cimport *
from pyorama.data.int_hash_map cimport *
from pyorama.data.vector cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *

from pyorama.graphics.camera cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.graphics_events cimport *
from pyorama.graphics.image cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.light cimport *
from pyorama.graphics.mesh cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.sprite cimport *
from pyorama.graphics.sprite_batch cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.transform cimport *
from pyorama.graphics.uniform cimport *
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
    GRAPHICS_SLOT_MESH
    GRAPHICS_SLOT_IMAGE
    GRAPHICS_SLOT_TEXTURE
    GRAPHICS_SLOT_UNIFORM
    GRAPHICS_SLOT_LIGHT
    GRAPHICS_SLOT_TRANSFORM
    GRAPHICS_SLOT_SPRITE
    GRAPHICS_SLOT_SPRITE_BATCH
    GRAPHICS_SLOT_CAMERA

cpdef enum WindowEventType:
    WINDOW_EVENT_TYPE_SHOWN = SDL_WINDOWEVENT_SHOWN
    WINDOW_EVENT_TYPE_HIDDEN = SDL_WINDOWEVENT_HIDDEN
    WINDOW_EVENT_TYPE_EXPOSED = SDL_WINDOWEVENT_EXPOSED
    WINDOW_EVENT_TYPE_MOVED = SDL_WINDOWEVENT_MOVED
    WINDOW_EVENT_TYPE_RESIZED = SDL_WINDOWEVENT_RESIZED
    WINDOW_EVENT_TYPE_SIZE_CHANGED = SDL_WINDOWEVENT_SIZE_CHANGED
    WINDOW_EVENT_TYPE_MINIMIZED = SDL_WINDOWEVENT_MINIMIZED
    WINDOW_EVENT_TYPE_MAXIMIZED = SDL_WINDOWEVENT_MAXIMIZED
    WINDOW_EVENT_TYPE_RESTORED = SDL_WINDOWEVENT_RESTORED
    WINDOW_EVENT_TYPE_ENTER = SDL_WINDOWEVENT_ENTER
    WINDOW_EVENT_TYPE_LEAVE = SDL_WINDOWEVENT_LEAVE
    WINDOW_EVENT_TYPE_FOCUS_GAINED = SDL_WINDOWEVENT_FOCUS_GAINED
    WINDOW_EVENT_TYPE_FOUCS_LOST = SDL_WINDOWEVENT_FOCUS_LOST
    WINDOW_EVENT_TYPE_CLOSE = SDL_WINDOWEVENT_CLOSE
    WINDOW_EVENT_TYPE_TAKE_FOCUS = SDL_WINDOWEVENT_TAKE_FOCUS
    WINDOW_EVENT_TYPE_HIT_TEST = SDL_WINDOWEVENT_HIT_TEST

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
        IntHashMapC window_ids
        bint right_handed
        bint homogeneous_depth

    cdef void c_init_sdl2(self) except *
    cdef void c_quit_sdl2(self) except *
    cdef void c_init_bgfx(self) except *
    cdef void c_quit_bgfx(self) except *
    cdef uint16_t c_get_next_view_index(self) except *