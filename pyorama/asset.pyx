cdef class AssetManager:

    def image_load_from_file(self, GraphicsManager graphics, bytes file_path):
        cdef:
            Handle image
            ImageC *image_ptr
        image = graphics.images.c_create()
        image_ptr = <ImageC *>graphics.images.c_get_ptr(image)
        surface = IMG_Load(file_path)
        if surface == NULL:
            raise ValueError("Image: cannot load file")
        converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_ABGR8888, 0)
        if converted_surface == NULL:
            SDL_FreeSurface(surface)#free the surface at this exit point
            raise ValueError("Image: cannot load file")
        image_ptr.pixels = <uint8_t *>converted_surface.pixels
        image_ptr.width = converted_surface.w
        image_ptr.height = converted_surface.h
        SDL_FreeSurface(surface)
        free(converted_surface)#free the struct, not the void *pixels data!
        return image

    def shader_load_from_file(self, GraphicsManager graphics, ShaderType type, bytes file_name):
        cdef:
            Handle shader
            object shader_file
            bytes shader_source
        shader_file = open(file_name, "rb")
        shader_source = shader_file.read()
        shader_file.close()
        shader = graphics.shader_create(type, shader_source)
        return shader

    def scene_load_from_file(self, GraphicsManager graphics, bytes file_name):
        cdef:
            uint32_t flags
            size_t i, j, k, m
            const aiScene *ai_scene
            const aiMesh *ai_mesh
            const aiFace *ai_face
            bint has_tex_coords
            #uint32_t mat_index
            void *v_data_ptr
            void *i_data_ptr
            float[:] v_data
            uint32_t[:] i_data
            Vec2C tex_coord_zero = (0.0, 0.0)
            float *p_ptr
            float *t_ptr
            float *n_ptr

            aiMaterial *ai_material
            aiString material_name
            int material_shading_model
            aiColor4D ambient
            aiColor4D diffuse
            aiColor4D specular
            float shininess
            
        """
        Handle[:] meshes
        Handle[:] materials
        Handle[:] animations
        Handle[:] textures
        Handle[:] lights
        Handle[:] cameras
        """
        
        """
        cdef struct aiScene:
            unsigned int mFlags
            aiNode* mRootNode
            unsigned int mNumMeshes
            aiMesh** mMeshes
            unsigned int mNumMaterials
            aiMaterial** mMaterials
            unsigned int mNumAnimations
            aiAnimation** mAnimations
            unsigned int mNumTextures
            aiTexture** mTextures
            unsigned int mNumLights
            aiLight** mLights
            unsigned int mNumCameras
            aiCamera** mCameras

        https://www.ics.com/blog/qt-and-opengl-loading-3d-model-open-asset-import-library-assimp
        """

        flags = (
            aiProcess_CalcTangentSpace | 
            aiProcess_Triangulate | 
            aiProcess_JoinIdenticalVertices | 
            aiProcess_SortByPType | 
            aiProcess_GenSmoothNormals | 
            aiProcess_GenUVCoords | 
            aiProcess_TransformUVCoords
        )
        ai_scene = aiImportFile(<char *>file_name, flags)
        if not &ai_scene:
            raise ValueError("Scene: file loading error: {0}".format(aiGetErrorString()))

        for i in range(ai_scene.mNumMaterials):
            ai_material = ai_scene.mMaterials[i]
            #ai_material
            aiGetMaterialString(ai_material, b"?mat.name", 0, 0, &material_name)
            aiGetMaterialIntegerArray(ai_material, b"$mat.shadingm", 0, 0, &material_shading_model, NULL)
            if material_shading_model == aiShadingMode_Phong or material_shading_model == aiShadingMode_Gouraud:
                #Treat both of these at Phong, no point of doing per-vertex shading that Gouraud specifies on modern pipelines
                print(material_name.data, material_shading_model, aiShadingMode_Phong, aiShadingMode_Gouraud)

                Vec4.c_set_data(<Vec4C *>&ambient, 0.0, 0.0, 0.0, 0.0)
                Vec4.c_set_data(<Vec4C *>&diffuse, 0.0, 0.0, 0.0, 0.0)
                Vec4.c_set_data(<Vec4C *>&specular, 0.0, 0.0, 0.0, 0.0)
                shininess = 0.0

                aiGetMaterialColor(ai_material, b"$clr.ambient", 0, 0, &ambient)
                aiGetMaterialColor(ai_material, b"$clr.diffuse", 0, 0, &diffuse)
                aiGetMaterialColor(ai_material, b"$clr.specular", 0, 0, &specular)
                aiGetMaterialFloatArray(ai_material, b"$sclr.shininess", 0, 0, &shininess, NULL)
                print(ambient, diffuse, specular, shininess)

            else:
                raise ValueError("Scene: unsupported material shading model")
        
        for i in range(ai_scene.mNumMeshes):
            pass
        
        """
        for i in range(ai_scene.mNumMeshes):
            ai_mesh = ai_scene.mMeshes[i]
            v_data_ptr = PyMem_Malloc(ai_mesh.mNumVertices * 8 * sizeof(float))
            if v_data_ptr == NULL:
                raise MemoryError("Scene: cannot allocate vertex data")
            v_data = <float[:ai_mesh.mNumVertices * 8]>v_data_ptr
            i_data_ptr = PyMem_Malloc(ai_mesh.mNumFaces * 3 * sizeof(uint32_t))
            if i_data_ptr == NULL:
                raise MemoryError("Scene: cannot allocate index data")
            i_data = <uint32_t[:ai_mesh.mNumFaces * 3]>i_data_ptr
            
            m = 0
            has_tex_coords = ai_mesh.mTextureCoords[0] != NULL
            if has_tex_coords:
                for j in range(ai_mesh.mNumVertices):
                    p_ptr = <float *>&ai_mesh.mVertices[j]
                    t_ptr = <float *>&ai_mesh.mTextureCoords[0][j]
                    n_ptr = <float *>&ai_mesh.mNormals[j]
                    memcpy(&v_data[m], p_ptr, sizeof(Vec3C))
                    memcpy(&v_data[m+3], t_ptr, sizeof(Vec2C))
                    memcpy(&v_data[m+5], n_ptr, sizeof(Vec3C))
                    m += 8
            else:
                for j in range(ai_mesh.mNumVertices):
                    p_ptr = <float *>&ai_mesh.mVertices[j]
                    t_ptr = <float *>&tex_coord_zero
                    n_ptr = <float *>&ai_mesh.mNormals[j]
                    memcpy(&v_data[m], p_ptr, sizeof(Vec3C))
                    memcpy(&v_data[m+3], t_ptr, sizeof(Vec2C))
                    memcpy(&v_data[m+5], n_ptr, sizeof(Vec3C))
                    m += 8
        
            m = 0
            for j in range(ai_mesh.mNumFaces):
                ai_face = &ai_mesh.mFaces[j]
                for k in range(ai_face.mNumIndices):
                    i_data[m] = ai_face.mIndices[k]
                    m += 1
            
            return v_data, i_data
        """
        aiReleaseImport(ai_scene)
    
    cdef void c_scene_parse_material(self, aiScene ai_scene, GraphicsManager graphics, Handle material) except *:
        cdef:
            MaterialC *material_ptr

        material_ptr = <MaterialC *>graphics.materials.c_get_ptr(material)