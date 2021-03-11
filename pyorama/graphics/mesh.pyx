ctypedef MeshC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Mesh:
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
        return Mesh.get_ptr_by_handle(self.manager, self.handle)

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

    cpdef void create(self, uint8_t[::1] vertex_data, uint8_t[::1] index_data) except *:
        cdef:
            MeshC *mesh_ptr
            size_t vertex_data_size
            size_t index_data_size
        self.handle = self.manager.create(ITEM_TYPE)
        mesh_ptr = self.get_ptr()
        vertex_data_size = vertex_data.shape[0]
        index_data_size = index_data.shape[0]
        mesh_ptr.vertex_data = <uint8_t *>calloc(vertex_data_size, sizeof(uint8_t))
        if mesh_ptr.vertex_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for vertex data")
        memcpy(mesh_ptr.vertex_data, &vertex_data[0], vertex_data_size)
        mesh_ptr.vertex_data_size = vertex_data_size
        mesh_ptr.index_data = <uint8_t *>calloc(index_data_size, sizeof(uint8_t))
        if mesh_ptr.index_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for index data")
        memcpy(mesh_ptr.index_data, &index_data[0], index_data_size)
        mesh_ptr.index_data_size = index_data_size

    cpdef void create_from_file(self, bytes file_path) except *:
        cdef:
            MeshC *mesh_ptr
            aiScene *ai_scene
            str error_str
            aiMesh *ai_mesh
            Vec3C *positions
            Vec3C *tex_coords#assimp uses Vec3 instead of Vec2
            Vec3C *normals
            Vec2C empty_tex_coord = Vec2C(0.0, 0.0)
            size_t num_vertices
            size_t vertex_data_size
            uint8_t *vertex_data
            size_t i
            uint8_t *dst_ptr
            size_t p_size = sizeof(Vec3C)
            size_t pt_size = p_size + sizeof(Vec2C)
            size_t ptn_size = pt_size + sizeof(Vec3C)
            size_t f_size = 3 * sizeof(uint32_t)
            size_t num_faces
            size_t num_indices
            size_t index_data_size
            uint8_t *index_data
            aiFace *ai_faces

        self.handle = self.manager.create(ITEM_TYPE)
        mesh_ptr = self.get_ptr()

        ai_scene = aiImportFile(file_path, 
            aiProcess_CalcTangentSpace | 
            aiProcess_GenNormals | #generates normals if not present in mesh file
            aiProcess_Triangulate |
            aiProcess_JoinIdenticalVertices |
            aiProcess_SortByPType,
        )
        if ai_scene == NULL:
            error_str = aiGetErrorString().decode("utf-8")
            raise ValueError("Mesh: assimp loader error message below:\n{0}".format(error_str))
        if ai_scene.mNumMeshes == 0:
            raise ValueError("Mesh: no meshes present in file")
        if ai_scene.mNumMeshes > 1:
            raise ValueError("Mesh: multiple mesh import not supported")
        
        ai_mesh = ai_scene.mMeshes[0]

        #get vertex data (interleaved)
        num_vertices = ai_mesh.mNumVertices
        vertex_data_size = num_vertices * ptn_size
        vertex_data = <uint8_t *>calloc(vertex_data_size, sizeof(uint8_t))
        if vertex_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for vertex data")

        positions = ai_mesh.mVertices
        tex_coords = ai_mesh.mTextureCoords[0]#takes only first channel of tex_coords
        normals = ai_mesh.mNormals
        
        if tex_coords == NULL:
            for i in range(num_vertices):
                dst_ptr = &vertex_data[i * ptn_size]
                memcpy(dst_ptr, &positions[i], sizeof(Vec3C))
                memcpy(dst_ptr + p_size, &empty_tex_coord, sizeof(Vec2C))
                memcpy(dst_ptr + pt_size, &normals[i], sizeof(Vec3C))
        else:
            for i in range(num_vertices):
                dst_ptr = &vertex_data[i * ptn_size]
                memcpy(dst_ptr, &positions[i], sizeof(Vec3C))
                memcpy(dst_ptr + p_size, &tex_coords[i], sizeof(Vec2C))
                memcpy(dst_ptr + pt_size, &normals[i], sizeof(Vec3C))
        mesh_ptr.vertex_data = vertex_data
        mesh_ptr.vertex_data_size = vertex_data_size

        #get index data
        ai_faces = ai_mesh.mFaces
        num_faces = ai_mesh.mNumFaces
        index_data_size = num_faces * f_size
        index_data = <uint8_t *>calloc(index_data_size, sizeof(uint8_t))
        if index_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for index data")
        for i in range(num_faces):
            memcpy(index_data + (i * f_size), ai_faces[i].mIndices, f_size)
        mesh_ptr.index_data = index_data
        mesh_ptr.index_data_size = index_data_size

        aiReleaseImport(ai_scene)

    cpdef void delete(self) except *:
        cdef:
            MeshC *mesh_ptr
        mesh_ptr = self.get_ptr()
        free(mesh_ptr.vertex_data)
        free(mesh_ptr.index_data)
        self.manager.delete(self.handle)
        self.handle = 0