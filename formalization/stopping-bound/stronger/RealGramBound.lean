import BadStopping
import SidonBad
namespace Bicycle.Family
open Matrix
/-- Real-valued lower bounds cannot distinguish the good/bad Gram twins either.
The validity premise applies to actual real-valued binary incidences. -/
theorem real_gram_only_bound {n : ℕ} [NeZero n]
    (lower : Matrix (Check n) (Check n) ℝ → ℝ)
    (valid_bad : ∀ T : Finset (Var n), Incidence.Stopping
      (fun v c => BadX (n := n) ℝ c v = 1) T →
      lower (BadX (n := n) ℝ * (BadX (n := n) ℝ)ᵀ) ≤ (T.card : ℝ)) :
    lower (HX (n := n) ℝ * (HX (n := n) ℝ)ᵀ) ≤ 2 := by
  rw [real_gram_equal]
  have h := valid_bad two (by
    simpa only [Incidence.Stopping,bad_real_incidence] using (@two_stopping n))
  simpa [two_card] using h
end Bicycle.Family

namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
theorem real_gram_only_bound (S : Finset G)
    (lower : Matrix G G ℝ → ℝ)
    (valid_bad : ∀ T : Finset (Bool × G), Incidence.Stopping (badE S) T →
      lower (BadX ℝ S * (BadX ℝ S)ᵀ) ≤ (T.card : ℝ)) :
    lower (X ℝ S * (X ℝ S)ᵀ) ≤ 2 := by
  rw [gram_equal]
  have h := valid_bad twin (twin_stopping S)
  simpa [twin_card] using h
end SidonStopping
