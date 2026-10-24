import CSSStopping
import SidonBad
import PowersFamily
import KernelStopping
import BicycleOverlap
import BadStopping

namespace StrongerAnswer
/-- The concrete family is universal in the positive cover multiplier. -/
theorem exact_stopping_six (t : ℕ) [NeZero t] :
    let n := 39*t
    letI : NeZero n := inferInstance
    (∀ T : Finset (Bicycle.Family.Var n),
      Incidence.Stopping Bicycle.Family.E T → 6 ≤ T.card) ∧
    Incidence.Stopping Bicycle.Family.E (@Bicycle.Family.six n) ∧
    (@Bicycle.Family.six n).card = 6 := by
  dsimp only
  exact Bicycle.Family.exact_six (dvd_mul_right 39 t)

/-- The reusable incidence criterion improves on the elementary guarantee two
on every member of a sparse family, independently of the exact-six search. -/
theorem reusable_four (t : ℕ) [NeZero t]
    (T : Finset (Bicycle.Family.Var (39*t)))
    (hT : Incidence.Stopping Bicycle.Family.E T) : 4 ≤ T.card :=
  Bicycle.Family.incidence_bound_four (dvd_mul_right 39 t) T hT
end StrongerAnswer
