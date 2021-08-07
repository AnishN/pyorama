graphics = GraphicsSystem("graphics")
audio = UserSystem("audio")
events = UserSystem("events")
physics = UserSystem("physics")
engine_systems = {
    "graphics": graphics,
    "audio": audio,
    "events": events,
    "physics": physics,
}
engine_systems_order = ["graphics", "audio", "events", "physics"]
user_systems = {}
user_systems_order = []

def iterate_systems(func_name, reverse=False, kwargs=None):
    systems = {**engine_systems, **user_systems}
    systems_order = engine_systems_order + user_systems_order
    if reverse:
        systems_order.reverse()
    if kwargs == None:
        kwargs = {}
    for name in systems_order:
        system = systems[name]
        func = getattr(system, func_name)
        func(**kwargs.get(name, {}))
    systems = None
    systems_order = None

def init(config={}):
    iterate_systems("init", config)

def quit():
    print("quit")
    iterate_systems("quit", reverse=True)

def update():
    iterate_systems("update")