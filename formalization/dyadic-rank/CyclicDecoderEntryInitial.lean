import CyclicDecoderEntryChannel
import CyclicDecoderEntry
import CyclicMergedWitnesses
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderEntryInitial
open CyclicDecoderEntryChannel
open scoped BigOperators

def rowMask (data : List (List Nat)) (i : Nat) : List Bool :=
  List.ofFn (fun v : Fin 252 => decide (v.val ∈ data.getD i []))

theorem rowMask_length (data : List (List Nat)) (i : Nat) :
    (rowMask data i).length = 252 := by simp only [rowMask, List.length_ofFn]
namespace Previous
def vertices : List Nat := [0, 42, 84, 126, 140, 154, 33, 74, 115, 173, 189, 209]
def triples : List (Nat × Nat × Nat) := [(75, 42, 84), (75, 43, 87), (75, 44, 92), (75, 14, 28), (75, 27, 40), (75, 25, 34), (0, 33, 117), (0, 32, 119), (0, 31, 123), (0, 47, 61), (0, 49, 62), (0, 55, 66)]
def input (i : Fin 12) : Nat × Nat × Nat := triples.getD i.val (0,0,0)
def mask (i : Nat) : List Bool := rowMask CyclicMergedWitnesses.Previous.originalData i

theorem actual_incidence : ∀ (i : Fin 12) (c : Fin 126),
    (vertices.getD i.val 0 ∈ CyclicMergedWitnesses.Previous.originalData.getD c.val []) ↔
      c.val = (if i.val < 6 then 0 else 75) ∨
      c.val = (input i).2.1 ∨ c.val = (input i).2.2 := by
  decide +kernel

theorem geometry : ∀ i : Fin 12,
    (mask (input i).1).count true = 6 ∧
    (mask (input i).2.1).count true = 6 ∧
    (mask (input i).2.2).count true = 6 ∧
    (xorMask (mask (input i).1) (mask (input i).2.1)).count true = 12 ∧
    (xorMask (mask (input i).1) (mask (input i).2.2)).count true = 12 ∧
    (xorMask (mask (input i).2.1) (mask (input i).2.2)).count true = 10 ∧
    (xorMask (xorMask (mask (input i).1) (mask (input i).2.1))
      (mask (input i).2.2)).count true = 16 := by
  apply CyclicDecoderPersistence.checked_all
  decide +kernel

/-- Exact probability of the opposite-source/common-common odd-syndrome
condition from the first-round decision-difference theorem. -/
theorem gate_probability (i : Fin 12) :
    average (1/25) 252 (tripleOdd (mask (input i).1)
      (mask (input i).2.1) (mask (input i).2.2)) =
      (253967631598958030208 / 23283064365386962890625 : ℚ) := by
  have h := triple_odd_probability (1/25) (mask (input i).1)
    (mask (input i).2.1) (mask (input i).2.2)
    (by simp [mask, rowMask_length]) (by simp [mask, rowMask_length])
  rcases geometry i with ⟨h1,h2,h3,h4,h5,h6,h7⟩
  rw [show (mask (input i).1).length = 252 by simp [mask, rowMask_length],
    h1,h2,h3,h4,h5,h6,h7] at h
  norm_num at h
  exact h

/-- The sum of the twelve gate probabilities; correlation between gates
is retained and no independence of the twelve events is assumed. -/
theorem expected_changed_gates :
    (∑ i : Fin 12, average (1/25) 252 (tripleOdd (mask (input i).1)
      (mask (input i).2.1) (mask (input i).2.2))) =
      (3047611579187496362496 / 23283064365386962890625 : ℚ) := by
  simp only [gate_probability]
  norm_num
end Previous
namespace Minimum
def vertices : List Nat := [0, 55, 94, 168, 182, 196, 35, 71, 117, 217, 235, 247]
def triples : List (Nat × Nat × Nat) := [(119, 0, 84), (119, 13, 89), (119, 10, 96), (119, 56, 70), (119, 69, 80), (119, 64, 82), (42, 35, 77), (42, 29, 72), (42, 33, 79), (42, 91, 105), (42, 95, 108), (42, 93, 101)]
def input (i : Fin 12) : Nat × Nat × Nat := triples.getD i.val (0,0,0)
def mask (i : Nat) : List Bool := rowMask CyclicMergedWitnesses.Minimum.originalData i

theorem actual_incidence : ∀ (i : Fin 12) (c : Fin 126),
    (vertices.getD i.val 0 ∈ CyclicMergedWitnesses.Minimum.originalData.getD c.val []) ↔
      c.val = (if i.val < 6 then 42 else 119) ∨
      c.val = (input i).2.1 ∨ c.val = (input i).2.2 := by
  decide +kernel

theorem geometry : ∀ i : Fin 12,
    (mask (input i).1).count true = 6 ∧
    (mask (input i).2.1).count true = 6 ∧
    (mask (input i).2.2).count true = 6 ∧
    (xorMask (mask (input i).1) (mask (input i).2.1)).count true = 12 ∧
    (xorMask (mask (input i).1) (mask (input i).2.2)).count true = 12 ∧
    (xorMask (mask (input i).2.1) (mask (input i).2.2)).count true = 10 ∧
    (xorMask (xorMask (mask (input i).1) (mask (input i).2.1))
      (mask (input i).2.2)).count true = 16 := by
  apply CyclicDecoderPersistence.checked_all
  decide +kernel

/-- Exact probability of the opposite-source/common-common odd-syndrome
condition from the first-round decision-difference theorem. -/
theorem gate_probability (i : Fin 12) :
    average (1/25) 252 (tripleOdd (mask (input i).1)
      (mask (input i).2.1) (mask (input i).2.2)) =
      (253967631598958030208 / 23283064365386962890625 : ℚ) := by
  have h := triple_odd_probability (1/25) (mask (input i).1)
    (mask (input i).2.1) (mask (input i).2.2)
    (by simp [mask, rowMask_length]) (by simp [mask, rowMask_length])
  rcases geometry i with ⟨h1,h2,h3,h4,h5,h6,h7⟩
  rw [show (mask (input i).1).length = 252 by simp [mask, rowMask_length],
    h1,h2,h3,h4,h5,h6,h7] at h
  norm_num at h
  exact h

/-- The sum of the twelve gate probabilities; correlation between gates
is retained and no independence of the twelve events is assumed. -/
theorem expected_changed_gates :
    (∑ i : Fin 12, average (1/25) 252 (tripleOdd (mask (input i).1)
      (mask (input i).2.1) (mask (input i).2.2))) =
      (3047611579187496362496 / 23283064365386962890625 : ℚ) := by
  simp only [gate_probability]
  norm_num
end Minimum
end CyclicDecoderEntryInitial
#print axioms CyclicDecoderEntryInitial.Previous.actual_incidence
#print axioms CyclicDecoderEntryInitial.Previous.geometry
#print axioms CyclicDecoderEntryInitial.Previous.gate_probability
#print axioms CyclicDecoderEntryInitial.Previous.expected_changed_gates
#print axioms CyclicDecoderEntryInitial.Minimum.actual_incidence
#print axioms CyclicDecoderEntryInitial.Minimum.geometry
#print axioms CyclicDecoderEntryInitial.Minimum.gate_probability
#print axioms CyclicDecoderEntryInitial.Minimum.expected_changed_gates
