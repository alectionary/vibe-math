/-
The code C^LP_{16,9} from Lee, arXiv:2610.06820v1, equation (50), and the bridge from its
physical operators to the pools of `Pools.lean`.

This is a line-by-line port of `verify_partial_frame.py` (`reconstruct_checks`, `shift`) and
`audit_pools.py` (`exchange`, canonical frame, pool coordinates). Operators are `Nat` bit masks
over the 1088 qubits; an X-type operator `x` and a Z-type operator `z` anticommute iff
`par x z` (odd overlap). Facts about the concrete data are checked by `native_decide`.
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod
import Pools
import PhysData

namespace C16Frames.Code
open C16Frames.Phys C16Frames.Pools

def P : Nat := 16
def N : Nat := 1088
def R : Nat := 3
def S : Nat := 5

/-- Equation (50): coefficients `0, 1, ω, ω²` coded as `0, 1, 2, 3`. -/
def Cf : List (List Nat) := [[1, 1, 1, 1, 1], [1, 1, 2, 0, 3], [1, 3, 1, 2, 0]]
/-- Equation (50): exponents. -/
def Ex : List (List Int) := [[0, 0, 0, 0, 0], [0, 6, 12, 9, 3], [0, 12, 6, 2, 14]]
/-- Binary trace representation: ρ(0)=0, ρ(1)=I, ρ(ω)=[[0,1],[1,1]], ρ(ω²)=[[1,1],[1,0]]. -/
def rho (c a b : Nat) : Bool :=
  match c, a, b with
  | 1, 0, 0 => true | 1, 1, 1 => true
  | 2, 0, 1 => true | 2, 1, 0 => true | 2, 1, 1 => true
  | 3, 0, 0 => true | 3, 0, 1 => true | 3, 1, 0 => true
  | _, _, _ => false

def cf (i a : Nat) : Nat := (Cf.getD i []).getD a 0
def ex (i a : Nat) : Int := (Ex.getD i []).getD a 0

/-- Number of qubits in the support. -/
def popc (v : Nat) : Nat := (List.range N).countP (fun c => v.testBit c)
/-- Odd overlap: X-type `a` and Z-type `b` anticommute. -/
def par (a b : Nat) : Bool := popc (a &&& b) % 2 == 1

def mask (supp : List Nat) : Nat := supp.foldl (fun acc q => acc ||| (1 <<< q)) 0

/-- Cyclic shift by `h` inside every 16-qubit block. -/
def shift (v h : Nat) : Nat :=
  (List.range N).foldl (fun acc q =>
    if v.testBit q then acc ||| (1 <<< ((q / P) * P + (q % P + h) % P)) else acc) 0

/-- Monomial lists of the balanced rows (`B = A†` uses the group inverse). -/
def hxRows : List (List (Nat × Nat × Int)) :=
  (List.range R).flatMap fun i => (List.range S).map fun b =>
    ((List.range S).map fun a => (a * S + b, cf i a, ex i a)) ++
    ((List.range R).map fun j => (S * S + i * R + j, cf j b, -ex j b))
def hzRows : List (List (Nat × Nat × Int)) :=
  (List.range S).flatMap fun a => (List.range R).map fun j =>
    ((List.range S).map fun b => (a * S + b, cf j b, ex j b)) ++
    ((List.range R).map fun i => (S * S + i * R + j, cf i a, -ex i a))

/-- Trace expansion of one quaternary row: two binary rows `first[0], first[1]`. -/
def firstRows (mons : List (Nat × Nat × Int)) : Nat × Nat :=
  mons.foldl (fun (acc : Nat × Nat) (m : Nat × Nat × Int) =>
    let (blk, c, e) := m
    let pos := ((-e) % (P : Int)).toNat
    let bitOf (b : Nat) : Nat := 1 <<< ((2 * blk + b) * P + pos)
    let r0 := (if rho c 0 0 then bitOf 0 else 0) ^^^ (if rho c 0 1 then bitOf 1 else 0)
    let r1 := (if rho c 1 0 then bitOf 0 else 0) ^^^ (if rho c 1 1 then bitOf 1 else 0)
    (acc.1 ^^^ r0, acc.2 ^^^ r1)) (0, 0)

/-- Balanced expansion: of the three nonzero binary rows keep the two lightest (ties by index),
then all 16 translates of each. -/
def expandRow (mons : List (Nat × Nat × Int)) : List Nat :=
  let (f0, f1) := firstRows mons
  let three : List (Nat × Nat) := [(popc f0, 0), (popc f1, 1), (popc (f0 ^^^ f1), 2)]
  let sorted := three.mergeSort (fun p q => p.1 < q.1 || (p.1 == q.1 && p.2 ≤ q.2))
  let rowOf (k : Nat) : Nat := if k == 0 then f0 else if k == 1 then f1 else f0 ^^^ f1
  (sorted.take 2).flatMap fun p => (List.range P).map fun h => shift (rowOf p.2) h

def hx : List Nat := hxRows.flatMap expandRow
def hz : List Nat := hzRows.flatMap expandRow

