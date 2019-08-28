import binascii
import json
import os
import numpy as np

cdef class GLTFLoader:

    cpdef load_gltf_json_file(self, str file_path, GraphicsManager graphics):
        """
        Traverse the tree of glTF objects bottom-up following this diagram:
        https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/figures/dictionary-objects.png
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
        node_ids = self._parse_nodes(data, graphics)
        scene_ids = self._parse_scenes(data, graphics)

        """
        cdef:
            size_t k
            Handle v
            ImageC *image_ptr
            int w
            int h
            uint32_t[:] pixels

        for k in image_ids:
            v = image_ids[k]
            item_slot_map_get_ptr(&graphics.images, v, <void **>&image_ptr)
            w, h = image_ptr.width, image_ptr.height
            pixels = <uint32_t[:w * h]>image_ptr.pixels
            print(v, w, h, np.asarray(pixels))
        """
    
    cdef dict _parse_buffers(self, dict data, GraphicsManager graphics, str dir_path):
        cdef:
            size_t i
            Handle handle
            dict buffer_ids = {}
            BufferC *buffer_ptr
            str buffer_path
            bytes buffer_bytes

        for i, buffer in enumerate(data.get("buffers", [])):
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
            Handle handle
            dict buffer_view
            dict buffer_view_ids = {}
            BufferViewC *buffer_view_ptr
            dict target_to_enum = {
                "NONE": BufferViewTarget.NONE,
                "ARRAY_BUFFER": BufferViewTarget.ARRAY_BUFFER,
                "ELEMENT_ARRAY_BUFFER": BufferViewTarget.ELEMENT_ARRAY_BUFFER,
            }
            int target

        for i, buffer_view in enumerate(data.get("bufferViews", [])):
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
            Handle handle
            dict accessor
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

        for i, accessor in enumerate(data.get("accessors", [])):
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
            Handle handle
            dict sampler
            list samplers
            dict sampler_ids = {}
            SamplerC *sampler_ptr
            int mag_filter
            int min_filter
            int wrap_s
            int wrap_t
        
        samplers = data.get("samplers", [])
        for i, sampler in enumerate(samplers):
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
        i = len(samplers)
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
            Handle handle
            dict image
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
        
        for i, image in enumerate(data.get("images", [])):
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
            Handle handle
            dict texture
            dict texture_ids = {}
            TextureC *texture_ptr
            size_t default_sampler_index = len(sampler_ids) - 1
        
        #Maps a texture to a sampler (default if needed) + source (aka image).
        for i, texture in enumerate(data.get("textures", [])):
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
            Handle handle
            dict material
            dict material_ids = {}
            MaterialC *material_ptr
        
        for i, material in enumerate(data.get("materials", [])):
            #print("material:", material)
            item_slot_map_create(&graphics.materials, &handle)
            item_slot_map_get_ptr(&graphics.materials, handle, <void **>&material_ptr)
            material_ids[i] = handle
        return material_ids

    cdef dict _parse_animations(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            Handle handle
            dict animation
            dict animation_ids = {}
            AnimationC *animation_ptr
        
        for i, animation in enumerate(data.get("animations", [])):
            #print("animation:", animation)
            item_slot_map_create(&graphics.animations, &handle)
            item_slot_map_get_ptr(&graphics.animations, handle, <void **>&animation_ptr)
            animation_ids[i] = handle
        return animation_ids

    cdef dict _parse_meshes(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            Handle handle
            dict mesh
            dict mesh_ids = {}
            MeshC *mesh_ptr
        
        for i, mesh in enumerate(data.get("meshes", [])):
            #print("mesh:", mesh)
            item_slot_map_create(&graphics.meshes, &handle)
            item_slot_map_get_ptr(&graphics.meshes, handle, <void **>&mesh_ptr)
            mesh_ids[i] = handle
        return mesh_ids

    cdef dict _parse_cameras(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            Handle handle
            dict camera
            dict camera_ids = {}
            CameraC *camera_ptr
        
        for i, camera in enumerate(data.get("cameras", [])):
            #print("camera:", camera)
            item_slot_map_create(&graphics.cameras, &handle)
            item_slot_map_get_ptr(&graphics.cameras, handle, <void **>&camera_ptr)
            camera_ids[i] = handle
        return camera_ids

    cdef dict _parse_skins(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            Handle handle
            dict skin
            dict skin_ids = {}
            SkinC *skin_ptr
        
        for i, skin in enumerate(data.get("skins", [])):
            #print("skin:", skin)
            item_slot_map_create(&graphics.skins, &handle)
            item_slot_map_get_ptr(&graphics.skins, handle, <void **>&skin_ptr)
            skin_ids[i] = handle
        return skin_ids

    cdef dict _parse_nodes(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            Handle handle
            dict node
            dict node_ids = {}
            NodeC *node_ptr
        
        for i, node in enumerate(data.get("nodes", [])):
            #print("node:", node)
            item_slot_map_create(&graphics.nodes, &handle)
            item_slot_map_get_ptr(&graphics.nodes, handle, <void **>&node_ptr)
            node_ids[i] = handle
        return node_ids

    cdef dict _parse_scenes(self, dict data, GraphicsManager graphics):
        cdef:
            size_t i
            Handle handle
            dict scene
            dict scene_ids = {}
            SceneC *scene_ptr
        
        for i, scene in enumerate(data.get("scenes", [])):
            #print("scene:", scene)
            item_slot_map_create(&graphics.scenes, &handle)
            item_slot_map_get_ptr(&graphics.scenes, handle, <void **>&scene_ptr)
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