cdef ViewC *view_get_ptr(Handle view) except *:
    return <ViewC *>graphics.slots.c_get_ptr(view)

cpdef Handle view_create() except *:
    cdef:
        Handle view
        ViewC *view_ptr
    view = graphics.slots.c_create(GRAPHICS_SLOT_VIEW)
    view_ptr = view_get_ptr(view)
    view_ptr.index = graphics.c_get_next_view_index()
    return view

cpdef void view_delete(Handle view) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.index = 0
    graphics.slots.c_delete(view)

cpdef void view_set_name(Handle view, bytes name) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.name = name
    view_ptr.name_length = len(name)

cpdef void view_set_mode(Handle view, ViewMode mode) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.mode = mode

cpdef void view_set_rect(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.rect.x = x
    view_ptr.rect.y = y
    view_ptr.rect.width = width
    view_ptr.rect.height = height

cpdef void view_set_scissor(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.scissor.x = x
    view_ptr.scissor.y = y
    view_ptr.scissor.width = width
    view_ptr.scissor.height = height

cpdef void view_set_clear(Handle view, uint16_t flags, uint32_t color, float depth, uint8_t stencil) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.clear.flags = flags
    view_ptr.clear.color = color
    view_ptr.clear.depth = depth
    view_ptr.clear.stencil = stencil

cpdef void view_set_transform_model(Handle view, Mat4 transform_model) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.transform.model = transform_model.data[0]

cpdef void view_set_transform_view(Handle view, Mat4 transform_view) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.transform.view = transform_view.data[0]

cpdef void view_set_transform_projection(Handle view, Mat4 transform_projection) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.transform.projection = transform_projection.data[0]

cpdef void view_set_frame_buffer(Handle view, Handle frame_buffer) except *:
    cdef:
        ViewC *view_ptr
        FrameBufferC *frame_buffer_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.frame_buffer = frame_buffer

cpdef void view_set_vertex_buffer(Handle view, Handle vertex_buffer) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.vertex_buffer = vertex_buffer

cpdef void view_set_index_buffer(Handle view, Handle index_buffer, int32_t offset=0, int32_t count=-1) except *:
    cdef:
        ViewC *view_ptr
        IndexBufferC *index_buffer_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.index_buffer = index_buffer
    view_ptr.index_offset = offset
    if count == -1:
        index_buffer_ptr = index_buffer_get_ptr(index_buffer)
        count = index_buffer_ptr.num_indices
    view_ptr.index_count = count

cpdef void view_set_program(Handle view, Handle program) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.program = program

cpdef void view_set_texture(Handle view, Handle sampler, Handle texture, uint8_t unit) except *:
    cdef:
        ViewC *view_ptr
    view_ptr = view_get_ptr(view)
    view_ptr.samplers[unit] = sampler
    view_ptr.textures[unit] = texture

cpdef void view_submit(Handle view) except *:
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
    
    view_ptr = view_get_ptr(view)
    frame_buffer_ptr = frame_buffer_get_ptr(view_ptr.frame_buffer)
    vertex_buffer_ptr = vertex_buffer_get_ptr(view_ptr.vertex_buffer)
    index_buffer_ptr = index_buffer_get_ptr(view_ptr.index_buffer)
    program_ptr = program_get_ptr(view_ptr.program)

    if view_ptr.name_length != 0:
        bgfx_set_view_name(view_ptr.index, view_ptr.name)
    bgfx_set_view_mode(view_ptr.index, <bgfx_view_mode_t>view_ptr.mode)
    bgfx_set_view_rect(view_ptr.index, view_ptr.rect.x, view_ptr.rect.y, view_ptr.rect.width, view_ptr.rect.height)
    bgfx_set_view_scissor(view_ptr.index, view_ptr.scissor.x, view_ptr.scissor.y, view_ptr.scissor.width, view_ptr.scissor.height)
    bgfx_set_view_clear(view_ptr.index, view_ptr.clear.flags, view_ptr.clear.color, view_ptr.clear.depth, view_ptr.clear.stencil)
    bgfx_set_transform(&view_ptr.transform.model, 1)#TODO: support multiple model transforms!
    bgfx_set_view_transform(view_ptr.index, &view_ptr.transform.view, &view_ptr.transform.projection)
    bgfx_set_view_frame_buffer(view_ptr.index, frame_buffer_ptr.bgfx_id)
    bgfx_set_vertex_buffer(view_ptr.index, vertex_buffer_ptr.bgfx_id, 0, vertex_buffer_ptr.num_vertices)
    bgfx_set_index_buffer(index_buffer_ptr.bgfx_id, view_ptr.index_offset, view_ptr.index_count)#0, index_buffer_ptr.num_indices)
    for i in range(256):
        texture = view_ptr.textures[i]
        sampler = view_ptr.samplers[i]
        if texture != 0 and sampler != 0:
            texture_ptr = texture_get_ptr(texture)
            sampler_ptr = uniform_get_ptr(sampler)
            bgfx_set_texture(i, sampler_ptr.bgfx_id, texture_ptr.bgfx_id, 0)
    bgfx_submit(view_ptr.index, program_ptr.bgfx_id, 0, BGFX_DISCARD_BINDINGS | BGFX_DISCARD_ALL)

cpdef void view_touch(Handle view) except *:
    cdef:
        ViewC *view_ptr
        FrameBufferC *frame_buffer_ptr
    
    view_ptr = view_get_ptr(view)
    if view_ptr.name_length != 0:
        bgfx_set_view_name(view_ptr.index, view_ptr.name)
    if view_ptr.frame_buffer != 0:
        frame_buffer_ptr = frame_buffer_get_ptr(view_ptr.frame_buffer)
        bgfx_set_view_frame_buffer(view_ptr.index, frame_buffer_ptr.bgfx_id)
    bgfx_set_view_rect(view_ptr.index, view_ptr.rect.x, view_ptr.rect.y, view_ptr.rect.width, view_ptr.rect.height)
    bgfx_set_view_clear(view_ptr.index, view_ptr.clear.flags, view_ptr.clear.color, view_ptr.clear.depth, view_ptr.clear.stencil)
    bgfx_touch(view_ptr.index)