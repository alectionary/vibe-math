import BicycleFamilyCore
import BicycleBase
namespace Bicycle.Family
theorem stopping_ge_six {n : ℕ} (h : 39 ∣ n) (T : Finset (Var n))
    (hT : Incidence.Stopping E T) : 6 ≤ T.card := by
  have hs := Incidence.stopping_cover_image E Bicycle.E (projV h) (projC h)
    (maps h) (lifts h) (local_inj h) T hT
  exact (Bicycle.stopping_ge_six _ hs).trans Finset.card_image_le

theorem exact_six {n : ℕ} (h : 39 ∣ n) :
    (∀ T : Finset (Var n), Incidence.Stopping E T → 6 ≤ T.card) ∧
    Incidence.Stopping E (@six n) ∧ (@six n).card = 6 :=
  ⟨stopping_ge_six h,six_stopping h,six_card h⟩
end Bicycle.Family
