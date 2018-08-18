import strutils, sets, tables, parseopt, nre, algorithm
import lib/io

var args: seq[string] = @[]

proc usage() =
  let s = """
Usage: line [OPTION]... [FILE]
  -b      : backward search.
  -f      : avoid comparing the first N fields."""
  echo s

var forward = true
var skipN = 0

try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "b":
      forward = false
    elif kind == cmdShortOption and key == "f":
      skipN = val.parseInt
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

proc skipFields(line: string): string =
  result = line
  for i in 1 .. skipN:
    result = result.replace(re"^\s*\S+\s+", "")

var already = initSet[string]()
let lines = read(args).split("\n")
if forward:
  for line in lines:
    let compare = skipFields(line)
    if not already.contains(compare):
      echo line
      already.incl(compare)
else:
  var outLines: seq[string] = @[]
  for line in lines.reversed:
    let compare = skipFields(line)
    if not already.contains(compare):
      outLines.add(line)
      already.incl(compare)
  for line in outLines.reversed:
    echo line

