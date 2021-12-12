from pyorama.math cimport *

cdef:
    bint initialized = False
    uint8_t g_View = 255
    bgfx_texture_handle_t g_FontTexture
    bgfx_program_handle_t g_ShaderHandle
    bgfx_uniform_handle_t g_AttribLocationTex
    bgfx_vertex_layout_t g_VertexLayout

cdef bgfx_shader_handle_t create_shader(bytes file_path):
    cdef bgfx_memory_t *file_memory
    in_file = open(file_path, "rb")
    file_data = in_file.read()
    in_file.close()
    file_size = <size_t>len(file_data)
    file_memory = bgfx_copy(<char *>file_data, file_size)
    return bgfx_create_shader(file_memory)

cdef void ImGui_Implbgfx_Init(uint8_t view):
    global g_view
    g_View = view & 0xff

cdef void ImGui_Implbgfx_Shutdown():
    ImGui_Implbgfx_InvalidateDeviceObjects()

cdef void ImGui_Implbgfx_NewFrame():
    global initialized
    if not initialized:
        ImGui_Implbgfx_CreateDeviceObjects()#if not created already!!!
        initialized = True

cdef void ImGui_Implbgfx_RenderDrawLists(ImDrawData *draw_data):
    cdef:
        ImGuiIO *io
        int fb_width, fb_height
        uint64_t state
        Mat4C ortho
        size_t n
        ImDrawList* cmd_list
        uint32_t idx_buffer_offset
        bgfx_transient_vertex_buffer_t tvb
        bgfx_transient_index_buffer_t tib
        uint32_t num_vertices
        uint32_t num_indices
        bint use_index_u32 = sizeof(ImDrawIdx) == 4
        ImDrawVert *verts
        ImDrawIdx *indices
        size_t cmd_i
        ImDrawCmd *cmd
        uint16_t xx, yy
        bgfx_texture_handle_t texture
    
    global initialized, g_View, g_FontTexture, g_ShaderHandle, g_AttribLocationTex, g_VertexLayout

    io = igGetIO()

    #check if minimized (aka zero size) and do hidpi scaling correction
    fb_width = <int>(io.DisplaySize.x * io.DisplayFramebufferScale.x)
    fb_height = <int>(io.DisplaySize.y * io.DisplayFramebufferScale.y)
    if fb_width == 0 or fb_height == 0:
        return
    ImDrawData_ScaleClipRects(draw_data, io.DisplayFramebufferScale)

    state = (
        BGFX_STATE_WRITE_RGB | 
        BGFX_STATE_WRITE_A | 
        BGFX_STATE_MSAA | 
        BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA, BGFX_STATE_BLEND_INV_SRC_ALPHA)
    )

    Mat4.c_ortho(&ortho, 0.0, io.DisplaySize.x, io.DisplaySize.y, 0.0, 0.0, 1000.0)
    bgfx_set_view_transform(g_View, NULL, <float *>&ortho)
    bgfx_set_view_rect(g_View, 0, 0, <uint16_t>fb_width, <uint16_t>fb_height)

    for n in range(draw_data.CmdListsCount):
        cmd_list = draw_data.CmdLists[n]
        idx_buffer_offset = 0
        num_vertices = <uint32_t>cmd_list.VtxBuffer.Size
        num_indices = <uint32_t>cmd_list.IdxBuffer.Size

        if (
            num_vertices != bgfx_get_avail_transient_vertex_buffer(num_vertices, &g_VertexLayout) or
            num_indices != bgfx_get_avail_transient_index_buffer(num_indices, use_index_u32)
        ):
            break
        
        bgfx_alloc_transient_vertex_buffer(&tvb, num_vertices, &g_VertexLayout)
        bgfx_alloc_transient_index_buffer(&tib, num_indices, use_index_u32)
        verts = <ImDrawVert *>tvb.data
        memcpy(verts, cmd_list.VtxBuffer.Data, num_vertices * sizeof(ImDrawVert))
        indices = <ImDrawIdx *>tib.data
        memcpy(indices, cmd_list.IdxBuffer.Data, num_indices * sizeof(ImDrawIdx))

        for cmd_i in range(cmd_list.CmdBuffer.Size):
            cmd = &cmd_list.CmdBuffer.Data[cmd_i]
            #skip cmd.UserCallback check
            xx = <uint16_t>max(cmd.ClipRect.x, 0.0)
            yy = <uint16_t>max(cmd.ClipRect.y, 0.0)
            bgfx_set_scissor(
                xx, 
                yy, 
                <uint16_t>min(cmd.ClipRect.z, 65535) - xx,
                <uint16_t>min(cmd.ClipRect.w, 65535) - yy,
            )
            bgfx_set_state(state, 0)
            texture.idx = <intptr_t>cmd.TextureId
            #texture = <bgfx_texture_handle_t>(<intptr_t>cmd.TextureId & 0xffff)
            bgfx_set_texture(0, g_AttribLocationTex, texture, 0)
            bgfx_set_transient_vertex_buffer(0, &tvb, 0, num_vertices)
            bgfx_set_transient_index_buffer(&tib, idx_buffer_offset, cmd.ElemCount)
            bgfx_submit(g_View, g_ShaderHandle, 0, BGFX_DISCARD_ALL)
            idx_buffer_offset += cmd.ElemCount

