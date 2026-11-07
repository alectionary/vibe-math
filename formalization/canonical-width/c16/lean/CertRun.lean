/-
Certificate checker for a swap-class no-frame search.

The hot loop is Nat bitwise arithmetic. `certificateOk` (in `CertValue.lean`) packages the
pool arrays, the generated item table and the generated token stream; `CertCheck.lean` proves
that acceptance implies there is no swap-invariant frame.

Bytecode, after hex decoding: `0` rank leaf; `1 c k` empty leaf; `2 c k m` branch;
`3`/`4`/`5` then a little-endian uint16 item id for a child that is expanded, killed, or
sharded. Sharded children are rejected: the swap certificate is one complete file.
-/

namespace C16Frames.CertRun

/-- Parity of the low 128 bits, by the xor-fold used in `Aut.lean`. -/
def par128 (v : Nat) : Bool :=
  let v := (v ^^^ (v >>> 64)) &&& (2 ^ 64 - 1)
  let v := v ^^^ (v >>> 32)
  let v := v ^^^ (v >>> 16)
  let v := v ^^^ (v >>> 8)
  let v := v ^^^ (v >>> 4)
  let v := v ^^^ (v >>> 2)
  let v := v ^^^ (v >>> 1)
  v % 2 == 1

/-- Flat item table. Item `q` occupies pairs `start[q] .. start[q+1]`. -/
structure Table where
  start : Array Nat
  ii : Array Nat
  jj : Array Nat
deriving Inhabited

def Table.nI (t : Table) : Nat :=
  if t.start.size = 0 then 0 else t.start.size - 1

def Table.pairs (t : Table) (q : Nat) : List (Nat × Nat) :=
  let a := t.start.getD q 0
  let b := t.start.getD (q + 1) 0
  (List.range (b - a)).map fun k => (t.ii.getD (a + k) 0, t.jj.getD (a + k) 0)

def keep (x z : Array Nat) (i j : Nat) : Bool :=
  let xi := x.getD i 0
  let xj := x.getD j 0
  let zi := z.getD i 0
  let zj := z.getD j 0
  let G (a b : Nat) : Bool := par128 (a &&& b)
  if i == j then G xi zi
  else G xi zj && G xj zi && !G xi zi && !G xj zj

/-- `some key` when `pairs` is the swap orbit of a partial frame, with `j ≤ i` packed as `j * 1024 + i`. -/
def itemKey (x z : Array Nat) (pairs : List (Nat × Nat)) : Option Nat :=
  match pairs with
  | [(i, j)] =>
    if i == j && decide (i < 720) && keep x z i i then some (i * 1024 + i) else none
  | [(i, j), (a, b)] =>
    if decide (i < 720) && decide (j < 720) && a == j && b == i && !(i == j) &&
        keep x z (max i j) (min i j) then
      some (min i j * 1024 + max i j)
    else none
  | _ => none

def genAcc (x z : Array Nat) (i j : Nat) (acc : Array Nat) : Array Nat :=
  if i ≥ 720 then acc
  else if j ≥ i + 1 then genAcc x z (i + 1) 0 acc
  else
    let acc := if keep x z i j then acc.push (j * 1024 + i) else acc
    genAcc x z i (j + 1) acc
termination_by (720 - i, (i + 1) - j)

