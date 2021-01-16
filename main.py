from pyorama.core.item_manager import *
from pyorama.core.item import *
from pyorama.graphics import *

print(GRAPHICS_ITEM_TYPE_WINDOW)

manager = ItemManager()

manager.register_item_types(item_types_info)
item_type = GRAPHICS_ITEM_TYPE_TEXT
item = Item(manager, item_type)
item.create()
print(item, item_type, GRAPHICS_ITEM_TYPE_TEXT)