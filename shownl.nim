import strutils, parseopt
import lib/io

var args: seq[string] = @[]

proc usage() =
  let s = """
Usage: newlines [OPTION]... [FILE]
  -s=<str>: Specify substituted str."""
  echo s

var subst = "\\n"
try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    if kind == cmdShortOption and key == "s":
      subst = val
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

stdout.write(readRaw(args).replace("\r","\\r").replace("\n", subst))

