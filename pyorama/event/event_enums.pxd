from pyorama.libs.sdl2 cimport *

cpdef enum EventType:
    EVENT_TYPE_WINDOW
    EVENT_TYPE_KEY_DOWN
    EVENT_TYPE_KEY_UP
    EVENT_TYPE_MOUSE_MOTION
    EVENT_TYPE_MOUSE_BUTTON_DOWN
    EVENT_TYPE_MOUSE_BUTTON_UP
    EVENT_TYPE_MOUSE_WHEEL

    EVENT_TYPE_ENTER_FRAME = SDL_USEREVENT#0x8000 (32768)
    EVENT_TYPE_USER = SDL_USEREVENT + 1024#reserve some EventType slots for pyorama
    EVENT_TYPE_LAST = SDL_LASTEVENT#0xFFFF (65535)

#I hate mapping one library's enums to another, so need to figure how to decouple this