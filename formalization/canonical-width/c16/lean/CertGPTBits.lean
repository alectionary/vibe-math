import Std
/- Parity and Gaussian span-count definitions adapted from the permitted read-only
   branch independent/c16-lean-cert-20261107, CertRun.lean (Grok/xAI).
   Kept separate from the Mathlib proofs for efficient executable use. -/
namespace C16Frames.CertGPT
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


end C16Frames.CertGPT