def genKeys (x z : Array Nat) : Array Nat :=
  (genAcc x z 0 0 #[]).qsort (fun a b => decide (a < b))

def takePairs (t : Table) (a b : Nat) : List (Nat × Nat) :=
  (List.range (b - a)).map fun k => (t.ii.getD (a + k) 0, t.jj.getD (a + k) 0)

def foldKeys (x z : Array Nat) (t : Table) (nI q cursor : Nat) (keys : Array Nat) :
    Option (Array Nat) :=
  if q ≥ nI then
    if cursor == t.ii.size then some keys else none
  else
    let a := t.start.getD q 0
    let b := t.start.getD (q + 1) 0
    if a != cursor || decide (b < a) then none
    else
      match itemKey x z (takePairs t a b) with
      | none => none
      | some k => foldKeys x z t nI (q + 1) b (keys.push k)
termination_by nI - q

def strictSortedFrom (a : Array Nat) (i prev : Nat) (seen : Bool) : Bool :=
  if i ≥ a.size then true
  else
    let k := a.getD i 0
    if seen && decide (k ≤ prev) then false else strictSortedFrom a (i + 1) k true
termination_by a.size - i

/-- The item table is exactly the set of swap orbits that are partial frames. -/
def itemsMatch (x z : Array Nat) (t : Table) : Bool :=
  if t.start.isEmpty then false
  else
    let nI := t.start.size - 1
    if t.start.getD 0 99 != 0 || t.ii.size != t.jj.size || t.start.getD nI 99 != t.ii.size then
      false
    else
      match foldKeys x z t nI 0 0 #[] with
      | none => false
      | some keys =>
        let sorted := keys.qsort (fun a b => decide (a < b))
        strictSortedFrom sorted 0 0 false && sorted == genKeys x z

def aset (a : Array Nat) (i v : Nat) : Array Nat :=
  if h : i < a.size then a.set i v h else a

def hexNib (b : UInt8) : Nat :=
  let n := b.toNat
  if n ≥ 48 && n ≤ 57 then n - 48
  else if n ≥ 97 && n ≤ 102 then n - 87
  else 16

def decodeHexBytes (s : String) : ByteArray := Id.run do
  let raw := s.toUTF8
  let n := raw.size / 2
  let mut o := ByteArray.emptyWithCapacity n
  for i in List.range n do
    let hi := hexNib raw[2 * i]!
    let lo := hexNib raw[2 * i + 1]!
    o := o.push (hi * 16 + lo).toUInt8
  return o

def bget (a : ByteArray) (i : Nat) : Nat :=
  if h : i < a.size then (a.get i h).toNat else 0

/-- Decode the certificate bytecode into the token stream `0 | 1 c k | 2 c k m | 3/4/5 q`. -/
def decodeTokens (bytes : ByteArray) : Array Nat := Id.run do
  let mut i : Nat := 0
  let mut tok : Array Nat := Array.emptyWithCapacity (bytes.size)
  let mut ok : Bool := true
  while i < bytes.size && ok do
    let b := bget bytes i
    if b = 0 then
      tok := tok.push 0
      i := i + 1
    else if b = 1 && i + 2 < bytes.size then
      tok := ((tok.push 1).push (bget bytes (i + 1))).push (bget bytes (i + 2))
      i := i + 3
    else if b = 2 && i + 3 < bytes.size then
      tok := (((tok.push 2).push (bget bytes (i + 1))).push (bget bytes (i + 2))).push
        (bget bytes (i + 3))
      i := i + 4
    else if (b = 3 || b = 4 || b = 5) && i + 2 < bytes.size then
      let q := bget bytes (i + 1) + 256 * bget bytes (i + 2)
      tok := (tok.push b).push q
      i := i + 3
    else
      ok := false
  return tok

def decodeHex (s : String) : Array Nat :=
  decodeTokens (decodeHexBytes s)

def readU16 (b : ByteArray) (i : Nat) : Nat :=
  bget b i + 256 * bget b (i + 1)

def readU16s (b : ByteArray) (off count : Nat) : Array Nat := Id.run do
  let mut a := Array.emptyWithCapacity count
  for i in List.range count do
    a := a.push (readU16 b (off + 2 * i))
  return a

/-- Decode `itemHex`: `nI`, `nPairs`, `nI + 1` starts, then the X and Z indices. -/
def decodeTable (s : String) : Table :=
  let raw := decodeHexBytes s
  let nI := readU16 raw 0
  let nP := readU16 raw 2
  let startOff := 4
  let iOff := startOff + 2 * (nI + 1)
  let jOff := iOff + 2 * nP
  { start := readU16s raw startOff (nI + 1)
    ii := readU16s raw iOff nP
    jj := readU16s raw jOff nP }

structure Ctx where
  x : Array Nat
  z : Array Nat
  gRow : Array Nat
  col : Array Nat
  xmask : Array Nat
  zmask : Array Nat
  items : Table
  tok : Array Nat

def foldN {α : Type} (n : Nat) (init : α) (f : Nat → α → α) : α :=
  let rec go (i : Nat) (acc : α) : α :=
    if i ≥ n then acc else go (i + 1) (f i acc)
  termination_by n - i
  go 0 init

def buildOneRow (x z : Array Nat) (i : Nat) : Nat :=
  let xi := x.getD i 0
  foldN 720 0 fun j acc =>
    if par128 (xi &&& z.getD j 0) then acc ||| (1 <<< j) else acc

@[noinline] def buildGRow (x z : Array Nat) : Array Nat :=
  Array.ofFn (n := 720) fun i => buildOneRow x z i.1

@[noinline] def buildCol (gRow : Array Nat) : Array Nat :=
  Array.ofFn (n := 720) fun j =>
    foldN 720 0 fun i acc =>
      if (gRow.getD i 0).testBit j.1 then acc ||| (1 <<< i) else acc

def pairMask (pairs : List (Nat × Nat)) (xSide : Bool) : Nat :=
  pairs.foldl (fun acc p => acc ||| (1 <<< if xSide then p.1 else p.2)) 0

def buildMasks (t : Table) : Array Nat × Array Nat :=
  let nI := t.nI
  let xm := Array.ofFn (n := nI) fun q => pairMask (t.pairs q.1) true
  let zm := Array.ofFn (n := nI) fun q => pairMask (t.pairs q.1) false
  (xm, zm)

def prep (x z : Array Nat) (t : Table) (tok : Array Nat) : Ctx :=
  let gRow := buildGRow x z
  let col := buildCol gRow
  let (xm, zm) := buildMasks t
  { x, z, gRow, col, xmask := xm, zmask := zm, items := t, tok }

def idRes : Array Nat :=
  Array.ofFn (n := 128) fun c => 1 <<< c.1

def resBit (res : Array Nat) (c k : Nat) : Bool :=
  (res.getD c 0).testBit k

def covers (x z : Array Nat) (pairs : List (Nat × Nat)) (c k : Nat) : Bool :=
  pairs.foldl (fun acc (i, j) =>
    acc ^^ ((x.getD i 0).testBit c && (z.getD j 0).testBit k)) false

def covList (ctx : Ctx) (live : Array Nat) (c k : Nat) : Array Nat :=
  live.filter fun q => covers ctx.x ctx.z (ctx.items.pairs q) c k

def toMask (a : Array Nat) : Nat :=
  a.foldl (fun acc q => acc ||| (1 <<< q)) 0

def setBits (mask : Nat) : Array Nat :=
  let rec go (i : Nat) (acc : Array Nat) : Array Nat :=
    if i ≥ 720 then acc
    else go (i + 1) (if mask.testBit i then acc.push i else acc)
  termination_by 720 - i
  go 0 #[]

def packRow (row : Nat) (cols : Array Nat) : Nat :=
  let rec go (b acc : Nat) : Nat :=
    if b ≥ cols.size then acc
    else
      let j := cols.getD b 0
      go (b + 1) (if row.testBit j then acc ||| (1 <<< b) else acc)
  termination_by cols.size - b
  go 0 0

def elimPiv (r : Nat) (pivs : Array Nat) : Nat :=
  let rec go (k r : Nat) : Nat :=
    if k ≥ pivs.size then r
    else
      let p := pivs.getD k 0
      let r := if p != 0 && r.testBit p.log2 then r ^^^ p else r
      go (k + 1) r
  termination_by pivs.size - k
  go 0 r

@[noinline] def geCount (rows : Array Nat) : Nat :=
  let pivs := rows.foldl (fun pivs r =>
    let r := elimPiv r pivs
    if r == 0 then pivs else pivs.push r) (#[] : Array Nat)
  pivs.size

@[noinline] def rankLt (ctx : Ctx) (live : Array Nat) (need : Nat) : Bool :=
  let (xs, zs) := live.foldl (fun (acc : Nat × Nat) q =>
    (acc.1 ||| ctx.xmask.getD q 0, acc.2 ||| ctx.zmask.getD q 0)) (0, 0)
  let cols := setBits zs
  let rows := (setBits xs).map fun i => packRow (ctx.gRow.getD i 0) cols
  decide (geCount rows < need)

def addPairs (x z : Array Nat) (res : Array Nat) (pairs : List (Nat × Nat)) : Array Nat :=
  pairs.foldl (fun res (i, j) =>
    let xi := x.getD i 0
    let zj := z.getD j 0
    foldN 128 res fun c res =>
      if xi.testBit c then aset res c ((res.getD c 0) ^^^ zj) else res) res

def compatible (ctx : Ctx) (q r : Nat) : Bool :=
  let xq := ctx.xmask.getD q 0
  let xr := ctx.xmask.getD r 0
  let zq := ctx.zmask.getD q 0
  let zr := ctx.zmask.getD r 0
  xq &&& xr == 0 && zq &&& zr == 0 &&
    (ctx.items.pairs q).all fun (i, j) =>
      ctx.gRow.getD i 0 &&& zr == 0 && ctx.col.getD j 0 &&& xr == 0

def itemLen (t : Table) (q : Nat) : Nat :=
  t.start.getD (q + 1) 0 - t.start.getD q 0

mutual
def checkNode (ctx : Ctx) (fuel pos need : Nat) (res live : Array Nat) : Option Nat :=
  match fuel with
  | 0 => none
  | fuel + 1 =>
    if need = 0 then none
    else
      let tag := ctx.tok.getD pos 99
      if tag = 0 then
        if rankLt ctx live need then some (pos + 1) else none
      else if tag = 1 then
        let c := ctx.tok.getD (pos + 1) 999
        let k := ctx.tok.getD (pos + 2) 999
        if decide (c < 128) && decide (k < 128) && resBit res c k &&
            (covList ctx live c k).isEmpty then
          some (pos + 3)
        else none
      else if tag = 2 then
        let c := ctx.tok.getD (pos + 1) 999
        let k := ctx.tok.getD (pos + 2) 999
        let m := ctx.tok.getD (pos + 3) 999
        if decide (c < 128) && decide (k < 128) && resBit res c k then
          let cov := covList ctx live c k
          if cov.size == m then
            checkKids ctx fuel (pos + 4) need res live cov (toMask cov) 0 0 m
          else none
        else none
      else none

def checkKids (ctx : Ctx) (fuel pos need : Nat) (res live cov : Array Nat)
    (covMask done seen : Nat) (m : Nat) : Option Nat :=
  match fuel with
  | 0 => none
  | fuel + 1 =>
    if seen = m then some pos
    else
      let ck := ctx.tok.getD pos 99
      let q := ctx.tok.getD (pos + 1) 999
      let nI := ctx.items.nI
      if decide (q < nI) && covMask.testBit q && !done.testBit q then
        let pos := pos + 2
        if ck = 4 then
          if decide (itemLen ctx.items q > need) then
            checkKids ctx fuel pos need res live cov covMask (done ||| (1 <<< q)) (seen + 1) m
          else none
        else if ck = 5 then
          none
        else if ck = 3 then
          if decide (itemLen ctx.items q ≤ need) then
            let res2 := addPairs ctx.x ctx.z res (ctx.items.pairs q)
            let live2 := live.filter fun r =>
              r != q && !done.testBit r && compatible ctx q r
            match checkNode ctx fuel pos (need - itemLen ctx.items q) res2 live2 with
            | some pos2 =>
              checkKids ctx fuel pos2 need res live cov covMask (done ||| (1 <<< q)) (seen + 1) m
            | none => none
          else none
        else none
      else none
end

def checkWith (ctx : Ctx) : Bool :=
  let nI := ctx.items.nI
  let live := Array.ofFn (n := nI) fun q => q.1
  match checkNode ctx (ctx.tok.size * 2 + 2) 0 128 idRes live with
  | some pos => decide (pos = ctx.tok.size)
  | none => false

def check (x z : Array Nat) (t : Table) (tok : Array Nat) : Bool :=
  checkWith (prep x z t tok)

end C16Frames.CertRun
