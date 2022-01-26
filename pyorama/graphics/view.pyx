cdef class View(HandleObject):
    
    cdef ViewC *get_ptr(self) except *:
        return <ViewC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create():
        cdef:
            View view

        view = View.__new__(View)
        view.create()
        return view

    cpdef void create(self) except *:
        cdef:
            ViewC *view_ptr
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_VIEW)
        view_ptr = self.get_ptr()
        view_ptr.index = graphics.c_get_next_view_index()
        view_ptr.msaa = True
        view_ptr.blend = False
        view_ptr.write_state = VIEW_WRITE_STATE_RGBAZ
        view_ptr.depth_state = VIEW_DEPTH_STATE_LESS
        view_ptr.cull_state = VIEW_CULL_STATE_NONE
        view_ptr.blend_state = [
            VIEW_BLEND_FUNCTION_ONE,#rgb_src
            VIEW_BLEND_FUNCTION_ZERO,#rgb_dst
            VIEW_BLEND_EQUATION_ADD,#rgb_eq
            VIEW_BLEND_FUNCTION_ONE,#alpha_src
            VIEW_BLEND_FUNCTION_ZERO,#alpha_dst
            VIEW_BLEND_EQUATION_ADD,#alpha_eq
        ]

    cpdef void delete(self) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.index = 0
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void set_name(self, bytes name) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.name = name
        view_ptr.name_length = len(name)

    cpdef void set_mode(self, ViewMode mode) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.mode = mode

    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.rect.x = x
        view_ptr.rect.y = y
        view_ptr.rect.width = width
        view_ptr.rect.height = height

    cpdef void set_scissor(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.scissor.x = x
        view_ptr.scissor.y = y
        view_ptr.scissor.width = width
        view_ptr.scissor.height = height

    cpdef void set_clear(self, uint16_t flags, uint32_t color, float depth, uint8_t stencil) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.clear.flags = flags
        view_ptr.clear.color = color
        view_ptr.clear.depth = depth
        view_ptr.clear.stencil = stencil

    cpdef void set_transform_model(self, Mat4 transform_model) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.transform.model = transform_model.data

    cpdef void set_transform_view(self, Mat4 transform_view) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.transform.view = transform_view.data

    cpdef void set_transform_projection(self, Mat4 transform_projection) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.transform.projection = transform_projection.data

    cpdef void set_frame_buffer(self, FrameBuffer frame_buffer) except *:
        cdef:
            ViewC *view_ptr
            FrameBufferC *frame_buffer_ptr
        view_ptr = self.get_ptr()
        view_ptr.frame_buffer = frame_buffer.handle

    cpdef void set_vertex_buffer(self, VertexBuffer vertex_buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.vertex_buffer = vertex_buffer.handle

    cpdef void set_index_buffer(self, IndexBuffer index_buffer, int32_t offset=0, int32_t count=-1) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.index_buffer = index_buffer.handle
        #view_ptr.index_offset = offset
        if count == -1:
            count = index_buffer.get_num_indices()
        #view_ptr.index_count = count

    cpdef void set_program(self, Program program) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.program = program.handle

    cpdef void set_texture(self, Uniform sampler, Texture texture, uint8_t unit) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.samplers[unit] = sampler.handle
        view_ptr.textures[unit] = texture.handle

    cpdef void set_write_state(self, ViewWriteState state) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.write_state = state

    cpdef void set_depth_state(self, ViewDepthState state) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.depth_state = state

    cpdef void set_cull_state(self, ViewCullState state) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.cull_state = state

    cpdef void set_msaa(self, bint state) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.msaa = state

    cpdef void set_blend(self, bint state) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.blend = state

    cpdef void set_blend_rgb_state(self, ViewBlendFunction src, ViewBlendFunction dst, ViewBlendEquation eq=VIEW_BLEND_EQUATION_ADD) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.blend_state.rgb_src = src
        view_ptr.blend_state.rgb_dst = dst
        view_ptr.blend_state.rgb_eq = eq

    cpdef void set_blend_alpha_state(self, ViewBlendFunction src, ViewBlendFunction dst, ViewBlendEquation eq=VIEW_BLEND_EQUATION_ADD) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.blend_state.alpha_src = src
        view_ptr.blend_state.alpha_dst = dst
        view_ptr.blend_state.alpha_eq = eq

    cpdef void set_blend_rgba_state(self, ViewBlendFunction src, ViewBlendFunction dst, ViewBlendEquation eq=VIEW_BLEND_EQUATION_ADD) except *:
        cdef:
            ViewC *view_ptr
        
        view_ptr = self.get_ptr()
        view_ptr.blend_state.rgb_src = src
        view_ptr.blend_state.rgb_dst = dst
        view_ptr.blend_state.rgb_eq = eq
        view_ptr.blend_state.alpha_src = src
        view_ptr.blend_state.alpha_dst = dst
        view_ptr.blend_state.alpha_eq = eq

    cpdef void submit(self) except *:
        cdef:
            size_t i
            Handle texture
            Handle sampler
            TextureC *texture_ptr
            UniformC *sampler_ptr
            ViewC *view_ptr
            FrameBufferC *frame_buffer_ptr
            VertexBufferC *vertex_buffer_ptr
            IndexBufferC *index_buffer_ptr
            ProgramC *program_ptr
            cdef uint64_t state
            ViewBlendStateC blend_state
        
        view_ptr = self.get_ptr()
        frame_buffer_ptr = <FrameBufferC *>graphics.slots.c_get_ptr(view_ptr.frame_buffer)
        vertex_buffer_ptr = <VertexBufferC *>graphics.slots.c_get_ptr(view_ptr.vertex_buffer)
        index_buffer_ptr = <IndexBufferC *>graphics.slots.c_get_ptr(view_ptr.index_buffer)
        program_ptr = <ProgramC *>graphics.slots.c_get_ptr(view_ptr.program)

        if view_ptr.name_length != 0:
            bgfx_set_view_name(view_ptr.index, view_ptr.name)
        bgfx_set_view_mode(view_ptr.index, <bgfx_view_mode_t>view_ptr.mode)
        bgfx_set_view_rect(view_ptr.index, view_ptr.rect.x, view_ptr.rect.y, view_ptr.rect.width, view_ptr.rect.height)
        bgfx_set_view_scissor(view_ptr.index, view_ptr.scissor.x, view_ptr.scissor.y, view_ptr.scissor.width, view_ptr.scissor.height)
        bgfx_set_view_clear(view_ptr.index, view_ptr.clear.flags, view_ptr.clear.color, view_ptr.clear.depth, view_ptr.clear.stencil)
        bgfx_set_transform(&view_ptr.transform.model, 1)#TODO: support multiple model transforms!
        bgfx_set_view_transform(view_ptr.index, &view_ptr.transform.view, &view_ptr.transform.projection)
        bgfx_set_view_frame_buffer(view_ptr.index, frame_buffer_ptr.bgfx_id)
        
        if vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_STATIC:
            if vertex_buffer_ptr.resizable:
                raise ValueError("View: static vertex buffer cannot be resizable")
            else:
                bgfx_set_vertex_buffer(view_ptr.index, vertex_buffer_ptr.bgfx_id.static, 0, vertex_buffer_ptr.data.fixed.max_items)
        elif vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_DYNAMIC:
            if vertex_buffer_ptr.resizable:
                bgfx_set_dynamic_vertex_buffer(view_ptr.index, vertex_buffer_ptr.bgfx_id.dynamic, 0, vertex_buffer_ptr.data.resizable.num_items)
            else:
                bgfx_set_dynamic_vertex_buffer(view_ptr.index, vertex_buffer_ptr.bgfx_id.dynamic, 0, vertex_buffer_ptr.data.fixed.max_items)
        elif vertex_buffer_ptr.type_ == VERTEX_BUFFER_TYPE_TRANSIENT:
            raise NotImplementedError()
        
        if index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_STATIC:
            if index_buffer_ptr.resizable:
                raise ValueError("View: static index buffer cannot be resizable")
            else:
                bgfx_set_index_buffer(index_buffer_ptr.bgfx_id.static, 0, index_buffer_ptr.data.fixed.max_items)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_DYNAMIC:
            if index_buffer_ptr.resizable:
                bgfx_set_dynamic_index_buffer(index_buffer_ptr.bgfx_id.dynamic, 0, index_buffer_ptr.data.resizable.num_items)
            else:
                bgfx_set_dynamic_index_buffer(index_buffer_ptr.bgfx_id.dynamic, 0, index_buffer_ptr.data.fixed.max_items)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_TRANSIENT:
            raise NotImplementedError()

        for i in range(256):
            texture = view_ptr.textures[i]
            sampler = view_ptr.samplers[i]
            if texture != 0 and sampler != 0:
                texture_ptr = <TextureC *>graphics.slots.c_get_ptr(texture)
                sampler_ptr = <UniformC *>graphics.slots.c_get_ptr(sampler)
                bgfx_set_texture(i, sampler_ptr.bgfx_id, texture_ptr.bgfx_id, 0)

        """
        bgfx_dynamic_index_buffer_handle_t bgfx_create_dynamic_index_buffer(uint32_t _num, uint16_t _flags)
        bgfx_dynamic_index_buffer_handle_t bgfx_create_dynamic_index_buffer_mem(const bgfx_memory_t* _mem, uint16_t _flags)
        void bgfx_update_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _startIndex, const bgfx_memory_t* _mem)
        void bgfx_destroy_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle)
        bgfx_dynamic_vertex_buffer_handle_t bgfx_create_dynamic_vertex_buffer(uint32_t _num, const bgfx_vertex_layout_t* _layout, uint16_t _flags)
        bgfx_dynamic_vertex_buffer_handle_t bgfx_create_dynamic_vertex_buffer_mem(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t* _layout, uint16_t _flags)
        void bgfx_update_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, const bgfx_memory_t* _mem)
        void bgfx_destroy_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle)
        """

        state = 0
        state |= view_ptr.write_state
        state |= view_ptr.depth_state
        state |= view_ptr.cull_state
        state |= BGFX_STATE_MSAA if view_ptr.msaa else 0
        if view_ptr.blend:
            blend_state = view_ptr.blend_state
            state |= BGFX_STATE_BLEND_FUNC_SEPARATE(
                blend_state.rgb_src, 
                blend_state.rgb_dst, 
                blend_state.alpha_src, 
                blend_state.alpha_dst,
            )
            state |= BGFX_STATE_BLEND_EQUATION_SEPARATE(
                blend_state.rgb_eq, 
                blend_state.alpha_eq,
            )
        
        bgfx_set_state(state, 0)
        bgfx_submit(view_ptr.index, program_ptr.bgfx_id, 0, BGFX_DISCARD_BINDINGS | BGFX_DISCARD_ALL)

    cpdef void touch(self) except *:
        cdef:
            ViewC *view_ptr
            FrameBufferC *frame_buffer_ptr
        
        view_ptr = self.get_ptr()
        if view_ptr.name_length != 0:
            bgfx_set_view_name(view_ptr.index, view_ptr.name)
        if view_ptr.frame_buffer != 0:
            frame_buffer_ptr = <FrameBufferC *>graphics.slots.c_get_ptr(view_ptr.frame_buffer)
            bgfx_set_view_frame_buffer(view_ptr.index, frame_buffer_ptr.bgfx_id)
        bgfx_set_view_rect(view_ptr.index, view_ptr.rect.x, view_ptr.rect.y, view_ptr.rect.width, view_ptr.rect.height)
        bgfx_set_view_clear(view_ptr.index, view_ptr.clear.flags, view_ptr.clear.color, view_ptr.clear.depth, view_ptr.clear.stencil)
        bgfx_touch(view_ptr.index)