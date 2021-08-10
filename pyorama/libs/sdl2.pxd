from libc.stdint cimport int8_t, int16_t, int32_t, int64_t
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t

cdef extern from "SDL2/SDL.h" nogil:
    cdef enum:
        SDL_INIT_TIMER
        SDL_INIT_AUDIO
        SDL_INIT_VIDEO
        SDL_INIT_JOYSTICK
        SDL_INIT_HAPTIC
        SDL_INIT_GAMECONTROLLER
        SDL_INIT_EVENTS
        SDL_INIT_EVERYTHING
        SDL_INIT_NOPARACHUTE
    int SDL_Init(uint32_t flags)
    int SDL_InitSubSystem(uint32_t flags)
    void SDL_Quit()
    void SDL_QuitSubSystem(uint32_t flags)
    uint64_t SDL_GetPerformanceCounter()
    uint64_t SDL_GetPerformanceFrequency()
    void SDL_Delay(uint32_t ms)
    const char *SDL_GetError()

    bint SDL_SetHint(const char *name, const char *value)
    char *SDL_HINT_NO_SIGNAL_HANDLERS
    char *SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS
    char *SDL_HINT_VIDEO_EXTERNAL_CONTEXT

    enum: SDL_RENDERER_PRESENTVSYNC
    
    #Window Management
    cdef enum:
        SDL_WINDOW_FULLSCREEN
        SDL_WINDOW_FULLSCREEN_DESKTOP
        SDL_WINDOW_OPENGL
        SDL_WINDOW_SHOWN
        SDL_WINDOW_HIDDEN
        SDL_WINDOW_BORDERLESS
        SDL_WINDOW_RESIZABLE
        SDL_WINDOW_MINIMIZED
        SDL_WINDOW_MAXIMIZED
        SDL_WINDOW_INPUT_GRABBED
        SDL_WINDOW_INPUT_FOCUS
        SDL_WINDOW_MOUSE_FOCUS
        SDL_WINDOW_FOREIGN
        SDL_WINDOW_ALLOW_HIGHDPI
        SDL_WINDOW_MOUSE_CAPTURE
        SDL_WINDOW_ALWAYS_ON_TOP
        SDL_WINDOW_SKIP_TASKBAR
        SDL_WINDOW_UTILITY
        SDL_WINDOW_TOOLTIP
        SDL_WINDOW_POPUP_MENU
    
    cdef enum:
        SDL_WINDOWPOS_CENTERED
        SDL_WINDOWPOS_UNDEFINED
    
    ctypedef struct SDL_SysWMinfo:
        pass
    ctypedef struct SDL_Window:
        pass
    ctypedef struct SDL_Renderer:
        pass

    ctypedef struct SDL_Rect:
        int x, y, w, h

    ctypedef void *SDL_GLContext
    SDL_Window *SDL_CreateWindow(char *title, int x, int y, int w, int h, uint32_t flags)
    void SDL_HideWindow(SDL_Window *window)
    void SDL_ShowWindow(SDL_Window *window)
    void SDL_MaximizeWindow(SDL_Window *window)
    void SDL_MinimizeWindow(SDL_Window *window)
    void SDL_RestoreWindow(SDL_Window *window)
    void SDL_RaiseWindow(SDL_Window *window)

    void SDL_SetWindowGrab(SDL_Window *window, bint grabbed)
    SDL_Window *SDL_GetGrabbedWindow()
    bint SDL_GetWindowGrab(SDL_Window *window)

    #int SDL_SetWindowInputFocus(SDL_Window *window)
    #void SDL_SetMouseFocus(SDL_Window *window)
    int SDL_CaptureMouse(bint enabled)

    void SDL_SetWindowPosition(SDL_Window *window, int x, int y)
    void SDL_GetWindowPosition(SDL_Window *window, int *x, int *y)
    void SDL_SetWindowSize(SDL_Window *window, int w, int h)
    void SDL_GetWindowSize(SDL_Window *window, int *w, int *h)
    void SDL_SetWindowTitle(SDL_Window *window, const char *title)
    const char *SDL_GetWindowTitle(SDL_Window *window)
    void SDL_SetWindowIcon(SDL_Window *window, SDL_Surface *icon)

    int SDL_GetNumVideoDisplays()
    int SDL_GetDisplayBounds(int displayIndex, SDL_Rect *rect)
    int SDL_GetDisplayDPI(int displayIndex, float *ddpi, float *hdpi, float *vdpi)

    SDL_Renderer *SDL_CreateRenderer(SDL_Window *window, int index, uint32_t flags)
    int SDL_SetRenderDrawColor(SDL_Renderer *renderer, uint8_t r, uint8_t g, uint8_t b, uint8_t a)
    int SDL_RenderClear(SDL_Renderer *renderer)
    void SDL_RenderPresent(SDL_Renderer *renderer)
    SDL_GLContext SDL_GL_CreateContext(SDL_Window *window)
    uint32_t SDL_GetWindowFlags(SDL_Window *window)
    uint32_t SDL_GetWindowID(SDL_Window *window)
    SDL_Window *SDL_GetWindowFromID(uint32_t id)
    void SDL_SetWindowResizable(SDL_Window *window, bint resizable)
    void SDL_SetWindowFullscreen(SDL_Window *window, uint32_t flags)
    void SDL_SetWindowBordered(SDL_Window *window, bint bordered)
    void SDL_GL_SwapWindow(SDL_Window *window)
    int SDL_GL_SetSwapInterval(int interval)
    int SDL_GL_MakeCurrent(SDL_Window *window, SDL_GLContext context)
    SDL_GLContext SDL_GL_GetCurrentContext()
    
    ctypedef enum SDL_GLattr:
        SDL_GL_RED_SIZE
        SDL_GL_GREEN_SIZE
        SDL_GL_BLUE_SIZE
        SDL_GL_ALPHA_SIZE
        SDL_GL_BUFFER_SIZE
        SDL_GL_DOUBLEBUFFER
        SDL_GL_DEPTH_SIZE
        SDL_GL_STENCIL_SIZE
        SDL_GL_ACCUM_RED_SIZE
        SDL_GL_ACCUM_GREEN_SIZE
        SDL_GL_ACCUM_BLUE_SIZE
        SDL_GL_ACCUM_ALPHA_SIZE
        SDL_GL_STEREO
        SDL_GL_MULTISAMPLEBUFFERS
        SDL_GL_MULTISAMPLESAMPLES
        SDL_GL_ACCELERATED_VISUAL
        SDL_GL_RETAINED_BACKING
        SDL_GL_CONTEXT_MAJOR_VERSION
        SDL_GL_CONTEXT_MINOR_VERSION
        SDL_GL_CONTEXT_EGL
        SDL_GL_CONTEXT_FLAGS
        SDL_GL_CONTEXT_PROFILE_MASK
        SDL_GL_SHARE_WITH_CURRENT_CONTEXT
        SDL_GL_FRAMEBUFFER_SRGB_CAPABLE
        SDL_GL_CONTEXT_RELEASE_BEHAVIOR
        SDL_GL_CONTEXT_RESET_NOTIFICATION
        SDL_GL_CONTEXT_NO_ERROR
    
    ctypedef enum SDL_GLprofile:
        SDL_GL_CONTEXT_PROFILE_CORE
        SDL_GL_CONTEXT_PROFILE_COMPATIBILITY
        SDL_GL_CONTEXT_PROFILE_ES
    
    int SDL_GL_SetAttribute(SDL_GLattr attr, int value)
    int SDL_GL_GetAttribute(SDL_GLattr attr, int *value)
    void SDL_GL_ResetAttributes()
    void SDL_DestroyWindow(SDL_Window *window)
    void SDL_DestroyRenderer(SDL_Renderer *renderer)
    void SDL_GL_DeleteContext(SDL_GLContext context)
    
    
    #Event Handling
    cdef enum: 
        SDL_FIRSTEVENT
        SDL_QUIT
        SDL_APP_TERMINATING
        SDL_APP_LOWMEMORY
        SDL_APP_WILLENTERBACKGROUND
        SDL_APP_DIDENTERBACKGROUND
        SDL_APP_WILLENTERFOREGROUND
        SDL_APP_DIDENTERFOREGROUND
        SDL_WINDOWEVENT
        SDL_SYSWMEVENT
        SDL_KEYDOWN
        SDL_KEYUP
        SDL_TEXTEDITING
        SDL_TEXTINPUT
        SDL_KEYMAPCHANGED
        SDL_MOUSEMOTION
        SDL_MOUSEBUTTONDOWN
        SDL_MOUSEBUTTONUP
        SDL_MOUSEWHEEL
        SDL_JOYAXISMOTION
        SDL_JOYBALLMOTION
        SDL_JOYHATMOTION
        SDL_JOYBUTTONDOWN
        SDL_JOYBUTTONUP
        SDL_JOYDEVICEADDED
        SDL_JOYDEVICEREMOVED
        SDL_CONTROLLERAXISMOTION
        SDL_CONTROLLERBUTTONDOWN
        SDL_CONTROLLERBUTTONUP
        SDL_CONTROLLERDEVICEADDED
        SDL_CONTROLLERDEVICEREMOVED
        SDL_CONTROLLERDEVICEREMAPPED
        SDL_FINGERDOWN
        SDL_FINGERUP
        SDL_FINGERMOTION
        SDL_DOLLARGESTURE
        SDL_DOLLARRECORD
        SDL_MULTIGESTURE
        SDL_CLIPBOARDUPDATE
        SDL_DROPFILE
        SDL_DROPTEXT
        SDL_DROPBEGIN
        SDL_DROPCOMPLETE
        SDL_AUDIODEVICEADDED
        SDL_AUDIODEVICEREMOVED
        SDL_RENDER_TARGETS_RESET
        SDL_RENDER_DEVICE_RESET
        SDL_USEREVENT
        SDL_LASTEVENT
    
    cdef enum:
        SDL_WINDOWEVENT_NONE
        SDL_WINDOWEVENT_SHOWN
        SDL_WINDOWEVENT_HIDDEN
        SDL_WINDOWEVENT_EXPOSED
        SDL_WINDOWEVENT_MOVED
        SDL_WINDOWEVENT_RESIZED
        SDL_WINDOWEVENT_SIZE_CHANGED
        SDL_WINDOWEVENT_MINIMIZED
        SDL_WINDOWEVENT_MAXIMIZED
        SDL_WINDOWEVENT_RESTORED
        SDL_WINDOWEVENT_ENTER
        SDL_WINDOWEVENT_LEAVE
        SDL_WINDOWEVENT_FOCUS_GAINED
        SDL_WINDOWEVENT_FOCUS_LOST
        SDL_WINDOWEVENT_CLOSE
        SDL_WINDOWEVENT_TAKE_FOCUS
        SDL_WINDOWEVENT_HIT_TEST
    
    ctypedef enum SDL_Scancode:
        SDL_SCANCODE_UNKNOWN = 0
        SDL_SCANCODE_A = 4
        SDL_SCANCODE_B = 5
        SDL_SCANCODE_C = 6
        SDL_SCANCODE_D = 7
        SDL_SCANCODE_E = 8
        SDL_SCANCODE_F = 9
        SDL_SCANCODE_G = 10
        SDL_SCANCODE_H = 11
        SDL_SCANCODE_I = 12
        SDL_SCANCODE_J = 13
        SDL_SCANCODE_K = 14
        SDL_SCANCODE_L = 15
        SDL_SCANCODE_M = 16
        SDL_SCANCODE_N = 17
        SDL_SCANCODE_O = 18
        SDL_SCANCODE_P = 19
        SDL_SCANCODE_Q = 20
        SDL_SCANCODE_R = 21
        SDL_SCANCODE_S = 22
        SDL_SCANCODE_T = 23
        SDL_SCANCODE_U = 24
        SDL_SCANCODE_V = 25
        SDL_SCANCODE_W = 26
        SDL_SCANCODE_X = 27
        SDL_SCANCODE_Y = 28
        SDL_SCANCODE_Z = 29
        SDL_SCANCODE_1 = 30
        SDL_SCANCODE_2 = 31
        SDL_SCANCODE_3 = 32
        SDL_SCANCODE_4 = 33
        SDL_SCANCODE_5 = 34
        SDL_SCANCODE_6 = 35
        SDL_SCANCODE_7 = 36
        SDL_SCANCODE_8 = 37
        SDL_SCANCODE_9 = 38
        SDL_SCANCODE_0 = 39
        SDL_SCANCODE_RETURN = 40
        SDL_SCANCODE_ESCAPE = 41
        SDL_SCANCODE_BACKSPACE = 42
        SDL_SCANCODE_TAB = 43
        SDL_SCANCODE_SPACE = 44
        SDL_SCANCODE_MINUS = 45
        SDL_SCANCODE_EQUALS = 46
        SDL_SCANCODE_LEFTBRACKET = 47
        SDL_SCANCODE_RIGHTBRACKET = 48
        SDL_SCANCODE_BACKSLASH = 49
        SDL_SCANCODE_NONUSHASH = 50
        SDL_SCANCODE_SEMICOLON = 51
        SDL_SCANCODE_APOSTROPHE = 52
        SDL_SCANCODE_GRAVE = 53
        SDL_SCANCODE_COMMA = 54
        SDL_SCANCODE_PERIOD = 55
        SDL_SCANCODE_SLASH = 56
        SDL_SCANCODE_CAPSLOCK = 57
        SDL_SCANCODE_F1 = 58
        SDL_SCANCODE_F2 = 59
        SDL_SCANCODE_F3 = 60
        SDL_SCANCODE_F4 = 61
        SDL_SCANCODE_F5 = 62
        SDL_SCANCODE_F6 = 63
        SDL_SCANCODE_F7 = 64
        SDL_SCANCODE_F8 = 65
        SDL_SCANCODE_F9 = 66
        SDL_SCANCODE_F10 = 67
        SDL_SCANCODE_F11 = 68
        SDL_SCANCODE_F12 = 69
        SDL_SCANCODE_PRINTSCREEN = 70
        SDL_SCANCODE_SCROLLLOCK = 71
        SDL_SCANCODE_PAUSE = 72
        SDL_SCANCODE_INSERT = 73
        SDL_SCANCODE_HOME = 74
        SDL_SCANCODE_PAGEUP = 75
        SDL_SCANCODE_DELETE = 76
        SDL_SCANCODE_END = 77
        SDL_SCANCODE_PAGEDOWN = 78
        SDL_SCANCODE_RIGHT = 79
        SDL_SCANCODE_LEFT = 80
        SDL_SCANCODE_DOWN = 81
        SDL_SCANCODE_UP = 82
        SDL_SCANCODE_NUMLOCKCLEAR = 83
        SDL_SCANCODE_KP_DIVIDE = 84
        SDL_SCANCODE_KP_MULTIPLY = 85
        SDL_SCANCODE_KP_MINUS = 86
        SDL_SCANCODE_KP_PLUS = 87
        SDL_SCANCODE_KP_ENTER = 88
        SDL_SCANCODE_KP_1 = 89
        SDL_SCANCODE_KP_2 = 90
        SDL_SCANCODE_KP_3 = 91
        SDL_SCANCODE_KP_4 = 92
        SDL_SCANCODE_KP_5 = 93
        SDL_SCANCODE_KP_6 = 94
        SDL_SCANCODE_KP_7 = 95
        SDL_SCANCODE_KP_8 = 96
        SDL_SCANCODE_KP_9 = 97
        SDL_SCANCODE_KP_0 = 98
        SDL_SCANCODE_KP_PERIOD = 99
        SDL_SCANCODE_NONUSBACKSLASH = 100
        SDL_SCANCODE_APPLICATION = 101
        SDL_SCANCODE_POWER = 102
        SDL_SCANCODE_KP_EQUALS = 103
        SDL_SCANCODE_F13 = 104
        SDL_SCANCODE_F14 = 105
        SDL_SCANCODE_F15 = 106
        SDL_SCANCODE_F16 = 107
        SDL_SCANCODE_F17 = 108
        SDL_SCANCODE_F18 = 109
        SDL_SCANCODE_F19 = 110
        SDL_SCANCODE_F20 = 111
        SDL_SCANCODE_F21 = 112
        SDL_SCANCODE_F22 = 113
        SDL_SCANCODE_F23 = 114
        SDL_SCANCODE_F24 = 115
        SDL_SCANCODE_EXECUTE = 116
        SDL_SCANCODE_HELP = 117
        SDL_SCANCODE_MENU = 118
        SDL_SCANCODE_SELECT = 119
        SDL_SCANCODE_STOP = 120
        SDL_SCANCODE_AGAIN = 121
        SDL_SCANCODE_UNDO = 122
        SDL_SCANCODE_CUT = 123
        SDL_SCANCODE_COPY = 124
        SDL_SCANCODE_PASTE = 125
        SDL_SCANCODE_FIND = 126
        SDL_SCANCODE_MUTE = 127
        SDL_SCANCODE_VOLUMEUP = 128
        SDL_SCANCODE_VOLUMEDOWN = 129
        SDL_SCANCODE_LOCKINGCAPSLOCK = 130
        SDL_SCANCODE_LOCKINGNUMLOCK = 131
        SDL_SCANCODE_LOCKINGSCROLLLOCK = 132
        SDL_SCANCODE_KP_COMMA = 133
        SDL_SCANCODE_KP_EQUALSAS400 = 134
        SDL_SCANCODE_INTERNATIONAL1 = 135
        SDL_SCANCODE_INTERNATIONAL2 = 136
        SDL_SCANCODE_INTERNATIONAL3 = 137
        SDL_SCANCODE_INTERNATIONAL4 = 138
        SDL_SCANCODE_INTERNATIONAL5 = 139
        SDL_SCANCODE_INTERNATIONAL6 = 140
        SDL_SCANCODE_INTERNATIONAL7 = 141
        SDL_SCANCODE_INTERNATIONAL8 = 142
        SDL_SCANCODE_INTERNATIONAL9 = 143
        SDL_SCANCODE_LANG1 = 144
        SDL_SCANCODE_LANG2 = 145
        SDL_SCANCODE_LANG3 = 146
        SDL_SCANCODE_LANG4 = 147
        SDL_SCANCODE_LANG5 = 148
        SDL_SCANCODE_LANG6 = 149
        SDL_SCANCODE_LANG7 = 150
        SDL_SCANCODE_LANG8 = 151
        SDL_SCANCODE_LANG9 = 152
        SDL_SCANCODE_ALTERASE = 153
        SDL_SCANCODE_SYSREQ = 154
        SDL_SCANCODE_CANCEL = 155
        SDL_SCANCODE_CLEAR = 156
        SDL_SCANCODE_PRIOR = 157
        SDL_SCANCODE_RETURN2 = 158
        SDL_SCANCODE_SEPARATOR = 159
        SDL_SCANCODE_OUT = 160
        SDL_SCANCODE_OPER = 161
        SDL_SCANCODE_CLEARAGAIN = 162
        SDL_SCANCODE_CRSEL = 163
        SDL_SCANCODE_EXSEL = 164
        SDL_SCANCODE_KP_00 = 176
        SDL_SCANCODE_KP_000 = 177
        SDL_SCANCODE_THOUSANDSSEPARATOR = 178
        SDL_SCANCODE_DECIMALSEPARATOR = 179
        SDL_SCANCODE_CURRENCYUNIT = 180
        SDL_SCANCODE_CURRENCYSUBUNIT = 181
        SDL_SCANCODE_KP_LEFTPAREN = 182
        SDL_SCANCODE_KP_RIGHTPAREN = 183
        SDL_SCANCODE_KP_LEFTBRACE = 184
        SDL_SCANCODE_KP_RIGHTBRACE = 185
        SDL_SCANCODE_KP_TAB = 186
        SDL_SCANCODE_KP_BACKSPACE = 187
        SDL_SCANCODE_KP_A = 188
        SDL_SCANCODE_KP_B = 189
        SDL_SCANCODE_KP_C = 190
        SDL_SCANCODE_KP_D = 191
        SDL_SCANCODE_KP_E = 192
        SDL_SCANCODE_KP_F = 193
        SDL_SCANCODE_KP_XOR = 194
        SDL_SCANCODE_KP_POWER = 195
        SDL_SCANCODE_KP_PERCENT = 196
        SDL_SCANCODE_KP_LESS = 197
        SDL_SCANCODE_KP_GREATER = 198
        SDL_SCANCODE_KP_AMPERSAND = 199
        SDL_SCANCODE_KP_DBLAMPERSAND = 200
        SDL_SCANCODE_KP_VERTICALBAR = 201
        SDL_SCANCODE_KP_DBLVERTICALBAR = 202
        SDL_SCANCODE_KP_COLON = 203
        SDL_SCANCODE_KP_HASH = 204
        SDL_SCANCODE_KP_SPACE = 205
        SDL_SCANCODE_KP_AT = 206
        SDL_SCANCODE_KP_EXCLAM = 207
        SDL_SCANCODE_KP_MEMSTORE = 208
        SDL_SCANCODE_KP_MEMRECALL = 209
        SDL_SCANCODE_KP_MEMCLEAR = 210
        SDL_SCANCODE_KP_MEMADD = 211
        SDL_SCANCODE_KP_MEMSUBTRACT = 212
        SDL_SCANCODE_KP_MEMMULTIPLY = 213
        SDL_SCANCODE_KP_MEMDIVIDE = 214
        SDL_SCANCODE_KP_PLUSMINUS = 215
        SDL_SCANCODE_KP_CLEAR = 216
        SDL_SCANCODE_KP_CLEARENTRY = 217
        SDL_SCANCODE_KP_BINARY = 218
        SDL_SCANCODE_KP_OCTAL = 219
        SDL_SCANCODE_KP_DECIMAL = 220
        SDL_SCANCODE_KP_HEXADECIMAL = 221
        SDL_SCANCODE_LCTRL = 224
        SDL_SCANCODE_LSHIFT = 225
        SDL_SCANCODE_LALT = 226
        SDL_SCANCODE_LGUI = 227
        SDL_SCANCODE_RCTRL = 228
        SDL_SCANCODE_RSHIFT = 229
        SDL_SCANCODE_RALT = 230
        SDL_SCANCODE_RGUI = 231
        SDL_SCANCODE_MODE = 257
        SDL_SCANCODE_AUDIONEXT = 258
        SDL_SCANCODE_AUDIOPREV = 259
        SDL_SCANCODE_AUDIOSTOP = 260
        SDL_SCANCODE_AUDIOPLAY = 261
        SDL_SCANCODE_AUDIOMUTE = 262
        SDL_SCANCODE_MEDIASELECT = 263
        SDL_SCANCODE_WWW = 264
        SDL_SCANCODE_MAIL = 265
        SDL_SCANCODE_CALCULATOR = 266
        SDL_SCANCODE_COMPUTER = 267
        SDL_SCANCODE_AC_SEARCH = 268
        SDL_SCANCODE_AC_HOME = 269
        SDL_SCANCODE_AC_BACK = 270
        SDL_SCANCODE_AC_FORWARD = 271
        SDL_SCANCODE_AC_STOP = 272
        SDL_SCANCODE_AC_REFRESH = 273
        SDL_SCANCODE_AC_BOOKMARKS = 274
        SDL_SCANCODE_BRIGHTNESSDOWN = 275
        SDL_SCANCODE_BRIGHTNESSUP = 276
        SDL_SCANCODE_DISPLAYSWITCH = 277
        SDL_SCANCODE_KBDILLUMTOGGLE = 278
        SDL_SCANCODE_KBDILLUMDOWN = 279
        SDL_SCANCODE_KBDILLUMUP = 280
        SDL_SCANCODE_EJECT = 281
        SDL_SCANCODE_SLEEP = 282
        SDL_SCANCODE_APP1 = 283
        SDL_SCANCODE_APP2 = 284
        SDL_SCANCODE_AUDIOREWIND = 285
        SDL_SCANCODE_AUDIOFASTFORWARD = 286
        SDL_NUM_SCANCODES = 512
    
    ctypedef int32_t SDL_Keycode
    cdef enum:
        SDLK_UNKNOWN
        SDLK_RETURN
        SDLK_ESCAPE
        SDLK_BACKSPACE
        SDLK_TAB
        SDLK_SPACE
        SDLK_EXCLAIM
        SDLK_QUOTEDBL
        SDLK_HASH
        SDLK_PERCENT
        SDLK_DOLLAR
        SDLK_AMPERSAND
        SDLK_QUOTE
        SDLK_LEFTPAREN
        SDLK_RIGHTPAREN
        SDLK_ASTERISK
        SDLK_PLUS
        SDLK_COMMA
        SDLK_MINUS
        SDLK_PERIOD
        SDLK_SLASH
        SDLK_0
        SDLK_1
        SDLK_2
        SDLK_3
        SDLK_4
        SDLK_5
        SDLK_6
        SDLK_7
        SDLK_8
        SDLK_9
        SDLK_COLON
        SDLK_SEMICOLON
        SDLK_LESS
        SDLK_EQUALS
        SDLK_GREATER
        SDLK_QUESTION
        SDLK_AT
        SDLK_LEFTBRACKET
        SDLK_BACKSLASH
        SDLK_RIGHTBRACKET
        SDLK_CARET
        SDLK_UNDERSCORE
        SDLK_BACKQUOTE
        SDLK_a
        SDLK_b
        SDLK_c
        SDLK_d
        SDLK_e
        SDLK_f
        SDLK_g
        SDLK_h
        SDLK_i
        SDLK_j
        SDLK_k
        SDLK_l
        SDLK_m
        SDLK_n
        SDLK_o
        SDLK_p
        SDLK_q
        SDLK_r
        SDLK_s
        SDLK_t
        SDLK_u
        SDLK_v
        SDLK_w
        SDLK_x
        SDLK_y
        SDLK_z
        SDLK_CAPSLOCK
        SDLK_F1
        SDLK_F2
        SDLK_F3
        SDLK_F4
        SDLK_F5
        SDLK_F6
        SDLK_F7
        SDLK_F8
        SDLK_F9
        SDLK_F10
        SDLK_F11
        SDLK_F12
        SDLK_PRINTSCREEN
        SDLK_SCROLLLOCK
        SDLK_PAUSE
        SDLK_INSERT
        SDLK_HOME
        SDLK_PAGEUP
        SDLK_DELETE
        SDLK_END
        SDLK_PAGEDOWN
        SDLK_RIGHT
        SDLK_LEFT
        SDLK_DOWN
        SDLK_UP
        SDLK_NUMLOCKCLEAR
        SDLK_KP_DIVIDE
        SDLK_KP_MULTIPLY
        SDLK_KP_MINUS
        SDLK_KP_PLUS
        SDLK_KP_ENTER
        SDLK_KP_1
        SDLK_KP_2
        SDLK_KP_3
        SDLK_KP_4
        SDLK_KP_5
        SDLK_KP_6
        SDLK_KP_7
        SDLK_KP_8
        SDLK_KP_9
        SDLK_KP_0
        SDLK_KP_PERIOD
        SDLK_APPLICATION
        SDLK_POWER
        SDLK_KP_EQUALS
        SDLK_F13
        SDLK_F14
        SDLK_F15
        SDLK_F16
        SDLK_F17
        SDLK_F18
        SDLK_F19
        SDLK_F20
        SDLK_F21
        SDLK_F22
        SDLK_F23
        SDLK_F24
        SDLK_EXECUTE
        SDLK_HELP
        SDLK_MENU
        SDLK_SELECT
        SDLK_STOP
        SDLK_AGAIN
        SDLK_UNDO
        SDLK_CUT
        SDLK_COPY
        SDLK_PASTE
        SDLK_FIND
        SDLK_MUTE
        SDLK_VOLUMEUP
        SDLK_VOLUMEDOWN
        SDLK_KP_COMMA
        SDLK_KP_EQUALSAS400
        SDLK_ALTERASE
        SDLK_SYSREQ
        SDLK_CANCEL
        SDLK_CLEAR
        SDLK_PRIOR
        SDLK_RETURN2
        SDLK_SEPARATOR
        SDLK_OUT
        SDLK_OPER
        SDLK_CLEARAGAIN
        SDLK_CRSEL
        SDLK_EXSEL
        SDLK_KP_00
        SDLK_KP_000
        SDLK_THOUSANDSSEPARATOR
        SDLK_DECIMALSEPARATOR
        SDLK_CURRENCYUNIT
        SDLK_CURRENCYSUBUNIT
        SDLK_KP_LEFTPAREN
        SDLK_KP_RIGHTPAREN
        SDLK_KP_LEFTBRACE
        SDLK_KP_RIGHTBRACE
        SDLK_KP_TAB
        SDLK_KP_BACKSPACE
        SDLK_KP_A
        SDLK_KP_B
        SDLK_KP_C
        SDLK_KP_D
        SDLK_KP_E
        SDLK_KP_F
        SDLK_KP_XOR
        SDLK_KP_POWER
        SDLK_KP_PERCENT
        SDLK_KP_LESS
        SDLK_KP_GREATER
        SDLK_KP_AMPERSAND
        SDLK_KP_DBLAMPERSAND
        SDLK_KP_VERTICALBAR
        SDLK_KP_DBLVERTICALBAR
        SDLK_KP_COLON
        SDLK_KP_HASH
        SDLK_KP_SPACE
        SDLK_KP_AT
        SDLK_KP_EXCLAM
        SDLK_KP_MEMSTORE
        SDLK_KP_MEMRECALL
        SDLK_KP_MEMCLEAR
        SDLK_KP_MEMADD
        SDLK_KP_MEMSUBTRACT
        SDLK_KP_MEMMULTIPLY
        SDLK_KP_MEMDIVIDE
        SDLK_KP_PLUSMINUS
        SDLK_KP_CLEAR
        SDLK_KP_CLEARENTRY
        SDLK_KP_BINARY
        SDLK_KP_OCTAL
        SDLK_KP_DECIMAL
        SDLK_KP_HEXADECIMAL
        SDLK_LCTRL
        SDLK_LSHIFT
        SDLK_LALT
        SDLK_LGUI
        SDLK_RCTRL
        SDLK_RSHIFT
        SDLK_RALT
        SDLK_RGUI
        SDLK_MODE
        SDLK_AUDIONEXT
        SDLK_AUDIOPREV
        SDLK_AUDIOSTOP
        SDLK_AUDIOPLAY
        SDLK_AUDIOMUTE
        SDLK_MEDIASELECT
        SDLK_WWW
        SDLK_MAIL
        SDLK_CALCULATOR
        SDLK_COMPUTER
        SDLK_AC_SEARCH
        SDLK_AC_HOME
        SDLK_AC_BACK
        SDLK_AC_FORWARD
        SDLK_AC_STOP
        SDLK_AC_REFRESH
        SDLK_AC_BOOKMARKS
        SDLK_BRIGHTNESSDOWN
        SDLK_BRIGHTNESSUP
        SDLK_DISPLAYSWITCH
        SDLK_KBDILLUMTOGGLE
        SDLK_KBDILLUMDOWN
        SDLK_KBDILLUMUP
        SDLK_EJECT
        SDLK_SLEEP
        SDLK_APP1
        SDLK_APP2
        SDLK_AUDIOREWIND
        SDLK_AUDIOFASTFORWARD
        
    ctypedef enum SDL_Keymod:
        KMOD_NONE = 0x0000
        KMOD_LSHIFT = 0x0001
        KMOD_RSHIFT = 0x0002
        KMOD_LCTRL = 0x0040
        KMOD_RCTRL = 0x0080
        KMOD_LALT = 0x0100
        KMOD_RALT = 0x0200
        KMOD_LGUI = 0x0400
        KMOD_RGUI = 0x0800
        KMOD_NUM = 0x1000
        KMOD_CAPS = 0x2000
        KMOD_MODE = 0x4000
        KMOD_RESERVED = 0x8000
        KMOD_CTRL
        KMOD_SHIFT
        KMOD_ALT
        KMOD_GUI
    
    ctypedef struct SDL_Keysym:
        SDL_Scancode scancode
        SDL_Keycode sym
        uint16_t mod
        uint32_t unused
    
    ctypedef struct SDL_CommonEvent:
        uint32_t type
        uint32_t timestamp

    ctypedef struct SDL_WindowEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        uint8_t event
        uint8_t padding1
        uint8_t padding2
        uint8_t padding3
        int32_t data1
        int32_t data2

    cdef enum: SDL_PRESSED
    cdef enum: SDL_RELEASED
    ctypedef struct SDL_KeyboardEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        uint8_t state
        uint8_t repeat
        uint8_t padding2
        uint8_t padding3
        SDL_Keysym keysym

    cdef enum: SDL_TEXTEDITINGEVENT_TEXT_SIZE#default is 32
    ctypedef struct SDL_TextEditingEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        char text[SDL_TEXTEDITINGEVENT_TEXT_SIZE]
        int32_t start
        int32_t length

    cdef enum: SDL_TEXTINPUTEVENT_TEXT_SIZE#default is 32
    ctypedef struct SDL_TextInputEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        char text[SDL_TEXTINPUTEVENT_TEXT_SIZE]

    ctypedef struct SDL_MouseMotionEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        uint32_t which
        uint32_t state
        int32_t x
        int32_t y
        int32_t xrel
        int32_t yrel

    cdef enum:
        SDL_BUTTON_LEFT
        SDL_BUTTON_MIDDLE
        SDL_BUTTON_RIGHT
        SDL_BUTTON_X1
        SDL_BUTTON_X2

    cdef enum:
        SDL_BUTTON_LMASK
        SDL_BUTTON_MMASK
        SDL_BUTTON_RMASK
        SDL_BUTTON_X1MASK
        SDL_BUTTON_X2MASK
        
    cdef enum:
        SDL_MOUSEWHEEL_NORMAL
        SDL_MOUSEWHEEL_FLIPPED

    ctypedef struct SDL_MouseButtonEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        uint32_t which
        uint8_t button
        uint8_t state
        uint8_t clicks
        uint8_t padding1
        int32_t x
        int32_t y

    ctypedef struct SDL_MouseWheelEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        uint32_t which
        int32_t x
        int32_t y
        uint32_t direction

    ctypedef int32_t SDL_JoystickID
    ctypedef struct SDL_JoyAxisEvent:
        uint32_t type
        uint32_t timestamp
        SDL_JoystickID which
        uint8_t axis
        uint8_t padding1
        uint8_t padding2
        uint8_t padding3
        int16_t value
        uint16_t padding4
    
    ctypedef struct SDL_JoyBallEvent:
        uint32_t type
        uint32_t timestamp
        SDL_JoystickID which
        uint8_t ball
        uint8_t padding1
        uint8_t padding2
        uint8_t padding3
        int16_t xrel
        int16_t yrel
    
    cdef enum: SDL_HAT_LEFTUP
    cdef enum: SDL_HAT_UP
    cdef enum: SDL_HAT_RIGHTUP
    cdef enum: SDL_HAT_LEFT
    cdef enum: SDL_HAT_CENTERED
    cdef enum: SDL_HAT_RIGHT
    cdef enum: SDL_HAT_LEFTDOWN
    cdef enum: SDL_HAT_DOWN
    cdef enum: SDL_HAT_RIGHTDOWN
    ctypedef struct SDL_JoyHatEvent:
        uint32_t type
        uint32_t timestamp
        SDL_JoystickID which
        uint8_t hat
        uint8_t value
        uint8_t padding1
        uint8_t padding2

    ctypedef struct SDL_JoyButtonEvent:
        uint32_t type
        uint32_t timestamp
        SDL_JoystickID which
        uint8_t button
        uint8_t state
        uint8_t padding1
        uint8_t padding2

    ctypedef struct SDL_JoyDeviceEvent:
        uint32_t type
        uint32_t timestamp
        int32_t which
    
    int SDL_NumJoysticks()
    ctypedef struct SDL_Joystick:#anonymous
        pass
    
    SDL_Joystick *SDL_JoystickOpen(int device_index)
    void SDL_JoystickClose(SDL_Joystick *joystick)
    const char *SDL_JoystickName(SDL_Joystick *joystick)
    const char *SDL_JoystickNameForIndex(int device_index)
    uint32_t SDL_JoystickInstanceID(SDL_Joystick *joystick)
    int SDL_JoystickNumAxes(SDL_Joystick *joystick)
    int16_t SDL_JoystickGetAxis(SDL_Joystick *joystick, int axis)
    int SDL_JoystickNumButtons(SDL_Joystick *joystick)
    uint8_t SDL_JoystickGetButton(SDL_Joystick *joystick, int button)
    int SDL_JoystickNumBalls(SDL_Joystick *joystick)
    int SDL_JoystickGetBall(SDL_Joystick *joystick, int ball, int *dx, int *dy)

    ctypedef struct SDL_ControllerAxisEvent:
        uint32_t type
        uint32_t timestamp
        SDL_JoystickID which
        uint8_t axis
        uint8_t padding1
        uint8_t padding2
        uint8_t padding3
        int16_t value
        uint16_t padding4

    ctypedef struct SDL_ControllerButtonEvent:
        uint32_t type
        uint32_t timestamp
        SDL_JoystickID which
        uint8_t button
        uint8_t state
        uint8_t padding1
        uint8_t padding2

    ctypedef struct SDL_ControllerDeviceEvent:
        uint32_t type
        uint32_t timestamp
        int32_t which

    ctypedef struct SDL_AudioDeviceEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t which
        uint8_t iscapture
        uint8_t padding1
        uint8_t padding2
        uint8_t padding3

    ctypedef struct SDL_QuitEvent:
        uint32_t type
        uint32_t timestamp

    ctypedef struct SDL_UserEvent:
        uint32_t type
        uint32_t timestamp
        uint32_t windowID
        int32_t code
        void *data1
        void *data2

    ctypedef struct SDL_SysWMmsg:
        pass#bad
        
    ctypedef struct SDL_SysWMEvent:
        uint32_t type
        uint32_t timestamp
        SDL_SysWMmsg *msg

    ctypedef int32_t SDL_TouchID
    ctypedef int32_t SDL_FingerID
    ctypedef struct SDL_TouchFingerEvent:
        uint32_t type
        uint32_t timestamp
        SDL_TouchID touchId
        SDL_FingerID fingerId
        float x
        float y
        float dx
        float dy
        float pressure

    ctypedef struct SDL_MultiGestureEvent:
        uint32_t type
        uint32_t timestamp
        SDL_TouchID touchId
        float dTheta
        float dDist
        float x
        float y
        uint16_t numFingers
        uint16_t padding

    ctypedef int32_t SDL_GestureID
    ctypedef struct SDL_DollarGestureEvent:
        uint32_t type
        uint32_t timestamp
        SDL_TouchID touchId
        SDL_GestureID gestureId
        uint32_t numFingers
        float error
        float x
        float y

    ctypedef struct SDL_DropEvent:
        uint32_t type
        uint32_t timestamp
        char *file
        uint32_t windowID
    
    ctypedef union SDL_Event:
        uint32_t type
        SDL_CommonEvent common
        SDL_WindowEvent window
        SDL_KeyboardEvent key
        SDL_TextEditingEvent edit
        SDL_TextInputEvent text
        SDL_MouseMotionEvent motion
        SDL_MouseButtonEvent button
        SDL_MouseWheelEvent wheel
        SDL_JoyAxisEvent jaxis
        SDL_JoyBallEvent jball
        SDL_JoyHatEvent jhat
        SDL_JoyButtonEvent jbutton
        SDL_JoyDeviceEvent jdevice
        SDL_ControllerAxisEvent caxis
        SDL_ControllerButtonEvent cbutton
        SDL_ControllerDeviceEvent cdevice
        SDL_AudioDeviceEvent adevice
        SDL_QuitEvent quit
        SDL_UserEvent user
        SDL_SysWMEvent syswm
        SDL_TouchFingerEvent tfinger
        SDL_MultiGestureEvent mgesture
        SDL_DollarGestureEvent dgesture
        SDL_DropEvent drop
        uint8_t padding[56]
    int SDL_PollEvent(SDL_Event *event)
    uint32_t SDL_RegisterEvents(int numevents)
    int SDL_PushEvent(SDL_Event *event)
    
    #Miscellaneous
    ctypedef struct SDL_Surface:
        uint32_t flags
        #SDL_PixelFormat *format
        int w, h
        #int pitch
        void *pixels
        #void *userdata
        #int locked
        #void *lock_data
        #SDL_Rect clip_rect
        #struct SDL_BlitMap *map
        #int refcount
    
    SDL_Surface *SDL_ConvertSurfaceFormat(SDL_Surface *src, uint32_t pixel_format, uint32_t flags)
    void SDL_FreeSurface(SDL_Surface *surface)
    SDL_Surface *SDL_CreateRGBSurfaceFrom(void *pixels, int width, int height, int depth, int pitch, uint32_t Rmask, uint32_t Gmask, uint32_t Bmask, uint32_t Amask)

    cdef enum:
        SDL_PIXELFORMAT_UNKNOWN
        SDL_PIXELFORMAT_INDEX1LSB
        SDL_PIXELFORMAT_INDEX1MSB
        SDL_PIXELFORMAT_INDEX4LSB
        SDL_PIXELFORMAT_INDEX4MSB
        SDL_PIXELFORMAT_INDEX8
        SDL_PIXELFORMAT_RGB332
        SDL_PIXELFORMAT_RGB444
        SDL_PIXELFORMAT_RGB555
        SDL_PIXELFORMAT_BGR555
        SDL_PIXELFORMAT_ARGB4444
        SDL_PIXELFORMAT_RGBA4444
        SDL_PIXELFORMAT_ABGR4444
        SDL_PIXELFORMAT_BGRA4444
        SDL_PIXELFORMAT_ARGB1555
        SDL_PIXELFORMAT_RGBA5551
        SDL_PIXELFORMAT_ABGR1555
        SDL_PIXELFORMAT_BGRA5551
        SDL_PIXELFORMAT_RGB565
        SDL_PIXELFORMAT_BGR565
        SDL_PIXELFORMAT_RGB24
        SDL_PIXELFORMAT_BGR24
        SDL_PIXELFORMAT_RGB888
        SDL_PIXELFORMAT_RGBX8888
        SDL_PIXELFORMAT_BGR888
        SDL_PIXELFORMAT_BGRX8888
        SDL_PIXELFORMAT_ARGB8888
        SDL_PIXELFORMAT_RGBA8888
        SDL_PIXELFORMAT_ABGR8888
        SDL_PIXELFORMAT_BGRA8888
        SDL_PIXELFORMAT_ARGB2101010
        SDL_PIXELFORMAT_RGBA32
        SDL_PIXELFORMAT_ARGB32
        SDL_PIXELFORMAT_BGRA32
        SDL_PIXELFORMAT_ABGR32
        SDL_PIXELFORMAT_YV12
        SDL_PIXELFORMAT_IYUV
        SDL_PIXELFORMAT_YUY2
        SDL_PIXELFORMAT_UYVY
        SDL_PIXELFORMAT_YVYU
        SDL_PIXELFORMAT_NV12
        SDL_PIXELFORMAT_NV21

    ctypedef struct SDL_AudioStream:
        pass
    
    ctypedef enum SDL_AudioFormat:
        AUDIO_U8
        AUDIO_S8
        AUDIO_U16LSB
        AUDIO_S16LSB
        AUDIO_U16MSB
        AUDIO_S16MSB
        AUDIO_U16
        AUDIO_S16
        AUDIO_S32LSB
        AUDIO_S32MSB
        AUDIO_S32
        AUDIO_F32LSB
        AUDIO_F32MSB
        AUDIO_F32
        AUDIO_U16SYS
        AUDIO_S16SYS
        AUDIO_S32SYS
        AUDIO_F32SYS
    
    SDL_AudioStream *SDL_NewAudioStream(
        const SDL_AudioFormat src_format,
        const uint8_t src_channels,
        const int src_rate,
        const SDL_AudioFormat dst_format,
        const uint8_t dst_channels,
        const int dst_rate
    )
    
    int SDL_AudioStreamPut(SDL_AudioStream *stream, const void *buf, int len)
    int SDL_AudioStreamGet(SDL_AudioStream *stream, void *buf, int len)
    int SDL_AudioStreamAvailable(SDL_AudioStream *stream)
    int SDL_AudioStreamFlush(SDL_AudioStream *stream)
    void SDL_AudioStreamClear(SDL_AudioStream *stream)
    void SDL_FreeAudioStream(SDL_AudioStream *stream)
    
