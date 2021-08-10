cdef WindowC *window_get_ptr(Handle window) except *:
    return <WindowC *>graphics.slots.c_get_ptr(window)

cpdef Handle window_create(uint16_t width, uint16_t height, bytes title) except *:
    cdef:
        Handle window
        WindowC *window_ptr
        uint64_t window_id
        size_t title_length
        uint32_t clear_flags = BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH | BGFX_CLEAR_STENCIL
        uint32_t debug = BGFX_DEBUG_TEXT
        uint32_t reset = BGFX_RESET_VSYNC
        
    window = graphics.slots.c_create(GRAPHICS_SLOT_WINDOW)
    window_ptr = window_get_ptr(window)
    window_ptr.sdl_ptr = SDL_CreateWindow(
        title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
        width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
    )
    window_ptr.sdl_id = SDL_GetWindowID(window_ptr.sdl_ptr)
    graphics.window_ids.c_insert(window_ptr.sdl_id, window)

    window_ptr.width = width
    window_ptr.height = height
    window_ptr.title = <char *>title
    window_ptr.title_length = len(title)
    bgfx_reset(width, height, reset, BGFX_TEXTURE_FORMAT_BGRA8)
    bgfx_set_debug(debug)
    bgfx_set_view_clear(1, clear_flags, 0x000000FF, 1.0, 0)
    bgfx_touch(0)
    bgfx_frame(False)
    return window

cpdef void window_delete(Handle window) except *:
    cdef:
        WindowC *window_ptr
    
    window_ptr = window_get_ptr(window)
    graphics.window_ids.c_remove(window_ptr.sdl_id)
    SDL_DestroyWindow(window_ptr.sdl_ptr)
    graphics.slots.c_delete(window)

#cpdef void window_load_from_id(Handle window, uint64_t window_id) except *:
#    graphics.window_ids.c_get(window_id)

cpdef uint16_t window_get_width(Handle window) except *:
    return window_get_ptr(window).width

cpdef uint16_t window_get_height(Handle window) except *:
    return window_get_ptr(window).height

cpdef tuple window_get_size(Handle window):
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    return (window_ptr.width, window_ptr.height)

cpdef bytes window_get_title(Handle window):
    return window_get_ptr(window).title

cpdef uint32_t window_get_flags(Handle window) except *:
    return window_get_ptr(window).flags

cpdef uint64_t window_get_id(Handle window) except *:
    return window_get_ptr(window).sdl_id

cpdef void window_set_width(Handle window, uint16_t width) except *:
    window_get_ptr(window).width = width

cpdef void window_set_height(Handle window, uint16_t height) except *:
    window_get_ptr(window).height = height

cpdef void window_set_size(Handle window, uint16_t width, uint16_t height) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    window_ptr.width = width
    window_ptr.height = height

cpdef void window_set_title(Handle window, bytes title) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    window_ptr.title = title
    window_ptr.title_length = len(title)

cpdef void window_set_flags(Handle window, uint32_t flags) except *:
    window_get_ptr(window).flags = flags