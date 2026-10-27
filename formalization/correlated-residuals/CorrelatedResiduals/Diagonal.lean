/-
Diagonal-residual identification for the three-trait pattern of Mi et al.,
equation (7), over the full positive-definite domain.

The structural matrix `B` is supported on positions `(0,1)`, `(0,2)`, and
`(1,2)`. Zero values are allowed, so every directed subgraph of this
topological order is included. `Ψ` is diagonal with positive entries and `Φ`
is positive definite. The map `(B, Γ, Ψ, Φ) ↦ Σ` has an explicit left inverse.
-/

import Mathlib.Data.Real.StarOrdered
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

open Matrix

namespace CorrelatedResiduals

abbrev M3 := Matrix (Fin 3) (Fin 3) ℝ

/-- Equation-(7) parameters in the sign convention of the source's equation (3). -/
@[ext]
structure Params where
  b12 : ℝ
  b13 : ℝ
  b23 : ℝ
  v1 : ℝ
  v2 : ℝ
  v3 : ℝ
  gamma : M3
  phi : M3

/-- Positive diagonal residuals and a positive-definite exogenous covariance. -/
def OnDomain (θ : Params) : Prop :=
  0 < θ.v1 ∧ 0 < θ.v2 ∧ 0 < θ.v3 ∧ θ.phi.PosDef

def Bmat (θ : Params) : M3 :=
  !![0, θ.b12, θ.b13;
     0, 0, θ.b23;
     0, 0, 0]

def subB (θ : Params) : M3 :=
  !![1, -θ.b12, -θ.b13;
     0, 1, -θ.b23;
     0, 0, 1]

/-- Closed form of `(I - B)⁻¹` for this zero pattern. -/
def Lmat (θ : Params) : M3 :=
  !![1, θ.b12, θ.b13 + θ.b12 * θ.b23;
     0, 1, θ.b23;
     0, 0, 1]

def psi (θ : Params) : M3 :=
  diagonal ![θ.v1, θ.v2, θ.v3]

def omega (θ : Params) : M3 :=
  Lmat θ * psi θ * (Lmat θ)ᵀ

/-- Observed blocks `Σ_yy`, `Σ_yx`, and `Σ_xx`. -/
structure Cov where
  yy : M3
  yx : M3
  xx : M3

def sigma (θ : Params) : Cov where
  yy := Lmat θ * (θ.gamma * θ.phi * θ.gammaᵀ + psi θ) * (Lmat θ)ᵀ
  yx := Lmat θ * θ.gamma * θ.phi
  xx := θ.phi

lemma subB_eq_one_sub (θ : Params) : subB θ = 1 - Bmat θ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [subB, Bmat, sub_apply]

