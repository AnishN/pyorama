import time

graphics = GraphicsSystem("graphics")
audio = UserSystem("audio")
event = EventSystem("event")
physics = UserSystem("physics")

def init(dict config={}):
    global target_fps, num_frame_times, use_vsync, use_sleep#need global when assigning variable
    global frame_times
    global frequency, start_time, curr_time, prev_time

    target_fps = config.get("target_fps", 60)
    num_frame_times = config.get("num_frame_times", 20)
    use_vsync = config.get("use_vsync", True)
    use_sleep = config.get("use_sleep", False)
    frame_times = [1.0 / target_fps] * num_frame_times
    frequency = SDL_GetPerformanceFrequency()
    start_time = c_get_current_time()

    graphics.init()
    audio.init()
    event.init()
    physics.init()

def quit():
    physics.quit()
    event.quit()
    audio.quit()
    graphics.quit()

def run():
    global curr_time, prev_time
    curr_time = start_time
    prev_time = curr_time
    if use_sleep:
        run_sleep()
    else:
        run_fixed_timestep()

def run_sleep():
    cdef:
        double delta_time
        double sleep_time
    global curr_time, prev_time

    curr_time = start_time
    while True:
        prev_time = curr_time
        step()
        curr_time = c_get_current_time()
        graphics.c_swap_root_window(use_vsync)
        delta_time = curr_time - prev_time
        sleep_time = max(0.0, (1.0 / target_fps) - delta_time)
        time.sleep(sleep_time)

def run_fixed_timestep():
    cdef:
        double delta_time
        double accumulated_time
    global curr_time, prev_time

    curr_time = start_time
    prev_time = curr_time
    while True:
        curr_time = c_get_current_time()
        delta_time = curr_time - prev_time
        accumulated_time += delta_time
        while accumulated_time > 1.0 / target_fps:
            step()
            accumulated_time -= 1.0 / target_fps
        prev_time = curr_time
        graphics.c_swap_root_window(use_vsync)

def step():
    cdef:
        size_t frame_index
        double frame_time
    global frame_count

    frame_index = frame_count % num_frame_times
    frame_time = curr_time - prev_time
    PyErr_CheckSignals()
    #event.event_type_emit(EVENT_TYPE_ENTER_FRAME)
    event.update(curr_time)
    #physics.update(1.0 / target_fps)
    graphics.update()
    frame_times[frame_index] = frame_time
    frame_count += 1

def get_frame_time():
    return sum(frame_times) / num_frame_times

def get_fps():
    return 1.0 / get_frame_time()

cdef double c_get_current_time() nogil:
    cdef:
        double counter
        double current_time
    counter = SDL_GetPerformanceCounter()
    current_time = counter / frequency
    return current_time