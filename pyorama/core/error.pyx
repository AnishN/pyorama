cdef void CHECK_ERROR(Error error) except *:
    if error == NO_ERROR:
        return
    elif error == MEMORY_ERROR:
        raise MemoryError("Error: out of memory")
    elif error == INVALID_INDEX_ERROR:
        raise ValueError("Error: invalid index")
    elif error == ITEM_NOT_FOUND_ERROR:
        raise ValueError("Error: item not found")
    elif error == POP_EMPTY_ERROR:
        raise ValueError("Error: cannot pop from empty container")
    elif error == INVALID_HANDLE_ERROR:
        raise ValueError("Error: invalid handle")
    elif error == INVALID_KEY_ERROR:
        raise ValueError("Error: invalid key")
    elif error == NOT_IMPLEMENTED_ERROR:
        raise NotImplementedError("Error: feature not implemented")