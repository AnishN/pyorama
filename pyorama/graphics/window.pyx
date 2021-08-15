cdef WindowC *window_get_ptr(Handle window) except *:
    return <WindowC *>graphics.slots.c_get_ptr(window)

cpdef Handle window_create(uint16_t width, uint16_t height, bytes title, uint32_t flags=WINDOW_FLAGS_SHOWN | WINDOW_FLAGS_RESIZABLE) except *:
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
        width, height, flags,
    )
    window_ptr.sdl_id = SDL_GetWindowID(window_ptr.sdl_ptr)
    graphics.window_ids.c_insert(window_ptr.sdl_id, window)

    window_ptr.width = width
    window_ptr.height = height
    window_ptr.title = <char *>title
    window_ptr.title_length = len(title)
    return window

cpdef void window_delete(Handle window) except *:
    cdef:
        WindowC *window_ptr
    
    window_ptr = window_get_ptr(window)
    graphics.window_ids.c_remove(window_ptr.sdl_id)
    SDL_DestroyWindow(window_ptr.sdl_ptr)
    graphics.slots.c_delete(window)

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
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    return SDL_GetWindowFlags(window_ptr.sdl_ptr)

cpdef uint64_t window_get_id(Handle window) except *:
    return window_get_ptr(window).sdl_id

cpdef bint window_is_fullscreen(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_FULLSCREEN

cpdef bint window_is_fullscreen_desktop(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_FULLSCREEN_DESKTOP

cpdef bint window_is_shown(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_SHOWN

cpdef bint window_is_hidden(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_HIDDEN

cpdef bint window_is_borderless(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_BORDERLESS

cpdef bint window_is_resizable(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_RESIZABLE

cpdef bint window_is_minimized(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_MINIMIZED

cpdef bint window_is_maximized(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_MAXIMIZED

cpdef bint window_is_input_grabbed(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_INPUT_GRABBED

cpdef bint window_is_mouse_captured(Handle window) except *:
    return window_get_flags(window) & WINDOW_FLAGS_MOUSE_CAPTURED

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
    cdef:
        WindowC *window_ptr
        bint full_screen
    window_ptr = window_get_ptr(window)
    
    #full_screen
    full_screen = flags & WINDOW_FLAGS_FULLSCREEN or flags & WINDOW_FLAGS_FULLSCREEN_DESKTOP
    if full_screen:
        if flags & WINDOW_FLAGS_FULLSCREEN:
            SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN)
        else:
            SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN_DESKTOP)
    else:
        SDL_SetWindowFullscreen(window_ptr.sdl_ptr, 0)
    
    #show_or_hide
    if flags & WINDOW_FLAGS_SHOWN:
        SDL_ShowWindow(window_ptr.sdl_ptr)
    if flags & WINDOW_FLAGS_HIDDEN:
        SDL_HideWindow(window_ptr.sdl_ptr)

    #borderless
    if flags & WINDOW_FLAGS_BORDERLESS:
        SDL_SetWindowBordered(window_ptr.sdl_ptr, False)
    else:
        SDL_SetWindowBordered(window_ptr.sdl_ptr, True)

    #resizable
    if flags & WINDOW_FLAGS_RESIZABLE:
        SDL_SetWindowResizable(window_ptr.sdl_ptr, True)
    else:
        SDL_SetWindowResizable(window_ptr.sdl_ptr, False)

    #min_max_restore
    if flags & WINDOW_FLAGS_MINIMIZED:
        SDL_MinimizeWindow(window_ptr.sdl_ptr)
    elif flags & WINDOW_FLAGS_MAXIMIZED:
        SDL_MaximizeWindow(window_ptr.sdl_ptr)
    else:
        SDL_RestoreWindow(window_ptr.sdl_ptr)
    
    if flags & WINDOW_FLAGS_INPUT_GRABBED:
        SDL_SetWindowGrab(window_ptr.sdl_ptr, True)
    else:
        SDL_SetWindowGrab(window_ptr.sdl_ptr, False)
    
    #mouse_capture
    if flags & WINDOW_FLAGS_MOUSE_CAPTURED:
        SDL_CaptureMouse(True)
    else:
        SDL_CaptureMouse(False)

cpdef void window_set_fullscreen(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN)
    
cpdef void window_set_fullscreen_desktop(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN_DESKTOP)

cpdef void window_set_shown(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_ShowWindow(window_ptr.sdl_ptr)

cpdef void window_set_hidden(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_HideWindow(window_ptr.sdl_ptr)

cpdef void window_set_borderless(Handle window, bint borderless) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_SetWindowBordered(window_ptr.sdl_ptr, not borderless)

cpdef void window_set_resizable(Handle window, bint resizable) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_SetWindowResizable(window_ptr.sdl_ptr, resizable)
    
cpdef void window_set_minimized(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_MinimizeWindow(window_ptr.sdl_ptr)

cpdef void window_set_maximized(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_MaximizeWindow(window_ptr.sdl_ptr)

cpdef void window_set_restored(Handle window) except *:
    cdef:
        WindowC *window_ptr
    window_ptr = window_get_ptr(window)
    SDL_RestoreWindow(window_ptr.sdl_ptr)

cpdef void window_toggle_fullscreen(Handle window) except *:
    cdef:
        bint is_fullscreen
    is_fullscreen = window_is_fullscreen(window)
    if is_fullscreen: window_set_restored(window)
    else: window_set_fullscreen(window)

cpdef void window_toggle_fullscreen_desktop(Handle window) except *:
    cdef:
        bint is_fullscreen_desktop
    is_fullscreen_desktop = window_is_fullscreen_desktop(window)
    if is_fullscreen_desktop: window_set_restored(window)
    else: window_set_fullscreen_desktop(window)

cpdef void window_toggle_shown(Handle window) except *:
    cdef:
        bint is_shown
    is_shown = window_is_shown(window)
    if is_shown: window_set_hidden(window)
    else: window_set_shown(window)

cpdef void window_toggle_hidden(Handle window) except *:
    cdef:
        bint is_hidden
    is_hidden = window_is_hidden(window)
    if is_hidden: window_set_shown(window)
    else: window_set_hidden(window)
    
cpdef void window_toggle_borderless(Handle window) except *:
    cdef:
        bint is_borderless
    is_borderless = window_is_borderless(window)
    window_set_borderless(window, not is_borderless)
    
cpdef void window_toggle_resizable(Handle window) except *:
    cdef:
        bint is_resizable
    is_resizable = window_is_resizable(window)
    window_set_resizable(window, not is_resizable)

cpdef void window_toggle_minimized(Handle window) except *:
    cdef:
        bint is_minimized
    is_minimized = window_is_minimized(window)
    if is_minimized: window_set_restored(window)
    else: window_set_minimized(window)
    
cpdef void window_toggle_maximized(Handle window) except *:
    cdef:
        bint is_maximized
    is_maximized = window_is_maximized(window)
    if is_maximized: window_set_restored(window)
    else: window_set_maximized(window)