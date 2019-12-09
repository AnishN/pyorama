import atexit as py_atexit
import time

cdef class App:

    def __init__(self, double ms_per_update=1000.0/60.0, bint use_vsync=True, bint use_sleep=False):
        self.ms_per_update = ms_per_update
        self.use_vsync = use_vsync
        self.use_sleep = use_sleep

    def init(self):
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

    def quit(self):
        #Tries to undo state changes from c_init in reverse order
        IMG_Quit()
        SDL_Quit()
        self.is_running = False

    def update(self):
        pass

    def trigger_quit(self):
        self.is_running = False

    def run(self):
        cdef:#only used in use_sleep=True case!
            double start_time
            double end_time
            double delta
            double delay
            SDL_Event e

        self.init()
        if not self.use_sleep:
            while self.is_running:
                self.current_time = self.c_get_current_time()
                self.delta = self.current_time - self.previous_time
                self.previous_time = self.current_time
                self.accumulated_time += self.delta

                #hack/debug - just empty queue
                while SDL_PollEvent(&e):
                    pass

                while self.accumulated_time > self.ms_per_update/1000:
                    self.update()
                    self.accumulated_time -= self.ms_per_update/1000
                #SDL_GL_MakeCurrent(self.root_window, self.root_context)
                #SDL_GL_SetSwapInterval(self.use_vsync)
                #SDL_GL_MakeCurrent(NULL, self.root_context)
        else:
            while self.is_running:
                #hack/debug - just empty queue
                start_time = self.c_get_current_time()
                while SDL_PollEvent(&e):
                    pass
                self.update()
                end_time = self.c_get_current_time() 
                self.delta = end_time - start_time
                delay = (self.ms_per_update/1000) - self.delta
                delay = max(delay, 0.0)
                time.sleep(delay)
                #SDL_GL_MakeCurrent(self.root_window, self.root_context)
                #SDL_GL_SetSwapInterval(self.use_vsync)
                #SDL_GL_MakeCurrent(NULL, self.root_context)

    cdef double c_get_current_time(self) nogil:
        cdef:
            double counter
            double current_time

        counter = SDL_GetPerformanceCounter()
        current_time = counter / self.frequency
        return current_time