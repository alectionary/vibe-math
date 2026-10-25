import MomentReplacement
import JointMomentFamily
namespace JointPowers
open Matrix Finset StoppingSpectral StoppingMoment
variable {γ n : ℕ} [NeZero n]
/-- The global spectral-only function is useful on every constructed member. -/
theorem replacement_value (hn : 3^(2*γ) ≤ n) :
    regularReplacement n (2*n) γ (2*γ)
      (∑ i,(eigs (JointSidon.X ℝ (leftMarks γ n) (rightMarks γ n)) i)^2) = γ+1 := by
  classical
  have hh : (∑ i,(eigs (JointSidon.X ℝ (leftMarks γ n) (rightMarks γ n)) i)^2) +
      ((2*n:ℕ):ℝ)*γ = ((2*n:ℕ):ℝ)*(γ:ℝ)^2+(n:ℝ)*((2*γ:ℕ):ℝ)^2 := by
    rw [fourth_moment hn]
    simp only [Nat.cast_mul,Nat.cast_ofNat]
    ring
  unfold regularReplacement
  rw [if_pos hh]

theorem replacement_informative (hn : 3^(2*γ) ≤ n) (hγ : 2≤γ) :
    2 < regularReplacement n (2*n) γ (2*γ)
      (∑ i,(eigs (JointSidon.X ℝ (leftMarks γ n) (rightMarks γ n)) i)^2) := by
  rw [replacement_value hn]
  omega

theorem base_fourth_moment :
    (∑ i,(eigs (JointSidon.X ℝ (leftMarks 2 81) (rightMarks 2 81)) i)^2) = 1620 := by
  rw [fourth_moment (γ := 2) (n := 81) (by decide)]
  norm_num
end JointPowers