/-- The X ↔ Z exchange (tensor transpose) on qubits. -/
def exchangeQ (q : Nat) : Nat :=
  let blk := q / P; let pos := q % P
  let tensor := blk / 2; let trace := blk % 2
  let t' := if tensor < 25 then (tensor % 5) * 5 + tensor / 5
            else 25 + ((tensor - 25) % 3) * 3 + (tensor - 25) / 3
  (2 * t' + trace) * P + pos
def exchange (v : Nat) : Nat :=
  (List.range N).foldl (fun acc q => if v.testBit q then acc ||| (1 <<< exchangeQ q) else acc) 0

/-- The width-18 canonical frame (8 seeds × 16 shifts). -/
def canX : List Nat := canonSeedX.flatMap fun r => (List.range P).map fun h => shift (mask r) h
def canZ : List Nat := canonSeedZ.flatMap fun r => (List.range P).map fun h => shift (mask r) h

/-- The physical pools, in the index order of `PoolData.lean` (entry `16a+h`). -/
def zPhys : List Nat := zReps.flatMap fun r => (List.range P).map fun h => shift (mask r) h
def xPhys : List Nat := zReps.flatMap fun r => (List.range P).map fun h => shift (exchange (mask r)) h

/-- Logical coordinates: pairing with the dual half of the width-18 frame. -/
def coordX (v : Nat) : Nat := ((List.range 128).filter fun c => par v (canZ.getD c 0)).foldl (fun a c => a ||| (1 <<< c)) 0
def coordZ (v : Nat) : Nat := ((List.range 128).filter fun c => par (canX.getD c 0) v).foldl (fun a c => a ||| (1 <<< c)) 0

/-! ### Checks on the code -/

/-- Row expansion always keeps two rows and all sixteen translates of each. -/
private theorem expandRow_length (mons : List (Nat × Nat × Int)) :
    (expandRow mons).length = 32 := by
  simp only [expandRow, List.length_flatMap, List.length_map, List.length_range,
    List.map_const', List.sum_replicate_nat, List.length_take, List.length_mergeSort,
    List.length_cons, List.length_nil, P]
  rfl

theorem hx_length : hx.length = 480 := by
  simp only [hx, List.length_flatMap, expandRow_length, List.map_const', List.sum_replicate_nat,
    hxRows, List.length_flatMap, List.length_map, List.length_range, List.map_const', List.sum_replicate_nat]
  rfl
theorem hz_length : hz.length = 480 := by
  simp only [hz, List.length_flatMap, expandRow_length, List.map_const', List.sum_replicate_nat,
    hzRows, List.length_flatMap, List.length_map, List.length_range, List.map_const', List.sum_replicate_nat]
  rfl
theorem checks_weight_le_9 : hx.all (fun v => popc v ≤ 9) && hz.all (fun v => popc v ≤ 9) := by
  native_decide
/-- CSS condition: every X check commutes with every Z check. -/
theorem checks_commute : hx.all (fun x => hz.all fun z => !par x z) := by native_decide

/-! ### The width-18 frame -/

theorem canon_length : canX.length = 128 ∧ canZ.length = 128 := by
  simp only [canX, canZ, List.length_flatMap, List.length_map, List.length_range,
    List.map_const', List.sum_replicate_nat]
  constructor <;> rfl
theorem canon_logical : canX.all (fun v => hz.all fun z => !par v z) &&
    canZ.all (fun v => hx.all fun x => !par x v) := by native_decide
theorem canon_gram : ∀ c d : Fin 128, par (canX.getD c 0) (canZ.getD d 0) = (c == d) := by
  native_decide
theorem canon_width : (canX ++ canZ).all (fun v => popc v ≤ 18) &&
    (canX ++ canZ).any (fun v => popc v == 18) := by native_decide

/-! ### The pools are weight-16 logical operators with the recorded coordinates -/

theorem pools_length : xPhys.length = 720 ∧ zPhys.length = 720 := by
  simp only [xPhys, zPhys, List.length_flatMap, List.length_map, List.length_range,
    List.map_const', List.sum_replicate_nat]
  constructor <;> rfl
theorem pools_weight_16 : xPhys.all (fun v => popc v == 16) && zPhys.all (fun v => popc v == 16) := by
  native_decide
theorem pools_logical : xPhys.all (fun v => hz.all fun z => !par v z) &&
    zPhys.all (fun v => hx.all fun x => !par x v) := by native_decide
theorem pools_distinct : xPhys.Nodup ∧ zPhys.Nodup := by native_decide
theorem coords_match : xPhys.map coordX = xArr.toList ∧ zPhys.map coordZ = zArr.toList := by
  native_decide
/-- Nontrivial: no pool operator has zero logical coordinates (so none is a stabilizer). -/
set_option maxRecDepth 10000 in
theorem coords_nonzero : xArr.all (· != 0) && zArr.all (· != 0) := by
  rw [← Array.all_toList, ← Array.all_toList]
  decide +kernel

/-- Physical anticommutation of the pool operators is exactly the pairing matrix `G` of
`Pools.lean`. -/
theorem physical_pairing_eq_G : ∀ i j : Fin 720,
    (if par (xPhys.getD i 0) (zPhys.getD j 0) then (1 : ZMod 2) else 0) = PoolBridge.G i j := by
  native_decide

end C16Frames.Code
