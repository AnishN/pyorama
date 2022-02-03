cdef size_t ASSET_QUEUE_DEFAULT_NUM_THREADS = 4

cdef AssetQueueC *c_asset_queue_get_ptr(Handle handle) except *:
    cdef:
        AssetQueueC *ptr
    CHECK_ERROR(slot_map_get_ptr(&asset_system.asset_queues, handle, <void **>&ptr))
    return ptr

cdef Handle c_asset_queue_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&asset_system.asset_queues, &handle))
    return handle

cdef void c_asset_queue_delete(Handle handle) except *:
    slot_map_delete(&asset_system.asset_queues, handle)

cdef class AssetQueue(HandleObject):

    @staticmethod
    cdef AssetQueue c_from_handle(Handle handle):
        cdef AssetQueue obj
        if handle == 0:
            raise ValueError("AssetQueue: invalid handle")
        obj = AssetQueue.__new__(AssetQueue)
        obj.handle = handle
        return obj

    cdef AssetQueueC *c_get_ptr(self) except *:
        return c_asset_queue_get_ptr(self.handle)
    
    @staticmethod
    def init_create(size_t num_threads=ASSET_QUEUE_DEFAULT_NUM_THREADS):
        cdef:
            AssetQueue asset_queue

        asset_queue = AssetQueue.__new__(AssetQueue)
        asset_queue.create(num_threads)
        return asset_queue

    cpdef void create(self, size_t num_threads=ASSET_QUEUE_DEFAULT_NUM_THREADS) except *:
        cdef:
            AssetQueueC *queue_ptr

        self.handle = c_asset_queue_create()
        queue_ptr = self.c_get_ptr()
        queue_ptr.num_threads = num_threads
        queue_ptr.threads = <pthread_t *>calloc(num_threads, sizeof(pthread_t))
        CHECK_ERROR(vector_init(&queue_ptr.assets, sizeof(AssetQueueItemC)))
        #queue_ptr.thread_args = <ThreadArgsC *>calloc(num_threads, sizeof(ThreadArgsC))

    cpdef void add_asset(self, AssetType type_, bytes name, bytes path, dict options=None) except *:
        cdef:
            AssetQueueC *queue_ptr
            size_t name_len = len(name)
            size_t path_len = len(path)
            AssetQueueItemC item
            Handle asset_id
        
        item.path = <char *>calloc(sizeof(char), path_len + 1)
        if item.path == NULL:
            raise MemoryError()
        memcpy(item.path, <char *>path, path_len)
        item.path_len = path_len

        item.name = <char *>calloc(sizeof(char), name_len + 1)
        if item.name == NULL:
            raise MemoryError()
        memcpy(item.name, <char *>name, name_len)
        item.name_len = name_len
        
        item.type_ = type_
        if item.type_ == ASSET_TYPE_IMAGE:
            item.asset_id = c_image_create()
        elif item.type_ == ASSET_TYPE_MESH:
            item.asset_id = c_mesh_create()
        elif item.type_ in (ASSET_TYPE_BINARY_SHADER, ASSET_TYPE_SOURCE_SHADER):
            item.asset_id = c_shader_create()

        queue_ptr = self.c_get_ptr()
        CHECK_ERROR(vector_push(&queue_ptr.assets, &item))

    cpdef void load(self) except *:
        cdef:
            AssetQueueC *queue_ptr
            size_t i
            bint exists
            size_t num_assets
            AssetQueueItemC *item_ptr
            cgltf_options options = [cgltf_file_type_glb]
            cgltf_data *data = NULL
            cgltf_result result
            #ImageC *image_ptr
        
        queue_ptr = self.c_get_ptr()
        num_assets = queue_ptr.assets.num_items
        for i in range(num_assets):
            item_ptr = <AssetQueueItemC *>vector_get_ptr_unsafe(&queue_ptr.assets, i)
            exists = str_hash_map_contains(&asset_system.assets_map, item_ptr.name, item_ptr.name_len)
            print(i, num_assets, item_ptr.name, item_ptr.path, item_ptr.type_, item_ptr.asset_id, exists)
            if exists:
                raise ValueError(item_ptr.name + b" is already included")
            if item_ptr.type_ == ASSET_TYPE_IMAGE:
                load_image(item_ptr.asset_id, item_ptr.path, item_ptr.path_len)
            elif item_ptr.type_ == ASSET_TYPE_MESH:
                result = cgltf_parse_file(&options, item_ptr.path, &data)
                if result == cgltf_result_success:
                    cgltf_free(data)
                else:
                    pass#did not load gltf
            elif item_ptr.type_ == ASSET_TYPE_SOURCE_SHADER:
                pass
            else:
                pass
            str_hash_map_insert(&asset_system.assets_map, item_ptr.name, item_ptr.name_len, item_ptr.asset_id)
    
    cpdef void delete(self) except *:
        cdef:
            AssetQueueC *queue_ptr
            size_t i
            size_t num_assets
            AssetInfoC *asset_ptr

        queue_ptr = self.c_get_ptr()
        num_assets = queue_ptr.assets.num_items
        for i in range(num_assets):
            asset_ptr = <AssetInfoC *>vector_get_ptr_unsafe(&queue_ptr.assets, i)
            free(asset_ptr.path)
        vector_free(&queue_ptr.assets)
        free(queue_ptr.threads)
        queue_ptr.num_threads = 0

        c_asset_queue_delete(self.handle)
        self.handle = 0