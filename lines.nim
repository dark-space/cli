import strutils, tables, parseopt, sets, nre
import lib/io

var args: seq[string] = @[]
var opts = initTable[string,string]()

proc usage() =
  let s = """
Usage: line [OPTION]... PATTERN [FILE]
  -0    : index starts with 0.
  -v    : invert match.
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


let lines = read(args).split("\n")
var indices: seq[int] = @[]

proc toIndex(n: int): int =
  if n == 0:
    return 0
  elif n > 0:
    if opts.contains("zero"):
      return n
    else:
      return n-1
  elif n < 0:
    return lines.len + n

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
  quit(0)

proc append(n: int) =
  indices.add(n)


proc printAll() =
  for n in 0 .. lines.len-1:
    append(n)
  print()

proc printExactNumber(n: int) =
  append(n.toIndex)
  print()

proc printFrom(start: int) =
  for n in start.toIndex .. lines.len-1:
    append(n)
  print()

proc printUntil(last: int) =
  for n in 0.toIndex .. last.toIndex:
    append(n)
  print()

proc printFromtTo(start: int, last: int) =
  for n in start.toIndex .. last.toIndex:
    append(n)
  print()

proc printModulo(num: int, modulo: int) =
  if opts.contains("zero"):
    for i in 0 .. lines.len-1:
      if i mod num == modulo:
        append(i)
  else:
    for i in 1 .. lines.len:
      if i mod num == modulo:
        append(i-1)
  print()

proc printEach(query: string) =
  for i in query.split(re"[,\s]+"):
    append(i.parseInt.toIndex)
  print()

let query = args[0]
var m: Option[RegexMatch]
if query == ":" or query == "..":
  printAll()
m = query.match(re"^-?[0-9]+$"); if m != none(RegexMatch):
  printExactNumber(query.parseInt)
m = query.match(re"^(-?[0-9]+)(:|\.\.)$"); if m != none(RegexMatch):
  let first  = m.get.captures[0].parseInt
  printFrom(first)
m = query.match(re"^(:|\.\.)(-?[0-9]+)$"); if m != none(RegexMatch):
  let op = m.get.captures[0]
  let second  = m.get.captures[1].parseInt
  if op == ":":
    printUntil(second-1)
  elif op == "..":
    printUntil(second)
m = query.match(re"^(-?[0-9]+)(:|\.\.)(-?[0-9]+)$"); if m != none(RegexMatch):
  let op = m.get.captures[1]
  let first  = m.get.captures[0].parseInt
  let second = m.get.captures[2].parseInt
  if op == ":":
    if second == 0:
      printFromtTo(first, 0)
    else:
      printFromtTo(first, second-1)
  elif op == "..":
    printFromtTo(first, second)
m = query.match(re"^%([0-9]+)$"); if m != none(RegexMatch):
  let first  = m.get.captures[0].parseInt
  printModulo(first, 0)
m = query.match(re"^%([0-9]+)==?([0-9]+)$"); if m != none(RegexMatch):
  let first  = m.get.captures[0].parseInt
  let second = m.get.captures[1].parseInt
  printModulo(first, second)
m = query.match(re"^[\s-0-9]+$"); if m != none(RegexMatch):
  printEach(query)
usage()
quit(1)

