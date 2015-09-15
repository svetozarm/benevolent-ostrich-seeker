#!/usr/bin/python

import sys, json, os, parse

source_dir = sys.argv[1]
maps_dir = sys.argv[2]
trace_dir = sys.argv[3]

print "src: %s\nmaps: %s\ntrace: %s" % (source_dir, maps_dir, trace_dir)

def read_line_range(filename, target, distance):
    retval = ""
    with open(filename) as f:
        for i, line in enumerate(f):
            if (i >= target - distance) and (i <= target + distance):
                if i == target - 1:
                    retval += "*** " + line + "\n"
                else:
                    retval += line + "\n"
    return retval


flctable = []

for dirname, dirnames, filenames in os.walk(trace_dir):
    for filename in filenames:
        if "_access.txt" in filename:
            (f,l,c) = parse.parse("{}_{}_{}_access.txt", filename)
            flctable += [{  "file" : int(f),
                            "line" : int(l),
                            "column" : int(c)}]

sourcemap = dict()

with open("%s/map_sources.json" % maps_dir, "r") as f:
    sm = json.load(f)
    for fname in sm:
        sourcemap[sm[fname]] = os.path.basename(fname)

distance = 5

for location in flctable:
    fname = "%s/%s" % (source_dir, sourcemap[location["file"]])
    src = read_line_range(fname, location["line"], distance)

    print "\n\n=========================="
    print "%d_%d_%d %s\n------------------------" % (location["file"],location["line"],location["column"],sourcemap[location["file"]])
    print src


