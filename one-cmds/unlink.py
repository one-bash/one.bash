from __future__ import print_function

import os
import sys


if len(sys.argv) > 1:
    CONFIG = sys.argv[1]
else:
    sys.exit("""
Usage: unlink <path>
Description: Cleanup soft-links created by dotbot
Example: unlink ./env.yaml
""")


def inject(lib_path):
    path = os.path.join(os.path.dirname(os.path.realpath(
        __file__)), '../deps/dotbot', 'lib', lib_path)
    sys.path.insert(0, path)


if sys.version_info[0] >= 3:
    inject('pyyaml/lib3')
else:
    inject('pyyaml/lib')

print("Config: ", CONFIG)

import yaml

stream = open(CONFIG, "r")
conf = yaml.load(stream, yaml.FullLoader)

for section in conf:
    if 'link' in section:
        for target in section['link']:
            realpath = os.path.expanduser(os.path.expandvars(target))
            if os.path.islink(realpath):
                print("Unlink ", realpath)
                os.unlink(realpath)
