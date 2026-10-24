module

public import IncidenceFamilySource
public import Incidence

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace Incidence.Family
/-- Every cyclic lift with length a positive multiple of 63 inherits the base bound. -/
theorem lower_six {n : ℕ} (h : 63 ∣ n) (T : Finset (Var n)) (hT : Stopping E T) :
    6 ≤ T.card := by
  have hs := stopping_cover_image E Incidence.E (projV h) (projC h)
    (maps h) (lifts h) (local_inj h) T hT
  have hl := running_lower_six _ hs
  exact hl.trans (Finset.card_image_le)

theorem matrix_stopping_iff {n : ℕ} (h : 63 ∣ n) (T : Finset (Var n)) :
    Stopping (fun v c => HX c v = 1) T ↔ Stopping E T := by
  simp only [Stopping,HX_incidence h]

/-- Exact stopping distance for the expanded QC-GHP matrices at all lift lengths divisible by 63.
For finite quantum codes take n>0; the proof also covers the infinite integer cover n=0. -/
theorem source_matrix_exact_six {n : ℕ} (h : 63 ∣ n) :
    (∀ T : Finset (Var n), Stopping (fun v c => HX c v = 1) T → 6 ≤ T.card) ∧
    ∃ T : Finset (Var n), Stopping (fun v c => HX c v = 1) T ∧ T.card = 6 := by
  refine ⟨?_,six,(matrix_stopping_iff h six).mpr six_stopping,six_card h⟩
  intro T hT
  exact lower_six h T ((matrix_stopping_iff h T).mp hT)

end Incidence.Family
