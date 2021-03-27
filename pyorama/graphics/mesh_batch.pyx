"""
cpdef Handle mesh_batch_create(self) except *:
        cdef:
            VertexBuffer vbo = VertexBuffer(self)
            IndexBuffer ibo = IndexBuffer(self)
            Handle batch
            MeshBatchC *batch_ptr

        batch = self.mesh_batches.c_create()
        batch_ptr = self.mesh_batch_c_get_ptr(batch)
        vbo.create(self.v_fmt_mesh)
        batch_ptr.vertex_buffer = vbo.handle
        ibo.create(self.i_fmt_mesh)
        batch_ptr.index_buffer = ibo.handle
        return batch

    cpdef void mesh_batch_delete(self, Handle batch) except *:
        self.mesh_batches.c_delete(batch)

    cpdef void mesh_batch_set_meshes(self, Handle batch, Handle[::1] meshes) except *:
        cdef:
            MeshBatchC *batch_ptr
            
        batch_ptr = self.mesh_batch_c_get_ptr(batch)
        if meshes.shape[0] > 65535:
            raise ValueError("MeshBatch: > 65535 meshes not supported")
        batch_ptr.num_meshes = meshes.shape[0]
        memcpy(batch_ptr.meshes, &meshes[0], sizeof(Handle) * batch_ptr.num_meshes)

    cpdef Handle mesh_batch_get_vertex_buffer(self, Handle batch) except *:
        cdef MeshBatchC *batch_ptr
        batch_ptr = self.mesh_batch_c_get_ptr(batch)
        return batch_ptr.vertex_buffer

    cpdef Handle mesh_batch_get_index_buffer(self, Handle batch) except *:
        cdef MeshBatchC *batch_ptr
        batch_ptr = self.mesh_batch_c_get_ptr(batch)
        return batch_ptr.index_buffer

    cdef void _mesh_batch_update(self, Handle batch) except *:
        pass
"""