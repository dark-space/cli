import strutils, parseopt, nre
import lib/io

proc usage() =
  let s = """
Usage: startswith [OPTION]... QUERY [FILE]
  -m      : remove coloring.
  -s      : remove leading spaces."""
  echo s

var monochrome = false
var remove_space = false

var args: seq[string] = @[]
try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif (kind == cmdShortOption and key == "m"):
      monochrome = true
    elif (kind == cmdShortOption and key == "s"):
      remove_space = true
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

let query = args[0]; args.delete(0)
let lines = read(args).split("\n")
for orig_line in lines:
  var l = orig_line
  if monochrome:
    l = l.replace(re"\[\d+m","")
  if remove_space:
    l = l.replace(re"^\s+","")
  if not l.startswith(query):
    continue
  echo orig_line

