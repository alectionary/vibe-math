import PackedTables
set_option maxHeartbeats 0
namespace KernelCatalog

structure Vertex where
  left : Bool
  a : Nat
  b : Nat
structure Edge where
  a : Nat
  b : Nat
  j : Nat
  i : Nat

def columnPairs : Array (Array Nat) := #[#[0,1],#[0,2],#[0,3],#[1,2],#[1,3],#[2,3]]
def rowPairs : Array (Array Nat) := #[#[0,1],#[0,2],#[1,2]]
def table (a : Array (Array Nat)) (i j : Nat) : Nat := (a[i]!)[j]!
def column10 (p j : Nat) : Nat :=
  let q := p/64/9
  if j=0 then q/36 else if j=1 then q/6%6 else q%6
def row10 (p i : Nat) : Nat := if i=0 then p/64/3%3 else p/64%3
def flip10 (p i j : Nat) : Nat := ((p%64) / (2^(5-(3*i+j))))%2

def vertex (w p v : Nat) : Vertex :=
  if w=7 then
    if v<4 then ⟨true,v,perm4Value (p/6) v⟩
    else ⟨false,perm3Value (p%6) (v-4),v-4⟩
  else if w=10 then
    if v<6 then ⟨true,v/2+1,columnPairValue (column10 p (v/2)) (v%2)⟩
    else ⟨false,rowPairValue (row10 p ((v-6)/2)) ((v-6)%2),(v-6)/2+1⟩
  else
    if v<3 then ⟨true,v,perm4Value (p/2448) v⟩
    else if v<8 then ⟨true,3,centerLeafValue (p/2%204) (v-3)⟩
    else ⟨false,perm3Value (p/408%6) (v-8),v-8⟩

def edge (w p k : Nat) : Edge :=
  if w=7 then ⟨k/3,4+k%3,k/3,k%3⟩
  else if w=10 then
    if k<3 then ⟨2*k,2*k+1,k+1,0⟩
    else
      let i := (k-3)/7
      let r := (k-3)%7
      if r=0 then ⟨6+2*i,7+2*i,0,i+1⟩
      else
        let j := (r-1)/2
        let t := (r-1)%2
        let mate := if t=flip10 p i j then 0 else 1
        ⟨2*j+t,6+2*i+mate,j+1,i+1⟩
  else
    if k<9 then ⟨k/3,8+k%3,k/3,k%3⟩
    else
      let leaf := (k-9)/3
      let r := (k-9)%3
      let orientation := p%2+1
      if r=0 then ⟨3,5+leaf,3,(leaf+orientation)%3⟩
      else if r=1 then ⟨4,5+leaf,3,(leaf+3-orientation)%3⟩
      else ⟨5+leaf,8+leaf,3,leaf⟩

def edgeCount (w : Nat) := if w=7 then 12 else if w=10 then 17 else 18
def patternCount (w : Nat) := if w=7 then 144 else if w=10 then 124416 else 58752

def entryCoefficient (i j k : Nat) : Int :=
  if i=0 ∨ j=0 then 0 else if k=3*(i-1)+j-1 then 1 else 0
def offsetCoefficient (v : Vertex) (j i k : Nat) : Int :=
  if v.left then entryCoefficient i v.b k else -entryCoefficient v.a j k

/-- A complete check-matching equation, including all vertex-fiber variables. -/
def sourceRow (w p : Nat) (r : Fin 18) (c : Fin (w+6)) : Int :=
  if r.val<edgeCount w then
    let e := edge w p r.val
    if c.val<6 then
      offsetCoefficient (vertex w p e.a) e.j e.i c.val -
        offsetCoefficient (vertex w p e.b) e.j e.i c.val
    else (if c.val=6+e.a then 1 else 0) - (if c.val=6+e.b then 1 else 0)
  else 0

def targetID (code : Nat) : Nat := code%256
def coefficientBits (code : Nat) : Nat := (code / 256)%256
def arity (code : Nat) : Nat := targetArity (targetID code)
def zigzagDecode (n : Nat) : Int :=
  if n%2=0 then (n/2 : Nat) else -((n+1)/2 : Nat)
def coefficient (code t i : Nat) : Int :=
  let bits := coefficientBits code
  zigzagDecode ((code / (2^(16+bits*(18*t+i))))%(2^bits))
def target (w code : Nat) (t : Fin (arity code)) (j : Fin (w+6)) : Int :=
  if j.val<6 then targetValue (targetID code) t.val j.val else 0

def dot18 (f : Fin 18 → Int) : Int := f 0 + f 1 + f 2 + f 3 + f 4 + f 5 + f 6 + f 7 + f 8 + f 9 + f 10 + f 11 + f 12 + f 13 + f 14 + f 15 + f 16 + f 17


def checkOne (w p code : Nat) : Bool :=
  decide (w=7 ∨ w=10 ∨ w=11) && decide (p<patternCount w) &&
    decide (targetID code<64) &&
    decide (∀ t : Fin (arity code), ∀ j : Fin (w+6),
      target w code t j=dot18 (fun i => coefficient code t.val i.val * sourceRow w p i j))

def checkBlock (w offset : Nat) (data : Array Nat) : Bool :=
  (List.range data.size).all (fun i => checkOne w (offset+i) data[i]!)

end KernelCatalog
