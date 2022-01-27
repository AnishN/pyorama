from pyorama.asset.asset_system cimport *
from pyorama.asset.image_loader cimport *
from pyorama.core.handle cimport *
from pyorama.libs.cgltf cimport *
from pyorama.libs.curl cimport *
from pyorama.libs.pthread cimport *
from pyorama.libs.xxhash cimport *

ctypedef struct AssetQueueC:
    Handle handle
    size_t num_threads
    pthread_t *threads
    VectorC assets

ctypedef struct AssetQueueItemC:
    char *name
    size_t name_len
    AssetType type_
    char *path
    size_t path_len
    Handle asset_id

ctypedef struct AssetInfoC:
    Handle handle
    AssetType type_
    char *path
    size_t path_len
    Handle asset_id

cpdef enum AssetType:
    ASSET_TYPE_IMAGE
    ASSET_TYPE_MESH
    ASSET_TYPE_BINARY_SHADER
    ASSET_TYPE_SOURCE_SHADER

cdef class AssetQueue(HandleObject):
    @staticmethod
    cdef AssetQueue c_from_handle(Handle handle)
    cdef AssetQueueC *c_get_ptr(self) except *
    cpdef void create(self, size_t num_threads=*) except *
    cpdef void add_asset(self, AssetType type_, bytes name, bytes path, dict options=*) except *
    #cpdef void add_image(self, bytes name, bytes path, bint flip_y=*) except *
    cpdef void load(self) except *
    cpdef void delete(self) except *