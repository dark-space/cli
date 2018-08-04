import strutils, tables, parseopt, sets, nre
import lib/io, lib/range

var args: seq[string] = @[]
var opts = initTable[string,string]()

proc usage() =
  let s = """
Usage: line [OPTION]... PATTERN [FILE]
  -0      : index starts with 0.
  -v      : invert match.
  -B=<int>: also show before n lines.
  -A=<int>: also show after n lines.
  -C=<int>: also show before and after n+n lines."""
  echo s

try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif kind == cmdShortOption and key == "0":
      opts["zero"] = ""
    elif kind == cmdShortOption and key.match(re"^[0-9]") != none(RegexMatch):
      args.add("-" & key & ":" & val)
    elif (kind == cmdShortOption and key == "v") or (kind == cmdLongOption and key == "invert"):
      opts["invert"] = ""
    elif (kind == cmdShortOption and key == "C") or (kind == cmdLongOption and key == "context"):
      if not opts.contains("before"):
        opts["before"] = val
      if not opts.contains("after"):
        opts["after"] = val
    elif (kind == cmdShortOption and key == "B") or (kind == cmdLongOption and key == "before"):
      opts["before"] = val
    elif (kind == cmdShortOption and key == "A") or (kind == cmdLongOption and key == "after"):
      opts["after"] = val
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)
if args.len < 1:
  args.add(":")

proc expandContext()
proc print()

let query = args[0]; args.delete(0)
let lines = read(args).split("\n")
var indices = getRange(query, lines.len, opts.contains("zero"))
print()


proc expandContext() =
  var array: seq[int] = @[]
  var b = 0; var a = 0;
  if opts.contains("before"): b = opts["before"].parseInt
  if opts.contains("after"):  a = opts["after"].parseInt
  for c in indices:
    for x in c-b .. c+a:
      array.add(x)
  indices = array

proc print() =
  if not opts.contains("invert"):
    if opts.contains("before") or opts.contains("after"):
      expandContext()
    for i in indices:
      if i >= 0 and i < lines.len:
        echo lines[i]
  else:
    if opts.contains("before") or opts.contains("after"):
      expandContext()
    var excludes = initSet[int]()
    for i in indices:
      excludes.incl(i)
    for i in 0 .. lines.len-1:
      if not excludes.contains(i):
        echo lines[i]

