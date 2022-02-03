import platform
import time

graphics_system = GraphicsSystem("graphics_system")
#audio = UserSystem("audio")
event_system = EventSystem("event_system")
#physics = UserSystem("physics")
#debug_ui = DebugUISystem("debug_ui")
asset_system = AssetSystem("asset_system")

def init(dict config=None):
    global target_fps, num_frame_times, use_vsync, use_sleep#need global when assigning variable
    global frame_times
    global frequency, start_time, curr_time, prev_time
    global platform_os

    #print("app init")
    cdef str platform_str = platform.system()
    if platform_str == "Windows":
        platform_os = PLATFORM_OS_WINDOWS
    elif platform_str == "Linux":
        platform_os = PLATFORM_OS_LINUX
    elif platform_str == "Darwin":
        platform_os = PLATFORM_OS_MACOS
    elif platform_str == "":
        platform_os = PLATFORM_OS_UNKNOWN

    if config == None:
        config = {}
    
    target_fps = config.get("target_fps", 60)
    num_frame_times = config.get("num_frame_times", 20)
    use_vsync = config.get("use_vsync", True)
    use_sleep = config.get("use_sleep", False)
    frame_times = [1.0 / target_fps] * num_frame_times
    frequency = SDL_GetPerformanceFrequency()
    start_time = c_get_current_time()

    if "random_seed" in config:
        random_set_seed(<uint64_t>config["random_seed"])
    else:
        random_set_seed_from_time()

    graphics_system.init(config.get("graphics_system", None))
    #audio.init(config.get("audio", None))
    event_system.init(config.get("event_system", None))
    #physics.init(config.get("physics", None))
    #debug_ui.init(config.get("debug_ui", None))
    asset_system.init(config.get("asset_system", None))

    graphics_system.bind_events()
    event_system.bind_events()

def quit():
    asset_system.quit()
    #debug_ui.quit()
    #physics.quit()
    event_system.quit()
    #audio.quit()
    graphics_system.quit()
    #print("app quit")

def run():
    global curr_time, prev_time
    global running
    running = True
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
    while running:
        prev_time = curr_time
        step()
        curr_time = c_get_current_time()
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
    while running:
        curr_time = c_get_current_time()
        delta_time = curr_time - prev_time
        accumulated_time += delta_time
        while accumulated_time > 1.0 / target_fps:
            step()
            accumulated_time -= 1.0 / target_fps
        prev_time = curr_time

def step():
    cdef:
        size_t frame_index
        double frame_time
    global frame_count

    frame_index = frame_count % num_frame_times
    frame_time = curr_time - prev_time
    PyErr_CheckSignals()
    event_system.event_type_emit(b"enter_frame")
    event_system.update(curr_time)
    #physics.update(1.0 / target_fps)
    asset_system.update()
    #debug_ui.update()
    graphics_system.update()
    frame_times[frame_index] = frame_time
    frame_count += 1

def get_frame_time():
    return sum(frame_times) / num_frame_times

def get_fps():
    return 1.0 / get_frame_time()

def trigger_quit():
    global running
    running = False

cdef double c_get_current_time() nogil:
    cdef:
        double counter
        double current_time
    counter = SDL_GetPerformanceCounter()
    current_time = counter / frequency
    return current_time

cdef PlatformOS c_get_platform_os() nogil:
    return platform_os