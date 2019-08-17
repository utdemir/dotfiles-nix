#!/usr/bin/env python3

import re
import sys
import json
import itertools as it
from pprint import pprint
from subprocess import check_output

[_, old, new] = sys.argv

def drv_deps(path):
    deps = check_output(["nix-store", "-qR", path]).splitlines()
    ret = "[" + " ".join('"' + i[44:].decode().strip() + '"' for i in deps) + "]"

    ret = check_output([
      "nix", "eval", "--json",
      f"( builtins.map builtins.parseDrvName {ret} )"
    ])

    ret = [(i["name"], i["version"]) for i in json.loads(ret)]
    ret.sort()
    ret = dict(ret)
    return ret

def strip_multiple_outputs(s):
    l = s.split("-")
    if len(l) > 1 and re.match("^[a-z]+$", l[-1]):
        return "-".join(l[:-1])
    else:
        return s

old = drv_deps(old)
new = drv_deps(new)

diff = [
    { "name": i, "old": old.get(i), "new": new.get(i) }
    for i in set(it.chain(old.keys(), new.keys()))
    if old.get(i) != new.get(i) and old.get(i) != "" and new.get(i) != ""
]

diff.sort(key=lambda i: i["name"])

for i in diff:
    print("{name}: {old} -> {new}".format(**i))

if not diff:
    print("No difference.")
