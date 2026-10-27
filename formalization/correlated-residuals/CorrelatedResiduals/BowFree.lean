/-
Global identification for one bow-free correlated-residual extension of the
equation-(7) pattern: the direct edge into trait 0 from trait 2 is removed,
and the residual covariance of that pair is freed. Sympy's algebraic solver
returns a single rational inverse on this six-parameter model; the proof below
is the direct expansion, not a call to that solver.
-/

import CorrelatedResiduals.Diagonal

open Matrix

namespace CorrelatedResiduals

@[ext]
structure Bow where
  b12 : ℝ
  b23 : ℝ
  v1 : ℝ
  v2 : ℝ
  v3 : ℝ
  c : ℝ
  gamma : M3
  phi : M3

/-- Residual covariance with the single free entry on the missing edge. -/
def Bow.noise (θ : Bow) : M3 :=
  !![θ.v1, 0, θ.c;
     0, θ.v2, 0;
     θ.c, 0, θ.v3]

def Bow.subB (θ : Bow) : M3 :=
  !![1, -θ.b12, 0;
     0, 1, -θ.b23;
     0, 0, 1]

def Bow.L (θ : Bow) : M3 :=
  !![1, θ.b12, θ.b12 * θ.b23;
     0, 1, θ.b23;
     0, 0, 1]

def Bow.B (θ : Bow) : M3 :=
  !![0, θ.b12, 0;
     0, 0, θ.b23;
     0, 0, 0]

def Bow.omega (θ : Bow) : M3 :=
  θ.L * θ.noise * θ.Lᵀ

def Bow.sigma (θ : Bow) : Cov where
  yy := θ.L * (θ.gamma * θ.phi * θ.gammaᵀ + θ.noise) * θ.Lᵀ
  yx := θ.L * θ.gamma * θ.phi
  xx := θ.phi

def OnBow (θ : Bow) : Prop :=
  θ.noise.PosDef ∧ θ.phi.PosDef

lemma Bow.subB_eq (θ : Bow) : θ.subB = 1 - θ.B := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Bow.subB, Bow.B, sub_apply]

