DEF ImGuiMouseCursor_COUNT = 8

cdef:
    SDL_Window *g_Window = NULL
    uint64_t g_Time = 0
    bint[3] g_MousePressed = [False, False, False]
    SDL_Cursor *g_MouseCursors[ImGuiMouseCursor_COUNT]
    char *g_ClipboardTextData = NULL
    bint g_MouseCanUseGlobalState = True

cdef void ImGui_ImplSDL2_MapKeys():
    cdef ImGuiIO *io = igGetIO()
    io.KeyMap[<size_t>ImGuiKey_Tab] = SDL_SCANCODE_TAB
    io.KeyMap[<size_t>ImGuiKey_LeftArrow] = SDL_SCANCODE_LEFT
    io.KeyMap[<size_t>ImGuiKey_RightArrow] = SDL_SCANCODE_RIGHT
    io.KeyMap[<size_t>ImGuiKey_UpArrow] = SDL_SCANCODE_UP
    io.KeyMap[<size_t>ImGuiKey_DownArrow] = SDL_SCANCODE_DOWN
    io.KeyMap[<size_t>ImGuiKey_PageUp] = SDL_SCANCODE_PAGEUP
    io.KeyMap[<size_t>ImGuiKey_PageDown] = SDL_SCANCODE_PAGEDOWN
    io.KeyMap[<size_t>ImGuiKey_Home] = SDL_SCANCODE_HOME
    io.KeyMap[<size_t>ImGuiKey_End] = SDL_SCANCODE_END
    io.KeyMap[<size_t>ImGuiKey_Insert] = SDL_SCANCODE_INSERT
    io.KeyMap[<size_t>ImGuiKey_Delete] = SDL_SCANCODE_DELETE
    io.KeyMap[<size_t>ImGuiKey_Backspace] = SDL_SCANCODE_BACKSPACE
    io.KeyMap[<size_t>ImGuiKey_Space] = SDL_SCANCODE_SPACE
    io.KeyMap[<size_t>ImGuiKey_Enter] = SDL_SCANCODE_RETURN
    io.KeyMap[<size_t>ImGuiKey_Escape] = SDL_SCANCODE_ESCAPE
    io.KeyMap[<size_t>ImGuiKey_KeyPadEnter] = SDL_SCANCODE_KP_ENTER
    io.KeyMap[<size_t>ImGuiKey_A] = SDL_SCANCODE_A
    io.KeyMap[<size_t>ImGuiKey_C] = SDL_SCANCODE_C
    io.KeyMap[<size_t>ImGuiKey_V] = SDL_SCANCODE_V
    io.KeyMap[<size_t>ImGuiKey_X] = SDL_SCANCODE_X
    io.KeyMap[<size_t>ImGuiKey_Y] = SDL_SCANCODE_Y
    io.KeyMap[<size_t>ImGuiKey_Z] = SDL_SCANCODE_Z

cdef void ImGui_ImplSDL2_MapCursors():
    cdef ImGuiIO *io = igGetIO()
    g_MouseCursors[<size_t>ImGuiMouseCursor_Arrow] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_ARROW)
    g_MouseCursors[<size_t>ImGuiMouseCursor_TextInput] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_IBEAM)
    g_MouseCursors[<size_t>ImGuiMouseCursor_ResizeAll] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_SIZEALL)
    g_MouseCursors[<size_t>ImGuiMouseCursor_ResizeNS] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_SIZENS)
    g_MouseCursors[<size_t>ImGuiMouseCursor_ResizeEW] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_SIZEWE)
    g_MouseCursors[<size_t>ImGuiMouseCursor_ResizeNESW] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_SIZENESW)
    g_MouseCursors[<size_t>ImGuiMouseCursor_ResizeNWSE] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_SIZENWSE)
    g_MouseCursors[<size_t>ImGuiMouseCursor_Hand] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_HAND)
    g_MouseCursors[<size_t>ImGuiMouseCursor_NotAllowed] = SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_NO)

