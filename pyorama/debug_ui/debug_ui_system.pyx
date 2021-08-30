cdef class DebugUISystem:

    def __cinit__(self, str name):
        self.name = name

    def __dealloc__(self):
        self.name = None

    def init(self, dict config=None):
        cdef:
            bytes vs_src_path = b"./pyorama/resources/shaders/debug_ui/vs_debug_ui.sc"
            bytes fs_src_path = b"./pyorama/resources/shaders/debug_ui/fs_debug_ui.sc"
            bytes vs_bin_path = b"./pyorama/resources/shaders/bin/vs_imgui.sc_bin"
            bytes fs_bin_path = b"./pyorama/resources/shaders/bin/fs_imgui.sc_bin"
            bytes font_path = b"./pyorama/resources/fonts/"
            uint8_t *pixels
            uint8_t[::1] pixels_view
            int width = 1600
            int height = 900
            int f_width
            int f_height
            int bpp
            BufferFormat v_fmt, i_fmt
            Buffer v_data_buf, i_data_buf
            Handle v_layout

        self.window = window_create(width, height, b"GUI window")
        self.frame_buffer = frame_buffer_create_from_window(self.window)
        self.view = view_create()

        self.vertex_buffer_format = BufferFormat([
            (b"a_position", 2, BUFFER_FIELD_TYPE_F32),
            (b"a_texcoord0", 2, BUFFER_FIELD_TYPE_F32),
            (b"a_color0", 4, BUFFER_FIELD_TYPE_U8),
        ])
        self.vertex_buffer_data = Buffer(self.vertex_buffer_format)
        self.vertex_layout = vertex_layout_create(
            self.vertex_buffer_format, 
            normalize={b"a_color0",},
        )

        self.index_buffer_format = BufferFormat([
            (b"a_indices", 1, BUFFER_FIELD_TYPE_U16),
        ])
        self.index_buffer_data = Buffer(self.index_buffer_format)
        self.index_layout = INDEX_LAYOUT_U16

        utils_runtime_compile_shader(vs_src_path, vs_bin_path, SHADER_TYPE_VERTEX)
        utils_runtime_compile_shader(fs_src_path, fs_bin_path, SHADER_TYPE_FRAGMENT)
        self.vertex_shader = shader_create_from_file(SHADER_TYPE_VERTEX, vs_bin_path)
        self.fragment_shader = shader_create_from_file(SHADER_TYPE_FRAGMENT, fs_bin_path)
        self.program = program_create(self.vertex_shader, self.fragment_shader)

        self.context = igCreateContext(NULL)
        self.io = igGetIO()
        self.io.DisplaySize = [width, height]

        self.style = igGetStyle()
        igStyleColorsDark(self.style)
        self.font_atlas = self.io.Fonts
        ImFontAtlas_AddFontDefault(self.font_atlas, self.font_config)
        ImFontAtlas_GetTexDataAsRGBA32(
            self.font_atlas,
            &pixels,
            &f_width,
            &f_height,
            &bpp,
        )

        import numpy as np

        pixels_view = <uint8_t[:f_width * f_height * bpp]>pixels
        print(np.array(pixels_view), pixels_view.shape)
        #pixels_view = np.random.randint(256, size=pixels_view.shape[0], dtype=np.uint8)
        #print(np.array(pixels_view), pixels_view.shape)
        #for i in range(pixels_view.shape[0], 5):
        #    pixels_view[i] = 127
        self.font_image = image_create_from_data(pixels_view, f_width, f_height)
        self.font_texture = texture_create_2d_from_image(self.font_image)
        self.font_sampler = uniform_create(b"s_tex", UNIFORM_TYPE_SAMPLER)
        image_write_to_file(self.font_image, b"test.png", IMAGE_FILE_TYPE_PNG)
    
    def quit(self):
        program_delete(self.program)
        shader_delete(self.fragment_shader)
        shader_delete(self.vertex_shader)
        #igEndFrame()
        ImFontAtlas_destroy(self.font_atlas)
        ImFontConfig_destroy(self.font_config)
        igDestroyContext(self.context)

    def update(self):
        cdef:
            size_t i, j
            ImDrawData *draw_data
            ImVec2 clip_off
            ImVec2 clip_scale
            ImDrawList *draw_list
            ImDrawCmd *cmd
            bint is_open = False
            ImVec2 p = [100, 50]
            int width = 1600
            int height = 900
            Vec2C clip_min
            Vec2C clip_max
        
        igNewFrame()

        igShowDemoWindow(&is_open)
        #igSetNextWindowPos(ImVec2(0, 0), ImGuiCond_FirstUseEver, ImVec2(0, 0))
        #igSetNextWindowSize(ImVec2(200, 100), ImGuiCond_FirstUseEver)
        #igBegin(b"Hello, world!", &is_open, ImGuiWindowFlags_None)
        #igText(b"Hello from Dear ImGUI!")
        #igButton("Kill me!", p)
        #igEnd()

        igRender()
        draw_data = igGetDrawData()
        clip_off = draw_data.DisplayPos#TODO: assumes 1 window for now...
        clip_scale = draw_data.FramebufferScale#TODO: assumes no hidpi for now...

        """
        draw_info = [
            "Valid: {0}".format(draw_data.Valid),
            "Command List Count: {0}".format(draw_data.CmdListsCount),
            "Vertex Count: {0}".format(draw_data.TotalVtxCount),
            "Index Count: {0}".format(draw_data.TotalIdxCount),
            "Display Position: {0}".format(draw_data.DisplayPos),
            "Display Size: {0}".format(draw_data.DisplaySize),
            "FBO Scale: {0}".format(draw_data.FramebufferScale),
        ]
        print("DRAW DATA:")
        for line in draw_info:
            print(line)
        """

        #bgfx_set_state(

        clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
        view_set_mode(self.view, VIEW_MODE_SEQUENTIAL)
        view_set_clear(self.view, clear_flags, 0x443355FF, 1.0, 0)
        view_set_rect(self.view, 0, 0, width, height)
        view_set_texture(self.view, self.font_sampler, self.font_texture, 0)
        view_set_program(self.view, self.program)
        view_set_frame_buffer(self.view, self.frame_buffer)

        cdef:
            Mat4 model_mat = Mat4()
            Mat4 view_mat = Mat4()
            Mat4 proj_mat = Mat4()
            list vbos = []
            list ibos = []
            Handle curr_vbo
            Handle curr_ibo

        Mat4.ortho(proj_mat, 0, width, 0, height, 0, 1000)
        view_set_transform_model(self.view, model_mat)
        view_set_transform_view(self.view, view_mat)
        view_set_transform_projection(self.view, proj_mat)

        import time
        import numpy as np

        for i in range(draw_data.CmdListsCount):
            #print("Command List", i)
            draw_list = draw_data.CmdLists[i]
            self.vertex_buffer_data.c_init_from_ptr(<uint8_t *>draw_list.VtxBuffer.Data, draw_list.VtxBuffer.Size)
            self.index_buffer_data.c_init_from_ptr(<uint8_t *>draw_list.IdxBuffer.Data, draw_list.IdxBuffer.Size)
            curr_vbo = vertex_buffer_create(self.vertex_layout, self.vertex_buffer_data)
            curr_ibo = index_buffer_create(self.index_layout, self.index_buffer_data)
            vbos.append(curr_vbo)
            ibos.append(curr_ibo)
            view_set_vertex_buffer(self.view, curr_vbo)

            #for j in range(draw_list.CmdBuffer.Size - 1, -1, -1):
            for j in range(draw_list.CmdBuffer.Size):
                #print("Command", j)
                cmd = &draw_list.CmdBuffer.Data[j]
                view_set_scissor(
                    self.view, 
                    <uint16_t>(cmd.ClipRect.x - draw_data.DisplayPos.x),
                    <uint16_t>(cmd.ClipRect.y - draw_data.DisplayPos.y),
                    <uint16_t>(cmd.ClipRect.z - draw_data.DisplayPos.x),
                    <uint16_t>(cmd.ClipRect.w - draw_data.DisplayPos.y),
                )
                view_set_index_buffer(self.view, curr_ibo, offset=cmd.IdxOffset, count=cmd.ElemCount)
                view_submit(self.view)
                #v_cmd_data = np.array(self.vertex_buffer_data)[cmd.IdxOffset:cmd.IdxOffset + cmd.ElemCount]
                #i_cmd_data = np.array(self.index_buffer_data)[cmd.IdxOffset:cmd.IdxOffset + cmd.ElemCount]
                #print("Command Vertices", np.min(v_cmd_data[:, 0]), np.max(v_cmd_data[:, 0]), np.min(v_cmd_data[0, :]), np.max(v_cmd_data[0, :]))
                #print("Command Indices", i_cmd_data)
                #bgfx_frame(False)
                #time.sleep(2)
        bgfx_frame(False)
        #print("")
        igEndFrame()
        
        bgfx_frame(False)
        for vbo in vbos:
            vertex_buffer_delete(vbo)
        for ibo in ibos:
            index_buffer_delete(ibo)
        self.vertex_buffer_data.free()
        self.index_buffer_data.free()

