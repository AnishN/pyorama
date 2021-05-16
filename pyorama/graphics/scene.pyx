ctypedef SceneC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Scene:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    cdef ItemTypeC *c_get_ptr(self) except *:
        return <ItemTypeC *>self.manager.c_get_ptr(self.handle)

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

    cpdef void create(self) except *:
        cdef:
            SceneC *scene_ptr
            Node root
        self.handle = self.manager.create(ITEM_TYPE)
        scene_ptr = self.c_get_ptr()
        root = Node(self.manager)
        root.create_empty(NODE_TYPE_ROOT)
        scene_ptr.root = root.handle

    cpdef void delete(self) except *:
        cdef:
            SceneC *scene_ptr
            Node root
        scene_ptr = self.c_get_ptr()
        root = Node(self.manager)
        root.handle = scene_ptr.root
        root.delete()
        self.manager.delete(self.handle)
        self.handle = 0
    
    cpdef void get_root_node(self, Node root) except *:
        cdef:
            SceneC *scene_ptr
        scene_ptr = self.c_get_ptr()
        root.manager = self.manager
        root.handle = scene_ptr.root
    
    cpdef void add_child(self, Node parent, Node child) except *:
        """
        Set the child's parent at first (easy part).
        Then iterate through the parent's children and add the new child at the end (hard/slow part).
        """
        cdef:
            NodeC *parent_ptr
            NodeC *child_ptr
            Handle curr_child
            NodeC *curr_child_ptr
        parent_ptr = parent.c_get_ptr()
        child_ptr = child.c_get_ptr()
        child_ptr.parent = parent.handle
        curr_child = parent_ptr.first_child
        if curr_child == 0:
            parent_ptr.first_child = child.handle
        else:
            while True:
                curr_child_ptr = <NodeC *>self.manager.c_get_ptr(curr_child)
                if curr_child_ptr.next_sibling == 0:
                    break
                else:
                    curr_child = curr_child_ptr.next_sibling
            curr_child_ptr = <NodeC *>self.manager.c_get_ptr(curr_child)
            curr_child_ptr.next_sibling = child.handle
            child_ptr.prev_sibling = curr_child

    cpdef void add_children(self, Node parent, list children) except *:
        cdef:
            size_t i
            size_t num_children
            Node child
        num_children = len(children)
        for i in range(num_children):
            child = <Node>children[i]
            self.add_child(parent, child)

    def remove_child(self, Node child):
        cdef:
            NodeC *child_ptr
            NodeC *parent_ptr
            NodeC *prev_sibling_ptr
            NodeC *next_sibling_ptr
            Handle parent
            Handle prev_sibling
            Handle next_sibling
        child_ptr = child.c_get_ptr()
        parent = child_ptr.parent
        prev_sibling = child_ptr.prev_sibling
        next_sibling = child_ptr.next_sibling
        if parent != 0:
            parent_ptr = <NodeC *>self.manager.c_get_ptr(parent)
            if parent_ptr.first_child == child.handle:
                parent_ptr.first_child = next_sibling
            if prev_sibling != 0:
                prev_sibling_ptr = <NodeC *>self.manager.c_get_ptr(prev_sibling)
                prev_sibling_ptr.next_sibling = next_sibling
            if next_sibling != 0:
                next_sibling_ptr = <NodeC *>self.manager.c_get_ptr(next_sibling)
                next_sibling_ptr.prev_sibling = prev_sibling
 
    def remove_children(self, list children):
        cdef:
            size_t i
            size_t num_children
            Node child
        num_children = len(children)
        for i in range(num_children):
            child = <Node>children[i]
            self.remove_child(child)

    cdef void c_update_node_transform(self, Handle node, bint is_dirty) except *:
        cdef:
            NodeC *node_ptr
            Handle parent
            NodeC *parent_ptr
            Handle curr_child
            NodeC *curr_child_ptr
        node_ptr = <NodeC *>self.manager.c_get_ptr(node)
        """
        print(
            node, 
            "parent:", node_ptr.parent,
            "first:", node_ptr.first_child,
            "prev:", node_ptr.prev_sibling,
            "next:", node_ptr.next_sibling,
        )
        """
        is_dirty |= node_ptr.is_dirty
        if is_dirty:
            parent = node_ptr.parent
            if parent:
                parent_ptr = <NodeC *>self.manager.c_get_ptr(parent)
                Mat4.c_dot(&node_ptr.world, &node_ptr.local, &parent_ptr.world)
            node_ptr.is_dirty = False
        curr_child = node_ptr.first_child
        while curr_child:
            self.c_update_node_transform(curr_child, is_dirty)
            curr_child_ptr = <NodeC *>self.manager.c_get_ptr(curr_child)
            curr_child = curr_child_ptr.next_sibling
    
    cdef void c_update_node_transforms(self) except *:
        cdef:
            SceneC *scene_ptr
        scene_ptr = self.c_get_ptr()
        self.c_update_node_transform(scene_ptr.root, False)

    def update(self):
        self.c_update_node_transforms()