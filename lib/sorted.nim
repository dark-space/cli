import sets, tables

proc search[T](a: openArray[T], x: T): int =
  var left  = 0
  var right = a.len-1
  while true:
    let center = int((left+right) / 2)
    if x < a[center]:
      if center == left:
        return center
      right = center-1
    elif x > a[center]:
      if center == right:
        return center+1
      left = center+1

###############
#[ SortedSet ]#
###############
type SortedSet*[T] = object
  s: seq[T]
  g: HashSet[T]

proc initSortedSet*[T](): SortedSet[T] =
  return SortedSet[T](s: @[], g: initSet[T]())

proc incl*[T](this: var SortedSet[T], x: T) {.inline.} =
  if this.g.contains(x):
    return
  this.g.incl(x)
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc get*[T](this: SortedSet[T], i: int): T {.inline.} =
  return this.s[i]

proc `[]`*[T](this: SortedSet[T], i: int): T {.inline.} =
  return this.s[i]


###############
#[ SortedMap ]#
###############
type SortedMap*[K,V] = object
  s: seq[K]
  g: Table[K,V]

proc initSortedMap*[K,V](): SortedMap[K,V] =
  return SortedMap[K,V](s: @[], g: initTable[K,V]())

proc `[]=`*[K,V](this: var SortedMap[K,V], x: K, y: V) {.inline.} =
  if this.g.contains(x):
    return
  this.g[x] = y
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc get*[K,V](this: SortedMap[K,V], k:K): V {.inline.} =
  return this.g[k]

proc `[]`*[K,V](this: SortedMap[K,V], i: int): V {.inline.} =
  return this.g[this.s[i]]