cdef float ImGui_ImplSDL2_GetAxisValue(uint16_t value, bint direction):
    cdef int dead_zone = 8000
    if direction:#up or right
        if value < dead_zone: return 0.0
        else: return <float>(value - dead_zone) / (32767 - dead_zone)
    else:#return down or left
        if value > -dead_zone: return 0.0
        else: return <float>(-value - dead_zone) / (32768 - dead_zone)

cdef ImGuiNavInput_ ImGui_ImplSDL2_ButtonToNavInput(SDL_GameControllerButton button):
    if button == SDL_CONTROLLER_BUTTON_INVALID: return ImGuiNavInput_COUNT
    elif button == SDL_CONTROLLER_BUTTON_A: return ImGuiNavInput_Activate
    elif button == SDL_CONTROLLER_BUTTON_B: return ImGuiNavInput_Cancel
    elif button == SDL_CONTROLLER_BUTTON_X: return ImGuiNavInput_Menu
    elif button == SDL_CONTROLLER_BUTTON_Y: return ImGuiNavInput_Input
    elif button == SDL_CONTROLLER_BUTTON_BACK: return ImGuiNavInput_COUNT
    elif button == SDL_CONTROLLER_BUTTON_GUIDE: return ImGuiNavInput_COUNT
    elif button == SDL_CONTROLLER_BUTTON_START: return ImGuiNavInput_COUNT
    elif button == SDL_CONTROLLER_BUTTON_LEFTSTICK: return ImGuiNavInput_COUNT
    elif button == SDL_CONTROLLER_BUTTON_RIGHTSTICK: return ImGuiNavInput_COUNT
    elif button == SDL_CONTROLLER_BUTTON_LEFTSHOULDER: return ImGuiNavInput_FocusPrev#what about ImGuiNavInput_TweakSlow
    elif button == SDL_CONTROLLER_BUTTON_RIGHTSHOULDER: return ImGuiNavInput_FocusNext#what about ImGuiNavInput_TweakFast
    elif button == SDL_CONTROLLER_BUTTON_DPAD_UP: return ImGuiNavInput_DpadUp
    elif button == SDL_CONTROLLER_BUTTON_DPAD_DOWN: return ImGuiNavInput_DpadDown
    elif button == SDL_CONTROLLER_BUTTON_DPAD_LEFT: return ImGuiNavInput_DpadLeft
    elif button == SDL_CONTROLLER_BUTTON_DPAD_RIGHT: return ImGuiNavInput_DpadRight
    elif button == SDL_CONTROLLER_BUTTON_MAX: return ImGuiNavInput_COUNT

cdef void ImGui_ImplSDL2_MapClipboard():
    cdef:
        ImGuiIO *io

    io = igGetIO()
    io.SetClipboardTextFn = ImGui_ImplSDL2_SetClipboardText
    io.GetClipboardTextFn = ImGui_ImplSDL2_GetClipboardText
    io.ClipboardUserData = NULL

cdef bint ImGui_ImplSDL2_Init(SDL_Window *window):
    cdef:
        ImGuiIO *io
        SDL_SysWMinfo *wmi
        bgfx_platform_data_t pd
    
    global g_Window, g_Time, g_MousePressed, g_MouseCursors, g_ClipboardTextData, g_MouseCanUseGlobalState
    
    g_Window = window

    io = igGetIO()
    io.BackendFlags |= ImGuiBackendFlags_HasMouseCursors
    io.BackendFlags |= ImGuiBackendFlags_HasSetMousePos
    io.BackendPlatformName = b"imgui_impl_sdl"
    g_MouseCanUseGlobalState = strncmp(SDL_GetCurrentVideoDriver(), "wayland", 7) != 0

    ImGui_ImplSDL2_MapKeys()
    ImGui_ImplSDL2_MapCursors()
    ImGui_ImplSDL2_MapClipboard()
    
    wmi = bgfx_fetch_wmi()
    bgfx_get_platform_data_from_window(&pd, wmi, window)
    io.ImeWindowHandle = pd.nwh
    return True

