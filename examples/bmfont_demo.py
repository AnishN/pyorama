import time
from bmfont_demo import *

if __name__ == "__main__":
    bmfont_path = b"./resources/fonts/bitmap/bm_test.fnt"
    start = time.time()
    bitmap_font_load_from_path(bmfont_path)
    end = time.time()
    print(end - start)