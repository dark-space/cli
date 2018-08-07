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
type SortedSet*[T] = ref object of RootObj
  s: seq[T]
  g: HashSet[T]

proc initSortedSet*[T](): SortedSet[T] =
  return SortedSet[T](s: @[], g: initSet[T]())

proc incl*[T](this: var SortedSet[T], x: T) =
  if this.g.contains(x):
    return
  this.g.incl(x)
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc get*[T](this: SortedSet[T], i: int): T =
  return this.s[i]

proc `[]`*[T](this: SortedSet[T], i: int): T =
  return this.s[i]


###############
#[ SortedMap ]#
###############
type SortedMap*[K,V] = ref object of RootObj
  s: seq[K]
  g: Table[K,V]

proc initSortedMap*[K,V](): SortedMap[K,V] =
  return SortedMap[K,V](s: @[], g: initTable[K,V]())

proc `[]=`*[K,V](this: var SortedMap[K,V], x: K, y: V) =
  if this.g.contains(x):
    return
  this.g[x] = y
  if this.s.len <= 0:
    this.s.add(x)
  else:
    this.s.insert(x, search(this.s, x))

proc get*[K,V](this: SortedMap[K,V], k:K): V =
  return this.g[k]

proc `[]`*[K,V](this: SortedMap[K,V], i: int): V =
  return this.g[this.s[i]]

var xxx = initSortedMap[string,int]()
xxx["three"] = 3
xxx["two"] = 2
xxx["one"] = 1
xxx["zero"] = 0
echo xxx[3]
echo xxx.get("one")
