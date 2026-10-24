import GlobalCounting
import PairEnergy
import Mathlib.Data.ZMod.Basic

set_option maxHeartbeats 0
open scoped BigOperators
open FourColumnClassification
namespace PaschClassification
variable {C : Type*} [Fintype C] [DecidableEq C]

def EvenChecks (N : I → Finset C) : Prop :=
  ∀ c, (support N c).card % 2 = 0

def Elementary40 (N : I → Finset C) : Prop :=
  (∀ c, (support N c).card ≤ 2) ∧ EvenChecks N

theorem finite_even_large : ∀ T : Finset I,
    T.card % 2 = 0 → 2 < T.card → T = Finset.univ := by decide

theorem finite_even_partner : ∀ T : Finset I,
    0 ∈ T → T.card % 2 = 0 → ∃ j ∈ T, j ≠ 0 := by decide

/-- In a cubic linear four-column incidence, a zero syndrome cannot hide a
degree-four check. Thus every weight-four binary codeword is elementary. -/
theorem even_checks_elementary (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1)
    (heven : EvenChecks N) : ∀ c, (support N c).card ≤ 2 := by
  intro c
  by_contra hlarge
  have hfull := finite_even_large (support N c) (heven c) (by omega)
  have hc : ∀ i, c ∈ N i := by
    intro i
    apply (mem_support N c i).mp
    rw [hfull]
    simp
  have hsub : N 0 ⊆ {c} := by
    intro d hd0
    by_cases hdc : d = c
    · simp [hdc]
    · have hmem : (0 : I) ∈ support N d := (mem_support N d 0).mpr hd0
      obtain ⟨j,hj,hj0⟩ := finite_even_partner (support N d) hmem (heven d)
      have hdj := (mem_support N d j).mp hj
      have hcd : ({c,d} : Finset C) ⊆ N 0 ∩ N j := by
        intro x hx
        simp only [Finset.mem_insert, Finset.mem_singleton] at hx
        rcases hx with rfl | rfl
        · exact Finset.mem_inter.mpr ⟨hc 0,hc j⟩
        · exact Finset.mem_inter.mpr ⟨hd0,hdj⟩
      have hle := (Finset.card_le_card hcd).trans (h4 0 j hj0.symm)
      have hcard : ({c,d} : Finset C).card = 2 := by simp [Ne.symm hdc]
      rw [hcard] at hle
      omega
  have hle := Finset.card_le_card hsub
  rw [hd 0, Finset.card_singleton] at hle
  omega

theorem elementary40_iff_even (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1) :
    Elementary40 N ↔ EvenChecks N :=
  ⟨And.right,fun h => ⟨even_checks_elementary N hd h4 h,h⟩⟩

theorem even_checks_absorbing (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3) (heven : EvenChecks N) : Absorbing N := by
  intro i
  have hz : oddAt N i = ∅ := by
    unfold oddAt
    apply Finset.filter_eq_empty_iff.mpr
    intro c hc
    have := heven c
    omega
  have hp := odd_even_partition N i
  rw [hz, Finset.card_empty, hd i] at hp
  rw [hz, Finset.card_empty]
  omega

theorem pasch_pair_cells (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1)
    (heven : EvenChecks N) :
    count N {0,1} = 1 ∧ count N {0,2} = 1 ∧ count N {0,3} = 1 ∧
    count N {1,2} = 1 ∧ count N {1,3} = 1 ∧ count N {2,3} = 1 := by
  have he := even_checks_elementary N hd h4 heven
  obtain ⟨h0,h1,h2,h3⟩ := degree_equations N he hd
  have ho := odd_partition N he
  have hz : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)) = ∅ := by
    apply Finset.filter_eq_empty_iff.mpr
    intro c hc
    have := heven c
    omega
  rw [hz,Finset.card_empty] at ho
  have hs : count N {0}+count N {1}+count N {2}+count N {3}=0 := by
    simpa [singletons, and_assoc] using ho.symm
  have h01 := pair_count_le_one N h4 (i:=0) (j:=1) (by decide)
  have h02 := pair_count_le_one N h4 (i:=0) (j:=2) (by decide)
  have h03 := pair_count_le_one N h4 (i:=0) (j:=3) (by decide)
  have h12 := pair_count_le_one N h4 (i:=1) (j:=2) (by decide)
  have h13 := pair_count_le_one N h4 (i:=1) (j:=3) (by decide)
  have h23 := pair_count_le_one N h4 (i:=2) (j:=3) (by decide)
  omega

def binarySyndrome (N : I → Finset C) (c : C) : ZMod 2 :=
  ∑ i : I, if c ∈ N i then 1 else 0

theorem binarySyndrome_eq_card (N : I → Finset C) (c : C) :
    binarySyndrome N c = ((support N c).card : ZMod 2) := by
  rw [Finset.card_eq_sum_ones, Nat.cast_sum]
  simp only [Nat.cast_one]
  simp only [support, Finset.sum_filter, binarySyndrome]

theorem binarySyndrome_zero_iff (N : I → Finset C) :
    (∀ c, binarySyndrome N c = 0) ↔ EvenChecks N := by
  simp only [binarySyndrome_eq_card, ZMod.natCast_eq_zero_iff,
    Nat.dvd_iff_mod_eq_zero, EvenChecks]

theorem weight_four_kernel_iff_elementary40 (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1) :
    (∀ c, binarySyndrome N c = 0) ↔ Elementary40 N := by
  rw [binarySyndrome_zero_iff, elementary40_iff_even N hd h4]

#print axioms even_checks_elementary
#print axioms elementary40_iff_even
#print axioms even_checks_absorbing
#print axioms pasch_pair_cells
#print axioms weight_four_kernel_iff_elementary40
end PaschClassification
