import PaschClassification
import Mathlib.Data.Matrix.Mul

set_option maxHeartbeats 0
open scoped BigOperators Matrix
namespace PaschKernelCount
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

/-- The actual binary parity-check matrix associated to check neighborhoods. -/
def checkMatrix (H : V → Finset C) : Matrix C V (ZMod 2) :=
  fun c v => if c ∈ H v then 1 else 0

def supportIndicator (S : Finset V) : V → ZMod 2 :=
  fun v => if v ∈ S then 1 else 0

def elementary40Check (H : V → Finset C) (S : Finset V) : Prop :=
  (∀ c, (GlobalCounting.selected H S c).card ≤ 2) ∧
  ∀ c, (GlobalCounting.selected H S c).card % 2 = 0

instance (H : V → Finset C) (S : Finset V) : Decidable (elementary40Check H S) :=
  inferInstanceAs (Decidable ((∀ c, (GlobalCounting.selected H S c).card ≤ 2) ∧
    ∀ c, (GlobalCounting.selected H S c).card % 2 = 0))

def count40 (H : V → Finset C) : ℕ :=
  ((GlobalCounting.fourSupports : Finset (Finset V)).filter (elementary40Check H)).card

def weightFourKernelCount (H : V → Finset C) : ℕ :=
  ((GlobalCounting.fourSupports : Finset (Finset V)).filter
    (fun S => ∀ c, ((checkMatrix H) *ᵥ supportIndicator S) c = 0)).card

theorem matrix_indicator_eq_selected (H : V → Finset C) (S : Finset V) (c : C) :
    ((checkMatrix H) *ᵥ supportIndicator S) c =
      ((GlobalCounting.selected H S c).card : ZMod 2) := by
  rw [Finset.card_eq_sum_ones, Nat.cast_sum]
  simp only [Nat.cast_one, GlobalCounting.selected, Finset.sum_filter]
  unfold Matrix.mulVec dotProduct checkMatrix supportIndicator
  have hsub : S ⊆ Finset.univ := Finset.subset_univ _
  have hsum := Finset.sum_subset (f := fun v : V =>
    (if c ∈ H v then (1 : ZMod 2) else 0) * (if v ∈ S then 1 else 0)) hsub
    (by intro v hv hnot; simp [hnot])
  rw [← hsum]
  apply Finset.sum_congr rfl
  intro v hv
  simp [hv]

theorem local_elementary40_iff (H : V → Finset C) (S : GlobalCounting.FourSupport V) :
    elementary40Check H S.val ↔
      PaschClassification.Elementary40 (GlobalCounting.localCols H S) := by
  simp only [elementary40Check, PaschClassification.Elementary40,
    PaschClassification.EvenChecks, GlobalCounting.support_selected_card]

theorem four_support_zero_iff (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1)
    (S : GlobalCounting.FourSupport V) :
    (∀ c, ((checkMatrix H) *ᵥ supportIndicator S.val) c = 0) ↔
      elementary40Check H S.val := by
  rw [local_elementary40_iff]
  rw [PaschClassification.elementary40_iff_even _
    (GlobalCounting.local_degree H hd S) (GlobalCounting.local_linear H h4 S)]
  simp only [matrix_indicator_eq_selected, ZMod.natCast_eq_zero_iff,
    Nat.dvd_iff_mod_eq_zero, PaschClassification.EvenChecks,
    GlobalCounting.support_selected_card]

/-- The (4,0) support count is exactly the weight-four coefficient of the
classical binary kernel. This is a support count, not a quantum distance claim. -/
theorem count40_eq_weightFourKernelCount (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) :
    count40 H = weightFourKernelCount H := by
  unfold count40 weightFourKernelCount
  congr 1
  apply Finset.filter_congr
  intro S hS
  exact (four_support_zero_iff H hd h4 ⟨S,hS⟩).symm

#print axioms matrix_indicator_eq_selected
#print axioms four_support_zero_iff
#print axioms count40_eq_weightFourKernelCount
end PaschKernelCount
