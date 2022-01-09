"""
from pyorama.app cimport *
from pyorama.asset.shader_loader cimport *
from pyorama.data.buffer cimport *
from pyorama.data.handle cimport *
from pyorama.graphics.image cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.cimgui cimport *
from pyorama.libs.sdl2 cimport *

cdef class DebugUISystem:
    cdef:
        str name
        ImGuiContext *context
        ImGuiIO *io

        ImGuiStyle *style
        ImFontConfig *font_config
        ImFontAtlas *font_atlas
        Handle window, frame_buffer, view
        Handle vertex_shader, fragment_shader, program
        Handle font_image, font_texture, font_sampler
        BufferFormat vertex_buffer_format
        BufferFormat index_buffer_format
        Buffer vertex_buffer_data
        Buffer index_buffer_data
        Handle vertex_layout, vertex_buffer, index_buffer
        IndexLayout index_layout
"""