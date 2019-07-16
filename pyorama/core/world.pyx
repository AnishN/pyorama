cdef class World:

    def __init__(self):
        self.entities = CompMap()
        self.systems = []

    cpdef void init(self, size_t max_entities) except *:
        self.entities.init(max_entities, 0, sizeof(EntityInfo), b"256t256Q")
        self.max_entities = max_entities
        self.systems = []

    cpdef void free(self) except *:
        cdef:
            CompInfo *info
            size_t i

        self.entities.free()
        self.max_entities = 0

        for i in range(256):
            info = &self.comps[i]
            if info.is_registered:
                (<CompMap>info.comp_map).free()
                Py_XDECREF(info.comp_map)
                info.comp_map = NULL
    
    cpdef void register_comp_type(self, CompType comp_type, size_t max_comps, size_t comp_size, bytes comp_format) except *:
        cdef:
            CompInfo *info
            CompMap comp_map

        info = &self.comps[comp_type]
        if info.is_registered:
            raise ValueError("World: CompType already registered")
        info.format_length = PyBytes_Size(comp_format)#does NOT include \0
        info.format = <char *>malloc(info.format_length + 1)
        if info.format == NULL:
            raise ValueError("World: CompType format string cannot be allocated")
        strcpy(info.format, comp_format)
        info.size = comp_size
        info.is_registered = True
        info.comp_map = NULL

        comp_map = CompMap.__new__(CompMap)
        comp_map.init(max_comps, comp_type, comp_size, comp_format)
        info.comp_map = <PyObject *>comp_map
        Py_XINCREF(info.comp_map)
    
    cpdef size_t get_comp_type_size(self, CompType comp_type) except 0:
        cdef CompInfo *info
        
        info = &self.comps[comp_type]
        if not info.is_registered:
            raise ValueError("World: CompType not registered")
        return info.size

    cpdef bytes get_comp_type_format(self, CompType comp_type):
        cdef:
            CompInfo *info
            bytes out

        info = &self.comps[comp_type]
        if not info.is_registered:
            raise ValueError("World: CompType not registered")
        out = info.format[:info.format_length]
        return out

    cpdef bint is_comp_type_registered(self, CompType comp_type):
        cdef CompInfo *info
        
        info = &self.comps[comp_type]
        return info.is_registered

    cpdef void register_comp_group_type(self, CompGroupType comp_group_type, list comp_types) except *:
        cdef:
            size_t i
            size_t n
            CompType comp_type
            CompGroupInfo *info
            bint comp_type_check
        
        comp_types = sorted(comp_types)
        info = &self.comp_groups[comp_group_type]
        if info.is_registered:
            raise ValueError("World: CompGroupType already registered")

        #Check if each CompType is registered BEFORE allocating
        n = len(comp_types)
        for i in range(n):
            comp_type = <CompType>comp_types[i]
            info.comp_types[i] = comp_type
            comp_type_check = self.is_comp_type_registered(comp_type)
            if not comp_type_check:
                raise ValueError("World: CompType not registered")
        
        info.comps = <Comp *>calloc(self.max_entities * n, sizeof(Comp))
        if info.comps == NULL:
            raise MemoryError("World: CompGroupType data cannot be allocated")

        info.num_comp_types = n
        info.is_registered = True
        
    cpdef Comp create_comp(self, CompType comp_type) except 0:
        cdef CompInfo *info

        info = &self.comps[comp_type]
        if not info.is_registered:
            raise ValueError("World: CompType not registered")
        return (<CompMap>info.comp_map).create()

    cpdef int delete_comp(self, Comp comp) except -1:
        cdef:
            CompType comp_type
            CompInfo *info

        comp_type = handle_get_type(&comp)
        info = &self.comps[comp_type]
        if not info.is_registered:
            raise ValueError("World: CompType not registered")
        return (<CompMap>info.comp_map).delete(comp)

    cpdef list get_comp_group(self, CompGroupType comp_group_type):
        cdef:
            CompGroupInfo *group
            list out
            size_t i
            size_t n
            CompType comp_type

        group = &self.comp_groups[comp_group_type]
        n = group.num_comp_types
        out = [None for i in range(n)]
        for i in range(n):
            comp_type = group.comp_types[i]
            out[i] = comp_type
        return out

    cpdef Comp[:, ::1] get_comp_group_data(self, CompGroupType comp_group_type) except *:
        cdef:
            CompGroupInfo *group
            Comp[:, ::1] out

        group = &self.comp_groups[comp_group_type]
        if group.num_comp_types == 0 or group.num_matches == 0:
            return None
        out = <Comp[:group.num_matches, :group.num_comp_types]>group.comps
        #out = <Comp[:self.max_entities, :group.num_comp_types]>group.comps
        return out

    cpdef Entity create_entity(self) except 0:
        return self.entities.create()

    cpdef int delete_entity(self, Entity entity) except -1:
        self.entities.delete(entity)

    cpdef int attach_comp(self, Entity entity, Comp comp) except -1:
        cdef:
            bint entity_check
            EntityInfo *entity_info
            bint comp_check
            CompInfo *comp_info
            CompType comp_type
        
        #Check if the entity is valid
        entity_check = self.entities.c_is_comp_valid(entity)
        if not entity_check:
            raise ValueError("World: cannot attach Comp to invalid Entity")

        #Check if the comp is valid
        comp_type = handle_get_type(&comp)
        comp_info = &self.comps[comp_type]
        comp_check = (<CompMap>comp_info.comp_map).c_is_comp_valid(comp)
        if not comp_check:
            raise ValueError("World: cannot attach invalid Comp to Entity")
        
        #Update the entity's comp_mask and comp properties
        entity_info = <EntityInfo *>self.entities.c_get(entity)
        comp_mask_set_bit_on(&entity_info.comp_mask, comp_type)
        entity_info.comps[comp_type] = comp

    cpdef int detach_comp(self, Entity entity, Comp comp) except -1:
        cdef:
            bint entity_check
            EntityInfo *entity_info
            bint comp_check
            CompInfo *comp_info
            CompType comp_type
        
        #Check if the entity is valid
        entity_check = self.entities.c_is_comp_valid(entity)
        if not entity_check:
            raise ValueError("World: cannot attach Comp to invalid Entity")

        #Check if the comp is valid
        comp_type = handle_get_type(&comp)
        comp_info = &self.comps[comp_type]
        comp_check = (<CompMap>comp_info.comp_map).c_is_comp_valid(comp)
        if not comp_check:
            raise ValueError("World: cannot attach invalid Comp to Entity")
        
        #Update the entity's comp_mask and comp properties
        entity_info = <EntityInfo *>self.entities.c_get(entity)
        comp_mask_set_bit_off(&entity_info.comp_mask, comp_type)
        entity_info.comps[comp_type] = 0

    cpdef void attach_system(self, System system, dict comp_group_types) except *:
        cdef:
            str group_name
            CompGroupType group_type
            CompGroupInfo *group_info

        if system.world != None:
            raise ValueError("World: System already attached to a World")
        
        for group_name in comp_group_types:
            group_type = <CompGroupType>comp_group_types[group_name]
            info = &self.comp_groups[group_type]
            if not info.is_registered:
                raise ValueError("World: CompGroupType not registered")

        system.world = self
        system.comp_group_types = comp_group_types

    cpdef void detach_system(self, System system) except *:
        if system.world == None:
            raise ValueError("World: System not attached to a World")
        system.world = None
        system.comp_group_types = {}

    cpdef void set_system_update_order(self, list systems) except *:
        cdef:
            size_t i
            size_t num_systems
            System system

        num_systems = len(systems)
        for i in range(num_systems):
            system = <System>systems[i]
            if system.world != self:
                raise ValueError("World: System not attached to this World")
        self.systems = systems
    
    cpdef void update(self) except *:
        cdef:
            size_t i, j, k
            size_t group_index
            EntityInfo *entity
            CompGroupInfo *group
            CompType comp_type
            bint is_group_match
            bint is_type_match
            Comp comp
            size_t num_systems
            System system

        #for each CompGroupType
        for i in range(65536):
            group = &self.comp_groups[i]
            if group.is_registered:
                group.num_matches = 0
                #need to find all matches for a group
                for j in range(self.entities.num_comps):
                    is_group_match = True
                    entity = <EntityInfo *>self.entities.comps.c_get_ptr(j)
                    for k in range(group.num_comp_types):
                        comp_type = group.comp_types[k]
                        is_type_match = comp_mask_get_bit(&entity.comp_mask, comp_type)
                        if not is_type_match:
                            is_group_match = False
                            break
                    if is_group_match:
                        for k in range(group.num_comp_types):
                            comp_type = group.comp_types[k]
                            comp = entity.comps[comp_type]
                            #print(i, j, k, group.num_matches, group.num_comp_types, comp)
                            group.comps[(group.num_matches * group.num_comp_types) + k] = comp
                        group.num_matches += 1

        #Now call all of the system update functions
        num_systems = len(self.systems)
        for i in range(num_systems):
            system = <System>self.systems[i]
            system.update()