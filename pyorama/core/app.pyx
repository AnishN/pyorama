import atexit as py_atexit
import time

cdef class App:

    def init(self, double ms_per_update=1000.0/60.0):
        self.ms_per_update = ms_per_update

        py_atexit.register(App.quit, self)
        SDL_Init(SDL_INIT_EVERYTHING)
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
        SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
        
        self.accumulated_time = 0.0
        self.delta = 0.0
        self.frequency = SDL_GetPerformanceFrequency()
        self.start_time = self.c_get_current_time()
        self.current_time = self.start_time
        self.previous_time = self.current_time
        self.is_running = True

        self.graphics = GraphicsManager()
        self.event = EventManager()

    def quit(self):
        #Tries to undo state changes from c_init in reverse order
        IMG_Quit()
        SDL_Quit()
        self.is_running = False

    def trigger_quit(self):
        self.is_running = False

    def run(self):
        cdef:
            double timestamp
        self.init()
        while self.is_running:
            self.current_time = self.c_get_current_time()
            self.delta = self.current_time - self.previous_time
            self.accumulated_time += self.delta
            
            #self.pre_update()
            while self.accumulated_time > self.ms_per_update/1000:
                print(self.accumulated_time)
                timestamp = self.current_time - self.start_time
                #self.update(self.accumulated_time)
                self.event.update(timestamp)
                self.accumulated_time -= self.ms_per_update/1000
            #self.post_update()
            self.graphics.update()
            self.previous_time = self.current_time
        self.quit()
                
    cdef double c_get_current_time(self) nogil:
        cdef:
            double counter
            double current_time

        counter = SDL_GetPerformanceCounter()
        current_time = counter / self.frequency
        return current_time