lemma subB_mul_L (θ : Params) : subB θ * Lmat θ = 1 := by
  rw [subB, Lmat, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma L_mul_subB (θ : Params) : Lmat θ * subB θ = 1 := by
  rw [Lmat, subB, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp
  all_goals ring

lemma psi_explicit (θ : Params) :
    psi θ = !![θ.v1, 0, 0; 0, θ.v2, 0; 0, 0, θ.v3] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [psi]

lemma L_transpose (θ : Params) :
    (Lmat θ)ᵀ =
      !![1, 0, 0;
         θ.b12, 1, 0;
         θ.b13 + θ.b12 * θ.b23, θ.b23, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

lemma omega_explicit (θ : Params) :
    let c := θ.b13 + θ.b12 * θ.b23
    omega θ =
      !![θ.v1 + θ.b12 ^ 2 * θ.v2 + c ^ 2 * θ.v3,
         θ.b12 * θ.v2 + c * θ.b23 * θ.v3,
         c * θ.v3;
         θ.b12 * θ.v2 + c * θ.b23 * θ.v3,
         θ.v2 + θ.b23 ^ 2 * θ.v3,
         θ.b23 * θ.v3;
         c * θ.v3,
         θ.b23 * θ.v3,
         θ.v3] := by
  intro c
  rw [omega, L_transpose, psi_explicit, Lmat, mul_fin_three, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [c] <;> ring

lemma omega_22 (θ : Params) : omega θ 2 2 = θ.v3 := by
  rw [omega_explicit]; simp

lemma omega_12 (θ : Params) : omega θ 1 2 = θ.b23 * θ.v3 := by
  rw [omega_explicit]; simp

lemma omega_02 (θ : Params) : omega θ 0 2 = (θ.b13 + θ.b12 * θ.b23) * θ.v3 := by
  rw [omega_explicit]; simp

lemma omega_11 (θ : Params) : omega θ 1 1 = θ.v2 + θ.b23 ^ 2 * θ.v3 := by
  rw [omega_explicit]; simp

lemma omega_01 (θ : Params) :
    omega θ 0 1 = θ.b12 * θ.v2 + (θ.b13 + θ.b12 * θ.b23) * θ.b23 * θ.v3 := by
  rw [omega_explicit]; simp

lemma omega_00 (θ : Params) :
    omega θ 0 0 =
      θ.v1 + θ.b12 ^ 2 * θ.v2 + (θ.b13 + θ.b12 * θ.b23) ^ 2 * θ.v3 := by
  rw [omega_explicit]; simp

lemma posDef_apply_diag {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℝ} (hM : M.PosDef) (i : n) : 0 < M i i := by
  have hx : Pi.single i (1 : ℝ) ≠ (0 : n → ℝ) := by
    intro h
    have := congr_fun h i
    simp [Pi.single_eq_same] at this
  have hpos := hM.2 (Pi.single i 1) hx
  simpa [star_trivial, mulVec_single_one, dotProduct_single_one, col_apply] using hpos

/-- Cancelling a positive-definite exogenous block leaves the residual Gram matrix. -/
lemma schur_noise {L G Φ N : M3} (hΦ : Φ.PosDef) :
    L * (G * Φ * Gᵀ + N) * Lᵀ - (L * G * Φ) * Φ⁻¹ * (L * G * Φ)ᵀ = L * N * Lᵀ := by
  have hdet : IsUnit Φ.det := (isUnit_iff_isUnit_det Φ).1 hΦ.isUnit
  have hsym : Φᵀ = Φ := by
    simpa [conjTranspose_eq_transpose_of_trivial] using hΦ.isHermitian.eq
  have hdist :
      L * (G * Φ * Gᵀ + N) * Lᵀ = L * (G * Φ * Gᵀ) * Lᵀ + L * N * Lᵀ := by
    rw [Matrix.mul_add, Matrix.add_mul]
  rw [hdist]
  have hyx : (L * G * Φ)ᵀ = Φ * Gᵀ * Lᵀ := by
    rw [transpose_mul, transpose_mul, hsym]
    simp only [mul_assoc]
  rw [hyx]
  have hcancel :
      (L * G * Φ) * Φ⁻¹ * (Φ * Gᵀ * Lᵀ) = L * (G * Φ * Gᵀ) * Lᵀ := by
    calc
      (L * G * Φ) * Φ⁻¹ * (Φ * Gᵀ * Lᵀ)
          = L * G * (Φ * Φ⁻¹) * (Φ * Gᵀ * Lᵀ) := by simp only [mul_assoc]
      _ = L * G * (1 : M3) * (Φ * Gᵀ * Lᵀ) := by rw [mul_nonsing_inv Φ hdet]
      _ = L * G * Φ * Gᵀ * Lᵀ := by simp only [mul_one, mul_assoc]
      _ = L * (G * Φ * Gᵀ) * Lᵀ := by simp only [mul_assoc]
  rw [hcancel, add_sub_cancel_left]

/-- Subtracting the exogenous signal leaves the residual Gram matrix. -/
lemma schur_omega (θ : Params) (hφ : θ.phi.PosDef) :
    (sigma θ).yy - (sigma θ).yx * (sigma θ).xx⁻¹ * (sigma θ).yxᵀ = omega θ := by
  simpa [sigma, omega] using schur_noise (L := Lmat θ) (G := θ.gamma) (Φ := θ.phi)
    (N := psi θ) hφ

/-- Coefficients and variances read off `Ω = L Ψ Lᵀ`. -/
noncomputable def readDiag (Ω : M3) : ℝ × ℝ × ℝ × ℝ × ℝ × ℝ :=
  let v3 := Ω 2 2
  let b23 := Ω 1 2 / v3
  let c13 := Ω 0 2 / v3
  let v2 := Ω 1 1 - b23 ^ 2 * v3
  let b12 := (Ω 0 1 - b23 * c13 * v3) / v2
  let b13 := c13 - b12 * b23
  let v1 := Ω 0 0 - b12 ^ 2 * v2 - c13 ^ 2 * v3
  (b12, b13, b23, v1, v2, v3)

lemma readDiag_omega (θ : Params) (hv2 : 0 < θ.v2) (hv3 : 0 < θ.v3) :
    readDiag (omega θ) = (θ.b12, θ.b13, θ.b23, θ.v1, θ.v2, θ.v3) := by
  have hv2' : θ.v2 ≠ 0 := ne_of_gt hv2
  have hv3' : θ.v3 ≠ 0 := ne_of_gt hv3
  set c : ℝ := θ.b13 + θ.b12 * θ.b23 with hcdef
  have hb23 : omega θ 1 2 / omega θ 2 2 = θ.b23 := by
    rw [omega_12, omega_22]; field_simp
  have hc : omega θ 0 2 / omega θ 2 2 = c := by
    rw [omega_02, omega_22, hcdef]; field_simp
  have hv2eq : omega θ 1 1 - (omega θ 1 2 / omega θ 2 2) ^ 2 * omega θ 2 2 = θ.v2 := by
    rw [hb23, omega_11, omega_22]; ring
  have hb12 :
      (omega θ 0 1 - (omega θ 1 2 / omega θ 2 2) * (omega θ 0 2 / omega θ 2 2) * omega θ 2 2) /
          (omega θ 1 1 - (omega θ 1 2 / omega θ 2 2) ^ 2 * omega θ 2 2) =
        θ.b12 := by
    rw [hv2eq, hb23, hc, omega_01, omega_22]
    field_simp [hv2']
    ring
  have hb13 :
      omega θ 0 2 / omega θ 2 2 -
          ((omega θ 0 1 -
                (omega θ 1 2 / omega θ 2 2) * (omega θ 0 2 / omega θ 2 2) * omega θ 2 2) /
              (omega θ 1 1 - (omega θ 1 2 / omega θ 2 2) ^ 2 * omega θ 2 2)) *
            (omega θ 1 2 / omega θ 2 2) =
        θ.b13 := by
    rw [hb12, hb23, hc, hcdef]; ring
  have hv1eq :
      omega θ 0 0 -
          ((omega θ 0 1 -
                (omega θ 1 2 / omega θ 2 2) * (omega θ 0 2 / omega θ 2 2) * omega θ 2 2) /
              (omega θ 1 1 - (omega θ 1 2 / omega θ 2 2) ^ 2 * omega θ 2 2)) ^ 2 *
            (omega θ 1 1 - (omega θ 1 2 / omega θ 2 2) ^ 2 * omega θ 2 2) -
          (omega θ 0 2 / omega θ 2 2) ^ 2 * omega θ 2 2 =
        θ.v1 := by
    rw [hb12, hv2eq, hc, omega_00, omega_22, hcdef]; ring
  unfold readDiag
  dsimp only
  rw [hv1eq, hb13, hb12, hv2eq, hb23, omega_22]

/-- Plug-in recovery of `(B, Γ, Ψ, Φ)` from the three observed blocks. -/
noncomputable def recover (cov : Cov) : Params :=
  let Ω := cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ
  let r := readDiag Ω
  let b12 := r.1
  let b13 := r.2.1
  let b23 := r.2.2.1
  let v1 := r.2.2.2.1
  let v2 := r.2.2.2.2.1
  let v3 := r.2.2.2.2.2
  let B : M3 :=
    !![0, b12, b13;
       0, 0, b23;
       0, 0, 0]
  { b12, b13, b23, v1, v2, v3,
    gamma := (1 - B) * cov.yx * cov.xx⁻¹,
    phi := cov.xx }

theorem recover_sigma (θ : Params) (h : OnDomain θ) : recover (sigma θ) = θ := by
  obtain ⟨hv1, hv2, hv3, hφ⟩ := h
  have _hpsi : (psi θ).PosDef := by
    rw [psi, posDef_diagonal_iff]
    intro i
    fin_cases i
    · simpa using hv1
    · simpa using hv2
    · simpa using hv3
  have hread : readDiag (omega θ) = (θ.b12, θ.b13, θ.b23, θ.v1, θ.v2, θ.v3) :=
    readDiag_omega θ hv2 hv3
  have hschur := schur_omega θ hφ
  simp only [recover, hschur, hread]
  have hB : (1 -
      !![0, θ.b12, θ.b13;
         0, 0, θ.b23;
         0, 0, 0]) = subB θ := by
    simpa [Bmat] using (subB_eq_one_sub θ).symm
  have hdet : IsUnit θ.phi.det := (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  apply Params.ext
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · simp only [sigma]
    rw [hB]
    calc
      subB θ * (Lmat θ * θ.gamma * θ.phi) * θ.phi⁻¹
          = (subB θ * Lmat θ) * θ.gamma * (θ.phi * θ.phi⁻¹) := by simp only [mul_assoc]
      _ = (1 : M3) * θ.gamma * (1 : M3) := by rw [subB_mul_L, mul_nonsing_inv _ hdet]
      _ = θ.gamma := by simp
  · rfl

theorem sigma_injective {θ θ' : Params} (hθ : OnDomain θ) (hθ' : OnDomain θ')
    (h : sigma θ = sigma θ') : θ = θ' := by
  rw [← recover_sigma θ hθ, ← recover_sigma θ' hθ', h]

end CorrelatedResiduals
