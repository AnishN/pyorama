ctypedef ViewC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef uint32_t c_clear_flags_to_gl(uint32_t flags) nogil:
    cdef uint32_t gl_flags = 0
    if flags & VIEW_CLEAR_COLOR:
        gl_flags |= GL_COLOR_BUFFER_BIT
    if flags & VIEW_CLEAR_DEPTH:
        gl_flags |= GL_DEPTH_BUFFER_BIT
    if flags & VIEW_CLEAR_STENCIL:
        gl_flags |= GL_STENCIL_BUFFER_BIT
    return gl_flags

cdef uint32_t c_blend_func_to_gl(BlendFunc func) nogil:
    if func == BLEND_FUNC_ZERO:
        return GL_ZERO 
    elif func == BLEND_FUNC_ONE:
        return GL_ONE
    elif func == BLEND_FUNC_SRC_COLOR:
        return GL_SRC_COLOR
    elif func == BLEND_FUNC_ONE_MINUS_SRC_COLOR:
        return GL_ONE_MINUS_SRC_COLOR
    elif func == BLEND_FUNC_DST_COLOR:
        return GL_DST_COLOR
    elif func == BLEND_FUNC_ONE_MINUS_DST_COLOR:
        return GL_ONE_MINUS_DST_COLOR
    elif func == BLEND_FUNC_SRC_ALPHA:
        return GL_SRC_ALPHA
    elif func == BLEND_FUNC_ONE_MINUS_SRC_ALPHA:
        return GL_ONE_MINUS_SRC_ALPHA
    elif func == BLEND_FUNC_DST_ALPHA:
        return GL_DST_ALPHA
    elif func == BLEND_FUNC_ONE_MINUS_DST_ALPHA:
        return GL_ONE_MINUS_DST_ALPHA
    elif func == BLEND_FUNC_CONSTANT_COLOR:
        return GL_CONSTANT_COLOR
    elif func == BLEND_FUNC_ONE_MINUS_CONSTANT_COLOR:
        return GL_ONE_MINUS_CONSTANT_COLOR
    elif func == BLEND_FUNC_CONSTANT_ALPHA:
        return GL_CONSTANT_ALPHA
    elif func == BLEND_FUNC_ONE_MINUS_CONSTANT_ALPHA:
        return GL_ONE_MINUS_CONSTANT_ALPHA

cdef uint32_t c_depth_func_to_gl(DepthFunc func) nogil:
    if func == DEPTH_FUNC_NEVER:
        return GL_NEVER
    elif func == DEPTH_FUNC_LESSER:
        return GL_LESS
    elif func == DEPTH_FUNC_EQUAL:
        return GL_EQUAL
    elif func == DEPTH_FUNC_LESSER_EQUAL:
        return GL_LEQUAL
    elif func == DEPTH_FUNC_GREATER:
        return GL_GREATER
    elif func == DEPTH_FUNC_NOT_EQUAL:
        return GL_NOTEQUAL
    elif func == DEPTH_FUNC_GREATER_EQUAL:
        return GL_GEQUAL
    elif func == DEPTH_FUNC_ALWAYS:
        return GL_ALWAYS

