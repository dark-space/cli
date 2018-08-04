import strutils, tables, parseopt, sets, nre
import lib/table, lib/io

var args: seq[string] = @[]
var opts = initTable[string,string]()

proc usage() =
  let s = """
Usage: columns [OPTION]... [FILE]
  -d <str>: delimiter; default=\"\t\"."""
  echo s

var delimiter = "\t"
var regex = false

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

let lines = read(args).split("\n")
let data = getMatrix(lines, delimiter, regex)
if regex:
  delimiter = "\t"
for y in 0..<data[0].len:
  var str = ""
  for x in 0..<data.len:
    str &= data[x][y]
    str &= ","
  echo str[0..str.len-delimiter.len-1]

