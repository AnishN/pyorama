import binascii
import json
import os
import numpy as np

cdef class GLTFLoader:

    cpdef load_gltf_json_file(self, str file_path, GraphicsManager graphics):
        """
        Traverse the tree of glTF objects bottom-up following this diagram:
        https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/figures/dictionary-objects.png

        Unfinished parts include:
        * Weights
        * Named accessors? TEX_COORD_0, JOINT, etc...
        * Sparse Accessors
        * Animation
        * Skin
        * Node (skin components)
        * Node (restructuring children)
        """
        cdef:
            str dir_path = os.path.dirname(file_path)
            object in_file = open(file_path, "r")
            dict data = json.load(in_file)
            dict buffer_ids
            dict buffer_view_ids
            dict accessor_ids
            dict sampler_ids
            dict image_ids
            dict texture_ids
            dict material_ids
            dict animation_ids
            dict mesh_ids
            dict camera_ids
            dict skin_ids
            dict node_ids
            dict scene_ids
        
        buffer_ids = self._parse_buffers(data, graphics, dir_path)
        buffer_view_ids = self._parse_buffer_views(data, graphics, buffer_ids)
        accessor_ids = self._parse_accessors(data, graphics, buffer_view_ids)
        sampler_ids = self._parse_samplers(data, graphics)
        image_ids = self._parse_images(data, graphics, dir_path, buffer_view_ids)
        texture_ids = self._parse_textures(data, graphics, sampler_ids, image_ids)
        material_ids = self._parse_materials(data, graphics)
        animation_ids = self._parse_animations(data, graphics)
        mesh_ids = self._parse_meshes(data, graphics)
        camera_ids = self._parse_cameras(data, graphics)
        skin_ids = self._parse_skins(data, graphics)
        node_ids = self._parse_nodes(data, graphics, mesh_ids, camera_ids, skin_ids)
        scene_ids = self._parse_scenes(data, graphics, node_ids)
    
    cdef dict _parse_buffers(self, dict data, GraphicsManager graphics, str dir_path):
        cdef:
            size_t i
            size_t num_buffers
            list buffers
            dict buffer
            Handle handle
            dict buffer_ids = {}
            BufferC *buffer_ptr
            str buffer_path
            bytes buffer_bytes

        buffers = data.get("buffers", [])
        num_buffers = len(buffers)
        for i in range(num_buffers):
            buffer = buffers[i]
            #print("buffer:", buffer)
            item_slot_map_create(&graphics.buffers, &handle)
            item_slot_map_get_ptr(&graphics.buffers, handle, <void **>&buffer_ptr)
            if buffer["uri"].endswith(".bin"):
                buffer_path = "{0}/{1}".format(dir_path, buffer["uri"])
                buffer_bytes = self.load_gltf_bin_file(buffer_path)
            else:
                buffer_bytes = binascii.a2b_base64(buffer["uri"])
            buffer_ptr.bytes = <char *>buffer_bytes
            buffer_ptr.byte_length = buffer["byteLength"]
            buffer_ids[i] = handle
        return buffer_ids

    cdef dict _parse_buffer_views(self, dict data, GraphicsManager graphics, dict buffer_ids):
        cdef:
            size_t i
            size_t num_buffer_views
            list buffer_views
            dict buffer_view
            Handle handle
            dict buffer_view_ids = {}
            BufferViewC *buffer_view_ptr
            dict target_to_enum = {
                "NONE": BufferViewTarget.NONE,
                "ARRAY_BUFFER": BufferViewTarget.ARRAY_BUFFER,
                "ELEMENT_ARRAY_BUFFER": BufferViewTarget.ELEMENT_ARRAY_BUFFER,
            }
            int target

        buffer_views = data.get("bufferViews", [])
        num_buffer_views = len(buffer_views)
        for i in range(num_buffer_views):
            buffer_view = buffer_views[i]
            #print("view:", buffer_view)
            item_slot_map_create(&graphics.buffer_views, &handle)
            item_slot_map_get_ptr(&graphics.buffer_views, handle, <void **>&buffer_view_ptr)
            buffer_view_ptr.buffer = buffer_ids[buffer_view["buffer"]]
            buffer_view_ptr.byte_offset = buffer_view.get("byteOffset", 0)
            buffer_view_ptr.byte_length = buffer_view["byteLength"]
            target = buffer_view.get("target", 0)
            buffer_view_ptr.target = <BufferViewTarget>(target)
            buffer_view_ids[i] = handle
        return buffer_view_ids

    cdef dict _parse_accessors(self, dict data, GraphicsManager graphics, dict buffer_view_ids):
        cdef:
            size_t i
            size_t num_accessors
            list accessors
            dict accessor
            Handle handle
            dict accessor_ids = {}
            AccessorC *accessor_ptr
            dict accessor_type_to_enum = {
                "SCALAR": AccessorType.SCALAR,
                "VEC2": AccessorType.VEC2,
                "VEC3": AccessorType.VEC3,
                "VEC4": AccessorType.VEC4,
                "MAT2": AccessorType.MAT2,
                "MAT3": AccessorType.MAT3,
                "MAT4": AccessorType.MAT4,
            }

        accessors = data.get("accessors", [])
        num_accessors = len(accessors)
        for i in range(num_accessors):
            accessor = accessors[i]
            #print("accessor:", accessor)
            item_slot_map_create(&graphics.accessors, &handle)
            item_slot_map_get_ptr(&graphics.accessors, handle, <void **>&accessor_ptr)
            accessor_ptr.buffer_view = buffer_view_ids[accessor["bufferView"]]
            accessor_ptr.byte_offset = accessor.get("byteOffset", 0)
            accessor_ptr.component_type = <AccessorComponentType>accessor["componentType"]
            accessor_ptr.normalized = accessor.get("normalized", False)
            accessor_ptr.count = accessor["count"]
            accessor_ptr.type = <AccessorType>accessor_type_to_enum[accessor["type"]]
            #accessor_ptr.max = 
            #accessor_ptr.min = 
            #min and max only required if sparse; no defaults for these
            accessor_ids[i] = handle
        return accessor_ids
    
    cdef dict _parse_samplers(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            size_t num_samplers
            list samplers
            dict sampler
            Handle handle
            dict sampler_ids = {}
            SamplerC *sampler_ptr
            int mag_filter
            int min_filter
            int wrap_s
            int wrap_t
        
        samplers = data.get("samplers", [])
        num_samplers = len(samplers)
        for i in range(num_samplers):
            sampler = samplers[i]
            #print("sampler:", sampler)
            item_slot_map_create(&graphics.samplers, &handle)
            item_slot_map_get_ptr(&graphics.samplers, handle, <void **>&sampler_ptr)
            mag_filter = sampler.get("magFilter", SamplerFilter.LINEAR)
            min_filter = sampler.get("minFilter", SamplerFilter.LINEAR)
            wrap_s = sampler.get("wrapS", SamplerWrap.REPEAT)
            wrap_t = sampler.get("wrapT", SamplerWrap.REPEAT)
            sampler_ptr.mag_filter = <SamplerFilter>mag_filter
            sampler_ptr.min_filter = <SamplerFilter>min_filter
            sampler_ptr.wrap_s = <SamplerWrap>wrap_s
            sampler_ptr.wrap_t = <SamplerWrap>wrap_t
            sampler_ids[i] = handle

        """
        Create a default sampler at the end of the function.
        If a texture does not define an associated sampler, this one is used.
        """
        i = num_samplers
        item_slot_map_create(&graphics.samplers, &handle)
        item_slot_map_get_ptr(&graphics.samplers, handle, <void **>&sampler_ptr)
        sampler_ptr.mag_filter = SamplerFilter.LINEAR
        sampler_ptr.min_filter = SamplerFilter.LINEAR
        sampler_ptr.wrap_s = SamplerWrap.REPEAT
        sampler_ptr.wrap_t = SamplerWrap.REPEAT
        sampler_ids[i] = handle
        return sampler_ids

    cdef dict _parse_images(self, dict data, GraphicsManager graphics, str dir_path, dict buffer_view_ids):
        cdef:
            size_t i
            size_t num_images
            list images
            dict image
            Handle handle
            dict image_ids = {}
            ImageC *image_ptr
            bytes image_path
            SDL_Surface *surface
            SDL_Surface *converted_surface
        
        """
        Properties:
        * uri (data-uri or url), assume it is a url for now...
        * mimeType: optional, required only w/ bufferView
            jpg: "image/jpeg"
            png: "image/png"
        * bufferView: alt to uri, not used in sample models
        """
        
        images = data.get("images", [])
        num_images = len(images)
        for i in range(num_images):
            image = images[i]
            #print("image:", image)
            item_slot_map_create(&graphics.images, &handle)
            item_slot_map_get_ptr(&graphics.images, handle, <void **>&image_ptr)
            image_path = ("{0}/{1}".format(dir_path, image["uri"])).encode("utf-8")
            IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
            surface = IMG_Load(image_path)
            if surface == NULL:
                raise ValueError("GLTFLoader: could not load image")
            converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA8888, 0)
            if converted_surface == NULL:
                raise ValueError("GLTFLoader: could not convert image to RGBA8888 format")
            image_ptr.pixels = <uint32_t *>converted_surface.pixels
            image_ptr.width = converted_surface.w
            image_ptr.height = converted_surface.h
            SDL_FreeSurface(surface)
            free(converted_surface)#free the struct, not the void *pixels data!
            image_ids[i] = handle
        return image_ids

    cdef dict _parse_textures(self, dict data, GraphicsManager graphics, dict sampler_ids, dict image_ids):
        cdef:
            size_t i
            size_t num_textures
            list textures
            dict texture
            Handle handle
            dict texture_ids = {}
            TextureC *texture_ptr
            size_t default_sampler_index = len(sampler_ids) - 1
        
        textures = data.get("textures", [])
        num_textures = len(textures)
        #Maps a texture to a sampler (default if needed) + source (aka image).
        for i in range(num_textures):
            texture = textures[i]
            #print("texture:", texture)
            item_slot_map_create(&graphics.textures, &handle)
            item_slot_map_get_ptr(&graphics.textures, handle, <void **>&texture_ptr)
            texture_ptr.sampler = sampler_ids[texture.get("sampler", default_sampler_index)]
            texture_ptr.source = image_ids[texture["source"]]
            texture_ids[i] = handle
        return texture_ids
    
    cdef dict _parse_materials(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            size_t num_materials
            list materials
            dict material
            Handle handle
            dict material_ids = {}
            MaterialC *material_ptr
        
        materials = data.get("materials", [])
        num_materials = len(materials)
        for i in range(num_materials):
            material = materials[i]
            #print("material:", material)
            item_slot_map_create(&graphics.materials, &handle)
            item_slot_map_get_ptr(&graphics.materials, handle, <void **>&material_ptr)
            material_ids[i] = handle
        return material_ids

    cdef dict _parse_animations(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            size_t num_animations
            list animations
            dict animation
            Handle handle
            dict animation_ids = {}
            AnimationC *animation_ptr
        
        animations = data.get("animations", [])
        num_animations = len(animations)
        for i in range(num_animations):
            animation = animations[i]
            #print("animation:", animation)
            item_slot_map_create(&graphics.animations, &handle)
            item_slot_map_get_ptr(&graphics.animations, handle, <void **>&animation_ptr)
            animation_ids[i] = handle
        return animation_ids

    cdef dict _parse_meshes(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            size_t num_meshes
            list meshs
            dict mesh
            Handle handle
            dict mesh_ids = {}
            MeshC *mesh_ptr
        
        meshes = data.get("meshes", [])
        num_meshes = len(meshes)
        for i in range(num_meshes):
            mesh = meshes[i]
            #print("mesh:", mesh)
            item_slot_map_create(&graphics.meshes, &handle)
            item_slot_map_get_ptr(&graphics.meshes, handle, <void **>&mesh_ptr)
            mesh_ids[i] = handle
        return mesh_ids

    cdef dict _parse_cameras(self, dict data, GraphicsManager graphics):
        """
        I diverge from the spec here. If aspect_ratio is undefined, GLTF should 
        apparently use the canvas ratio. However, a context may not be created.
        Therefore, opting for default value of 1.0.
        Also am not handling the zfar "infinite projection matrix" case.
        """
        cdef:
            size_t i
            size_t num_cameras
            list cameras
            dict camera
            Handle handle
            dict camera_ids = {}
            dict ortho
            dict persp
            CameraC *camera_ptr
        
        cameras = data.get("cameras", [])
        num_cameras = len(cameras)
        for i in range(num_cameras):
            camera = cameras[i]
            #print("camera:", camera)
            item_slot_map_create(&graphics.cameras, &handle)
            item_slot_map_get_ptr(&graphics.cameras, handle, <void **>&camera_ptr)
            if camera["type"] == "orthographic":
                camera_ptr.type = CameraType.ORTHOGRAPHIC
                ortho = camera["orthographic"]
                camera_ptr.data.orthographic.x_mag = ortho["xmag"]
                camera_ptr.data.orthographic.y_mag = ortho["ymag"]
                camera_ptr.data.orthographic.z_far = ortho["zfar"]
                camera_ptr.data.orthographic.z_near = ortho["znear"]
            elif camera["type"] == "perspective":
                camera_ptr.type = CameraType.PERSPECTIVE
                persp = camera["perspective"]
                camera_ptr.data.perspective.aspect_ratio = persp.get("aspectRatio", 1.0)
                camera_ptr.data.perspective.y_fov = persp["yfov"]
                camera_ptr.data.perspective.z_far = persp["zfar"]
                camera_ptr.data.perspective.z_near = persp["znear"]
            else:
                raise ValueError("GLTFLoader: invalid camera type")
            camera_ids[i] = handle
        return camera_ids

    cdef dict _parse_skins(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            size_t num_skins
            list skins
            dict skin
            Handle handle
            dict skin_ids = {}
            SkinC *skin_ptr
        
        skins = data.get("skins", [])
        num_skins = len(skins)
        for i in range(num_skins):
            skin = skins[i]
            #print("skin:", skin)
            item_slot_map_create(&graphics.skins, &handle)
            item_slot_map_get_ptr(&graphics.skins, handle, <void **>&skin_ptr)
            skin_ids[i] = handle
        return skin_ids

    cdef dict _parse_nodes(self, dict data, GraphicsManager graphics, dict mesh_ids, dict camera_ids, dict skin_ids):
        """
        TRS = translation, rotation, scale.
        Either use a matrix or a TRS set of values.
        Does NOT calculate the matrix from the TRS at the moment.
        Does NOT handle skin (with weights) at the moment.
        
        In order to handle children, the code iterates twice over the nodes.
        First time to create all of the handles.
        Second time to populate the nodes with their respective data.
        Currently storing children as vectors within a node.
        But this can be improved by just storing the following handles:
            * parent
            * first_child
            * next_sibling
            * prev_sibling
        For more info on that approach, check out: 
        http://bitsquid.blogspot.com/2014/10/building-data-oriented-entity-system.html
        """
        cdef:
            size_t i, j
            Handle handle
            size_t num_nodes
            list nodes
            dict node
            dict node_ids = {}
            NodeC *node_ptr
            #Using math3d python objects for easier parsing from list
            Mat4 m = Mat4()#matrix
            Vec3 t = Vec3(0.0, 0.0, 0.0)#translation
            Quat r = Quat(0.0, 0.0, 0.0, 1.0)#rotation
            Vec3 s = Vec3(1.0, 1.0, 1.0)#scale
            list children
            size_t num_children
            Handle child
        
        nodes = data.get("nodes", [])
        num_nodes = len(nodes)
        for i in range(num_nodes):
            item_slot_map_create(&graphics.nodes, &handle)
            item_slot_map_get_ptr(&graphics.nodes, handle, <void **>&node_ptr)
            node_ids[i] = handle
        
        for i in range(num_nodes):
            node = nodes[i]
            
            #Handling matrix or TRS
            if "matrix" in node:
                Mat4.set_data(m, *node["matrix"])
                memcpy(&node_ptr.matrix, m.ptr, sizeof(Mat4C))
                node_ptr.use_matrix = True
            else:
                if "translation" in node:
                    Vec3.set_data(t, *node["translation"])
                if "rotation" in node:
                    Quat.set_data(r, *node["rotation"])
                if "scale" in node:
                    Vec3.set_data(s, *node["scale"])
                memcpy(&node_ptr.translation, t.ptr, sizeof(Vec3C))
                memcpy(&node_ptr.rotation, r.ptr, sizeof(QuatC))
                memcpy(&node_ptr.scale, s.ptr, sizeof(Vec3C))
                node_ptr.use_matrix = False
            
            #Handling mesh, camera, skin
            if "mesh" in node:
                node_ptr.type = NodeType.MESH_NODE
                node_ptr.handle = mesh_ids[node["mesh"]]
            elif "camera" in node:
                node_ptr.type = NodeType.CAMERA_NODE
                node_ptr.handle = camera_ids[node["camera"]]
            elif "skin" in node:
                node_ptr.type = NodeType.SKIN_NODE
                node_ptr.handle = skin_ids[node["skin"]]
            else:
                node_ptr.type = NodeType.EMPTY_NODE
                node_ptr.handle = 0

            #Handling children
            item_vector_init(&node_ptr.children, sizeof(Handle))
            children = node.get("children", [])
            num_children = len(children)
            for j in range(num_children):
                child = node_ids[children[j]]
                item_vector_push(&node_ptr.children, &child)
        
        return node_ids
    
    cdef dict _parse_scenes(self, dict data, GraphicsManager graphics, dict node_ids):
        cdef:
            size_t i, j
            size_t num_scenes
            list scenes
            dict scene
            Handle handle
            list nodes
            size_t num_nodes
            Handle node_handle
            dict scene_ids = {}
            SceneC *scene_ptr
        
        scenes = data.get("scenes", [])
        num_scenes = len(scenes)
        for i in range(num_scenes):
            scene = scenes[i]
            #print("scene:", scene)
            item_slot_map_create(&graphics.scenes, &handle)
            item_slot_map_get_ptr(&graphics.scenes, handle, <void **>&scene_ptr)
            item_vector_init(&scene_ptr.nodes, sizeof(Handle))
            nodes = scene["nodes"]
            num_nodes = len(nodes)
            for j in range(num_nodes):
                node_handle = node_ids[nodes[j]]
                item_vector_push(&scene_ptr.nodes, &node_handle)
            scene_ids[i] = handle
        return scene_ids

    cpdef bytes load_gltf_bin_file(self, str file_path):
        cdef:
            object in_file
            bytes data
        
        in_file = open(file_path, "rb")
        data = in_file.read()
        return data
    
    cpdef load_glb_file(self, str file_path, GraphicsManager graphics):
        pass