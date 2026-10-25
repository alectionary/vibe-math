import BicycleCoverEnergy
import BicycleSpectralBase
namespace Bicycle.SpectralFamily
open StoppingSpectral StoppingPlane CoverEnergy SpectralBase
variable {n : ℕ} [NeZero n]
lemma check_count (h : 39 ∣ n) : 2 ≤ Fintype.card (ZMod n) := by
  have hn : 0 < n := NeZero.pos n
  have hb := Nat.le_of_dvd hn h
  simpa using (show 2 ≤ n by omega)

theorem second_lower (h : 39 ∣ n) :
    (290:ℝ)/13 ≤ eigs (Family.HX (n := n) ℝ) ⟨1,by exact check_count h⟩ := by
  have hnU : normSq uR = 13 := by
    change normSq (fun c => (uZ c : ℝ)) = 13
    rw [norm_cast,norm_u]; norm_num
  have hnV : normSq vR = 13 := by
    change normSq (fun c => (vZ c : ℝ)) = 13
    rw [norm_cast,norm_v]; norm_num
  have hd : innerForm uR vR = 0 := by
    change innerForm (fun c => (uZ c : ℝ)) (fun c => (vZ c : ℝ)) = 0
    rw [dot_cast,dot_uv]; norm_num
  have heU : energy HR uR = 332 := by
    change energy HR (fun c => (uZ c : ℝ)) = 332
    rw [energy_cast,energy_u]; norm_num
  have heV : energy HR vR = 332 := by
    change energy HR (fun c => (vZ c : ℝ)) = 332
    rw [energy_cast,energy_v]; norm_num
  have heC : gramForm HR uR vR = 42 := by
    change gramForm HR (fun c => (uZ c : ℝ)) (fun c => (vZ c : ℝ)) = 42
    rw [cross_cast,cross_uv]; norm_num
  have hc := copies_pos h
  apply StoppingPlane.second_lower (Family.HX ℝ) (check_count h)
    (fun c => uR (Family.projC h c)) (fun c => vR (Family.projC h c))
    (copies h*13) (copies h*332) (copies h*42)
  · positivity
  · positivity
  · rw [norm_pull,hnU]
  · rw [norm_pull,hnV]
  · rw [dot_pull,hd,mul_zero]
  · rw [energy_pull]; exact congrArg (copies h * ·) heU
  · rw [energy_pull]; exact congrArg (copies h * ·) heV
  · rw [cross_pull]; exact congrArg (copies h * ·) heC
  · nlinarith

/-- The original strict gap is impossible on every positive 39-cover. -/
theorem source_gap_impossible (h : 39 ∣ n) :
    ¬ eigs (Family.HX (n := n) ℝ) ⟨1,by exact check_count h⟩ < 2 := by
  have hs := second_lower h
  linarith

/-- The numerical values of both Zhu-Chugg Corollary 6 formulas are strictly
negative whenever their strict Perron-gap condition holds. Other applicability
hypotheses are not assumed or suppressed by this algebraic comparison. -/
theorem zhu_chugg_negative (h : 39 ∣ n)
    (hgap : eigs (Family.HX (n := n) ℝ) ⟨1,by exact check_count h⟩ < 32) :
    let s := eigs (Family.HX (n := n) ℝ) ⟨1,by exact check_count h⟩
    (2*(n:ℝ))*(8-s)/(32-s) < 0 ∧
    (4*(n:ℝ))*(14-s)/(8*(32-s)) < 0 := by
  dsimp
  have hs := second_lower h
  have hn : (0:ℝ) < n := by exact_mod_cast NeZero.pos n
  constructor
  · apply div_neg_of_neg_of_pos
    · exact mul_neg_of_pos_of_neg (by positivity) (by linarith)
    · linarith
  · apply div_neg_of_neg_of_pos
    · exact mul_neg_of_pos_of_neg (by positivity) (by linarith)
    · positivity
end Bicycle.SpectralFamily