cdef extern from "SDL2/SDL_image.h" nogil:
    cdef enum:
        SDL_IMAGE_MAJOR_VERSION
        SDL_IMAGE_MINOR_VERSION
        SDL_IMAGE_PATCHLEVEL
    ctypedef enum IMG_InitFlags:
        IMG_INIT_JPG
        IMG_INIT_PNG
        IMG_INIT_TIF
        IMG_INIT_WEBP
    int IMG_Init(int flags)
    void IMG_Quit()
    ctypedef struct SDL_RWops
    ctypedef struct SDL_Texture
    SDL_Surface *IMG_LoadTyped_RW(SDL_RWops *src, int freesrc, const char *type)
    SDL_Surface *IMG_Load(const char *file)
    SDL_Surface *IMG_Load_RW(SDL_RWops *src, int freesrc)
    SDL_Texture *IMG_LoadTexture(SDL_Renderer *renderer, const char *file)
    SDL_Texture *IMG_LoadTexture_RW(SDL_Renderer *renderer, SDL_RWops *src, int freesrc)
    SDL_Texture *IMG_LoadTextureTyped_RW(SDL_Renderer *renderer, SDL_RWops *src, int freesrc, const char *type)
    int IMG_isICO(SDL_RWops *src)
    int IMG_isCUR(SDL_RWops *src)
    int IMG_isBMP(SDL_RWops *src)
    int IMG_isGIF(SDL_RWops *src)
    int IMG_isJPG(SDL_RWops *src)
    int IMG_isLBM(SDL_RWops *src)
    int IMG_isPCX(SDL_RWops *src)
    int IMG_isPNG(SDL_RWops *src)
    int IMG_isPNM(SDL_RWops *src)
    int IMG_isSVG(SDL_RWops *src)
    int IMG_isTIF(SDL_RWops *src)
    int IMG_isXCF(SDL_RWops *src)
    int IMG_isXPM(SDL_RWops *src)
    int IMG_isXV(SDL_RWops *src)
    int IMG_isWEBP(SDL_RWops *src)
    SDL_Surface *IMG_LoadICO_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadCUR_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadBMP_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadGIF_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadJPG_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadLBM_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadPCX_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadPNG_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadPNM_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadSVG_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadTGA_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadTIF_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadXCF_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadXPM_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadXV_RW(SDL_RWops *src)
    SDL_Surface *IMG_LoadWEBP_RW(SDL_RWops *src)
    SDL_Surface *IMG_ReadXPMFromArray(char **xpm)
    int IMG_SavePNG(SDL_Surface *surface, const char *file)
    int IMG_SavePNG_RW(SDL_Surface *surface, SDL_RWops *dst, int freedst)
    int IMG_SaveJPG(SDL_Surface *surface, const char *file, int quality)
    int IMG_SaveJPG_RW(SDL_Surface *surface, SDL_RWops *dst, int freedst, int quality)
    void IMG_SetError(char *error)
    char *IMG_GetError()
    
cdef extern from "SDL2/SDL_mixer.h" nogil:
    cdef enum:
        MIX_CHANNELS
        MIX_DEFAULT_FREQUENCY
        MIX_DEFAULT_FORMAT
        MIX_DEFAULT_CHANNELS
        MIX_MAX_VOLUME
    
    ctypedef struct Mix_Chunk:
        int allocated
        uint8_t *abuf
        uint32_t alen
        uint8_t volume
    
    ctypedef enum MIX_InitFlags:
        MIX_INIT_FLAC
        MIX_INIT_MOD
        MIX_INIT_MP3
        MIX_INIT_OGG
        MIX_INIT_MID
    
    int Mix_Init(int flags)
    void Mix_Quit()
    int Mix_OpenAudio(int frequency, int format, int channels, int chunksize)
    void Mix_CloseAudio()
    Mix_Chunk  *Mix_LoadWAV(char *file)
    int Mix_PlayChannel(int channel, Mix_Chunk *chunk, int loops)