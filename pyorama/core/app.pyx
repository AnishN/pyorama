#import atexit as py_atexit
import os
import time


#os.environ["LD_LIBRARY_PATH"] = "./pyorama/libs/shared"

cdef class App:

    def init(self, double ms_per_update=1000.0/60.0, bint use_vsync=True, bint use_sleep=False):
        self.ms_per_update = ms_per_update
        self.use_vsync = use_vsync
        self.use_sleep = use_sleep

        #py_atexit.register(App.quit, self)
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
        self.physics = PhysicsManager()

        self.accumulated_time = 0.0
        self.delta = 0.0
        self.frequency = SDL_GetPerformanceFrequency()
        self.start_time = self.c_get_current_time()
        self.current_time = self.start_time
        self.previous_time = self.current_time
        self.tick_time = self.current_time

    def quit(self):
        os._exit(-1)

    def run(self):
        self.init()
        
        #basic fixed timestep with accumulator
        while True:
            self.current_time = self.c_get_current_time()
            self.delta = self.current_time - self.previous_time
            self.accumulated_time += self.delta
            while self.accumulated_time > self.ms_per_update/1000:
                self.timestamp = self.c_get_current_time() - self.start_time
                PyErr_CheckSignals()
                self.event.event_type_emit(EVENT_TYPE_ENTER_FRAME)
                self.event.update(self.timestamp)
                self.physics.update(self.ms_per_update/1000)
                self.graphics.update()
                self.accumulated_time -= self.ms_per_update/1000
            self.previous_time = self.current_time

        """
        #"fuzzy accumulator" logic instead
        #https://medium.com/@tglaiel/how-to-make-your-game-run-at-60fps-24c61210fe75
        while True:
            self.current_time = self.c_get_current_time()
            self.delta = self.current_time - self.previous_time
            self.accumulated_time += self.delta
            while self.accumulated_time > (1.0 / ((1.0 / self.ms_per_update) + 1.0))/1000:
                self.timestamp = self.c_get_current_time() - self.start_time
                PyErr_CheckSignals()
                self.event.event_type_emit(EVENT_TYPE_ENTER_FRAME)
                self.event.update(self.timestamp)
                self.physics.update(self.ms_per_update/1000)
                self.graphics.update()
                self.accumulated_time -= max(0.0, (1.0 / ((1.0 / self.ms_per_update) - 1.0))/1000)
            self.previous_time = self.current_time
        """

        """
        #naive sleep option
        while True:
            self.current_time = self.c_get_current_time()
            self.delta = self.current_time - self.previous_time
            PyErr_CheckSignals()
            self.event.event_type_emit(EVENT_TYPE_ENTER_FRAME)
            self.event.update(self.timestamp)
            self.physics.update(self.ms_per_update/1000)
            self.graphics.update()#differs from fix your timestep (avoids interpolation), will decide in more intensive demos
            print(self.ms_per_update/1000, self.delta)
            time.sleep(max(0.0, self.ms_per_update/1000 - self.delta))
            self.previous_time = self.current_time
        """
                
    cdef double c_get_current_time(self) nogil:
        cdef:
            double counter
            double current_time
        counter = SDL_GetPerformanceCounter()
        current_time = counter / self.frequency
        return current_time