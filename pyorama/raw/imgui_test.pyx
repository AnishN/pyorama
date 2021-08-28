from pyorama.libs.c cimport *
from pyorama.libs.cimgui cimport *
from pyorama.libs.bgfx cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.math cimport *
from pyorama.data.handle cimport *
import pyorama
from pyorama.app cimport *
import math

"""
ctypedef struct Vertex:
    float x
    float y
    float z
    uint32_t abgr

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = event["window"]
        pyorama.app.trigger_quit()

def on_enter_frame_event(event, *args, **kwargs):
    global counter
    cdef:
        Handle on_window_listener
        Handle on_enter_frame_listener
        bint running = True

    Vec3.set_data(
        eye, 
        c_math.sin(<float>counter/100)*8, 
        2,
        c_math.cos(<float>counter/100)*8,
    )
    Mat4.look_at(view_mat, eye, at, up)
    Mat4.perspective(proj_mat, math.radians(60.0), <float>width / <float>height,  0.01, 1000.0)
    Mat4.identity(mtx)
    Mat4.from_rotation_x(mtx_x, counter * 0.007)
    Mat4.from_rotation_y(mtx_y, counter * 0.01)
    Mat4.dot(mtx, mtx_x, mtx_y)

    pyorama.graphics.view_set_clear(view, VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH, 0x443355FF, 1.0, 0)
    pyorama.graphics.view_set_rect(view, 0, 0, width, height)
    pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
    pyorama.graphics.view_set_transform(view, view_mat, proj_mat)
    bgfx_set_vertex_buffer(0, vbh, 0, 8)
    bgfx_set_index_buffer(ibh, 0, 12*3)

    bgfx_set_transform(&mtx.data, 1)

    bgfx_submit(0, program, 0, BGFX_DISCARD_ALL)

    Mat4.from_translation(mtx, shift)
    bgfx_set_transform(&mtx.data, 1)
    bgfx_set_vertex_buffer(0, vbh, 0, 8)
    bgfx_set_index_buffer(ibh, 0, 12*3)
    bgfx_submit(0, program, 0, BGFX_DISCARD_ALL)
    bgfx_touch(0)

    counter += 1

def runtime_compile_shaders():
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./resources/shaders/vs_cubes.sc",
        out_file_path=b"./resources/shaders/vs_cubes.glsl",
        shader_type=pyorama.graphics.SHADER_TYPE_VERTEX,
    )
    pyorama.graphics.utils_runtime_compile_shader(
        in_file_path=b"./resources/shaders/fs_cubes.sc",
        out_file_path=b"./resources/shaders/fs_cubes.glsl",
        shader_type=pyorama.graphics.SHADER_TYPE_FRAGMENT,
    )

def load_shader(bytes file_path):
    cdef:
        object in_file
        bytes file_data
        size_t file_size
        bgfx_memory_t *file_memory
        bgfx_shader_handle_t shader

    in_file = open(file_path, "rb")
    file_data = in_file.read()
    in_file.close()
    file_size = <size_t>len(file_data)
    file_memory = bgfx_copy(<char *>file_data, file_size)
    shader = bgfx_create_shader(file_memory)
    return shader

cdef:
    Vertex cube_vertices[8]
    uint16_t cube_indices[36]
    uint16_t width = 800
    uint16_t height = 600
    char *title = b"Hello, world!"
    Handle window
    Handle frame_buffer
    Handle view
    bgfx_init_t init
    bgfx_vertex_layout_t layout
    bgfx_memory_t *vbm
    bgfx_vertex_buffer_handle_t vbh
    bgfx_memory_t *ibm
    bgfx_index_buffer_handle_t ibh
    bgfx_shader_handle_t vsh
    bgfx_shader_handle_t fsh
    bgfx_program_handle_t program
    uint32_t counter = 0

    Vec3 at = Vec3(0.0, 0.0, 0.0)
    Vec3 eye = Vec3()
    Vec3 up = Vec3(0.0, 1.0, 0.0)
    Vec3 shift = Vec3(3.0, 0.0, 0.0)
    Mat4 view_mat = Mat4()
    Mat4 proj_mat = Mat4()
    Mat4 mtx = Mat4()
    Mat4 mtx_x = Mat4()
    Mat4 mtx_y = Mat4()

cube_vertices = [
    [-1.0,  1.0,  1.0, 0xff888888],
    [ 1.0,  1.0,  1.0, 0xff8888ff],
    [-1.0, -1.0,  1.0, 0xff88ff88],
    [ 1.0, -1.0,  1.0, 0xff88ffff],
    [-1.0,  1.0, -1.0, 0xffff8888],
    [ 1.0,  1.0, -1.0, 0xffff88ff],
    [-1.0, -1.0, -1.0, 0xffffff88],
    [ 1.0, -1.0, -1.0, 0xffffffff],
]

cube_indices = [
    2, 1, 0,
    2, 3, 1,
    5, 6, 4,
    7, 6, 5,
    4, 2, 0,
    6, 2, 4,
    3, 5, 1,
    3, 7, 5,
    1, 4, 0,
    1, 5, 4,
    6, 3, 2,
    7, 3, 6,
]

pyorama.app.init({
    #"use_sleep": True,
    "use_sleep": False,
})

bgfx_vertex_layout_begin(&layout, bgfx_get_renderer_type())
bgfx_vertex_layout_add(&layout, BGFX_ATTRIB_POSITION, 3, BGFX_ATTRIB_TYPE_FLOAT, False, False)
bgfx_vertex_layout_add(&layout, BGFX_ATTRIB_COLOR0, 4, BGFX_ATTRIB_TYPE_UINT8, True, False)
bgfx_vertex_layout_end(&layout)

vbm = bgfx_copy(cube_vertices, sizeof(Vertex) * 8)
vbh = bgfx_create_vertex_buffer(vbm, &layout, BGFX_BUFFER_NONE)

ibm = bgfx_copy(cube_indices, sizeof(uint16_t) * 12 * 3)
ibh = bgfx_create_index_buffer(ibm, BGFX_BUFFER_NONE)

runtime_compile_shaders()
vsh = load_shader(b"./resources/shaders/vs_cubes.glsl")
fsh = load_shader(b"./resources/shaders/fs_cubes.glsl")
program = bgfx_create_program(vsh, fsh, False)

#window = SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE)
window = pyorama.graphics.window_create(width, height, title)
frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
view = pyorama.graphics.view_create()

#print("loop time!")

on_window_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_WINDOW, 
    on_window_event, None, None,
)

on_enter_frame_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_ENTER_FRAME, 
    on_enter_frame_event, None, None,
)

pyorama.app.run()

bgfx_destroy_shader(vsh)
bgfx_destroy_shader(fsh)
bgfx_destroy_program(program)
bgfx_destroy_index_buffer(ibh)
bgfx_destroy_vertex_buffer(vbh)

pyorama.graphics.view_delete(view)
pyorama.graphics.frame_buffer_delete(frame_buffer)
pyorama.graphics.window_delete(window)

pyorama.app.quit()
"""

