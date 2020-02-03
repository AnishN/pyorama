import atexit as py_atexit
import time

cdef class App:

    def init(self, double ms_per_update=1000.0/60.0, bint use_vsync=True, bint use_sleep=False):
        self.ms_per_update = ms_per_update
        self.use_vsync = use_vsync
        self.use_sleep = use_sleep

        py_atexit.register(self.quit)
        SDL_Init(SDL_INIT_EVERYTHING)
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        #SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
        #SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3)
        SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1)
        #SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_COMPATIBILITY)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE)
        SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
        
        self.accumulated_time = 0.0
        self.delta = 0.0
        self.frequency = SDL_GetPerformanceFrequency()
        self.current_time = self.c_get_current_time()
        self.previous_time = self.current_time
        self.is_running = True
        self.assets = AssetManager()
        self.graphics = GraphicsManager()
        self.events = EventManager()

    def quit(self):
        #Tries to undo state changes from c_init in reverse order
        IMG_Quit()
        SDL_Quit()
        self.is_running = False
        self.assets = None
        self.graphics = None
        self.events = None

    def update(self, double delta):
        pass

    def trigger_quit(self):
        self.is_running = False

    def run(self):
        cdef:#only used in use_sleep=True case!
            double start_time
            double end_time
            double delta
            double delay

        self.init()
        if not self.use_sleep:
            while self.is_running:
                self.current_time = self.c_get_current_time()
                self.delta = self.current_time - self.previous_time
                self.accumulated_time += self.delta
                
                #self.pre_update()
                while self.accumulated_time > self.ms_per_update/1000:
                    self.update(self.accumulated_time)
                    self.accumulated_time -= self.ms_per_update/1000
                #self.post_update()
                self.previous_time = self.current_time
        else:
            while self.is_running:
                self.current_time = self.c_get_current_time()
                self.delta = self.current_time - self.previous_time
                start_time = self.c_get_current_time()
                #self.pre_update()
                self.update(self.delta)
                #self.post_update()
                end_time = self.c_get_current_time()
                delay = (self.ms_per_update/1000) - (end_time - start_time)
                delay = max(delay, 0.0)
                time.sleep(delay)
                self.previous_time = self.current_time
                
    cdef double c_get_current_time(self) nogil:
        cdef:
            double counter
            double current_time

        counter = SDL_GetPerformanceCounter()
        current_time = counter / self.frequency
        return current_time