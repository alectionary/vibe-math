import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Algebra.BigOperators.Ring.Finset

set_option maxHeartbeats 0
namespace FiniteEventArithmetic
open scoped BigOperators
variable {α : Type*} [Fintype α]

theorem count_sum (P : α → Prop) [DecidablePred P] :
    (Nat.card {a : α // P a} : ℤ)=∑ a : α, if P a then 1 else 0 := by
  rw [Nat.card_eq_fintype_card,Fintype.card_subtype]
  simp only [Finset.card_eq_sum_ones,Nat.cast_sum,Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro a _
  by_cases h : P a <;> simp [h]

theorem avoid_one (P : α → Prop) [DecidablePred P] :
    (Nat.card {a : α // ¬P a} : ℤ)=(Nat.card α : ℤ)-(Nat.card {a : α // P a} : ℤ) := by
  rw [count_sum,count_sum]
  have hc : (Nat.card α : ℤ)=∑ _a : α, (1 : ℤ) := by simp [Nat.card_eq_fintype_card]
  rw [hc,← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro a _
  by_cases h : P a <;> simp [h]

theorem avoid_two (P Q : α → Prop) [DecidablePred P] [DecidablePred Q] :
    (Nat.card {a : α // ¬P a ∧ ¬Q a} : ℤ)=
      (Nat.card α : ℤ)-(Nat.card {a : α // P a} : ℤ)-
      (Nat.card {a : α // Q a} : ℤ)+(Nat.card {a : α // P a ∧ Q a} : ℤ) := by
  rw [count_sum,count_sum,count_sum,count_sum]
  have hc : (Nat.card α : ℤ)=∑ _a : α, (1 : ℤ) := by simp [Nat.card_eq_fintype_card]
  rw [hc,← Finset.sum_sub_distrib,← Finset.sum_sub_distrib,← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro a _
  by_cases hp : P a <;> by_cases hq : Q a <;> simp [hp,hq]

#print axioms avoid_one
#print axioms avoid_two
end FiniteEventArithmetic
