import CyclicDecoderEntryInitial
import Mathlib.Tactic.Ring

/-! Signed gate moments: first-step bit-error bias, not eventual failure. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderEntryBias
open CyclicDecoderEntryChannel

/-- At the fixed first-update magnitude, the change in raw bit error is a
signed gate: own-parity agreement decides whether the flip harms or helps. -/
theorem first_bit_error_gap (actual own opposite a b : Bool) :
    (if (CyclicMergedMessages.decision (CyclicMergedMessages.prior +
       CyclicMergedMessages.signed (own ^^ opposite) 2665945 +
       CyclicMergedMessages.signed a 2665945 +
       CyclicMergedMessages.signed b 2665945) ^^ actual) then (1 : ℚ) else 0) -
    (if (CyclicMergedMessages.decision (CyclicMergedMessages.prior +
       CyclicMergedMessages.signed own 2665945 +
       CyclicMergedMessages.signed a 2665945 +
       CyclicMergedMessages.signed b 2665945) ^^ actual) then (1 : ℚ) else 0) =
    (if own ^^ actual then (-1 : ℚ) else 1) *
      (if opposite && a && b then (1 : ℚ) else 0) := by
  cases actual <;> cases own <;> cases opposite <;> cases a <;> cases b <;> decide +kernel

theorem moment_at (p : ℚ) (n : Nat) (a : List Bool) (h : a.length = n) :
    average p n (character a) = (1-2*p)^(a.count true) := by
  rw [← h]; exact parity_moment p a

theorem gated_character (p : ℚ) (d a b c : List Bool)
    (ha : a.length = d.length) (hb : b.length = d.length)
    (hc : c.length = d.length) :
    average p d.length (fun bits => character d bits * tripleOdd a b c bits) =
      ((1-2*p)^(d.count true)
       -(1-2*p)^((xorMask d a).count true)
       -(1-2*p)^((xorMask d b).count true)
       -(1-2*p)^((xorMask d c).count true)
       +(1-2*p)^((xorMask d (xorMask a b)).count true)
       +(1-2*p)^((xorMask d (xorMask a c)).count true)
       +(1-2*p)^((xorMask d (xorMask b c)).count true)
       -(1-2*p)^((xorMask d (xorMask (xorMask a b) c)).count true))/8 := by
  have hab := ha.trans hb.symm
  have hac := ha.trans hc.symm
  have hbc := hb.trans hc.symm
  have point : (fun bits => character d bits * tripleOdd a b c bits) = fun bits =>
      (1/8 : ℚ)*character d bits + (-1/8 : ℚ)*character (xorMask d a) bits +
      (-1/8 : ℚ)*character (xorMask d b) bits + (-1/8 : ℚ)*character (xorMask d c) bits +
      (1/8 : ℚ)*character (xorMask d (xorMask a b)) bits +
      (1/8 : ℚ)*character (xorMask d (xorMask a c)) bits +
      (1/8 : ℚ)*character (xorMask d (xorMask b c)) bits +
      (-1/8 : ℚ)*character (xorMask d (xorMask (xorMask a b) c)) bits := by
    funext bits
    rw [character_xor d a bits ha.symm, character_xor d b bits hb.symm,
      character_xor d c bits hc.symm,
      character_xor d (xorMask a b) bits ((xorMask_length a b hab).trans ha).symm,
      character_xor d (xorMask a c) bits ((xorMask_length a c hac).trans ha).symm,
      character_xor d (xorMask b c) bits ((xorMask_length b c hbc).trans hb).symm,
      character_xor d (xorMask (xorMask a b) c) bits
        ((xorMask_length (xorMask a b) c ((xorMask_length a b hab).trans hac)).trans
          ((xorMask_length a b hab).trans ha)).symm,
      character_xor a b bits hab, character_xor a c bits hac,
      character_xor b c bits hbc,
      character_xor (xorMask a b) c bits ((xorMask_length a b hab).trans hac),
      character_xor a b bits hab]
    unfold tripleOdd oddIndicator
    ring
  rw [point]
  simp only [average_add, average_smul]
  simp only [moment_at p d.length _ rfl,
    moment_at p d.length _ (xorMask_length d a ha.symm),
    moment_at p d.length _ (xorMask_length d b hb.symm),
    moment_at p d.length _ (xorMask_length d c hc.symm),
    moment_at p d.length _ (xorMask_length d (xorMask a b) ((xorMask_length a b hab).trans ha).symm),
    moment_at p d.length _ (xorMask_length d (xorMask a c) ((xorMask_length a c hac).trans ha).symm),
    moment_at p d.length _ (xorMask_length d (xorMask b c) ((xorMask_length b c hbc).trans hb).symm),
    moment_at p d.length _ (xorMask_length d (xorMask (xorMask a b) c)
      ((xorMask_length (xorMask a b) c ((xorMask_length a b hab).trans hac)).trans
        ((xorMask_length a b hab).trans ha)).symm)]
  ring

