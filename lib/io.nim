import strutils, nre

proc read*(files: seq[string]): string =
  if files.len < 1 or files[0] == "-":
    return readAll(stdin).replace("\r","").replace(re"\n$","")
  else:
    let f = open(files[0], FileMode.fmRead)
    defer: f.close()
    return f.readAll().replace("\r","").replace(re"\n$","")

proc read*(file: string): string =
  return read(@[file])

proc readRaw*(files: seq[string]): string =
  if files.len < 1 or files[0] == "-":
    return readAll(stdin)
  else:
    let f = open(files[0], FileMode.fmRead)
    defer: f.close()
    return f.readAll()

proc readRaw*(file: string): string =
  return readRaw(@[file])

iterator readLines*(files: seq[string]): string =
  if files.len < 1 or files[0] == "-":
    while true:
      yield readline(stdin).replace("\r","").replace(re"\n$","")
  else:
    let f = open(files[0], FileMode.fmRead)
    defer: f.close()
    while true:
      yield f.readline().replace("\r","").replace(re"\n$","")

iterator readLines*(file: string): string =
  let f = open(file, FileMode.fmRead)
  defer: f.close()
  while true:
    yield f.readline().replace("\r","").replace(re"\n$","")

iterator readLinesRaw*(files: seq[string]): string =
  if files.len < 1 or files[0] == "-":
    while true:
      yield readline(stdin)
  else:
    let f = open(files[0], FileMode.fmRead)
    defer: f.close()
    while true:
      yield f.readline()

iterator readLinesRaw*(file: string): string =
  let f = open(file, FileMode.fmRead)
  defer: f.close()
  while true:
    yield f.readline()

