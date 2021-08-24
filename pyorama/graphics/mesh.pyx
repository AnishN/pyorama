cdef MeshC *mesh_get_ptr(Handle mesh) except *:
    return <MeshC *>graphics.slots.c_get_ptr(mesh)

cpdef Handle mesh_create_from_file(bytes file_path) except *:
    cdef:
        Handle mesh
        MeshC *mesh_ptr
        aiScene *ai_scene
        aiMesh *ai_mesh
        aiFace *ai_face
        bytes ai_error
        uint32_t ai_flags = (
            #aiProcess_CalcTangentSpace | 
            aiProcess_Triangulate | 
            aiProcess_JoinIdenticalVertices | 
            aiProcess_SortByPType
        )

        size_t num_meshes
        size_t num_vertices
        size_t num_faces
        size_t num_indices
        uint8_t *vertices
        uint8_t *indices
        uint32_t *indices_32
        size_t i, j, k
        
    ai_scene = aiImportFile(<char *>file_path, ai_flags)
    if ai_scene == NULL:
        ai_error = aiGetErrorString()
        raise ValueError("Mesh: {0}".format(ai_error.decode("utf-8")))

    num_meshes = ai_scene.mNumMeshes
    if num_meshes == 0:
        raise ValueError("Mesh: imported file contains no meshes.")
    elif num_meshes > 1:
        raise ValueError("Mesh: imported file contains multiple meshes.")
    
    ai_mesh = ai_scene.mMeshes[0]
    num_vertices = ai_mesh.mNumVertices
    num_faces = ai_mesh.mNumFaces
    if num_vertices == 0:
        raise ValueError("Mesh: no vertices found")
    if num_faces == 0:
        raise ValueError("Mesh: no faces/indices found.")
    
    #TODO: support more than just raw vertex positions
    vertices = <uint8_t *>calloc(num_vertices, sizeof(Vec3C))
    if vertices == NULL:
        raise MemoryError("Mesh: could not allocate vertices")

    #TODO: cut index buffer to uint16_t whenever possible
    indices = <uint8_t *>calloc(num_faces * 3, sizeof(uint32_t))
    if indices == NULL:
        raise MemoryError("Mesh: count not allocate indices")

    
    #copy in the data from assimp structs
    memcpy(vertices, ai_mesh.mVertices, num_vertices * sizeof(Vec3C))
    indices_32 = <uint32_t *>indices
    for i in range(num_faces):
        ai_face = &ai_mesh.mFaces[i]
        #ai_mesh.mFaces.mNumIndices == 3 since we are triangulating!
        for j in range(3):
            k = i * 3 + j
            #print(i, j, k, ai_face.mIndices[j])
            indices_32[k] = ai_face.mIndices[j]

    aiReleaseImport(ai_scene)

    mesh = graphics.slots.c_create(GRAPHICS_SLOT_MESH)
    mesh_ptr = mesh_get_ptr(mesh)
    mesh_ptr.vertices = vertices
    mesh_ptr.num_vertices = num_vertices
    mesh_ptr.vertex_size = sizeof(Vec3C)#TODO: support more than just position
    mesh_ptr.indices = indices
    mesh_ptr.num_indices = num_faces * 3
    mesh_ptr.index_size = sizeof(uint32_t)#TODO: support more than just uint32_t indices
    
    return mesh

cpdef Buffer mesh_get_vertices(Handle mesh):
    cdef:
        MeshC *mesh_ptr
        Buffer vertices
    
    mesh_ptr = mesh_get_ptr(mesh)
    vertices = Buffer()
    vertices.c_init_from_ptr(b"=fff", mesh_ptr.vertices, mesh_ptr.num_vertices)
    return vertices
    
cpdef Buffer mesh_get_indices(Handle mesh):
    cdef:
        MeshC *mesh_ptr
        Buffer vertices
    
    mesh_ptr = mesh_get_ptr(mesh)
    vertices = Buffer()
    vertices.c_init_from_ptr(b"=I", mesh_ptr.indices, mesh_ptr.num_indices)
    return vertices

cpdef void mesh_delete(Handle mesh) except *:
    cdef:
        MeshC *mesh_ptr
    
    mesh_ptr = mesh_get_ptr(mesh)
    free(mesh_ptr.vertices); mesh_ptr.vertices = NULL
    mesh_ptr.num_vertices = 0
    mesh_ptr.vertex_size = 0
    free(mesh_ptr.indices); mesh_ptr.indices = NULL
    mesh_ptr.num_indices = 0
    mesh_ptr.index_size = 0
    graphics.slots.c_delete(mesh)