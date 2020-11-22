import ctypes
import glob
import os
import time

cdef class App:

    def init(self, int target_fps=60, int num_frame_times=20, bint use_vsync=True, bint use_sleep=False):
        self.target_fps = target_fps
        self.num_frame_times = num_frame_times
        self.use_vsync = use_vsync
        self.use_sleep = use_sleep
        self.frame_times = [1.0 / self.target_fps] * self.num_frame_times

        #hack to get around setting LD_LIBRARYPATH = ./pyorama/libs/shared prior to running apps
        lib_base_path = "./pyorama/libs/shared/*.so"
        lib_paths = glob.glob(lib_base_path)
        libs = []
        for lib_path in lib_paths:
            lib = ctypes.CDLL(lib_path)
            libs.append(lib)
        
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

        self.frequency = SDL_GetPerformanceFrequency()
        self.start_time = self.c_get_current_time()

    def quit(self):
        os._exit(-1)

    def run(self):
        self.current_time = self.start_time
        self.previous_time = self.current_time
        self.init()
        if self.use_sleep:
            self.run_sleep()
        else:
            self.run_fixed_timestep()
    
    def run_sleep(self):
        cdef:
            double start_time
            double end_time
            double delta_time
            double sleep_time
        
        while True:
            start_time = self.c_get_current_time()
            self.step()
            self.c_swap_root_window()
            end_time = self.c_get_current_time()
            delta_time = end_time - start_time
            sleep_time = max(0.0, (1.0 / self.target_fps) - delta_time)
            time.sleep(sleep_time)
    
    def run_fixed_timestep(self):
        cdef:
            double current_time = self.c_get_current_time()
            double previous_time = current_time
            double delta_time
            double accumulated_time
        
        while True:
            current_time = self.c_get_current_time()
            delta_time = current_time - previous_time
            accumulated_time += delta_time
            while accumulated_time > 1.0 / self.target_fps:
                self.step()
                accumulated_time -= 1.0 / self.target_fps
            previous_time = current_time
            self.c_swap_root_window()

    def step(self):
        cdef:
            size_t frame_index
            double frame_time
        self.current_time = self.c_get_current_time() - self.start_time
        frame_index = self.frame_count % self.num_frame_times
        frame_time = self.current_time - self.previous_time
        PyErr_CheckSignals()
        self.event.event_type_emit(EVENT_TYPE_ENTER_FRAME)
        self.event.update(self.current_time)
        self.physics.update(1.0/self.target_fps)
        self.graphics.update()
        self.frame_times[frame_index] = frame_time
        self.frame_count += 1
        self.previous_time = self.current_time

    cdef double c_get_current_time(self) nogil:
        cdef:
            double counter
            double current_time
        counter = SDL_GetPerformanceCounter()
        current_time = counter / self.frequency
        return current_time

    cpdef double get_frame_time(self) except *:
        return sum(self.frame_times) / self.num_frame_times

    cpdef double get_fps(self) except *:
        return 1.0 / self.get_frame_time()

    cdef void c_swap_root_window(self) except *:
        SDL_GL_MakeCurrent(self.graphics.root_window, self.graphics.root_context)
        SDL_GL_SetSwapInterval(self.use_vsync)
        SDL_GL_SwapWindow(self.graphics.root_window)