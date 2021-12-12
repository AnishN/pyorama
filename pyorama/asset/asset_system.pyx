cdef class AssetSystem:
    
    def __cinit__(self, str name):
        self.name = name
        self.slots = SlotManager()
        self.slot_sizes = {
            ASSET_SLOT_ASSET_QUEUE: sizeof(AssetQueueC),
            ASSET_SLOT_ASSET_INFO: sizeof(AssetInfoC),
        }
    
    def __dealloc__(self):
        self.name = None

    def init(self, dict config=None):
        self.slots.c_init(self.slot_sizes)
        CHECK_ERROR(str_hash_map_init(&self.assets_map))
        CHECK_ERROR(vector_init(&self.assets_info, sizeof(AssetInfoC)))
        
    def quit(self):
        vector_free(&self.assets_info)
        str_hash_map_free(&self.assets_map)
        self.slots.c_free()

    def update(self):
        cdef:
            SlotMapC *queues
            size_t i
            AssetQueueC *queue
            bytes file_path
            FILE *file_ptr
            void *file_data
            size_t file_size
        
        queues = self.slots.get_slot_map(ASSET_SLOT_ASSET_QUEUE)
        for i in range(queues.items.num_items):
            queue = <AssetQueueC *>vector_get_ptr_unsafe(&queues.items, i)
            #print(i, <uintptr_t>queue)

    cpdef void get_asset(self, bytes asset_name, HandleObject asset) except *:
        asset.handle = str_hash_map_get(&self.assets_map, asset_name, len(asset_name))