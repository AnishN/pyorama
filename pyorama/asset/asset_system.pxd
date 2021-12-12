from pyorama cimport app
from pyorama.data.handle cimport *
from pyorama.core.slot_manager cimport *
from pyorama.data.str_hash_map cimport *
from pyorama.data.vector cimport *
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
        str name
        SlotManager slots
        dict slot_sizes
        StrHashMapC assets_map
        VectorC assets_info

    cpdef void get_asset(self, bytes asset_name, HandleObject asset) except *