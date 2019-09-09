cdef class GraphicsManager:
    
    def init(self):
        item_slot_map_init(&self.buffers, ITEM_SIZE_BUFFER, ITEM_TYPE_BUFFER)
        item_slot_map_init(&self.buffer_views, ITEM_SIZE_BUFFER_VIEW, ITEM_TYPE_BUFFER_VIEW)
        item_slot_map_init(&self.accessors, ITEM_SIZE_ACCESSOR, ITEM_TYPE_ACCESSOR)
        item_slot_map_init(&self.samplers, ITEM_SIZE_SAMPLER, ITEM_TYPE_SAMPLER)#done
        item_slot_map_init(&self.images, ITEM_SIZE_IMAGE, ITEM_TYPE_IMAGE)#done
        item_slot_map_init(&self.textures, ITEM_SIZE_TEXTURE, ITEM_TYPE_TEXTURE)#done
        item_slot_map_init(&self.materials, ITEM_SIZE_MATERIAL, ITEM_TYPE_MATERIAL)
        item_slot_map_init(&self.animations, ITEM_SIZE_ANIMATION, ITEM_TYPE_ANIMATION)
        item_slot_map_init(&self.meshes, ITEM_SIZE_MESH, ITEM_TYPE_MESH)
        item_slot_map_init(&self.cameras, ITEM_SIZE_CAMERA, ITEM_TYPE_CAMERA)
        item_slot_map_init(&self.skins, ITEM_SIZE_SKIN, ITEM_TYPE_SKIN)
        item_slot_map_init(&self.nodes, ITEM_SIZE_NODE, ITEM_TYPE_NODE)
        item_slot_map_init(&self.scenes, ITEM_SIZE_SCENE, ITEM_TYPE_SCENE)
        item_slot_map_init(&self.shaders, ITEM_SIZE_SHADER, ITEM_TYPE_SHADER)#done

    def free(self):
        item_slot_map_free(&self.buffers)
        item_slot_map_free(&self.buffer_views)
        item_slot_map_free(&self.accessors)
        item_slot_map_free(&self.samplers)
        item_slot_map_free(&self.images)
        item_slot_map_free(&self.textures)
        item_slot_map_free(&self.materials)
        item_slot_map_free(&self.animations)
        item_slot_map_free(&self.meshes)
        item_slot_map_free(&self.cameras)
        item_slot_map_free(&self.skins)
        item_slot_map_free(&self.nodes)
        item_slot_map_free(&self.scenes)
        item_slot_map_free(&self.shaders)

    def create_sampler(self):
        cdef:
            Sampler sampler
            Handle handle
        item_slot_map_create(&self.samplers, &handle)
        sampler = Sampler.__new__(Sampler)
        sampler.graphics = self
        sampler.handle = handle
        return sampler
    
    def delete_sampler(self, Sampler sampler):
        if sampler.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Sampler object")
        item_slot_map_delete(&self.samplers, sampler.handle)

    def create_image(self):
        cdef:
            Image image
            Handle handle
        item_slot_map_create(&self.images, &handle)
        image = Image.__new__(Image)
        image.graphics = self
        image.handle = handle
        return image
    
    def delete_image(self, Image image):
        if image.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Image object")
        item_slot_map_delete(&self.images, image.handle)

    def create_texture(self):
        cdef:
            Texture texture
            Handle handle
        item_slot_map_create(&self.textures, &handle)
        texture = Texture.__new__(Texture)
        texture.graphics = self
        texture.handle = handle
        return texture
    
    def delete_texture(self, Texture texture):
        if texture.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Texture object")
        item_slot_map_delete(&self.textures, texture.handle)

    def create_shader(self):
        cdef:
            Shader shader
            Handle handle
        item_slot_map_create(&self.shaders, &handle)
        shader = Shader.__new__(Shader)
        shader.graphics = self
        shader.handle = handle
        return shader
    
    def delete_shader(self, Shader shader):
        if shader.graphics != self:
            raise ValueError("GraphicsManager: cannot delete unowned Shader object")
        item_slot_map_delete(&self.shaders, shader.handle)