print(igGetVersion())

"""
/*
 * Copyright 2014-2015 Daniel Collin. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

#include <bgfx/bgfx.h>
#include <bgfx/embedded_shader.h>
#include <bx/allocator.h>
#include <bx/math.h>
#include <bx/timer.h>
#include <dear-imgui/imgui.h>
#include <dear-imgui/imgui_internal.h>

#include "imgui.h"
#include "../bgfx_utils.h"

//#define USE_ENTRY 1

#ifndef USE_ENTRY
#	define USE_ENTRY 0
#endif // USE_ENTRY

#if USE_ENTRY
#	include "../entry/entry.h"
#	include "../entry/input.h"
#endif // USE_ENTRY

#include "vs_ocornut_imgui.bin.h"
#include "fs_ocornut_imgui.bin.h"
#include "vs_imgui_image.bin.h"
#include "fs_imgui_image.bin.h"

#include "roboto_regular.ttf.h"
#include "robotomono_regular.ttf.h"
#include "icons_kenney.ttf.h"
#include "icons_font_awesome.ttf.h"

static const bgfx::EmbeddedShader s_embeddedShaders[] =
{
	BGFX_EMBEDDED_SHADER(vs_ocornut_imgui),
	BGFX_EMBEDDED_SHADER(fs_ocornut_imgui),
	BGFX_EMBEDDED_SHADER(vs_imgui_image),
	BGFX_EMBEDDED_SHADER(fs_imgui_image),

	BGFX_EMBEDDED_SHADER_END()
};

struct FontRangeMerge
{
	const void* data;
	size_t      size;
	ImWchar     ranges[3];
};

static FontRangeMerge s_fontRangeMerge[] =
{
	{ s_iconsKenneyTtf,      sizeof(s_iconsKenneyTtf),      { ICON_MIN_KI, ICON_MAX_KI, 0 } },
	{ s_iconsFontAwesomeTtf, sizeof(s_iconsFontAwesomeTtf), { ICON_MIN_FA, ICON_MAX_FA, 0 } },
};

static void* memAlloc(size_t _size, void* _userData);
static void memFree(void* _ptr, void* _userData);

struct OcornutImguiContext
{
	void render(ImDrawData* _drawData)
	{
		// Avoid rendering when minimized, scale coordinates for retina displays (screen coordinates != framebuffer coordinates)
		int fb_width = (int)(_drawData->DisplaySize.x * _drawData->FramebufferScale.x);
		int fb_height = (int)(_drawData->DisplaySize.y * _drawData->FramebufferScale.y);
		if (fb_width <= 0 || fb_height <= 0)
			return;

		bgfx::setViewName(m_viewId, "ImGui");
		bgfx::setViewMode(m_viewId, bgfx::ViewMode::Sequential);

		const bgfx::Caps* caps = bgfx::getCaps();
		{
			float ortho[16];
			float x = _drawData->DisplayPos.x;
			float y = _drawData->DisplayPos.y;
			float width = _drawData->DisplaySize.x;
			float height = _drawData->DisplaySize.y;

			bx::mtxOrtho(ortho, x, x + width, y + height, y, 0.0f, 1000.0f, 0.0f, caps->homogeneousDepth);
			bgfx::setViewTransform(m_viewId, NULL, ortho);
			bgfx::setViewRect(m_viewId, 0, 0, uint16_t(width), uint16_t(height) );
		}

		const ImVec2 clipPos   = _drawData->DisplayPos;       // (0,0) unless using multi-viewports
		const ImVec2 clipScale = _drawData->FramebufferScale; // (1,1) unless using retina display which are often (2,2)

		// Render command lists
		for (int32_t ii = 0, num = _drawData->CmdListsCount; ii < num; ++ii)
		{
			bgfx::TransientVertexBuffer tvb;
			bgfx::TransientIndexBuffer tib;

			const ImDrawList* drawList = _drawData->CmdLists[ii];
			uint32_t numVertices = (uint32_t)drawList->VtxBuffer.size();
			uint32_t numIndices  = (uint32_t)drawList->IdxBuffer.size();

			if (!checkAvailTransientBuffers(numVertices, m_layout, numIndices) )
			{
				// not enough space in transient buffer just quit drawing the rest...
				break;
			}

			bgfx::allocTransientVertexBuffer(&tvb, numVertices, m_layout);
			bgfx::allocTransientIndexBuffer(&tib, numIndices, sizeof(ImDrawIdx) == 4);

			ImDrawVert* verts = (ImDrawVert*)tvb.data;
			bx::memCopy(verts, drawList->VtxBuffer.begin(), numVertices * sizeof(ImDrawVert) );

			ImDrawIdx* indices = (ImDrawIdx*)tib.data;
			bx::memCopy(indices, drawList->IdxBuffer.begin(), numIndices * sizeof(ImDrawIdx) );

			bgfx::Encoder* encoder = bgfx::begin();

			uint32_t offset = 0;
			for (const ImDrawCmd* cmd = drawList->CmdBuffer.begin(), *cmdEnd = drawList->CmdBuffer.end(); cmd != cmdEnd; ++cmd)
			{
				if (cmd->UserCallback)
				{
					cmd->UserCallback(drawList, cmd);
				}
				else if (0 != cmd->ElemCount)
				{
					uint64_t state = 0
						| BGFX_STATE_WRITE_RGB
						| BGFX_STATE_WRITE_A
						| BGFX_STATE_MSAA
						;

					bgfx::TextureHandle th = m_texture;
					bgfx::ProgramHandle program = m_program;

					if (NULL != cmd->TextureId)
					{
						union { ImTextureID ptr; struct { bgfx::TextureHandle handle; uint8_t flags; uint8_t mip; } s; } texture = { cmd->TextureId };
						state |= 0 != (IMGUI_FLAGS_ALPHA_BLEND & texture.s.flags)
							? BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA, BGFX_STATE_BLEND_INV_SRC_ALPHA)
							: BGFX_STATE_NONE
							;
						th = texture.s.handle;
						if (0 != texture.s.mip)
						{
							const float lodEnabled[4] = { float(texture.s.mip), 1.0f, 0.0f, 0.0f };
							bgfx::setUniform(u_imageLodEnabled, lodEnabled);
							program = m_imageProgram;
						}
					}
					else
					{
						state |= BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA, BGFX_STATE_BLEND_INV_SRC_ALPHA);
					}

					// Project scissor/clipping rectangles into framebuffer space
					ImVec4 clipRect;
					clipRect.x = (cmd->ClipRect.x - clipPos.x) * clipScale.x;
					clipRect.y = (cmd->ClipRect.y - clipPos.y) * clipScale.y;
					clipRect.z = (cmd->ClipRect.z - clipPos.x) * clipScale.x;
					clipRect.w = (cmd->ClipRect.w - clipPos.y) * clipScale.y;

					if (clipRect.x <  fb_width
					&&  clipRect.y <  fb_height
					&&  clipRect.z >= 0.0f
					&&  clipRect.w >= 0.0f)
					{
						const uint16_t xx = uint16_t(bx::max(clipRect.x, 0.0f) );
						const uint16_t yy = uint16_t(bx::max(clipRect.y, 0.0f) );
						encoder->setScissor(xx, yy
								, uint16_t(bx::min(clipRect.z, 65535.0f)-xx)
								, uint16_t(bx::min(clipRect.w, 65535.0f)-yy)
								);

						encoder->setState(state);
						encoder->setTexture(0, s_tex, th);
						encoder->setVertexBuffer(0, &tvb, 0, numVertices);
						encoder->setIndexBuffer(&tib, offset, cmd->ElemCount);
						encoder->submit(m_viewId, program);
					}
				}

				offset += cmd->ElemCount;
			}

			bgfx::end(encoder);
		}
	}

	void create(float _fontSize, bx::AllocatorI* _allocator)
	{
		m_allocator = _allocator;

		if (NULL == _allocator)
		{
			static bx::DefaultAllocator allocator;
			m_allocator = &allocator;
		}

		m_viewId = 255;
		m_lastScroll = 0;
		m_last = bx::getHPCounter();

		ImGui::SetAllocatorFunctions(memAlloc, memFree, NULL);

		m_imgui = ImGui::CreateContext();

		ImGuiIO& io = ImGui::GetIO();

		io.DisplaySize = ImVec2(1280.0f, 720.0f);
		io.DeltaTime   = 1.0f / 60.0f;
		io.IniFilename = NULL;

		setupStyle(true);

#if USE_ENTRY
		io.KeyMap[ImGuiKey_Tab]        = (int)entry::Key::Tab;
		io.KeyMap[ImGuiKey_LeftArrow]  = (int)entry::Key::Left;
		io.KeyMap[ImGuiKey_RightArrow] = (int)entry::Key::Right;
		io.KeyMap[ImGuiKey_UpArrow]    = (int)entry::Key::Up;
		io.KeyMap[ImGuiKey_DownArrow]  = (int)entry::Key::Down;
		io.KeyMap[ImGuiKey_PageUp]     = (int)entry::Key::PageUp;
		io.KeyMap[ImGuiKey_PageDown]   = (int)entry::Key::PageDown;
		io.KeyMap[ImGuiKey_Home]       = (int)entry::Key::Home;
		io.KeyMap[ImGuiKey_End]        = (int)entry::Key::End;
		io.KeyMap[ImGuiKey_Insert]     = (int)entry::Key::Insert;
		io.KeyMap[ImGuiKey_Delete]     = (int)entry::Key::Delete;
		io.KeyMap[ImGuiKey_Backspace]  = (int)entry::Key::Backspace;
		io.KeyMap[ImGuiKey_Space]      = (int)entry::Key::Space;
		io.KeyMap[ImGuiKey_Enter]      = (int)entry::Key::Return;
		io.KeyMap[ImGuiKey_Escape]     = (int)entry::Key::Esc;
		io.KeyMap[ImGuiKey_A]          = (int)entry::Key::KeyA;
		io.KeyMap[ImGuiKey_C]          = (int)entry::Key::KeyC;
		io.KeyMap[ImGuiKey_V]          = (int)entry::Key::KeyV;
		io.KeyMap[ImGuiKey_X]          = (int)entry::Key::KeyX;
		io.KeyMap[ImGuiKey_Y]          = (int)entry::Key::KeyY;
		io.KeyMap[ImGuiKey_Z]          = (int)entry::Key::KeyZ;

		io.ConfigFlags |= 0
			| ImGuiConfigFlags_NavEnableGamepad
			| ImGuiConfigFlags_NavEnableKeyboard
			;

		io.NavInputs[ImGuiNavInput_Activate]    = (int)entry::Key::GamepadA;
		io.NavInputs[ImGuiNavInput_Cancel]      = (int)entry::Key::GamepadB;
//		io.NavInputs[ImGuiNavInput_Input]       = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_Menu]        = (int)entry::Key::;
		io.NavInputs[ImGuiNavInput_DpadLeft]    = (int)entry::Key::GamepadLeft;
		io.NavInputs[ImGuiNavInput_DpadRight]   = (int)entry::Key::GamepadRight;
		io.NavInputs[ImGuiNavInput_DpadUp]      = (int)entry::Key::GamepadUp;
		io.NavInputs[ImGuiNavInput_DpadDown]    = (int)entry::Key::GamepadDown;
//		io.NavInputs[ImGuiNavInput_LStickLeft]  = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_LStickRight] = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_LStickUp]    = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_LStickDown]  = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_FocusPrev]   = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_FocusNext]   = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_TweakSlow]   = (int)entry::Key::;
//		io.NavInputs[ImGuiNavInput_TweakFast]   = (int)entry::Key::;
#endif // USE_ENTRY

		bgfx::RendererType::Enum type = bgfx::getRendererType();
		m_program = bgfx::createProgram(
			  bgfx::createEmbeddedShader(s_embeddedShaders, type, "vs_ocornut_imgui")
			, bgfx::createEmbeddedShader(s_embeddedShaders, type, "fs_ocornut_imgui")
			, true
			);

		u_imageLodEnabled = bgfx::createUniform("u_imageLodEnabled", bgfx::UniformType::Vec4);
		m_imageProgram = bgfx::createProgram(
			  bgfx::createEmbeddedShader(s_embeddedShaders, type, "vs_imgui_image")
			, bgfx::createEmbeddedShader(s_embeddedShaders, type, "fs_imgui_image")
			, true
			);

		m_layout
			.begin()
			.add(bgfx::Attrib::Position,  2, bgfx::AttribType::Float)
			.add(bgfx::Attrib::TexCoord0, 2, bgfx::AttribType::Float)
			.add(bgfx::Attrib::Color0,    4, bgfx::AttribType::Uint8, true)
			.end();

		s_tex = bgfx::createUniform("s_tex", bgfx::UniformType::Sampler);

		uint8_t* data;
		int32_t width;
		int32_t height;
		{
			ImFontConfig config;
			config.FontDataOwnedByAtlas = false;
			config.MergeMode = false;
//			config.MergeGlyphCenterV = true;

			const ImWchar* ranges = io.Fonts->GetGlyphRangesCyrillic();
			m_font[ImGui::Font::Regular] = io.Fonts->AddFontFromMemoryTTF( (void*)s_robotoRegularTtf,     sizeof(s_robotoRegularTtf),     _fontSize,      &config, ranges);
			m_font[ImGui::Font::Mono   ] = io.Fonts->AddFontFromMemoryTTF( (void*)s_robotoMonoRegularTtf, sizeof(s_robotoMonoRegularTtf), _fontSize-3.0f, &config, ranges);

			config.MergeMode = true;
			config.DstFont   = m_font[ImGui::Font::Regular];

			for (uint32_t ii = 0; ii < BX_COUNTOF(s_fontRangeMerge); ++ii)
			{
				const FontRangeMerge& frm = s_fontRangeMerge[ii];

				io.Fonts->AddFontFromMemoryTTF( (void*)frm.data
						, (int)frm.size
						, _fontSize-3.0f
						, &config
						, frm.ranges
						);
			}
		}

		io.Fonts->GetTexDataAsRGBA32(&data, &width, &height);

		m_texture = bgfx::createTexture2D(
			  (uint16_t)width
			, (uint16_t)height
			, false
			, 1
			, bgfx::TextureFormat::BGRA8
			, 0
			, bgfx::copy(data, width*height*4)
			);

		ImGui::InitDockContext();
	}

	void destroy()
	{
		ImGui::ShutdownDockContext();
		ImGui::DestroyContext(m_imgui);

		bgfx::destroy(s_tex);
		bgfx::destroy(m_texture);

		bgfx::destroy(u_imageLodEnabled);
		bgfx::destroy(m_imageProgram);
		bgfx::destroy(m_program);

		m_allocator = NULL;
	}

	void setupStyle(bool _dark)
	{
		// Doug Binks' darl color scheme
		// https://gist.github.com/dougbinks/8089b4bbaccaaf6fa204236978d165a9
		ImGuiStyle& style = ImGui::GetStyle();
		if (_dark)
		{
			ImGui::StyleColorsDark(&style);
		}
		else
		{
			ImGui::StyleColorsLight(&style);
		}

		style.FrameRounding    = 4.0f;
		style.WindowBorderSize = 0.0f;
	}

	void beginFrame(
		  int32_t _mx
		, int32_t _my
		, uint8_t _button
		, int32_t _scroll
		, int _width
		, int _height
		, int _inputChar
		, bgfx::ViewId _viewId
		)
	{
		m_viewId = _viewId;

		ImGuiIO& io = ImGui::GetIO();
		if (_inputChar >= 0)
		{
			io.AddInputCharacter(_inputChar);
		}

		io.DisplaySize = ImVec2( (float)_width, (float)_height);

		const int64_t now = bx::getHPCounter();
		const int64_t frameTime = now - m_last;
		m_last = now;
		const double freq = double(bx::getHPFrequency() );
		io.DeltaTime = float(frameTime/freq);

		io.MousePos = ImVec2( (float)_mx, (float)_my);
		io.MouseDown[0] = 0 != (_button & IMGUI_MBUT_LEFT);
		io.MouseDown[1] = 0 != (_button & IMGUI_MBUT_RIGHT);
		io.MouseDown[2] = 0 != (_button & IMGUI_MBUT_MIDDLE);
		io.MouseWheel = (float)(_scroll - m_lastScroll);
		m_lastScroll = _scroll;

#if USE_ENTRY
		uint8_t modifiers = inputGetModifiersState();
		io.KeyShift = 0 != (modifiers & (entry::Modifier::LeftShift | entry::Modifier::RightShift) );
		io.KeyCtrl  = 0 != (modifiers & (entry::Modifier::LeftCtrl  | entry::Modifier::RightCtrl ) );
		io.KeyAlt   = 0 != (modifiers & (entry::Modifier::LeftAlt   | entry::Modifier::RightAlt  ) );
		for (int32_t ii = 0; ii < (int32_t)entry::Key::Count; ++ii)
		{
			io.KeysDown[ii] = inputGetKeyState(entry::Key::Enum(ii) );
		}
#endif // USE_ENTRY

		ImGui::NewFrame();

		ImGuizmo::BeginFrame();
	}

	void endFrame()
	{
		ImGui::Render();
		render(ImGui::GetDrawData() );
	}

	ImGuiContext*       m_imgui;
	bx::AllocatorI*     m_allocator;
	bgfx::VertexLayout  m_layout;
	bgfx::ProgramHandle m_program;
	bgfx::ProgramHandle m_imageProgram;
	bgfx::TextureHandle m_texture;
	bgfx::UniformHandle s_tex;
	bgfx::UniformHandle u_imageLodEnabled;
	ImFont* m_font[ImGui::Font::Count];
	int64_t m_last;
	int32_t m_lastScroll;
	bgfx::ViewId m_viewId;
};

static OcornutImguiContext s_ctx;

static void* memAlloc(size_t _size, void* _userData)
{
	BX_UNUSED(_userData);
	return BX_ALLOC(s_ctx.m_allocator, _size);
}

static void memFree(void* _ptr, void* _userData)
{
	BX_UNUSED(_userData);
	BX_FREE(s_ctx.m_allocator, _ptr);
}

void imguiCreate(float _fontSize, bx::AllocatorI* _allocator)
{
	s_ctx.create(_fontSize, _allocator);
}

void imguiDestroy()
{
	s_ctx.destroy();
}

void imguiBeginFrame(int32_t _mx, int32_t _my, uint8_t _button, int32_t _scroll, uint16_t _width, uint16_t _height, int _inputChar, bgfx::ViewId _viewId)
{
	s_ctx.beginFrame(_mx, _my, _button, _scroll, _width, _height, _inputChar, _viewId);
}

void imguiEndFrame()
{
	s_ctx.endFrame();
}

namespace ImGui
{
	void PushFont(Font::Enum _font)
	{
		PushFont(s_ctx.m_font[_font]);
	}

	void PushEnabled(bool _enabled)
	{
		extern void PushItemFlag(int option, bool enabled);
		PushItemFlag(ImGuiItemFlags_Disabled, !_enabled);
		PushStyleVar(ImGuiStyleVar_Alpha, ImGui::GetStyle().Alpha * (_enabled ? 1.0f : 0.5f) );
	}

	void PopEnabled()
	{
		extern void PopItemFlag();
		PopItemFlag();
		PopStyleVar();
	}

} // namespace ImGui

BX_PRAGMA_DIAGNOSTIC_IGNORED_MSVC(4505); // error C4505: '' : unreferenced local function has been removed
BX_PRAGMA_DIAGNOSTIC_IGNORED_CLANG_GCC("-Wunused-function"); // warning: 'int rect_width_compare(const void*, const void*)' defined but not used
BX_PRAGMA_DIAGNOSTIC_PUSH();
BX_PRAGMA_DIAGNOSTIC_IGNORED_CLANG("-Wunknown-pragmas")
BX_PRAGMA_DIAGNOSTIC_IGNORED_CLANG_GCC("-Wtype-limits"); // warning: comparison is always true due to limited range of data type
#define STBTT_malloc(_size, _userData) memAlloc(_size, _userData)
#define STBTT_free(_ptr, _userData) memFree(_ptr, _userData)
#define STB_RECT_PACK_IMPLEMENTATION
#include <stb/stb_rect_pack.h>
#define STB_TRUETYPE_IMPLEMENTATION
#include <stb/stb_truetype.h>
BX_PRAGMA_DIAGNOSTIC_POP();
"""