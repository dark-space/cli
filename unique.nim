import strutils, sets, tables, parseopt, nre
import lib/io

var args: seq[string] = @[]
var opts = initTable[string,string]()

proc usage() =
  let s = """
Usage: unique [FILE]"""
  echo s

try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)


var already = initSet[string]()
let lines = read(args).split("\n")
for line in lines:
  if not already.contains(line):
    echo line
    already.incl(line)

