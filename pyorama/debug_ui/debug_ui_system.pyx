"""
cdef class DebugUISystem:

    def __cinit__(self, str name):
        self.name = name

    def __dealloc__(self):
        self.name = None

    def init(self, dict config=None):
        cdef:
            bytes vs_src_path = b"./pyorama/resources/shaders/debug_ui/vs_debug_ui.sc"
            bytes fs_src_path = b"./pyorama/resources/shaders/debug_ui/fs_debug_ui.sc"
            bytes vs_bin_path = b"./pyorama/resources/shaders/bin/vs_imgui.bin"
            bytes fs_bin_path = b"./pyorama/resources/shaders/bin/fs_imgui.bin"
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