import EventHistogram
import Mathlib.Algebra.BigOperators.Group.Finset.Powerset
import Mathlib.Tactic.NormNum

set_option maxHeartbeats 0
namespace HistogramPolynomials
open scoped BigOperators
open EventHistogram

def rankOf (k : ℕ) : ℕ := min (3*k) 11

def binTerm (N : ℤ) (j : Fin 6) (k : ℕ) : ℤ :=
  (if j.val≤k then (-1)^(k-j.val)*(k.choose j.val : ℤ) else 0)*N^(11-rankOf k)

def polynomial (N : ℤ) (j : Fin 6) : ℤ := match j.val with
  | 0 => N^11-5*N^8+10*N^5-10*N^2+4
  | 1 => 5*(N^8-4*N^5+6*N^2-3)
  | 2 => 10*(N^5-3*N^2+2)
  | 3 => 10*(N^2-1)
  | 4 => 0
  | _ => 1

theorem group_by_card (N : ℤ) (j : Fin 6) :
    (∑ S : Finset (Fin 5), coefficient j S*N^(11-rankOf S.card))=
      ∑ k ∈ Finset.range 6, (Nat.choose 5 k : ℤ)*binTerm N j k := by
  change (∑ S ∈ (Finset.univ : Finset (Finset (Fin 5))), binTerm N j S.card)=_
  rw [← Finset.powerset_univ,Finset.sum_powerset]
  simp only [Finset.card_univ,Fintype.card_fin]
  apply Finset.sum_congr rfl
  intro k _
  rw [Finset.sum_powersetCard]
  simp only [Finset.card_univ,Fintype.card_fin,nsmul_eq_mul]

theorem evaluate (N : ℤ) (j : Fin 6) :
    (∑ k ∈ Finset.range 6, (Nat.choose 5 k : ℤ)*binTerm N j k)=polynomial N j := by
  fin_cases j <;> norm_num [Finset.sum_range_succ,binTerm,rankOf,polynomial,Nat.choose] <;> ring

theorem histogram_formula {α : Type*} [Fintype α] (E : α → Fin 5 → Bool)
    (N : ℕ) (h : ∀ S, intersectionCount E S=N^(11-rankOf S.card)) (j : Fin 6) :
    (histogram E j : ℤ)=polynomial N j := by
  rw [inversion]
  simp_rw [h,Nat.cast_pow]
  exact (group_by_card N j).trans (evaluate N j)

#print axioms group_by_card
#print axioms evaluate
#print axioms histogram_formula
end HistogramPolynomials
