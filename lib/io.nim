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

