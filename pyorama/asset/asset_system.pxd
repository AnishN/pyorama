from pyorama cimport app
from pyorama.core.handle cimport *
from pyorama.core.slot_map cimport *
from pyorama.core.str_hash_map cimport *
from pyorama.core.vector cimport *
from pyorama.libs.c cimport *

from pyorama.asset.asset_queue cimport *
from pyorama.asset.image_loader cimport *
from pyorama.asset.mesh_loader cimport *
from pyorama.asset.shader_loader cimport *

cpdef enum AssetSlot:
    ASSET_SLOT_ASSET_QUEUE
    ASSET_SLOT_ASSET_INFO

cdef class AssetSystem:
    cdef:
        SlotMapC asset_queues
        SlotMapC asset_infos
        StrHashMapC assets_map
        VectorC assets_info

    cpdef void get_asset(self, bytes asset_name, HandleObject asset) except *