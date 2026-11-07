/- Executable certificate checking. This module does not claim a soundness theorem.
   SHA-256 authentication and gzip decoding are performed by CertGPTGen.py. -/
import Std
import CertGPTKernel
import CertGPTBits
namespace C16Frames.CertGPT

abbrev Pair := Nat × Nat
structure Instance where
  x : Array Nat
  z : Array Nat
  items : Array (Array Pair)
  deriving Inhabited

abbrev parity := par128

def gram (d : Instance) (i j : Nat) : Bool := parity (d.x[i]! &&& d.z[j]!)
def bit (v c : Nat) : Bool := v >>> c &&& 1 == 1

def partialFrame (d : Instance) (q : Array Pair) : Bool :=
  !q.isEmpty && (Array.range q.size).all (fun a =>
    let p := q[a]!
    p.1 < d.x.size && p.2 < d.z.size &&
      (Array.range q.size).all (fun b =>
        let r := q[b]!
        gram d p.1 r.2 == (a == b) &&
          (a == b || (p.1 != r.1 && p.2 != r.2))))

def tau (k i : Nat) : Nat := 16 * (i / 16) + (i % 16 + k) % 16

def orbit (kind : String) (i j : Nat) : Array Pair :=
  if kind == "swap" then
    if i == j then #[(i,j)] else #[(i,j),(j,i)]
  else #[(i,j),(tau 4 i,tau 4 j),(tau 8 i,tau 8 j),(tau 12 i,tau 12 j)]

/-- Regenerate every partial-frame orbit. Compare pair sets, not item order. -/
@[noinline] def validateItems (d : Instance) (kind : String) : Bool := Id.run do
  if kind != "swap" && kind != "quarter" then return false
  if d.x.size != d.z.size then return false
  let n := d.x.size
  let mut seen := Array.replicate (n*n) false
  for q in d.items do
    if !partialFrame d q then return false
    let (i,j) := q[0]!
    let o := orbit kind i j
    if o.size != q.size || !o.all (fun p => q.contains p) then return false
    let key := o.foldl (fun v p => min v (p.1*n+p.2)) (n*n)
    if seen[key]! then return false
    seen := seen.set! key true
  let mut count := 0
  for i in [:n] do
    for j in [:n] do
      let o := orbit kind i j
      let key := o.foldl (fun v p => min v (p.1*n+p.2)) (n*n)
      if key == i*n+j && partialFrame d o then
        if !seen[key]! then return false
        count := count + 1
  return count == d.items.size

abbrev rank128 := geCount

structure SearchState where
  need : Nat
  residual : Array Nat
  live : Array Nat
  chosen : Array Pair := #[]
  deriving Inhabited

@[noinline] def cov (d : Instance) (q c k : Nat) : Bool :=
  d.items[q]!.foldl (fun a p => a != (bit d.x[p.1]! c && bit d.z[p.2]! k)) false

@[noinline] def rankLeaf (d : Instance) (s : SearchState) : Bool := Id.run do
  let mut xs := Array.replicate d.x.size false
  let mut zs := Array.replicate d.z.size false
  for q in s.live do
    for (i,j) in d.items[q]! do
      xs := xs.set! i true
      zs := zs.set! j true
  let xr := (Array.range d.x.size).filterMap (fun i => if xs[i]! then some d.x[i]! else none)
  let zr := (Array.range d.z.size).filterMap (fun i => if zs[i]! then some d.z[i]! else none)
  return rank128 xr < s.need || rank128 zr < s.need

@[noinline] def childState (d : Instance) (s : SearchState) (q : Nat)
    (done : Array Nat) : SearchState := Id.run do
  let item := d.items[q]!
  let mut r := s.residual
  for (i,j) in item do
    for c in [:128] do
      if bit d.x[i]! c then r := r.set! c (r[c]! ^^^ d.z[j]!)
  let live := s.live.filter fun a => a != q && !done.contains a &&
    d.items[a]!.all (fun p => item.all fun t =>
      p.1 != t.1 && p.2 != t.2 && !gram d p.1 t.2 && !gram d t.1 p.2)
  return {need := s.need-item.size, residual := r, live := live, chosen := s.chosen ++ item}

inductive Task where
  | node (s : SearchState)
  | children (s : SearchState) (remaining done : Array Nat) (count : Nat)
  deriving Inhabited

structure Stats where
  branches : Nat := 0
  ranks : Nat := 0
  empty : Nat := 0
  children : Nat := 0
  deriving Repr, Inhabited

structure Result where
  status : String
  cursor : Nat
  stats : Stats
  frame : Array Pair := #[]
  deriving Repr

/-- Total, fuelled DFS on a flat token stream. Opcodes R=0,E=1,B=2,C=3,K=4,S=5,F=6.
    END COMPLETE is removed by the strict decoder. Shards are deliberately rejected. -/
