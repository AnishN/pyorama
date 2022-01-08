ctypedef enum Error:
    NO_ERROR
    MEMORY_ERROR
    FILE_ERROR
    INVALID_INDEX_ERROR
    ITEM_NOT_FOUND_ERROR
    POP_EMPTY_ERROR
    INVALID_HANDLE_ERROR
    INVALID_KEY_ERROR
    NOT_IMPLEMENTED_ERROR

cdef void CHECK_ERROR(Error error) except *