cdef bint ImGui_Implbgfx_CreateDeviceObjects():
    cdef:
        bgfx_renderer_type_t type_
        bytes vs_src_path = b"./pyorama/resources/shaders/debug_ui/vs_debug_ui.sc"
        bytes fs_src_path = b"./pyorama/resources/shaders/debug_ui/fs_debug_ui.sc"
        bytes vs_bin_path = b"./pyorama/resources/shaders/bin/vs_debug_ui.bin"
        bytes fs_bin_path = b"./pyorama/resources/shaders/bin/fs_debug_ui.bin"
        bgfx_shader_handle_t vs
        bgfx_shader_handle_t fs

        ImGuiIO *io
        uint8_t *pixels
        int width, height, bpp
    
    global initialized, g_View, g_FontTexture, g_ShaderHandle, g_AttribLocationTex, g_VertexLayout

    #create program
    type_ = bgfx_get_renderer_type()
    utils_runtime_compile_shader(vs_src_path, vs_bin_path, SHADER_TYPE_VERTEX)
    utils_runtime_compile_shader(fs_src_path, fs_bin_path, SHADER_TYPE_FRAGMENT)
    vs = create_shader(vs_bin_path)
    fs = create_shader(fs_bin_path)
    g_ShaderHandle = bgfx_create_program(vs, fs, True)
    
    #create vertex layout
    bgfx_vertex_layout_begin(&g_VertexLayout, bgfx_get_renderer_type())
    bgfx_vertex_layout_add(&g_VertexLayout, BGFX_ATTRIB_POSITION, 2, BGFX_ATTRIB_TYPE_FLOAT, False, False)
    bgfx_vertex_layout_add(&g_VertexLayout, BGFX_ATTRIB_TEXCOORD0, 2, BGFX_ATTRIB_TYPE_FLOAT, False, False)
    bgfx_vertex_layout_add(&g_VertexLayout, BGFX_ATTRIB_COLOR0, 4, BGFX_ATTRIB_TYPE_UINT8, True, False)
    bgfx_vertex_layout_end(&g_VertexLayout)

    #create sampler uniform
    bgfx_create_uniform(b"g_AttribLocationTex", BGFX_UNIFORM_TYPE_SAMPLER, 1)

    #create texture
    io = igGetIO()
    ImFontAtlas_AddFontDefault(io.Fonts, NULL)
    ImFontAtlas_GetTexDataAsRGBA32(
        io.Fonts,
        &pixels,
        &width,
        &height,
        &bpp,
    )
    g_FontTexture = bgfx_create_texture_2d(
        <uint16_t>width,
        <uint16_t>height,
        False,
        1,
        BGFX_TEXTURE_FORMAT_BGRA8,
        0, 
        bgfx_copy(pixels, width * height * bpp),
    )
    io.Fonts.TexID = <void *><intptr_t>g_FontTexture.idx

    return True

cdef void ImGui_Implbgfx_InvalidateDeviceObjects():
    bgfx_destroy_uniform(g_AttribLocationTex)
    bgfx_destroy_program(g_ShaderHandle)
    bgfx_destroy_texture(g_FontTexture)
    igGetIO().Fonts.TexID = <ImTextureID>0