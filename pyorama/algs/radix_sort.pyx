DEF RADIX = 256

cdef list get_data(uint8_t *data, size_t num_items):
    items_list = []
    for i in range(num_items):
        items_list.append(data[i])
    return items_list

cdef void c_radix_sort_u8(uint8_t *items, size_t num_items) nogil:
    cdef:
        size_t i
        uint8_t item
        size_t[RADIX + 1] offsets
        size_t[RADIX + 1] shift_offsets
        size_t offset
        size_t shift_offset

    #offsets are only counts at this point
    memset(offsets, 0, sizeof(size_t) * (RADIX + 1))
    for i in range(num_items):
        item = items[i]
        offsets[item + 1] += 1

    #cumulative sum calculation to make offsets and shifted offsets
    for i in range(RADIX):
        offsets[i + 1] += offsets[i]
        shift_offsets[i] = offsets[i + 1]
    
    for i in range(num_items):
        while True:
            item = items[i]
            offset = offsets[item]
            shift_offset = shift_offsets[item]
            if offset == shift_offset:
                break
            items[i], items[offset] = items[offset], items[i]
            offsets[item] += 1

"""
#this version works but does NOT sort in place!!!
cdef void c_radix_sort_u8(uint8_t *items, size_t num_items) except *:
    cdef:
        size_t i
        uint8_t item
        size_t[RADIX + 1] offsets
        uint8_t *aux
        size_t offset
    
    memset(offsets, 0, sizeof(size_t) * (RADIX + 1))
    for i in range(num_items):
        item = items[i]
        offsets[item + 1] += 1

    for i in range(RADIX):
        offsets[i + 1] += offsets[i]
    
    aux = <uint8_t *>calloc(num_items, sizeof(uint8_t))
    for i in range(num_items):
        item = items[i]
        aux[offsets[item]] = item
        offsets[item] += 1

    for i in range(num_items):
        items[i] = aux[i]
    free(aux)
"""