"""

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
}
"""

"""
constexpr auto FPS_RATE = 120;
int windowHeight = 600, windowWidth = 1000, windowDepth = 600;

//for camera
struct MyPoint3f { float x; float y; float z; };
MyPoint3f lastMousePos = { };
bool mouseButtonWasPressed = false;
float mouseSensitivity = 0.00125f;
int camMoveSpeed = 1;
float camPitchAngle = 0, camYawAngle = 0;
float currentCamPitchAngle = 0, currentCamYawAngle = 0;
//Camera cam;

//OpenGL
int groundImageWidth = 0, groundImageHeight = 0;
unsigned char* groundImage = 0;
GLuint groundTexture = 0;

void init();
void displayFunction();
void idleFunction();
void reshapeFunction(int, int);
void keyboardFunction(unsigned char, int, int);
void specialKeysFunction(int, int, int);
void mouseFunc(int, int, int, int);
void motionFunction(int, int);
double getTime();

double getTime()
{
	using Duration = std::chrono::duration<double>;
	return std::chrono::duration_cast<Duration>(
		std::chrono::high_resolution_clock::now().time_since_epoch()
		).count();
}

const float frame_delay = 1.0f / FPS_RATE;
double last_render = 0;

static bool showWindow = true;

void displayFunction()
{
/*
	if (abs(currentCamPitchAngle + -(camPitchAngle * mouseSensitivity)) < 0.90)
		cam.ChangePitch(-(camPitchAngle * mouseSensitivity));
	cam.ChangeHeading((camYawAngle * mouseSensitivity));
	if (abs(currentCamPitchAngle + -(camPitchAngle * mouseSensitivity)) < 0.90)
		currentCamPitchAngle += -(camPitchAngle * mouseSensitivity);
	currentCamYawAngle += -(camYawAngle * mouseSensitivity);
	camPitchAngle = 0; camYawAngle = 0;
*/
	ImGui_ImplOpenGL2_NewFrame();
    ImGui_ImplGLUT_NewFrame();
	//draw window
	if (showWindow)
	{
		ImGui::Begin("Another Window", &showWindow);   // Pass a pointer to our bool variable (the window will have a closing button that will clear the bool when clicked)
		ImGui::Text("Hello from another window!");
		if (ImGui::Button("Close Me"))
			showWindow = false;
		ImGui::End();
	}

	//render
	ImGui::Render();
	ImGuiIO& io = ImGui::GetIO();
        glViewport(0, 0, (GLsizei)io.DisplaySize.x, (GLsizei)io.DisplaySize.y);

	//clear screen
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
/*
	//set camera
	glm::mat4 model, view, projection;
	cam.Update();
	cam.GetMatricies(projection, view, model);
	glm::mat4 mvp = projection * view * model;
	glLoadMatrixf(glm::value_ptr(mvp));
	glMatrixMode(GL_MODELVIEW);
*/
	//draw white polygon
	glBegin(GL_POLYGON);
	glVertex3i(-1, 0, 0);
	glVertex3i(0, 0, 0);
	glVertex3i(0, -1, 0);
	glVertex3i(-1, -1, 0);
	glEnd();

	ImGui_ImplOpenGL2_RenderDrawData(ImGui::GetDrawData());
	
	glutSwapBuffers();
    glutPostRedisplay();
}
void init()
{
/*
	//load texture image
	groundImage = SOIL_load_image("groundTexture.jpg", &groundImageWidth, &groundImageHeight, 0, SOIL_LOAD_RGB);
	if (!groundImage)
		MessageBox(NULL, L"Load image falded", L"Error", MB_OK);
	//generate 1 texture
	glGenTextures(1, &groundTexture);
*/
	//setting callback functions
	glutDisplayFunc(displayFunction);
	glutIdleFunc(idleFunction);
	glutReshapeFunc(reshapeFunction);
	glutKeyboardFunc(keyboardFunction);
	glutMouseFunc(mouseFunc);
	glutMotionFunc(motionFunction);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glClearColor(117.0f / 255.0f, 187.0f / 255.0f, 253.0f / 255.0f, 0.0f);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
/*
	//setting cam
	cam.SetPosition(glm::vec3(0.f, 100.f, 350.f));
	cam.SetLookAt(glm::vec3(0.f, 100.f, 349.f));
	cam.SetClipping(0.1f, 2000.f);
	cam.SetFOV(45);
*/
}


void idleFunction()
{
	const double current_time = getTime();
	if ((current_time - last_render) > frame_delay)
	{
		last_render = current_time;
		glutPostRedisplay();
	}
}

void reshapeFunction(int w, int h)
{
	//cam.SetViewport(0, 0, windowWidth, windowHeight);
}

void keyboardFunction(unsigned char key, int w, int h)
{
	switch (key)
	{
	case '+': case '=':
		break;
	case '-': case '_':
		break;
/*
	case 'w': case 'W':
		for (int z = 0; z < camMoveSpeed; ++z)
			cam.Move(FORWARD);
		break;
	case 'a': case 'A':
		for (int z = 0; z < camMoveSpeed; ++z)
			cam.Move(LEFT);
		break;
	case 's': case 'S':
		for (int z = 0; z < camMoveSpeed; ++z)
			cam.Move(BACK);
		break;
	case 'd': case 'D':
		for (int z = 0; z < camMoveSpeed; ++z)
			cam.Move(RIGHT);
		break;
	case 'q': case 'Q':
		for (int z = 0; z < camMoveSpeed; ++z)
			cam.Move(DOWN);
		break;
	case 'e': case 'E':
		for (int z = 0; z < camMoveSpeed; ++z)
			cam.Move(UP);
		break;
	case 27:
		currentCamPitchAngle = 0;
		currentCamYawAngle = 0;
		break;
*/
	default:
		cout << key << endl;
		break;
	}
}

void specialKeysFunction(int key, int x, int y)
{
	cout << key << endl;
}

void mouseFunc(int button, int state, int x, int y)
{
	if (button == GLUT_LEFT_BUTTON && state == GLUT_DOWN)
	{
		mouseButtonWasPressed = true;
		lastMousePos.x = (float)x;
		lastMousePos.y = (float)y;
	}
}

void motionFunction(int mousePosX, int mousePosY)
{
	if (mousePosX >= 0 && mousePosX < windowWidth && mousePosY >= 0 && mousePosY < windowHeight)
	{
		if (mouseButtonWasPressed)
		{
			camPitchAngle += -mousePosY + lastMousePos.y;
			camYawAngle += (float)mousePosX - lastMousePos.x;
			lastMousePos.x = (float)mousePosX;
			lastMousePos.y = (float)mousePosY;
		}
	}
}

int main(int argc, char* argv[])
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
	glutInitWindowSize(windowWidth, windowHeight);
	glutInitWindowPosition(0, 0);
	glutCreateWindow("Window");
	//glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_CONTINUE_EXECUTION);

	init();

	//imgui setup
	IMGUI_CHECKVERSION();
	ImGui::CreateContext();
	ImGuiIO& io = ImGui::GetIO(); (void)io;

	ImGui::StyleColorsDark();

	ImGui_ImplGLUT_Init();
	ImGui_ImplGLUT_InstallFuncs();
	ImGui_ImplOpenGL2_Init();
	
	glutMainLoop();

	ImGui_ImplOpenGL2_Shutdown();
	ImGui_ImplGLUT_Shutdown();
	ImGui::DestroyContext();

	return 0;
}
"""