cdef class GraphicsManager:
    
    def init(self):
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_context = SDL_GL_CreateContext(self.root_window)
        glewInit()
        ItemSlotMap.c_init(&self.windows, ITEM_SIZE_WINDOW, ITEM_TYPE_WINDOW)
        ItemSlotMap.c_init(&self.buffers, ITEM_SIZE_BUFFER, ITEM_TYPE_BUFFER)
        ItemSlotMap.c_init(&self.buffer_views, ITEM_SIZE_BUFFER_VIEW, ITEM_TYPE_BUFFER_VIEW)
        ItemSlotMap.c_init(&self.accessors, ITEM_SIZE_ACCESSOR, ITEM_TYPE_ACCESSOR)
        ItemSlotMap.c_init(&self.samplers, ITEM_SIZE_SAMPLER, ITEM_TYPE_SAMPLER)#done
        ItemSlotMap.c_init(&self.images, ITEM_SIZE_IMAGE, ITEM_TYPE_IMAGE)#done
        ItemSlotMap.c_init(&self.textures, ITEM_SIZE_TEXTURE, ITEM_TYPE_TEXTURE)#done
        ItemSlotMap.c_init(&self.materials, ITEM_SIZE_MATERIAL, ITEM_TYPE_MATERIAL)
        ItemSlotMap.c_init(&self.animations, ITEM_SIZE_ANIMATION, ITEM_TYPE_ANIMATION)
        ItemSlotMap.c_init(&self.meshes, ITEM_SIZE_MESH, ITEM_TYPE_MESH)
        ItemSlotMap.c_init(&self.cameras, ITEM_SIZE_CAMERA, ITEM_TYPE_CAMERA)
        ItemSlotMap.c_init(&self.skins, ITEM_SIZE_SKIN, ITEM_TYPE_SKIN)
        ItemSlotMap.c_init(&self.nodes, ITEM_SIZE_NODE, ITEM_TYPE_NODE)
        ItemSlotMap.c_init(&self.scenes, ITEM_SIZE_SCENE, ITEM_TYPE_SCENE)
        ItemSlotMap.c_init(&self.shaders, ITEM_SIZE_SHADER, ITEM_TYPE_SHADER)#done
        ItemSlotMap.c_init(&self.programs, ITEM_SIZE_PROGRAM, ITEM_TYPE_PROGRAM)#done

    def quit(self):
        SDL_GL_DeleteContext(self.root_context)
        SDL_DestroyWindow(self.root_window)
        ItemSlotMap.c_free(&self.windows)
        ItemSlotMap.c_free(&self.buffers)
        ItemSlotMap.c_free(&self.buffer_views)
        ItemSlotMap.c_free(&self.accessors)
        ItemSlotMap.c_free(&self.samplers)
        ItemSlotMap.c_free(&self.images)
        ItemSlotMap.c_free(&self.textures)
        ItemSlotMap.c_free(&self.materials)
        ItemSlotMap.c_free(&self.animations)
        ItemSlotMap.c_free(&self.meshes)
        ItemSlotMap.c_free(&self.cameras)
        ItemSlotMap.c_free(&self.skins)
        ItemSlotMap.c_free(&self.nodes)
        ItemSlotMap.c_free(&self.scenes)
        ItemSlotMap.c_free(&self.shaders)
        ItemSlotMap.c_free(&self.programs)

    def create_window(self):
        cdef:
            Window window
            Handle handle
        ItemSlotMap.c_create(&self.windows, &handle)
        window = Window.__new__(Window)
        window.graphics = self
        window.handle = handle
        return window
    
    def delete_window(self, Window window):
        if window.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Window object")
        ItemSlotMap.c_delete(&self.windows, window.handle)

    def create_sampler(self):
        cdef:
            Sampler sampler
            Handle handle
        ItemSlotMap.c_create(&self.samplers, &handle)
        sampler = Sampler.__new__(Sampler)
        sampler.graphics = self
        sampler.handle = handle
        return sampler
    
    def delete_sampler(self, Sampler sampler):
        if sampler.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Sampler object")
        ItemSlotMap.c_delete(&self.samplers, sampler.handle)

    def create_image(self):
        cdef:
            Image image
            Handle handle
        ItemSlotMap.c_create(&self.images, &handle)
        image = Image.__new__(Image)
        image.graphics = self
        image.handle = handle
        return image
    
    def delete_image(self, Image image):
        if image.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Image object")
        ItemSlotMap.c_delete(&self.images, image.handle)

    def create_texture(self):
        cdef:
            Texture texture
            Handle handle
        ItemSlotMap.c_create(&self.textures, &handle)
        texture = Texture.__new__(Texture)
        texture.graphics = self
        texture.handle = handle
        return texture
    
    def delete_texture(self, Texture texture):
        if texture.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Texture object")
        ItemSlotMap.c_delete(&self.textures, texture.handle)

    def create_shader(self):
        cdef:
            Shader shader
            Handle handle
        ItemSlotMap.c_create(&self.shaders, &handle)
        shader = Shader.__new__(Shader)
        shader.graphics = self
        shader.handle = handle
        return shader
    
    def delete_shader(self, Shader shader):
        if shader.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Shader object")
        ItemSlotMap.c_delete(&self.shaders, shader.handle)

    def create_program(self):
        cdef:
            Program program
            Handle handle
        ItemSlotMap.c_create(&self.programs, &handle)
        program = Program.__new__(Program)
        program.graphics = self
        program.handle = handle
        return program
    
    def delete_program(self, Program program):
        if program.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Program object")
        ItemSlotMap.c_delete(&self.programs, program.handle)