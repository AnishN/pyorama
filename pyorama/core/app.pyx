import atexit as py_atexit
import os
import time

cdef class App:

    def init(self, double ms_per_update=1000.0/60.0, bint use_vsync=True, bint use_sleep=False):
        self.ms_per_update = ms_per_update
        self.use_vsync = use_vsync
        self.use_sleep = use_sleep

        py_atexit.register(App.quit, self)
        SDL_Init(SDL_INIT_EVERYTHING)
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
        SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")

        self.graphics = GraphicsManager()
        self.event = EventManager()

        self.accumulated_time = 0.0
        self.delta = 0.0
        self.frequency = SDL_GetPerformanceFrequency()
        self.start_time = self.c_get_current_time()
        self.current_time = self.start_time
        self.previous_time = self.current_time
        self.is_running = True

    def quit(self):
        self.graphics = None
        self.event = None
        IMG_Quit()
        SDL_Quit()
        os._exit(-1)
    
    def trigger_quit(self):
        self.is_running = False

    def run(self):
        self.init()
        while self.is_running:
            self.current_time = self.c_get_current_time()
            self.delta = self.current_time - self.previous_time
            self.accumulated_time += self.delta
            while self.accumulated_time > self.ms_per_update/1000:
                self.timestamp = self.current_time - self.start_time
                PyErr_CheckSignals()
                self.event.event_type_emit(EVENT_TYPE_ENTER_FRAME)
                self.event.update(self.timestamp)
                self.graphics.update()#differs from fix your timestep (avoids interpolation), will decide in more intensive demos
                self.accumulated_time -= self.ms_per_update/1000
            self.previous_time = self.current_time
                
    cdef double c_get_current_time(self) nogil:
        cdef:
            double counter
            double current_time
        counter = SDL_GetPerformanceCounter()
        current_time = counter / self.frequency
        return current_time