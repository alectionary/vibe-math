import FourColumnClassification
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.BigOperators.Group.Finset.Sigma

set_option maxHeartbeats 0
set_option maxRecDepth 100000
open scoped BigOperators

namespace PairEnergy

variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def degreeInto (H : V → Finset C) (W : Finset V) (c : C) : ℕ :=
  (W.filter (fun v => c ∈ H v)).card

def energy (H : V → Finset C) (W : Finset V) : ℕ :=
  ∑ c : C, (degreeInto H W c)^2

def adjacentPairs (H : V → Finset C) (W : Finset V) : Finset (V × V) :=
  (W ×ˢ W).filter (fun p => p.1 ≠ p.2 ∧ (H p.1 ∩ H p.2).Nonempty)

def missingPairs (H : V → Finset C) (W : Finset V) : Finset (V × V) :=
  (W ×ˢ W).filter (fun p => p.1 ≠ p.2 ∧ ¬ (H p.1 ∩ H p.2).Nonempty)

def diagonalPairs (W : Finset V) : Finset (V × V) :=
  (W ×ˢ W).filter (fun p => p.1 = p.2)

theorem degree_square (H : V → Finset C) (W : Finset V) (c : C) :
    (degreeInto H W c)^2 =
      ∑ u ∈ W, ∑ v ∈ W, if c ∈ H u ∧ c ∈ H v then 1 else 0 := by
  have hc : degreeInto H W c = ∑ u ∈ W, if c ∈ H u then 1 else 0 := by
    rw [← Finset.sum_filter]
    simp [degreeInto]
  rw [hc,pow_two,Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro u hu
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro v hv
  by_cases hcu : c ∈ H u <;> by_cases hcv : c ∈ H v <;> simp [hcu,hcv]

theorem sum_checks (H : V → Finset C) (u v : V) :
    (∑ c : C, if c ∈ H u ∧ c ∈ H v then 1 else 0) = (H u ∩ H v).card := by
  rw [← Finset.sum_filter]
  have h : Finset.univ.filter (fun c => c ∈ H u ∧ c ∈ H v) = H u ∩ H v := by
    ext c
    simp
  rw [h]
  simp

/-- Integer incidence energy counts ordered variable pairs with their actual
number of shared checks. -/
theorem energy_eq_pair_sum (H : V → Finset C) (W : Finset V) :
    energy H W = ∑ u ∈ W, ∑ v ∈ W, (H u ∩ H v).card := by
  unfold energy
  simp_rw [degree_square]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro u hu
  rw [Finset.sum_comm]
  simp_rw [sum_checks]

theorem common_card (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) (u v : V) :
    (H u ∩ H v).card =
      (if u = v then 3 else 0) +
      (if u ≠ v ∧ (H u ∩ H v).Nonempty then 1 else 0) := by
  by_cases huv : u = v
  · subst v
    simp [hd]
  · have hle := h4 u v huv
    by_cases hn : (H u ∩ H v).Nonempty
    · have hpos := Finset.card_pos.mpr hn
      simp [huv,hn]
      omega
    · have hz := Finset.not_nonempty_iff_eq_empty.mp hn
      simp [huv,hn,hz]

theorem energy_eq_three_card_add_adjacent (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) (W : Finset V) :
    energy H W = 3 * W.card + (adjacentPairs H W).card := by
  rw [energy_eq_pair_sum]
  simp_rw [common_card H hd h4, Finset.sum_add_distrib]
  have diagonal : (∑ u ∈ W, ∑ v ∈ W, if u = v then 3 else 0) = 3 * W.card := by
    have hinner : ∀ u ∈ W, (∑ v ∈ W, if u = v then 3 else 0) = 3 := by
      intro u hu
      simp [hu]
    simp_rw [Finset.sum_congr rfl hinner]
    simp [Nat.mul_comm]
  rw [diagonal]
  congr 1
  unfold adjacentPairs
  rw [Finset.card_eq_sum_ones, Finset.sum_filter, Finset.sum_product]

theorem diagonal_card (W : Finset V) : (diagonalPairs W).card = W.card := by
  unfold diagonalPairs
  rw [Finset.card_eq_sum_ones,Finset.sum_filter,Finset.sum_product]
  have hi : ∀ u ∈ W, (∑ v ∈ W, if u = v then 1 else 0) = 1 := by
    intro u hu
    simp [hu]
  rw [Finset.sum_congr rfl hi]
  simp

theorem pair_partition (H : V → Finset C) (W : Finset V) :
    W.card + (adjacentPairs H W).card + (missingPairs H W).card = W.card^2 := by
  conv_lhs => arg 1; arg 1; rw [← diagonal_card W]
  unfold diagonalPairs adjacentPairs missingPairs
  simp only [Finset.card_eq_sum_ones,Finset.sum_filter]
  rw [← Finset.sum_add_distrib,← Finset.sum_add_distrib]
  have hterm : ∀ p ∈ W ×ˢ W,
      (if p.1 = p.2 then 1 else 0) +
      (if p.1 ≠ p.2 ∧ (H p.1 ∩ H p.2).Nonempty then 1 else 0) +
      (if p.1 ≠ p.2 ∧ ¬ (H p.1 ∩ H p.2).Nonempty then 1 else 0) = 1 := by
    intro p hp
    by_cases he : p.1 = p.2 <;> by_cases hn : (H p.1 ∩ H p.2).Nonempty <;> simp [he,hn]
  rw [Finset.sum_congr rfl hterm]
  simp [pow_two]

/-- The positive form of the inner counting identity used in the corrected
(4,2) formula. This is exact over the natural numbers. -/
theorem missing_pair_energy_identity (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) (W : Finset V) :
    (missingPairs H W).card + energy H W = W.card^2 + 2 * W.card := by
  have he := energy_eq_three_card_add_adjacent H hd h4 W
  have hp := pair_partition H W
  omega

#print axioms energy_eq_pair_sum
#print axioms missing_pair_energy_identity

end PairEnergy
