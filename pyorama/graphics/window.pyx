cdef class Window:
    def __init__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef WindowC *get_ptr(self) except *:
        return self.graphics.window_get_ptr(self.handle)

    cpdef void create(self, uint16_t width, uint16_t height, bytes title) except *:
        cdef:
            Handle window
            WindowC *window_ptr
            size_t title_length
            #SDL_Renderer *renderer

        self.handle = self.graphics.windows.c_create()
        window_ptr = self.get_ptr()
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
        window_ptr = self.get_ptr()
        SDL_DestroyWindow(window_ptr.sdl_ptr)
        self.graphics.windows.c_delete(self.handle)
        self.handle = 0

    cpdef void set_texture(self, Handle texture) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.get_ptr()
        window_ptr.texture = texture

    cpdef void clear(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.get_ptr()
        SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.graphics.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height); self.graphics.c_check_gl()
        glClearColor(0.0, 0.0, 0.0, 0.0); self.graphics.c_check_gl()
        glClearDepthf(1.0); self.graphics.c_check_gl()
        glClearStencil(0); self.graphics.c_check_gl()
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT); self.graphics.c_check_gl()
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(window_ptr.sdl_ptr)
        SDL_GL_MakeCurrent(self.graphics.root_window, self.graphics.root_context)

    cpdef void render(self) except *:
        cdef:
            WindowC *window_ptr
            TextureC *texture_ptr
            ProgramC *program_ptr
        window_ptr = self.get_ptr()
        SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.graphics.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height); self.graphics.c_check_gl()
        glClearColor(0.0, 0.0, 0.0, 0.0); self.graphics.c_check_gl()
        glClearDepthf(1.0); self.graphics.c_check_gl()
        glClearStencil(0); self.graphics.c_check_gl()
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT); self.graphics.c_check_gl()
        if self.graphics.textures.c_is_handle_valid(window_ptr.texture):
            glActiveTexture(GL_TEXTURE0); self.graphics.c_check_gl()
            texture_ptr = self.graphics.texture_get_ptr(window_ptr.texture)
            program_ptr = self.graphics.program_get_ptr(self.graphics.quad_program)
            glUseProgram(program_ptr.gl_id); self.graphics.c_check_gl()
            glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.graphics.c_check_gl()
            self.graphics._program_bind_uniform(self.graphics.quad_program, self.graphics.u_quad.handle)
            self.graphics._program_bind_attributes(self.graphics.quad_program, self.graphics.quad_vbo.handle)
            self.graphics.quad_ibo._draw()
            self.graphics._program_unbind_attributes(self.graphics.quad_program)
            glBindTexture(GL_TEXTURE_2D, 0); self.graphics.c_check_gl()
            SDL_GL_SetSwapInterval(0)
            SDL_GL_SwapWindow(window_ptr.sdl_ptr)
            glUseProgram(0); self.graphics.c_check_gl()
        SDL_GL_MakeCurrent(self.graphics.root_window, self.graphics.root_context)

    cpdef void set_title(self, bytes title) except *:
        cdef:
            WindowC *window_ptr
            size_t title_length
        window_ptr = self.get_ptr()
        title_length = len(title)
        if title_length >= 256:
            raise ValueError("Window: title cannot exceed 255 characters")
        memcpy(window_ptr.title, <char *>title, title_length)
        window_ptr.title_length = title_length
        window_ptr.title[title_length] = b"\0"
        SDL_SetWindowTitle(window_ptr.sdl_ptr, window_ptr.title)