def run (d : Instance) (tokens : Array Nat) : Nat → List Task → Nat → Stats → Result
  | 0, _, p, st => ⟨"REJECT fuel",p,st,#[]⟩
  | fuel+1, tasks, p, st =>
    match tasks with
    | [] => ⟨if p == tokens.size then "ACCEPT" else "REJECT trailing",p,st,#[]⟩
    | .node s :: rest =>
      if s.need == 0 then
        if s.chosen.size == 128 && partialFrame d s.chosen then
          ⟨"FRAME",p,st,s.chosen⟩
        else ⟨"REJECT invalid frame",p,st,#[]⟩
      else if p >= tokens.size then ⟨"REJECT eof",p,st,#[]⟩
      else if tokens[p]! == 0 then
        if rankLeaf d s then run d tokens fuel rest (p+1) {st with ranks := st.ranks+1}
        else ⟨"REJECT rank",p,st,#[]⟩
      else if tokens[p]! == 1 || tokens[p]! == 2 then
        if p+2 >= tokens.size then ⟨"REJECT eof entry",p,st,#[]⟩ else
        let c := tokens[p+1]!; let k := tokens[p+2]!
        if c >= 128 || k >= 128 || !bit s.residual[c]! k then
          ⟨"REJECT residual",p,st,#[]⟩
        else
          let covering := s.live.filter (fun q => cov d q c k)
          if tokens[p]! == 1 then
            if covering.isEmpty then run d tokens fuel rest (p+3) {st with empty := st.empty+1}
            else ⟨"REJECT empty",p,st,#[]⟩
          else if p+3 >= tokens.size || tokens[p+3]! != covering.size then
            ⟨"REJECT coverage count",p,st,#[]⟩
          else run d tokens fuel (.children s covering #[] covering.size :: rest) (p+4)
            {st with branches := st.branches+1}
      else ⟨"REJECT node opcode",p,st,#[]⟩
    | .children s remaining done count :: rest =>
      if count == 0 then
        if remaining.isEmpty then run d tokens fuel rest p st
        else ⟨"REJECT missing children",p,st,#[]⟩
      else if p+1 >= tokens.size then ⟨"REJECT eof child",p,st,#[]⟩
      else
        let op := tokens[p]!; let q := tokens[p+1]!
        if !remaining.contains q then ⟨"REJECT child coverage",p,st,#[]⟩
        else
          let next := Task.children s (remaining.filter (fun a => a != q)) (done.push q) (count-1)
          if op == 4 then
            if d.items[q]!.size > s.need then run d tokens fuel (next::rest) (p+2) st
            else ⟨"REJECT K",p,st,#[]⟩
          else if op == 3 && d.items[q]!.size <= s.need then
            run d tokens fuel (.node (childState d s q done)::next::rest) (p+2)
              {st with children := st.children+1}
          else ⟨"REJECT child opcode or oversized C",p,st,#[]⟩

def checkTokens (d : Instance) (tokens : Array Nat) : Result :=
  run d tokens (tokens.size*2+2)
    [.node {need := 128, residual := (Array.range 128).map (fun c => 1 <<< c),
            live := Array.range d.items.size}] 0 {}

/-- Concrete operations for the proved generic recursion. Mathematical `RulesSound`
    obligations remain separate; this definition does not assert them. -/
def concreteRules (d : Instance) : Rules SearchState Nat (Nat × Nat) where
  need := SearchState.need
  rankOk := rankLeaf d
  emptyOk := fun s (c,k) => c < 128 && k < 128 && bit s.residual[c]! k &&
    !(s.live.any (fun q => cov d q c k))
  branchOk := fun s (c,k) qs => c < 128 && k < 128 && bit s.residual[c]! k &&
    let covering := s.live.filter (fun q => cov d q c k)
    qs.length == covering.size && qs.all (fun q => covering.contains q) &&
      decide qs.Nodup
  eligible := fun s q => q < d.items.size && s.live.contains q
  tooLarge := fun s q => d.items[q]!.size > s.need
  next := fun s done q => childState d s q done.toArray

mutual
  def parseTree (a : Array Nat) : Nat → Nat → Option (Tree Nat (Nat × Nat) × Nat)
    | 0, _ => none
    | fuel+1, p => do
      let op ← a[p]?
      if op == 0 then return (.rank,p+1)
      if op == 6 then return (.frame,p+1)
      if op == 5 then return (.shard,p+1)
      if op != 1 && op != 2 then failure
      let c ← a[p+1]?; let k ← a[p+2]?
      if op == 1 then return (.empty (c,k),p+3)
      let n ← a[p+3]?
      let (cs,p') ← parseChildren a fuel n (p+4)
      return (.branch (c,k) cs,p')
  def parseChildren (a : Array Nat) : Nat → Nat → Nat →
      Option (List (Nat × Option (Tree Nat (Nat × Nat))) × Nat)
    | 0, _, _ => none
    | fuel+1, count, p => do
      if count == 0 then return ([],p)
      let op ← a[p]?; let q ← a[p+1]?
      if op != 3 && op != 4 then failure
      let (t,p') ← if op == 4 then pure (none,p+2) else do
        let (t,r) ← parseTree a fuel (p+2)
        pure (some t,r)
      let (cs,p'') ← parseChildren a fuel (count-1) p'
      return ((q,t)::cs,p'')
end

/-- Evaluate the *proved generic recursion* with concrete executable operations.
    This still needs concrete RulesSound and pool-data proofs for no_swap_frame. -/
def checkViaKernel (d : Instance) (tokens : Array Nat) : Bool :=
  match parseTree tokens (tokens.size+1) 0 with
  | none => false
  | some (tree,p) => p == tokens.size &&
    check (concreteRules d) 129
      {need := 128, residual := (Array.range 128).map (fun c => 1 <<< c),
       live := Array.range d.items.size} tree

end C16Frames.CertGPT
