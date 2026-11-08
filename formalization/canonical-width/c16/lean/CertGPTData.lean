/- Runtime decoded data loader. Authenticated gzip conversion: CertGPTGen.py. -/
import CertGPTCheck
namespace C16Frames.CertGPT

def decode (a : Array Nat) : Option (Instance × Array Nat) := do
  let nx ← a[0]?; let nz ← a[1]?; let ni ← a[2]?
  if nx == 0 || nz == 0 || nx > 10000 || nz > 10000 || ni > 1000000 then none else do
  let mut p := 3
  let mut x := #[]; let mut z := #[]; let mut items := #[]
  for _ in [:nx] do
    let v ← a[p]?; if v >= 2^128 then failure
    x := x.push v; p := p+1
  for _ in [:nz] do
    let v ← a[p]?; if v >= 2^128 then failure
    z := z.push v; p := p+1
  for _ in [:ni] do
    let n ← a[p]?; p := p+1
    if n == 0 || n > 128 then failure
    let mut q := #[]
    for _ in [:n] do
      let i ← a[p]?; let j ← a[p+1]?; p := p+2
      if i >= nx || j >= nz then failure
      q := q.push (i,j)
    items := items.push q
  let n ← a[p]?; p := p+1
  if p+n != a.size then failure
  return ({x,z,items}, a.extract p a.size)
def decodeText (text : String) : Option (Instance × Array Nat) := do
  let words := text.splitOn " " |>.filter (fun s => !s.trimAscii.toString.isEmpty)
  let nums ← words.mapM (fun s => s.trimAscii.toString.toNat?)
  decode nums.toArray
end C16Frames.CertGPT
