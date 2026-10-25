import BicycleDegrees
import FiberSums
namespace Bicycle.CoverEnergy
open Finset StoppingSpectral StoppingPlane StoppingFiber
variable {n : ℕ} [NeZero n]
def q (h : 39 ∣ n) : ZMod n →+ ZMod 39 := (ZMod.castHom h (ZMod 39)).toAddMonoidHom
lemma q_surj (h : 39 ∣ n) : Function.Surjective (q h) := ZMod.castHom_surjective h
noncomputable def copies (h : 39 ∣ n) : ℝ := Fintype.card {x : ZMod n // q h x = 0}
lemma copies_pos (h : 39 ∣ n) : 0 < copies h := by
  unfold copies
  exact_mod_cast kernel_card_pos (q h)
lemma sum_pull (h : 39 ∣ n) (f : ZMod 39 → ℝ) :
    ∑ c : ZMod n, f (Family.projC h c) = copies h * ∑ d, f d :=
  pullback_sum (q h) (q_surj h) f
lemma var_sum_pull (h : 39 ∣ n) (f : Bool × ZMod 39 → ℝ) :
    ∑ v : Family.Var n, f (Family.projV h v) = copies h * ∑ w, f w := by
  rw [Fintype.sum_prod_type,Fintype.sum_prod_type,Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro b _
  exact sum_pull h (fun d => f (b,d))
lemma action_list (h : 39 ∣ n) (x : ZMod n → ℝ) (v : Family.Var n) :
    ∑ c, Family.HX ℝ c v*x c = ((Family.col v).map x).sum := by
  have hs : ∑ c, Family.HX ℝ c v*x c = ∑ c ∈ (Family.col v).toFinset, x c := by
    have he (c : ZMod n) : Family.HX ℝ c v*x c =
        if c ∈ (Family.col v).toFinset then x c else 0 := by
      by_cases hc : Family.E v c
      · have hm : c ∈ (Family.col v).toFinset := List.mem_toFinset.mpr hc
        rw [Family.HX_entry,if_pos hc,one_mul,if_pos hm]
      · have hm : c ∉ (Family.col v).toFinset := fun hmem => hc (List.mem_toFinset.mp hmem)
        rw [Family.HX_entry,if_neg hc,zero_mul,if_neg hm]
    simp_rw [he]
    exact Finset.sum_ite_mem_eq _ _
  rw [hs,List.sum_toFinset x (Family.col_nodup h v)]
lemma action_pull (h : 39 ∣ n) (x : ZMod 39 → ℝ) (v : Family.Var n) :
    ∑ c, Family.HX ℝ c v*x (Family.projC h c) =
      ∑ d, Family.HX ℝ d (Family.projV h v)*x d := by
  rw [action_list h,action_list (dvd_refl 39)]
  change (List.map (x ∘ Family.projC h) (Family.col v)).sum = _
  rw [← List.map_map,Family.project_col]
  rfl
lemma norm_pull (h : 39 ∣ n) (x : ZMod 39 → ℝ) :
    normSq (fun c => x (Family.projC h c)) = copies h * normSq x :=
  sum_pull h (fun c => x c ^ 2)
lemma dot_pull (h : 39 ∣ n) (x y : ZMod 39 → ℝ) :
    innerForm (fun c => x (Family.projC h c)) (fun c => y (Family.projC h c)) =
      copies h * innerForm x y := sum_pull h (fun c => x c*y c)
lemma energy_pull (h : 39 ∣ n) (x : ZMod 39 → ℝ) :
    energy (Family.HX ℝ) (fun c => x (Family.projC h c)) =
      copies h * energy (Family.HX ℝ) x := by
  unfold energy
  simp_rw [action_pull h]
  exact var_sum_pull h (fun v => (∑ c,Family.HX ℝ c v*x c)^2)
lemma cross_pull (h : 39 ∣ n) (x y : ZMod 39 → ℝ) :
    gramForm (Family.HX ℝ) (fun c => x (Family.projC h c)) (fun c => y (Family.projC h c)) =
      copies h * gramForm (Family.HX ℝ) x y := by
  unfold gramForm
  simp_rw [action_pull h]
  exact var_sum_pull h (fun v => (∑ c,Family.HX ℝ c v*x c)*(∑ c,Family.HX ℝ c v*y c))
end Bicycle.CoverEnergy
