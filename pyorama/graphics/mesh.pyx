cdef MeshC *mesh_get_ptr(Handle mesh) except *:
    return <MeshC *>graphics.slots.c_get_ptr(mesh)

cpdef Handle mesh_create_from_file(bytes file_path, bint load_tex_coords=True, bint load_normals=True) except *:
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
        size_t vertex_size
        Vec3C *p
        Vec2C *t
        Vec3C *n
        size_t p_size = sizeof(Vec3C)
        size_t t_size = sizeof(Vec2C)
        size_t n_size = sizeof(Vec3C)
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
    vertex_size = (
        sizeof(Vec3C) + 
        sizeof(Vec2C) * load_tex_coords +
        sizeof(Vec3C) * load_normals
    )

    vertices = <uint8_t *>calloc(num_vertices, vertex_size)
    if vertices == NULL:
        raise MemoryError("Mesh: could not allocate vertices")

    #TODO: cut index buffer to uint16_t whenever possible
    indices = <uint8_t *>calloc(num_faces * 3, sizeof(uint32_t))
    if indices == NULL:
        raise MemoryError("Mesh: count not allocate indices")

    j = 0
    for i in range(num_vertices):
        p = &ai_mesh.mVertices[i]
        memcpy(&vertices[j], p, p_size)
        j += p_size
        if load_tex_coords:
            t = <Vec2C *>&ai_mesh.mTextureCoords[0][i]
            memcpy(&vertices[j], t, t_size)
            j += t_size
        if load_normals:
            n = &ai_mesh.mNormals[i]
            memcpy(&vertices[j], n, n_size)
            j += n_size
    
    indices_32 = <uint32_t *>indices
    for i in range(num_faces):
        ai_face = &ai_mesh.mFaces[i]
        for j in range(3):#ai_mesh.mFaces.mNumIndices == 3 since we are triangulating!
            k = i * 3 + j
            #print(i, j, k, ai_face.mIndices[j])
            indices_32[k] = ai_face.mIndices[j]

    aiReleaseImport(ai_scene)

    mesh = graphics.slots.c_create(GRAPHICS_SLOT_MESH)
    mesh_ptr = mesh_get_ptr(mesh)
    mesh_ptr.vertices = vertices
    mesh_ptr.num_vertices = num_vertices
    mesh_ptr.vertex_size = vertex_size
    mesh_ptr.indices = indices
    mesh_ptr.num_indices = num_faces * 3
    mesh_ptr.index_size = sizeof(uint32_t)#TODO: support more than just uint32_t indices
    return mesh

cpdef void mesh_get_vertices(Handle mesh, Buffer vertices) except *:
    cdef MeshC *mesh_ptr
    mesh_ptr = mesh_get_ptr(mesh)
    vertices.c_init_from_ptr(mesh_ptr.vertices, mesh_ptr.num_vertices)
    
cpdef void mesh_get_indices(Handle mesh, Buffer indices) except *:
    cdef MeshC *mesh_ptr
    mesh_ptr = mesh_get_ptr(mesh)
    indices.c_init_from_ptr(mesh_ptr.indices, mesh_ptr.num_indices)

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