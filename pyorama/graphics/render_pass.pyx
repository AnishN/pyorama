ctypedef RenderPassC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class RenderPass:
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
        return RenderPass.get_ptr_by_handle(self.manager, self.handle)

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

    cpdef void create(self, Scene scene, Camera camera, Texture positions, Texture colors, Texture depths) except *:
        cdef:
            RenderPassC *pass_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        pass_ptr = self.get_ptr()
        pass_ptr.scene = scene.handle
        pass_ptr.camera = camera.handle
        pass_ptr.positions = positions.handle
        pass_ptr.colors = colors.handle
        pass_ptr.depths = depths.handle
        
        """
        Okay, so camera attached to a node in the scene
        And each mesh is attached to a node
        Same mesh can belong to multiple nodes (saves LOTS of memory in "instancing")
        So a mesh cannot refer to a singular "parent" node

        maybe a type_index for a node would help?
            - but then a node cannot be shared between scenes...
            - node does not know which scene it belongs to...
        get list of nodes with meshes
        get list of nodes with cameras

        #extract meshes
        #extract cameras
        #texture 
        
        #g_buffer.color
        #g_buffer.depth
        #g_buffer.stencil
        """

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0