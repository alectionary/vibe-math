import Mathlib.Combinatorics.Enumerative.InclusionExclusion
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace EventHistogram
open scoped BigOperators

def trueSet (p : Fin 5 → Bool) : Finset (Fin 5) := Finset.univ.filter (fun i => p i)

def coefficient (j : Fin 6) (S : Finset (Fin 5)) : ℤ :=
  if j.val≤S.card then (-1)^(S.card-j.val)*(S.card.choose j.val : ℤ) else 0

/-- Pointwise binomial inversion, checked on all 32 truth patterns and six bins. -/
theorem pointwise : ∀ (p : Fin 5 → Bool) (j : Fin 6),
    (∑ S : Finset (Fin 5), coefficient j S *
      (if ∀ i∈S, p i=true then 1 else 0)) =
      if (trueSet p).card=j.val then 1 else 0 := by decide

variable {α : Type*} [Fintype α]

def histogram (E : α → Fin 5 → Bool) (j : Fin 6) : ℕ :=
  (Finset.univ.filter (fun a => (trueSet (E a)).card=j.val)).card

def intersectionCount (E : α → Fin 5 → Bool) (S : Finset (Fin 5)) : ℕ :=
  (Finset.univ.filter (fun a => ∀ i∈S, E a i=true)).card

/-- Finite event counts follow from the pointwise identity by summation. -/
theorem inversion (E : α → Fin 5 → Bool) (j : Fin 6) :
    (histogram E j : ℤ)=
      ∑ S : Finset (Fin 5), coefficient j S*(intersectionCount E S : ℤ) := by
  classical
  have hc (p : α → Prop) [DecidablePred p] :
      ((Finset.univ.filter p).card : ℤ)=∑ a : α, if p a then 1 else 0 := by
    simp only [Finset.card_eq_sum_ones, Nat.cast_sum, Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro a _
    by_cases h : p a <;> simp [h]
  rw [histogram, hc]
  simp_rw [← pointwise]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro S _
  rw [← Finset.mul_sum]
  congr 1
  exact (hc (fun a => ∀ i∈S, E a i=true)).symm

#print axioms pointwise
#print axioms inversion
end EventHistogram
