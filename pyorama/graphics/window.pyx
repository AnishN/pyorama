ctypedef WindowC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Window:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    cdef ItemTypeC *c_get_ptr(self) except *:
        return <ItemTypeC *>self.manager.c_get_ptr(self.handle)
    
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

    cpdef void create(self, uint16_t width, uint16_t height, bytes title) except *:
        cdef:
            Handle window
            WindowC *window_ptr
            size_t title_length
            #SDL_Renderer *renderer

        self.handle = self.manager.create(ITEM_TYPE)
        window_ptr = self.c_get_ptr()
        window_ptr.sdl_ptr = SDL_CreateWindow(
            title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
            width, height, SDL_WINDOW_OPENGL,
        )
        window_ptr.width = width
        window_ptr.height = height
        self.set_title(title)
        self.clear()

    cpdef void delete(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_DestroyWindow(window_ptr.sdl_ptr)
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void set_texture(self, Texture texture) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        window_ptr.texture = texture.handle

    cpdef void clear(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.manager.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height); self.manager.c_check_gl()
        glClearColor(0.0, 0.0, 0.0, 0.0); self.manager.c_check_gl()
        glClearDepthf(1.0); self.manager.c_check_gl()
        glClearStencil(0); self.manager.c_check_gl()
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT); self.manager.c_check_gl()
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(window_ptr.sdl_ptr)
        SDL_GL_MakeCurrent(self.manager.root_window, self.manager.root_context)

    cpdef void render(self) except *:
        cdef:
            WindowC *window_ptr
            TextureC *texture_ptr
            ProgramC *program_ptr
        window_ptr = self.c_get_ptr()
        SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.manager.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height); self.manager.c_check_gl()
        glClearColor(0.0, 0.0, 0.0, 0.0); self.manager.c_check_gl()
        glClearDepthf(1.0); self.manager.c_check_gl()
        glClearStencil(0); self.manager.c_check_gl()
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT); self.manager.c_check_gl()
        if handle_get_type(&window_ptr.texture) == Texture.c_get_type():
            glActiveTexture(GL_TEXTURE0); self.manager.c_check_gl()
            texture_ptr = <TextureC *>self.manager.c_get_ptr(window_ptr.texture)
            program_ptr = <ProgramC *>self.manager.c_get_ptr(self.manager.quad_program.handle)
            glUseProgram(program_ptr.gl_id); self.manager.c_check_gl()
            glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.manager.c_check_gl()
            self.manager.quad_program._bind_uniform(self.manager.u_quad.handle)
            self.manager.quad_program._bind_attributes(self.manager.quad_vbo.handle)
            self.manager.quad_ibo._draw()
            self.manager.quad_program._unbind_attributes()
            glBindTexture(GL_TEXTURE_2D, 0); self.manager.c_check_gl()
            SDL_GL_SetSwapInterval(0)
            SDL_GL_SwapWindow(window_ptr.sdl_ptr)
            glUseProgram(0); self.manager.c_check_gl()
        SDL_GL_MakeCurrent(self.manager.root_window, self.manager.root_context)

    cpdef void set_title(self, bytes title) except *:
        cdef:
            WindowC *window_ptr
            size_t title_length
        window_ptr = self.c_get_ptr()
        title_length = len(title)
        if title_length >= 256:
            raise ValueError("Window: title cannot exceed 255 characters")
        memcpy(window_ptr.title, <char *>title, title_length)
        window_ptr.title_length = title_length
        window_ptr.title[title_length] = b"\0"
        SDL_SetWindowTitle(window_ptr.sdl_ptr, window_ptr.title)