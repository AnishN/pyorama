cdef class AssetSystem:
    
    def __cinit__(self):
        slot_map_init(&self.asset_queues, ASSET_SLOT_ASSET_QUEUE, sizeof(AssetQueueC))
        slot_map_init(&self.asset_infos, ASSET_SLOT_ASSET_INFO, sizeof(AssetInfoC))
    
    def __dealloc__(self):
        slot_map_free(&self.asset_queues)
        slot_map_free(&self.asset_infos)

    def init(self, dict config=None):
        CHECK_ERROR(str_hash_map_init(&self.assets_map))
        CHECK_ERROR(vector_init(&self.assets_info, sizeof(AssetInfoC)))
        
    def quit(self):
        vector_free(&self.assets_info)
        str_hash_map_free(&self.assets_map)

    def update(self):
        pass

    cpdef void get_asset(self, bytes asset_name, HandleObject asset) except *:
        asset.handle = str_hash_map_get(&self.assets_map, asset_name, len(asset_name))