import sets

###############
#[ SortedSet ]#
###############
type SortedSet*[T] = ref object of RootObj
  s: seq[T]
  g: HashSet[T]

proc search(a: openArray[int], x: int): int =
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


