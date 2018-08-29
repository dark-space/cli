import strutils, parseopt, nre
import lib/io

proc usage() =
  let s = """
Usage: de [OPTION]... PATTERN [FILE]
  -n      : repeat N times.
  -r      : remain first N islands."""
  echo s

var repeatN = 1
var reverse = false

var args: seq[string] = @[]
try:
  for kind, key, val in getopt():
    if kind == cmdArgument:
      args.add(key)
    elif (kind == cmdShortOption and key == "n"):
      repeatN = val.parseInt
    elif (kind == cmdShortOption and key == "r"):
      reverse = true
    else:
      usage()
      quit(0)
except:
  usage()
  quit(1)

if not reverse:
  if repeatN >= 0:
    for line in readLines(args):
      var l = line
      for i in 1 .. repeatN:
        l = l.replace(re"^\s*\S+\s*", "")
      l = l.replace(re"^\s+","").replace(re"\s+$","")
      echo l
  else:
    for line in readLines(args):
      var l = line
      for i in 1 .. -repeatN:
        l = l.replace(re"\s*\S+\s*$", "")
      l = l.replace(re"^\s+","").replace(re"\s+$","")
      echo l
else:
  var m: Option[RegexMatch]
  if repeatN >= 0:
    for line in readLines(args):
      var outStr = ""
      var l = line
      for i in 1 .. repeatN:
        m = l.match(re"^(\s*\S+\s*)(.*)$"); if m != none(RegexMatch):
          outStr &= m.get.captures[0]
          l = m.get.captures[1]
      outStr = outStr.replace(re"^\s+","").replace(re"\s+$","")
      echo outStr
  else:
    for line in readLines(args):
      var outStr = ""
      var l = line
      for i in 1 .. -repeatN:
        m = l.match(re"^(.*?)(\s*\S+\s*)$"); if m != none(RegexMatch):
          outStr = m.get.captures[1] & outStr
          l = m.get.captures[0]
      outStr = outStr.replace(re"^\s+","").replace(re"\s+$","")
      echo outStr

