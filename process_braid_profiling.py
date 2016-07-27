#!/usr/bin/python

import sys,json

filename = sys.argv[1]

summary = None

with open(filename, "r") as f:
    summary = json.load(f)

# print "####################"
# print "filename: %s" % filename
# print

print "== %s ==" % filename
print "=== Valid candidates ==="
# print "####################"
# print "Valid candidates:"
# print
candidates = []
for s in summary:
    cand = summary[s]

    realloc = False
    for alloc in cand["allocators"]:
        if "realloc" in alloc:
            realloc = True
    if realloc:
        continue

    if cand["array_child"]:
        continue
    if cand["struct_child"]:
        continue
    if len(cand["passed_by_value"]) > 0:
        continue
    candidates += [ (s, cand["size"], len(cand["loops"]), cand["allocators"]) ]

scandidates = sorted(candidates, key=lambda x: (x[2], x[1]), reverse=True)

print "| Name | Size | #Loops | Allocators |"
print "|------|------|--------|------------|"
for sc in scandidates:
    print "| %s | %d | %d | %s |" % sc #(s, cand["size"], len(cand["loops"]))
    # print "\t%s | size %d | appears in %d loops" % sc #(s, cand["size"], len(cand["loops"]))

# print
# print "####################"
# print "UnBRAIDable:"
# print
print "=== UnBRAIDable ==="

print "| Name | has array child | has struct child | #passes by value | reallocated |"
print "|------|-----------------|------------------|------------------|-------------|"

for s in summary:
    cand = summary[s]
    unb = False
    reasons = [] 
    arr_child = ""
    str_child = ""
    reallocated = ""
    n_byval = 0

    for alloc in cand["allocators"]:
        if "realloc" in alloc:
            reallocated = "x"
            unb = True
    if cand["array_child"]:
        reasons += ["Contains arrays"]
        arr_child = "x"
        unb = True
    if cand["struct_child"]:
        str_child = "x"
        reasons += ["Contains structs"]
        unb = True
    if len(cand["passed_by_value"]) > 0:
        reasons += [ "Passed by value in: %s" % cand["passed_by_value"] ]
        n_byval = len(cand["passed_by_value"])
        unb = True
    if unb:
        print "| %s | %s | %s | %d | %s |" % (s, arr_child, str_child, n_byval, reallocated)
        # print "\t%s\n\tReasons:" % s
        # for r in reasons:
            # print "\t\t- %s" % r
        # print
