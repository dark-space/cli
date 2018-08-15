import strutils, parseopt, nre
import lib/io

var args: seq[string] = @[]

proc usage() =
  let s = """
Usage: newlines [OPTION]... [FILE]
  -s=<str>: Specify substituted str.
  -t      : Delete tail newlines."""
  echo s

var subst = "\\n"
var delete_tail = false
try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    if kind == cmdShortOption and key == "s":
      subst = val
    if kind == cmdShortOption and key == "t":
      delete_tail = true
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

var str = readRaw(args)
if delete_tail:
  str = str.replace(re"\s+","")
stdout.write(str.replace("\r","\\r").replace("\n", subst))