cdef void ImGui_ImplSDL2_Shutdown():
    cdef:
        size_t n
    
    global g_Window, g_Time, g_MousePressed, g_MouseCursors, g_ClipboardTextData, g_MouseCanUseGlobalState

    g_Window = NULL
    if g_ClipboardTextData:
        free(g_ClipboardTextData)
    g_ClipboardTextData = NULL
    for n in range(ImGuiMouseCursor_COUNT):
        SDL_FreeCursor(g_MouseCursors[n])
    memset(g_MouseCursors, 0, sizeof(g_MouseCursors))

cdef void ImGui_ImplSDL2_NewFrame(SDL_Window *window):
    cdef:
        ImGuiIO *io
        int w, h
        int display_w, display_h
        uint64_t frequency
        uint64_t current_time
    
    global g_Window, g_Time, g_MousePressed, g_MouseCursors, g_ClipboardTextData, g_MouseCanUseGlobalState

    io = igGetIO()
    SDL_GetWindowSize(window, &w, &h)
    SDL_GL_GetDrawableSize(window, &display_w, &display_h)
    io.DisplaySize = ImVec2(<float>w, <float>h)
    if w > 0 and h > 0:
        io.DisplayFramebufferScale = ImVec2(
            <float>display_w / w, 
            <float>display_h / h,
        )

    frequency = SDL_GetPerformanceFrequency()
    current_time = SDL_GetPerformanceCounter()
    if g_Time > 0:
        io.DeltaTime = <float>(<double>(current_time - g_Time) / frequency)
    else:
        io.DeltaTime = <float>1.0 / 60.0
    g_Time = current_time

    #ImGui_ImplSDL2_UpdateMousePosAndButtons()
    ImGui_ImplSDL2_UpdateMouseCursor()
    #ImGui_ImplSDL2_UpdateGamepads()

cdef bint ImGui_ImplSDL2_ProcessEvent(SDL_Event *event):
    cdef:
        ImGuiIO *io
        int key
        ImGuiNavInput_ nav_input
        SDL_GameController *pad

    global g_Window, g_Time, g_MousePressed, g_MouseCursors, g_ClipboardTextData, g_MouseCanUseGlobalState
    
    io = igGetIO()
    if event.type == SDL_MOUSEWHEEL:
        if event.wheel.x > 0: io.MouseWheelH += 1
        if event.wheel.x < 0: io.MouseWheelH -= 1
        if event.wheel.y > 0: io.MouseWheel += 1
        if event.wheel.y < 0: io.MouseWheel -= 1
        return True
    elif event.type == SDL_MOUSEBUTTONDOWN:
        if event.button.button == SDL_BUTTON_LEFT: 
            io.MouseDown[0] = True
        if event.button.button == SDL_BUTTON_RIGHT:
            io.MouseDown[1] = True
        if event.button.button == SDL_BUTTON_MIDDLE:
            io.MouseDown[2] = True
        return True
    elif event.type == SDL_MOUSEBUTTONUP:
        if event.button.button == SDL_BUTTON_LEFT: 
            io.MouseDown[0] = False
        if event.button.button == SDL_BUTTON_RIGHT:
            io.MouseDown[1] = False
        if event.button.button == SDL_BUTTON_MIDDLE:
            io.MouseDown[2] = False
        return True
    elif event.type == SDL_MOUSEMOTION:
        io.MousePos = ImVec2(event.motion.x, event.motion.y)
    elif event.type == SDL_TEXTINPUT:
        ImGuiIO_AddInputCharactersUTF8(io, event.text.text)
        return True
    elif event.type in (SDL_KEYDOWN, SDL_KEYUP):
        key = event.key.keysym.scancode
        io.KeysDown[key] = event.type == SDL_KEYDOWN
        io.KeyShift = (SDL_GetModState() & KMOD_SHIFT) != 0
        io.KeyCtrl = (SDL_GetModState() & KMOD_CTRL) != 0
        io.KeyAlt = (SDL_GetModState() & KMOD_ALT) != 0
        return True
    elif event.type == SDL_CONTROLLERDEVICEADDED:
        pad = SDL_GameControllerOpen(0)
        if pad == NULL: io.BackendFlags &= ~ImGuiBackendFlags_HasGamepad
        else: io.BackendFlags |= ImGuiBackendFlags_HasGamepad
    elif event.type == SDL_CONTROLLERDEVICEREMOVED:
        pad = SDL_GameControllerOpen(0)
        if pad == NULL: io.BackendFlags &= ~ImGuiBackendFlags_HasGamepad
        else: io.BackendFlags |= ImGuiBackendFlags_HasGamepad
    elif event.type == SDL_CONTROLLERDEVICEREMAPPED:
        pad = SDL_GameControllerOpen(0)
        if pad == NULL: io.BackendFlags &= ~ImGuiBackendFlags_HasGamepad
        else: io.BackendFlags |= ImGuiBackendFlags_HasGamepad
    elif event.type == SDL_CONTROLLERAXISMOTION:
        if event.caxis.which == 0:
            if event.caxis.axis == SDL_CONTROLLER_AXIS_LEFTX:
                io.NavInputs[<size_t>ImGuiNavInput_LStickLeft] = ImGui_ImplSDL2_GetAxisValue(event.caxis.value, False)
                io.NavInputs[<size_t>ImGuiNavInput_LStickRight] = ImGui_ImplSDL2_GetAxisValue(event.caxis.value, True)
            elif event.caxis.axis == SDL_CONTROLLER_AXIS_LEFTY:
                io.NavInputs[<size_t>ImGuiNavInput_LStickUp] = ImGui_ImplSDL2_GetAxisValue(event.caxis.value, False)
                io.NavInputs[<size_t>ImGuiNavInput_LStickDown] = ImGui_ImplSDL2_GetAxisValue(event.caxis.value, True)
        return True
    elif event.type == SDL_CONTROLLERBUTTONDOWN:
        if event.cbutton.which == 0:
            nav_input = ImGui_ImplSDL2_ButtonToNavInput(<SDL_GameControllerButton>event.cbutton.button)
            if nav_input != ImGuiNavInput_COUNT:
                io.NavInputs[<size_t>nav_input] = True
        return True
    elif event.type == SDL_CONTROLLERBUTTONUP:
        if event.cbutton.which == 0:
            nav_input = ImGui_ImplSDL2_ButtonToNavInput(<SDL_GameControllerButton>event.cbutton.button)
            if nav_input != ImGuiNavInput_COUNT:
                io.NavInputs[<size_t>nav_input] = False
        return True
    return False

