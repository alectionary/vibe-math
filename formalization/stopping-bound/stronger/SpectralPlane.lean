import Spectral
import Mathlib.LinearAlgebra.Matrix.Reindex
namespace StoppingPlane
open StoppingSpectral Matrix Finset WithLp
variable {C V : Type*} [Fintype C] [Fintype V] [DecidableEq C] [DecidableEq V]

def innerForm (x y : C → ℝ) : ℝ := ∑ c, x c*y c
def gramForm (H : Matrix C V ℝ) (x y : C → ℝ) : ℝ :=
  ∑ v, (∑ c, H c v*x c)*(∑ c, H c v*y c)
lemma norm_expand (x y : C → ℝ) (a b : ℝ) :
    normSq (fun c => a*x c+b*y c) =
      a^2*normSq x+2*a*b*innerForm x y+b^2*normSq y := by
  unfold normSq innerForm
  simp only [mul_sum,← sum_add_distrib]
  apply sum_congr rfl
  intro c _
  ring
lemma energy_expand (H : Matrix C V ℝ) (x y : C → ℝ) (a b : ℝ) :
    energy H (fun c => a*x c+b*y c) =
      a^2*energy H x+2*a*b*gramForm H x y+b^2*energy H y := by
  unfold energy gramForm
  have h (v : V) : (∑ c, H c v*(a*x c+b*y c)) =
      a*(∑ c,H c v*x c)+b*(∑ c,H c v*y c) := by
    simp only [mul_add,sum_add_distrib]
    simp_rw [mul_left_comm _ a,mul_left_comm _ b,← mul_sum]
  simp_rw [h]
  simpa only [normSq,innerForm] using
    norm_expand (fun v => ∑ c, H c v*x c) (fun v => ∑ c, H c v*y c) a b

/-- A rational two-vector certificate gives a bound for the actual second
Gram eigenvalue, counting multiplicity; no spectral envelope is assumed. -/
theorem second_lower (H : Matrix C V ℝ) (hm : 2 ≤ Fintype.card C)
    (x y : C → ℝ) (q D K L : ℝ) (hq : 0 < q) (hK : 0 ≤ K)
    (hxx : normSq x = q) (hyy : normSq y = q) (hxy : innerForm x y = 0)
    (hEx : energy H x = D) (hEy : energy H y = D) (hE : gramForm H x y = K)
    (hL : L*q ≤ D-K) : L ≤ eigs H ⟨1,by omega⟩ := by
  let plane : (Fin 2 → ℝ) →ₗ[ℝ] EuclideanSpace ℝ C :=
    { toFun := fun u => toLp 2 (fun c => u 0*x c+u 1*y c)
      map_add' := by intros; ext c; simp; ring
      map_smul' := by intros; ext c; simp; ring }
  let f : (Fin 2 → ℝ) →ₗ[ℝ] ℝ :=
    { toFun := fun u => (eBasis H).repr (plane u) ⟨0,by omega⟩
      map_add' := by intros; simp
      map_smul' := by intros; simp }
  have hk : LinearMap.ker f ≠ ⊥ := LinearMap.ker_ne_bot_of_finrank_lt (by norm_num)
  obtain ⟨u,hu,hune⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hk
  have hc0 : (eBasis H).repr (plane u) ⟨0,by omega⟩ = 0 := hu
  have hpos : 0 < (u 0)^2+(u 1)^2 := by
    by_contra h
    have h0 : u 0=0 := by nlinarith [sq_nonneg (u 0),sq_nonneg (u 1)]
    have h1 : u 1=0 := by nlinarith [sq_nonneg (u 0),sq_nonneg (u 1)]
    apply hune
    ext i
    fin_cases i <;> assumption
  have hn : normSq (plane u : C → ℝ) = q*((u 0)^2+(u 1)^2) := by
    change normSq (fun c => u 0*x c+u 1*y c) = _
    rw [norm_expand,hxx,hyy,hxy]
    ring
  have he : energy H (plane u : C → ℝ) = D*((u 0)^2+(u 1)^2)+2*K*u 0*u 1 := by
    change energy H (fun c => u 0*x c+u 1*y c) = _
    rw [energy_expand,hEx,hEy,hE]
    ring
  have hupp := energy_le_of_coeff_zero H hm (plane u) hc0
  rw [hn,he] at hupp
  have hlow : L*q*((u 0)^2+(u 1)^2) ≤
      D*((u 0)^2+(u 1)^2)+2*K*u 0*u 1 := by
    nlinarith [mul_nonneg hK (sq_nonneg (u 0+u 1)),
      mul_le_mul_of_nonneg_right hL (le_of_lt hpos)]
  have : 0 < q*((u 0)^2+(u 1)^2) := mul_pos hq hpos
  nlinarith
end StoppingPlane
