module

public import Spectral
public import IncidenceFamilySource

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
open scoped BigOperators
open Matrix WithLp
namespace Incidence.Family
open StoppingSpectral
variable {n : ℕ} [NeZero n]

def HR : Matrix (Check n) (Var n) ℝ := fun c v => (HX c v : ℝ)

lemma action_false (u : ZMod 7 → ℝ) (j : ZMod 7) (f : ZMod n) :
    (∑ c : Check n, HR c (false,j,f) * u c.1) = u j + u (j+1) + u (j+2) := by
  simp [HR,HX,A,P,Fintype.sum_prod_type,add_mul,Finset.sum_add_distrib]

lemma action_true (u : ZMod 7 → ℝ) (j : ZMod 7) (f : ZMod n) :
    (∑ c : Check n, HR c (true,j,f) * u c.1) = 3*u j := by
  simp [HR,HX,B,P_transpose,Fintype.sum_prod_type,add_mul,Finset.sum_add_distrib]
  ring

def coef (u : Fin 2 → ℝ) (r : ZMod 7) : ℝ :=
  if r = 0 then u 0 else if r = 3 then u 1 else 0

noncomputable def plane : (Fin 2 → ℝ) →ₗ[ℝ] EuclideanSpace ℝ (Check n) where
  toFun u := toLp 2 (fun c => coef u c.1)
  map_add' u v := by ext c; dsimp [coef]; split_ifs <;> simp
  map_smul' a u := by ext c; dsimp [coef]; split_ifs <;> simp

lemma coef_norm (u : Fin 2 → ℝ) : ∑ r : ZMod 7, (coef u r)^2 = (u 0)^2 + (u 1)^2 := by
  rw [← (ZMod.finEquiv 7).toEquiv.sum_comp (fun r => (coef u r)^2)]
  simp +decide [coef,ZMod.finEquiv,Fin.sum_univ_succ]

lemma coef_action (u : Fin 2 → ℝ) :
    (∑ r : ZMod 7, (coef u r + coef u (r+1) + coef u (r+2))^2) =
      3*((u 0)^2+(u 1)^2) := by
  rw [← (ZMod.finEquiv 7).toEquiv.sum_comp
    (fun r => (coef u r + coef u (r+1) + coef u (r+2))^2)]
  simp +decide [coef,ZMod.finEquiv,Fin.sum_univ_succ]
  ring

lemma plane_norm (u : Fin 2 → ℝ) :
    normSq (plane u : Check n → ℝ) = (n:ℝ)*((u 0)^2+(u 1)^2) := by
  calc
    _ = (n:ℝ)*(∑ r : ZMod 7, (coef u r)^2) := by
      simp [normSq,plane,Fintype.sum_prod_type,Finset.mul_sum]
    _ = _ := by rw [coef_norm]

lemma plane_energy (u : Fin 2 → ℝ) :
    energy (HR (n := n)) (plane (n := n) u) =
      12*normSq (plane u : Check n → ℝ) := by
  calc
    _ = (n:ℝ)*((∑ r : ZMod 7, (coef u r + coef u (r+1) + coef u (r+2))^2) +
        9*(∑ r : ZMod 7, (coef u r)^2)) := by
      change (∑ v : Var n, (∑ c : Check n, HR c v * coef u c.1)^2) = _
      rw [Fintype.sum_prod_type]
      simp only [Fintype.sum_bool]
      simp_rw [action_false,action_true,mul_pow]
      simp only [Fintype.sum_prod_type,Finset.sum_const,Finset.card_univ,
        ZMod.card,nsmul_eq_mul]
      norm_num only [pow_succ, pow_zero, mul_one]
      simp_rw [← Finset.mul_sum]
      ring
    _ = 12*normSq (plane u : Check n → ℝ) := by
      rw [coef_norm,coef_action,plane_norm]
      ring


lemma row_count_ge_two : 2 ≤ Fintype.card (Check n) := by
  have hn := NeZero.pos n
  simp only [Check,Fintype.card_prod,ZMod.card]
  omega

/-- Actual expanded real-matrix bound, with multiplicities retained in the ordered spectrum. -/
theorem second_lower_twelve :
    12 ≤ eigs (HR (n := n)) ⟨1,lt_of_lt_of_le (by decide : 1 < 2) row_count_ge_two⟩ := by
  let H := HR (n := n)
  have hm := row_count_ge_two (n := n)
  let f : (Fin 2 → ℝ) →ₗ[ℝ] ℝ :=
    { toFun := fun u => (eBasis H).repr (plane u) ⟨0,by omega⟩
      map_add' := by intros; simp
      map_smul' := by intros; simp }
  have hk : LinearMap.ker f ≠ ⊥ := LinearMap.ker_ne_bot_of_finrank_lt (by norm_num)
  obtain ⟨u,hu,hune⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hk
  have hu0 : (eBasis H).repr (plane u) ⟨0,by omega⟩ = 0 := hu
  have hx : plane u ≠ (0 : EuclideanSpace ℝ (Check n)) := by
    intro h
    apply hune
    ext j
    fin_cases j
    · have hh := congrArg (fun x : EuclideanSpace ℝ (Check n) => x (0,0)) h
      simpa +decide [plane,coef] using hh
    · have hh := congrArg (fun x : EuclideanSpace ℝ (Check n) => x (3,0)) h
      simpa +decide [plane,coef] using hh
  have hp : 0 < normSq (plane u : Check n → ℝ) := by
    rw [normSq_euclidean]
    exact sq_pos_of_pos (norm_pos_iff.mpr hx)
  have he := plane_energy (n := n) u
  have hh := energy_le_of_coeff_zero H hm (plane u) hu0
  change 12 ≤ eigs H _
  nlinarith

theorem source_gap_impossible :
    ¬ eigs (HR (n := n)) ⟨1,lt_of_lt_of_le (by decide : 1 < 2) row_count_ge_two⟩ < (3:ℝ)/2 := by
  have hl := second_lower_twelve (n := n)
  linarith

/-- Neither classical two-eigenvalue stopping bound is positive on this family.
If the classical strict gap s<18 fails, its displayed denominators are outside the regime. -/
theorem zhu_chugg_bounds_negative
    (hgap : eigs (HR (n := n)) ⟨1,lt_of_lt_of_le (by decide : 1 < 2) row_count_ge_two⟩ < 18) :
    let s := eigs (HR (n := n)) ⟨1,lt_of_lt_of_le (by decide : 1 < 2) row_count_ge_two⟩
    (14*(n:ℝ))*(6-s)/(18-s) < 0 ∧
      2*(14*(n:ℝ))*(10-s)/(6*(18-s)) < 0 := by
  dsimp
  have hl := second_lower_twelve (n := n)
  have hn : (0:ℝ) < n := by exact_mod_cast NeZero.pos n
  constructor
  · apply div_neg_of_neg_of_pos
    · exact mul_neg_of_pos_of_neg (by positivity) (by linarith)
    · linarith
  · apply div_neg_of_neg_of_pos
    · exact mul_neg_of_pos_of_neg (by positivity) (by linarith)
    · positivity

end Incidence.Family
