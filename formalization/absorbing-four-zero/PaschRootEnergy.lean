import PaschKernelCount
import PairFormulaCore

set_option maxHeartbeats 0
open scoped BigOperators
namespace PaschRootEnergy
open PairEnergy PairFormula
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def outsideCols (H : V → Finset C) (B : Finset C) (v : V) : Finset C := H v \ B

def rootCheckEnergy (H : V → Finset C) (W : Finset V) (B : Finset C) : ℕ :=
  ∑ c ∈ B, (degreeInto H W c)^2

theorem outside_degreeInto (H : V → Finset C) (W : Finset V) (B : Finset C) (c : C) :
    degreeInto (outsideCols H B) W c = if c ∈ B then 0 else degreeInto H W c := by
  by_cases hc : c ∈ B <;> simp [degreeInto,outsideCols,hc]

theorem energy_partition (H : V → Finset C) (W : Finset V) (B : Finset C) :
    energy H W = rootCheckEnergy H W B + energy (outsideCols H B) W := by
  unfold energy rootCheckEnergy
  simp_rw [outside_degreeInto]
  have hB : (∑ c ∈ B, (degreeInto H W c)^2) =
      ∑ c : C, if c ∈ B then (degreeInto H W c)^2 else 0 := by
    rw [← Finset.sum_filter]
    simp
  rw [hB,← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro c hc
  by_cases hb : c ∈ B <;> simp [hb]

/-- Each proper six-cycle third variable has exactly one check outside the
five checks of an adjacent cubic root pair. -/
theorem proper_common_outside_one (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1)
    (u v w : V) (hw : w ∈ properCommon H u v) :
    (outsideCols H (H u ∪ H v) w).card = 1 := by
  obtain ⟨hwu,hwv,huw,hvw,ht⟩ := (Finset.mem_filter.mp hw).2
  have hwu' : (H w ∩ H u).Nonempty := by simpa [Finset.inter_comm] using huw
  have hwv' : (H w ∩ H v).Nonempty := by simpa [Finset.inter_comm] using hvw
  have ha : (H w ∩ H u).card = 1 := by
    have hp := Finset.card_pos.mpr hwu'
    have hl := h4 w u hwu
    omega
  have hb : (H w ∩ H v).card = 1 := by
    have hp := Finset.card_pos.mpr hwv'
    have hl := h4 w v hwv
    omega
  have hdis : Disjoint (H w ∩ H u) (H w ∩ H v) := by
    apply Finset.disjoint_left.mpr
    intro c hca hcb
    apply ht
    exact ⟨c,Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr
      ⟨(Finset.mem_inter.mp hca).2,(Finset.mem_inter.mp hcb).2⟩,
      (Finset.mem_inter.mp hca).1⟩⟩
  have hab : (H w ∩ (H u ∪ H v)).card = 2 := by
    rw [Finset.inter_union_distrib_left,Finset.card_union_of_disjoint hdis,ha,hb]
  have he := Finset.card_sdiff_add_card_inter (H w) (H u ∪ H v)
  rw [hd w,hab] at he
  unfold outsideCols
  omega

/-- General incidence energy for a set of columns of degree one. -/
theorem one_degree_energy (K : V → Finset C) (W : Finset V)
    (hdeg : ∀ w ∈ W, (K w).card = 1) :
    energy K W = W.card + (adjacentPairs K W).card := by
  rw [energy_eq_pair_sum]
  have hterm : ∀ u ∈ W, ∀ v ∈ W,
      (K u ∩ K v).card = (if u = v then 1 else 0) +
      (if u ≠ v ∧ (K u ∩ K v).Nonempty then 1 else 0) := by
    intro u hu v hv
    by_cases he : u = v
    · subst v; simp [hdeg u hu]
    · have hl : (K u ∩ K v).card ≤ 1 := by
        calc
          _ ≤ (K u).card := Finset.card_le_card Finset.inter_subset_left
          _ = 1 := hdeg u hu
      by_cases hn : (K u ∩ K v).Nonempty
      · have hp := Finset.card_pos.mpr hn
        simp [he,hn]
        omega
      · have hz := Finset.not_nonempty_iff_eq_empty.mp hn
        simp [he,hn,hz]
  simp_rw [Finset.sum_congr rfl (fun u hu => Finset.sum_congr rfl (hterm u hu)),
    Finset.sum_add_distrib]
  have hdiag : (∑ u ∈ W, ∑ v ∈ W, if u = v then 1 else 0) = W.card := by
    have hi : ∀ u ∈ W, (∑ v ∈ W, if u = v then 1 else 0) = 1 := by
      intro u hu; simp [hu]
    rw [Finset.sum_congr rfl hi]
    simp
  rw [hdiag]
  congr 1
  unfold adjacentPairs
  rw [Finset.card_eq_sum_ones,Finset.sum_filter,Finset.sum_product]

def localPaschPairs (H : V → Finset C) (u v : V) : Finset (V × V) :=
  adjacentPairs (outsideCols H (H u ∪ H v)) (properCommon H u v)

/-- Positive form, avoiding truncated subtraction. The ordered outer pairs
share a check outside the root checks. Under the hypotheses they form Pasches. -/
theorem local_energy_identity (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) (u v : V) :
    energy H (properCommon H u v) =
      rootCheckEnergy H (properCommon H u v) (H u ∪ H v) +
      (properCommon H u v).card + (localPaschPairs H u v).card := by
  rw [energy_partition H _ (H u ∪ H v),one_degree_energy]
  · simp only [localPaschPairs,Nat.add_assoc]
  · intro w hw
    exact proper_common_outside_one H hd h4 u v w hw

#print axioms proper_common_outside_one
#print axioms energy_partition
#print axioms local_energy_identity
end PaschRootEnergy
