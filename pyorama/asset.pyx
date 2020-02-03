cdef class AssetManager:

    def image_load_from_file(self, GraphicsManager graphics, bytes file_path):
        cdef:
            Handle image
            ImageC *image_ptr
        image = graphics.images.c_create()
        image_ptr = graphics.c_image_get_ptr(image)
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
            print(aiGetErrorString())
        print(ai_scene.mNumMeshes, ai_scene.mNumMaterials)

        for i in range(ai_scene.mNumMeshes):
            ai_mesh = ai_scene.mMeshes[i]
            v_data_ptr = PyMem_Malloc(ai_mesh.mNumVertices * 8 * sizeof(float))
            if v_data_ptr == NULL:
                raise MemoryError()
            v_data = <float[:ai_mesh.mNumVertices * 8]>v_data_ptr
            i_data_ptr = PyMem_Malloc(ai_mesh.mNumFaces * 3 * sizeof(uint32_t))
            if i_data_ptr == NULL:
                raise MemoryError()
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
        
        aiReleaseImport(ai_scene)