cdef char *ImGui_ImplSDL2_GetClipboardText(void* user_data):
    global g_ClipboardTextData
    if g_ClipboardTextData != NULL:
        free(g_ClipboardTextData)
    g_ClipboardTextData = SDL_GetClipboardText()
    return g_ClipboardTextData

cdef void ImGui_ImplSDL2_SetClipboardText(void* user_data, char* text):
    SDL_SetClipboardText(text)

cdef void ImGui_ImplSDL2_UpdateMouseCursor():
    cdef:
        ImGuiIO *io
        ImGuiMouseCursor imgui_cursor
    
    global g_Window, g_Time, g_MousePressed, g_MouseCursors, g_ClipboardTextData, g_MouseCanUseGlobalState

    io = igGetIO()
    if io.ConfigFlags & ImGuiConfigFlags_NoMouseCursorChange:
        return

    imgui_cursor = igGetMouseCursor()
    if io.MouseDrawCursor:
        SDL_ShowCursor(False)
    else:
        if g_MouseCursors[imgui_cursor]:
            SDL_SetCursor(g_MouseCursors[imgui_cursor])
        else:
            SDL_SetCursor(g_MouseCursors[<size_t>ImGuiMouseCursor_Arrow])
        SDL_ShowCursor(True)

cdef void ImGui_ImplSDL2_UpdateGamepads():
    cdef:
        ImGuiIO *io
        #SDL_GameController *pad
    
    global g_Window, g_Time, g_MousePressed, g_MouseCursors, g_ClipboardTextData, g_MouseCanUseGlobalState

    io = igGetIO()
    memset(io.NavInputs, 0, sizeof(io.NavInputs))
    if (io.ConfigFlags & ImGuiConfigFlags_NavEnableGamepad) == 0:
        return