lemma Bow.subB_mul_L (θ : Bow) : θ.subB * θ.L = 1 := by
  rw [Bow.subB, Bow.L, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma Bow.L_transpose (θ : Bow) :
    θ.Lᵀ = !![1, 0, 0; θ.b12, 1, 0; θ.b12 * θ.b23, θ.b23, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

lemma Bow.omega_explicit (θ : Bow) :
    θ.omega =
      !![θ.v1 + θ.b12 ^ 2 * θ.v2 + 2 * θ.b12 * θ.b23 * θ.c + θ.b12 ^ 2 * θ.b23 ^ 2 * θ.v3,
         θ.b12 * θ.v2 + θ.b12 * θ.b23 ^ 2 * θ.v3 + θ.b23 * θ.c,
         θ.b12 * θ.b23 * θ.v3 + θ.c;
         θ.b12 * θ.v2 + θ.b12 * θ.b23 ^ 2 * θ.v3 + θ.b23 * θ.c,
         θ.v2 + θ.b23 ^ 2 * θ.v3,
         θ.b23 * θ.v3;
         θ.b12 * θ.b23 * θ.v3 + θ.c,
         θ.b23 * θ.v3,
         θ.v3] := by
  rw [Bow.omega, Bow.L_transpose, Bow.noise, Bow.L, mul_fin_three, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp <;> ring

lemma Bow.omega_22 (θ : Bow) : θ.omega 2 2 = θ.v3 := by
  rw [Bow.omega_explicit]; simp

lemma Bow.omega_12 (θ : Bow) : θ.omega 1 2 = θ.b23 * θ.v3 := by
  rw [Bow.omega_explicit]; simp

lemma Bow.omega_11 (θ : Bow) : θ.omega 1 1 = θ.v2 + θ.b23 ^ 2 * θ.v3 := by
  rw [Bow.omega_explicit]; simp

lemma Bow.omega_02 (θ : Bow) : θ.omega 0 2 = θ.b12 * θ.b23 * θ.v3 + θ.c := by
  rw [Bow.omega_explicit]; simp

lemma Bow.omega_01 (θ : Bow) :
    θ.omega 0 1 = θ.b12 * θ.v2 + θ.b12 * θ.b23 ^ 2 * θ.v3 + θ.b23 * θ.c := by
  rw [Bow.omega_explicit]; simp

lemma Bow.omega_00 (θ : Bow) :
    θ.omega 0 0 =
      θ.v1 + θ.b12 ^ 2 * θ.v2 + 2 * θ.b12 * θ.b23 * θ.c +
        θ.b12 ^ 2 * θ.b23 ^ 2 * θ.v3 := by
  rw [Bow.omega_explicit]; simp

lemma Bow.v2_pos (θ : Bow) (h : θ.noise.PosDef) : 0 < θ.v2 := by
  have := posDef_apply_diag h (1 : Fin 3)
  simpa [Bow.noise] using this

lemma Bow.v3_pos (θ : Bow) (h : θ.noise.PosDef) : 0 < θ.v3 := by
  have := posDef_apply_diag h (2 : Fin 3)
  simpa [Bow.noise] using this

noncomputable def readBow (Ω : M3) : ℝ × ℝ × ℝ × ℝ × ℝ × ℝ :=
  let v3 := Ω 2 2
  let b23 := Ω 1 2 / v3
  let den := Ω 1 1 * Ω 2 2 - Ω 1 2 ^ 2
  let v2 := den / v3
  let b12 := (Ω 0 1 * Ω 2 2 - Ω 0 2 * Ω 1 2) / den
  let c := (Ω 0 2 * Ω 1 1 - Ω 0 1 * Ω 1 2) * Ω 2 2 / den
  let v1 := Ω 0 0 - b12 ^ 2 * v2 - 2 * b12 * b23 * c - b12 ^ 2 * b23 ^ 2 * v3
  (b12, b23, v1, v2, v3, c)

lemma readBow_omega (θ : Bow) (hv2 : 0 < θ.v2) (hv3 : 0 < θ.v3) :
    readBow θ.omega = (θ.b12, θ.b23, θ.v1, θ.v2, θ.v3, θ.c) := by
  have hv2' : θ.v2 ≠ 0 := ne_of_gt hv2
  have hv3' : θ.v3 ≠ 0 := ne_of_gt hv3
  have hden : θ.v2 * θ.v3 ≠ 0 := mul_ne_zero hv2' hv3'
  have hb23 : θ.omega 1 2 / θ.omega 2 2 = θ.b23 := by
    rw [Bow.omega_12, Bow.omega_22]; field_simp
  have hden_eq : θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2 = θ.v2 * θ.v3 := by
    rw [Bow.omega_11, Bow.omega_22, Bow.omega_12]; ring
  have hv2eq : (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2) / θ.omega 2 2 = θ.v2 := by
    rw [hden_eq, Bow.omega_22]; field_simp
  have hb12 :
      (θ.omega 0 1 * θ.omega 2 2 - θ.omega 0 2 * θ.omega 1 2) /
          (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2) =
        θ.b12 := by
    rw [hden_eq, Bow.omega_01, Bow.omega_22, Bow.omega_02, Bow.omega_12]
    field_simp
    ring
  have hc :
      (θ.omega 0 2 * θ.omega 1 1 - θ.omega 0 1 * θ.omega 1 2) * θ.omega 2 2 /
          (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2) =
        θ.c := by
    rw [hden_eq, Bow.omega_02, Bow.omega_11, Bow.omega_01, Bow.omega_12, Bow.omega_22]
    field_simp
    ring
  have hv1eq :
      θ.omega 0 0 -
          ((θ.omega 0 1 * θ.omega 2 2 - θ.omega 0 2 * θ.omega 1 2) /
              (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2)) ^ 2 *
            ((θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2) / θ.omega 2 2) -
          2 *
            ((θ.omega 0 1 * θ.omega 2 2 - θ.omega 0 2 * θ.omega 1 2) /
              (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2)) *
            (θ.omega 1 2 / θ.omega 2 2) *
            ((θ.omega 0 2 * θ.omega 1 1 - θ.omega 0 1 * θ.omega 1 2) * θ.omega 2 2 /
              (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2)) -
          ((θ.omega 0 1 * θ.omega 2 2 - θ.omega 0 2 * θ.omega 1 2) /
              (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2)) ^ 2 *
            (θ.omega 1 2 / θ.omega 2 2) ^ 2 * θ.omega 2 2 =
        θ.v1 := by
    rw [hb12, hv2eq, hb23, hc, Bow.omega_00, Bow.omega_22]
    ring
  unfold readBow
  dsimp only
  rw [hv1eq, hc, hb12, hv2eq, hb23, Bow.omega_22]

noncomputable def recoverBow (cov : Cov) : Bow :=
  let Ω := cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ
  let r := readBow Ω
  let b12 := r.1
  let b23 := r.2.1
  let v1 := r.2.2.1
  let v2 := r.2.2.2.1
  let v3 := r.2.2.2.2.1
  let c := r.2.2.2.2.2
  let B : M3 := !![0, b12, 0; 0, 0, b23; 0, 0, 0]
  { b12, b23, v1, v2, v3, c,
    gamma := (1 - B) * cov.yx * cov.xx⁻¹,
    phi := cov.xx }

theorem recover_bow (θ : Bow) (h : OnBow θ) : recoverBow θ.sigma = θ := by
  obtain ⟨hN, hφ⟩ := h
  have hv2 := Bow.v2_pos θ hN
  have hv3 := Bow.v3_pos θ hN
  have hread := readBow_omega θ hv2 hv3
  have hschur : θ.sigma.yy - θ.sigma.yx * θ.sigma.xx⁻¹ * θ.sigma.yxᵀ = θ.omega := by
    simpa [Bow.sigma, Bow.omega] using
      schur_noise (L := θ.L) (G := θ.gamma) (Φ := θ.phi) (N := θ.noise) hφ
  simp only [recoverBow, hschur, hread]
  have hB : (1 - !![0, θ.b12, 0; 0, 0, θ.b23; 0, 0, 0]) = θ.subB := by
    simpa [Bow.B] using (Bow.subB_eq θ).symm
  have hdet : IsUnit θ.phi.det := (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  apply Bow.ext
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · simp only [Bow.sigma]
    rw [hB]
    calc
      θ.subB * (θ.L * θ.gamma * θ.phi) * θ.phi⁻¹
          = (θ.subB * θ.L) * θ.gamma * (θ.phi * θ.phi⁻¹) := by simp only [mul_assoc]
      _ = (1 : M3) * θ.gamma * (1 : M3) := by rw [Bow.subB_mul_L, mul_nonsing_inv _ hdet]
      _ = θ.gamma := by simp
  · rfl

theorem bow_injective {θ θ' : Bow} (hθ : OnBow θ) (hθ' : OnBow θ')
    (h : θ.sigma = θ'.sigma) : θ = θ' := by
  rw [← recover_bow θ hθ, ← recover_bow θ' hθ', h]

end CorrelatedResiduals
