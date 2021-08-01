"""
import os
pyd_folders = []
for root, folders, file_paths in os.walk("."):
    for folder in folders:
        f_path = os.path.join(root, folder)
        print(f_path)
        try:
            os["environ"] += os.pathsep + f_path
            #os.add_dll_directory(f_path)
        except:
            print("failure")
"""

import os
os.environ["PATH"] = os.pathsep + "./pyorama/libs/shared/Windows"
import pyorama.test