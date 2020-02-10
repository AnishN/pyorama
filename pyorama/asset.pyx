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
            size_t i
            const aiScene *ai_scene
            const aiMaterial *ai_material
            Handle material
            Handle[:] materials
            const aiMesh *ai_mesh
            Handle mesh
            Handle[:] meshes

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
        if ai_scene == NULL:
            raise ValueError("Scene: file loading error: {0}".format(aiGetErrorString()))

        materials = <Handle[:ai_scene.mNumMaterials]>PyMem_Malloc(ai_scene.mNumMaterials * sizeof(Handle))
        meshes = <Handle[:ai_scene.mNumMeshes]>PyMem_Malloc(ai_scene.mNumMeshes * sizeof(Handle))
        
        for i in range(ai_scene.mNumMaterials):
            ai_material = ai_scene.mMaterials[i]
            material = graphics.materials.c_create()
            self.c_scene_parse_material(ai_material, graphics, material)
            materials[i] = material

        for i in range(ai_scene.mNumMeshes):
            ai_mesh = ai_scene.mMeshes[i]
            mesh = graphics.meshes.c_create()
            self.c_scene_parse_mesh(ai_mesh, graphics, mesh)
            meshes[i] = mesh
        
        aiReleaseImport(ai_scene)
        return materials, meshes
    
    cdef void c_scene_parse_material(self, aiMaterial *ai_material, GraphicsManager graphics, Handle material) except *:
        cdef:
            MaterialC *material_ptr
            aiString material_name
            int material_shading_model
        
        material_ptr = <MaterialC *>graphics.materials.c_get_ptr(material)
        aiGetMaterialString(ai_material, b"?mat.name", 0, 0, &material_name)
        aiGetMaterialIntegerArray(ai_material, b"$mat.shadingm", 0, 0, &material_shading_model, NULL)
        if material_shading_model == aiShadingMode_Phong or material_shading_model == aiShadingMode_Gouraud:
            #Treat both of these at Phong, no point of doing per-vertex shading that Gouraud specifies on modern pipelines
            material_ptr.name = material_name.data
            material_ptr.name_length = material_name.length
            aiGetMaterialColor(ai_material, b"$clr.ambient", 0, 0, <aiColor4D *>&material_ptr.ambient)
            aiGetMaterialColor(ai_material, b"$clr.diffuse", 0, 0, <aiColor4D *>&material_ptr.diffuse)
            aiGetMaterialColor(ai_material, b"$clr.specular", 0, 0, <aiColor4D *>&material_ptr.specular)
            aiGetMaterialFloatArray(ai_material, b"$sclr.shininess", 0, 0, &material_ptr.shininess, NULL)
        else:
            print(material_shading_model)
            raise ValueError("Scene: unsupported material shading model")

    cdef void c_scene_parse_mesh(self, aiMesh *ai_mesh, GraphicsManager graphics, Handle mesh) except *:
        cdef:
            MeshC *mesh_ptr
            float *v_data
            size_t v_length
            uint32_t *i_data
            size_t i_length
            size_t i, j, k
            const aiFace *ai_face
            bint has_tex_coords
            Vec2C tex_coord_zero = (0.0, 0.0)
            float *p_ptr
            float *t_ptr
            float *n_ptr

        mesh_ptr = <MeshC *>graphics.meshes.c_get_ptr(mesh)
        v_length = ai_mesh.mNumVertices * 8
        v_data = <float *>malloc(v_length * sizeof(float))
        if v_data == NULL:
            raise MemoryError("Scene: cannot allocate vertex data")
        i_length = ai_mesh.mNumFaces * 3
        i_data = <uint32_t *>malloc(ai_mesh.mNumFaces * 3 * sizeof(uint32_t))
        if i_data == NULL:
            raise MemoryError("Scene: cannot allocate index data")
        
        j = 0
        has_tex_coords = ai_mesh.mTextureCoords[0] != NULL
        if has_tex_coords:
            for i in range(ai_mesh.mNumVertices):
                p_ptr = <float *>&ai_mesh.mVertices[i]
                t_ptr = <float *>&ai_mesh.mTextureCoords[0][i]
                n_ptr = <float *>&ai_mesh.mNormals[i]
                memcpy(&v_data[j], p_ptr, sizeof(Vec3C))
                memcpy(&v_data[j+3], t_ptr, sizeof(Vec2C))
                memcpy(&v_data[j+5], n_ptr, sizeof(Vec3C))
                j += 8
        else:
            for i in range(ai_mesh.mNumVertices):
                p_ptr = <float *>&ai_mesh.mVertices[i]
                t_ptr = <float *>&tex_coord_zero
                n_ptr = <float *>&ai_mesh.mNormals[i]
                memcpy(&v_data[j], p_ptr, sizeof(Vec3C))
                memcpy(&v_data[j+3], t_ptr, sizeof(Vec2C))
                memcpy(&v_data[j+5], n_ptr, sizeof(Vec3C))
                j += 8

        j = 0
        for i in range(ai_mesh.mNumFaces):
            ai_face = &ai_mesh.mFaces[i]
            for k in range(ai_face.mNumIndices):
                i_data[j] = ai_face.mIndices[k]
                j += 1

        mesh_ptr.vertices_data = v_data
        mesh_ptr.vertices_length = v_length
        mesh_ptr.indices_data = i_data
        mesh_ptr.indices_length = i_length

    """
    cdef void c_scene_parse_nodes(self, aiScene *ai_scene, GraphicsManager graphics) except *:
        cdef:
            aiNode *ai_root
            aiNode ai_empty
            Mat4C identity
            Handle root
            NodeC *root_ptr
            #Handle[:] nodes
            ItemVector nodes
            #ItemVector 

        ai_root = ai_scene.mRootNode
        if ai_root == NULL:
            raise ValueError("Scene: root node not present in file")
        
        Mat4.c_identity(&identity)
        root = graphics.nodes.c_create()
        root_ptr = <NodeC *>graphics.nodes.c_get_ptr(root)
        root_ptr.parent = 0
        #root_ptr.prev_sibling = 0
        #root_ptr.next_sibling = 0

        #ai_empty.mTransformation = <aiMatrix4x4>identity[0]
        #ai_root.mParent = &ai_empty
        #root = graphics.nodes.c_create()
        #root.parent = 0
        #root.prev_sibling = 0
        #root.next_sibling = 0
        #self.c_scene_parse_node(ai_root, graphics, root)
    
    cdef void c_scene_parse_node(self, aiNode *ai_node, GraphicsManager graphics, Handle node) except *:
        cdef:
            NodeC *node_ptr
            size_t i
            aiNode *ai_child
            Handle child
            NodeC *child_ptr
            Handle prev_sibling = 0
            Handle curr_sibling = 0
            Handle next_sibling = 0

        node_ptr = <NodeC *>graphics.nodes.c_get_ptr(node)
        memcpy(&node_ptr.local, &(ai_node.mTransformation[0]), sizeof(Mat4C))
        for i in range(ai_node.mNumChildren):
            ai_child = ai_node.mChildren[i]
            child = graphics.nodes.c_create()
            child_ptr =  <NodeC *>graphics.nodes.c_get_ptr(child)
            if i == 0:
                node_ptr.first_child = child
            child_ptr.prev_sibling = prev_sibling
            child_ptr.next_sibling = next_sibling
            child_ptr.parent = node
            self.c_scene_parse_node(ai_child, graphics, child)
    """

    """
    cdef struct aiNode:
        aiString mName
        aiMatrix4x4 mTransformation
        aiNode* mParent
        unsigned int mNumChildren
        aiNode** mChildren
        unsigned int mNumMeshes
        unsigned int* mMeshes
        aiMetadata* mMetaData
    """
    
    """
    ctypedef struct NodeC:
        Mat4C local
        Mat4C world
        bint is_dirty
        Handle parent
        #Handle first_child
        #Handle next_sibling
        #Handle prev_sibling
    """