cdef class View:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return View.get_ptr_by_handle(self.manager, self.handle)
    
    @staticmethod
    cdef uint8_t c_get_type() nogil:
        return ITEM_TYPE

    @staticmethod
    def get_type():
        return ITEM_TYPE

    @staticmethod
    cdef size_t c_get_size() nogil:
        return ITEM_SIZE

    @staticmethod
    def get_size():
        return ITEM_SIZE
    
    cpdef void create(self) except *:
        cdef:
            ViewC *view_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        view_ptr = self.get_ptr()
        view_ptr.clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL
        view_ptr.clear_color = Vec4C(0.0, 0.0, 0.0, 1.0)
        view_ptr.clear_depth = 1.0
        view_ptr.clear_stencil = 0
        view_ptr.rect = (0, 0, 1, 1)
        view_ptr.depth = True
        view_ptr.depth_func = DEPTH_FUNC_LESSER_EQUAL
        view_ptr.blend = True
        view_ptr.src_rgb = BLEND_FUNC_ONE
        view_ptr.dst_rgb = BLEND_FUNC_ZERO
        view_ptr.src_alpha = BLEND_FUNC_ONE
        view_ptr.dst_alpha = BLEND_FUNC_ZERO

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0
    
    cpdef void set_depth(self, bint depth) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.depth = depth

    cpdef void set_depth_func(self, DepthFunc depth_func) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.depth_func = depth_func

    cpdef void set_blend(self, bint blend) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.blend = blend

    cpdef void set_blend_func(self, BlendFunc src_rgb, BlendFunc dst_rgb, BlendFunc src_alpha, BlendFunc dst_alpha) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.src_rgb = src_rgb
        view_ptr.dst_rgb = dst_rgb
        view_ptr.src_alpha = src_alpha
        view_ptr.dst_alpha = dst_alpha

    cpdef void set_clear_flags(self, uint32_t clear_flags) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.clear_flags = clear_flags

    cpdef void set_clear_color(self, Vec4 color) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.clear_color = color.data

    cpdef void set_clear_depth(self, float depth) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.clear_depth = depth

    cpdef void set_clear_stencil(self, uint32_t stencil) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.clear_stencil = stencil

    cpdef void set_color_mask(self, bint r, bint g, bint b, bint a) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.color_mask = [r, g, b, a]

    cpdef void set_depth_mask(self, bint depth) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.depth_mask = depth

    cpdef void set_stencil_mask(self, bint stencil) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.stencil_mask = stencil
    
    cpdef void set_masks(self, bint r, bint g, bint b, bint a, bint depth, bint stencil) except *:
        self.set_color_mask(r, g, b, a)
        self.set_depth_mask(depth)
        self.set_stencil_mask(stencil)

    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.rect[0] = x
        view_ptr.rect[1] = y
        view_ptr.rect[2] = width
        view_ptr.rect[3] = height

    cpdef void set_program(self, Program program) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.program = program.handle

    cpdef void set_uniforms(self, list uniforms) except *:
        cdef:
            ViewC *view_ptr
            size_t i
            size_t num_uniforms
            Handle uniform
        view_ptr = self.get_ptr()
        num_uniforms = len(uniforms)
        if num_uniforms > 16:
            raise ValueError("View: cannot set more than {0} uniforms".format(PROGRAM_MAX_UNIFORMS))
        view_ptr.num_uniforms = num_uniforms
        for i in range(num_uniforms):
            uniform = (<Uniform>uniforms[i]).handle
            view_ptr.uniforms[i] = uniform

    cpdef void set_vertex_buffer(self, VertexBuffer buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.vertex_buffer = buffer.handle

    cpdef void set_index_buffer(self, IndexBuffer buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.index_buffer = buffer.handle

    cpdef void set_textures(self, dict textures) except *:
        cdef:
            ViewC *view_ptr
            size_t num_textures
            size_t i = 0
            TextureUnit unit
            Handle texture
        view_ptr = self.get_ptr()
        num_textures = len(textures)
        if num_textures > MAX_TEXTURE_UNITS:
            raise ValueError("View: cannot set more than 16 textures")
        memset(view_ptr.texture_units, 0, MAX_TEXTURE_UNITS * sizeof(int32_t))
        memset(view_ptr.textures, 0, MAX_TEXTURE_UNITS * sizeof(Handle))
        for unit in textures:
            texture = (<Texture>textures[unit]).handle
            view_ptr.texture_units[i] = unit
            view_ptr.textures[<size_t>unit] = texture
            i += 1
        view_ptr.num_texture_units = num_textures

    cpdef void set_frame_buffer(self, FrameBuffer frame_buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.get_ptr()
        view_ptr.frame_buffer = frame_buffer.handle