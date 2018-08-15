import strutils, parseopt, nre
import lib/io

proc usage() =
  let s = """
Usage: line [OPTION]... PATTERN [FILE]
  -n      : repeat N times.
  -a=[str]: append removed string to oppoite side with delimiter."""
  echo s

var repeatN = 1
var append = ""

var args: seq[string] = @[]
try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif (kind == cmdShortOption and key == "n"):
      repeatN = val.parseInt
    elif (kind == cmdShortOption and key == "a"):
      append = if (val.len > 0): val else: "\t"
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

let lines = read(args).split("\n")
if repeatN >= 0:
  for line in lines:
    var l = line
    for i in 1 .. repeatN:
      l = l.replace(re"^\s*\S+\s*", "")
    if append.len > 0:
      var removed = line[..(line.len - l.len - 1)].replace(re"^\s+","").replace(re"\s+$","")
      l = l & append & removed
    echo l
else:
  for line in lines:
    var l = line
    for i in 1 .. -repeatN:
      l = l.replace(re"\s*\S+\s*$", "")
    if append.len > 0:
      var removed = line[l.len..(line.len-1)].replace(re"^\s+","").replace(re"\s+$","")
      l = removed & append & l
    echo l

