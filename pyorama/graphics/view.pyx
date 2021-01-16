cdef uint8_t ITEM_TYPE = GRAPHICS_ITEM_TYPE_VIEW
ctypedef ViewC ItemTypeC

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

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0
        
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