namespace Previous
open CyclicDecoderEntryInitial.Previous
def ownCheck (i : Fin 12) : Nat := if i.val < 6 then 0 else 75
def remainder (i : Fin 12) : List Bool :=
  xorMask (mask (ownCheck i)) (List.ofFn (fun v : Fin 252 => decide (v.val = vertices.getD i.val 0)))

theorem remainder_geometry : ∀ i : Fin 12,
    let (a,b,c) := input i
    (remainder i).count true = 5 ∧
    (xorMask (remainder i) (mask a)).count true = 11 ∧
    (xorMask (remainder i) (mask b)).count true = 11 ∧
    (xorMask (remainder i) (mask c)).count true = 11 ∧
    (xorMask (remainder i) (xorMask (mask a) (mask b))).count true = 17 ∧
    (xorMask (remainder i) (xorMask (mask a) (mask c))).count true = 17 ∧
    (xorMask (remainder i) (xorMask (mask b) (mask c))).count true = 15 ∧
    (xorMask (remainder i) (xorMask (xorMask (mask a) (mask b)) (mask c))).count true = 21 := by
  decide +kernel

theorem signed_gate_moment (i : Fin 12) :
    let (a,b,c) := input i
    average (1/25) 252 (fun bits =>
      character (remainder i) bits * tripleOdd (mask a) (mask b) (mask c) bits) =
      1634622787868532325023049344 / 227373675443232059478759765625 := by
  have len (j : Nat) : (mask j).length = 252 := CyclicDecoderEntryInitial.rowMask_length _ j
  have rem_len : (remainder i).length = 252 := by
    simp only [remainder, xorMask, List.length_zipWith, len, List.length_ofFn, min_self]
  have h := gated_character (1/25) (remainder i) (mask (input i).1)
    (mask (input i).2.1) (mask (input i).2.2)
    ((len _).trans rem_len.symm) ((len _).trans rem_len.symm) ((len _).trans rem_len.symm)
  rw [rem_len] at h
  have g := remainder_geometry i
  dsimp only at g ⊢
  rw [g.1, g.2.1, g.2.2.1, g.2.2.2.1, g.2.2.2.2.1,
    g.2.2.2.2.2.1, g.2.2.2.2.2.2.1, g.2.2.2.2.2.2.2] at h
  norm_num at h ⊢
  exact h
end Previous

namespace Minimum
open CyclicDecoderEntryInitial.Minimum
def ownCheck (i : Fin 12) : Nat := if i.val < 6 then 42 else 119
def remainder (i : Fin 12) : List Bool :=
  xorMask (mask (ownCheck i)) (List.ofFn (fun v : Fin 252 => decide (v.val = vertices.getD i.val 0)))

theorem remainder_geometry : ∀ i : Fin 12,
    let (a,b,c) := input i
    (remainder i).count true = 5 ∧
    (xorMask (remainder i) (mask a)).count true = 11 ∧
    (xorMask (remainder i) (mask b)).count true = 11 ∧
    (xorMask (remainder i) (mask c)).count true = 11 ∧
    (xorMask (remainder i) (xorMask (mask a) (mask b))).count true = 17 ∧
    (xorMask (remainder i) (xorMask (mask a) (mask c))).count true = 17 ∧
    (xorMask (remainder i) (xorMask (mask b) (mask c))).count true = 15 ∧
    (xorMask (remainder i) (xorMask (xorMask (mask a) (mask b)) (mask c))).count true = 21 := by
  decide +kernel

theorem signed_gate_moment (i : Fin 12) :
    let (a,b,c) := input i
    average (1/25) 252 (fun bits =>
      character (remainder i) bits * tripleOdd (mask a) (mask b) (mask c) bits) =
      1634622787868532325023049344 / 227373675443232059478759765625 := by
  have len (j : Nat) : (mask j).length = 252 := CyclicDecoderEntryInitial.rowMask_length _ j
  have rem_len : (remainder i).length = 252 := by
    simp only [remainder, xorMask, List.length_zipWith, len, List.length_ofFn, min_self]
  have h := gated_character (1/25) (remainder i) (mask (input i).1)
    (mask (input i).2.1) (mask (input i).2.2)
    ((len _).trans rem_len.symm) ((len _).trans rem_len.symm) ((len _).trans rem_len.symm)
  rw [rem_len] at h
  have g := remainder_geometry i
  dsimp only at g ⊢
  rw [g.1, g.2.1, g.2.2.1, g.2.2.2.1, g.2.2.2.2.1,
    g.2.2.2.2.2.1, g.2.2.2.2.2.2.1, g.2.2.2.2.2.2.2] at h
  norm_num at h ⊢
  exact h
end Minimum
end CyclicDecoderEntryBias
#print axioms CyclicDecoderEntryBias.gated_character
#print axioms CyclicDecoderEntryBias.Previous.signed_gate_moment
#print axioms CyclicDecoderEntryBias.Minimum.signed_gate_moment
