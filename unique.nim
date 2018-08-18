import strutils, sets, tables, parseopt, nre, algorithm
import lib/io

var args: seq[string] = @[]

proc usage() =
  let s = """
Usage: line [OPTION]... [FILE]
  -b      : backward search."""
  echo s

var forward = true

try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "b":
      forward = false
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)


var already = initSet[string]()
let lines = read(args).split("\n")
if forward:
  for line in lines:
    if not already.contains(line):
      echo line
      already.incl(line)
else:
  var outLines: seq[string] = @[]
  for line in lines.reversed:
    if not already.contains(line):
      outLines.add(line)
      already.incl(line)
  for line in outLines.reversed:
    echo line

