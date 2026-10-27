/-
The other two bow-free missing-edge patterns on three traits.

`Bow01` deletes the edge into trait 0 from trait 1 and frees that residual
covariance. `Bow23` deletes the edge into trait 1 from trait 2 and frees that
residual covariance. Each recovery is a left inverse on the positive-definite
domain. The third pattern, deleting the edge into trait 0 from trait 2, is
`Bow` in `BowFree.lean`.
-/

import CorrelatedResiduals.Diagonal

open Matrix

namespace CorrelatedResiduals

/-! ### Missing edge `(0,1)` -/

@[ext]
structure Bow01 where
  b13 : ℝ
  b23 : ℝ
  v1 : ℝ
  v2 : ℝ
  v3 : ℝ
  c : ℝ
  gamma : M3
  phi : M3

def Bow01.noise (θ : Bow01) : M3 :=
  !![θ.v1, θ.c, 0;
     θ.c, θ.v2, 0;
     0, 0, θ.v3]

def Bow01.subB (θ : Bow01) : M3 :=
  !![1, 0, -θ.b13;
     0, 1, -θ.b23;
     0, 0, 1]

def Bow01.L (θ : Bow01) : M3 :=
  !![1, 0, θ.b13;
     0, 1, θ.b23;
     0, 0, 1]

def Bow01.B (θ : Bow01) : M3 :=
  !![0, 0, θ.b13;
     0, 0, θ.b23;
     0, 0, 0]

def Bow01.omega (θ : Bow01) : M3 :=
  θ.L * θ.noise * θ.Lᵀ

def Bow01.sigma (θ : Bow01) : Cov where
  yy := θ.L * (θ.gamma * θ.phi * θ.gammaᵀ + θ.noise) * θ.Lᵀ
  yx := θ.L * θ.gamma * θ.phi
  xx := θ.phi

def OnBow01 (θ : Bow01) : Prop :=
  θ.noise.PosDef ∧ θ.phi.PosDef

lemma Bow01.subB_eq (θ : Bow01) : θ.subB = 1 - θ.B := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Bow01.subB, Bow01.B, sub_apply]

lemma Bow01.subB_mul_L (θ : Bow01) : θ.subB * θ.L = 1 := by
  rw [Bow01.subB, Bow01.L, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma Bow01.L_transpose (θ : Bow01) :
    θ.Lᵀ = !![1, 0, 0; 0, 1, 0; θ.b13, θ.b23, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

lemma Bow01.omega_explicit (θ : Bow01) :
    θ.omega =
      !![θ.v1 + θ.b13 ^ 2 * θ.v3, θ.c + θ.b13 * θ.b23 * θ.v3, θ.b13 * θ.v3;
         θ.c + θ.b13 * θ.b23 * θ.v3, θ.v2 + θ.b23 ^ 2 * θ.v3, θ.b23 * θ.v3;
         θ.b13 * θ.v3, θ.b23 * θ.v3, θ.v3] := by
  rw [Bow01.omega, Bow01.L_transpose, Bow01.noise, Bow01.L, mul_fin_three, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp <;> ring

lemma Bow01.omega_22 (θ : Bow01) : θ.omega 2 2 = θ.v3 := by
  rw [Bow01.omega_explicit]; simp

lemma Bow01.omega_02 (θ : Bow01) : θ.omega 0 2 = θ.b13 * θ.v3 := by
  rw [Bow01.omega_explicit]; simp

lemma Bow01.omega_12 (θ : Bow01) : θ.omega 1 2 = θ.b23 * θ.v3 := by
  rw [Bow01.omega_explicit]; simp

lemma Bow01.omega_00 (θ : Bow01) : θ.omega 0 0 = θ.v1 + θ.b13 ^ 2 * θ.v3 := by
  rw [Bow01.omega_explicit]; simp

lemma Bow01.omega_11 (θ : Bow01) : θ.omega 1 1 = θ.v2 + θ.b23 ^ 2 * θ.v3 := by
  rw [Bow01.omega_explicit]; simp

lemma Bow01.omega_01 (θ : Bow01) : θ.omega 0 1 = θ.c + θ.b13 * θ.b23 * θ.v3 := by
  rw [Bow01.omega_explicit]; simp

lemma Bow01.v3_pos (θ : Bow01) (h : θ.noise.PosDef) : 0 < θ.v3 := by
  have := posDef_apply_diag h (2 : Fin 3)
  simpa [Bow01.noise] using this

noncomputable def readBow01 (Ω : M3) : ℝ × ℝ × ℝ × ℝ × ℝ × ℝ :=
  let v3 := Ω 2 2
  let b13 := Ω 0 2 / v3
  let b23 := Ω 1 2 / v3
  let v1 := Ω 0 0 - b13 ^ 2 * v3
  let v2 := Ω 1 1 - b23 ^ 2 * v3
  let c := Ω 0 1 - b13 * b23 * v3
  (b13, b23, v1, v2, v3, c)

lemma readBow01_omega (θ : Bow01) (hv3 : 0 < θ.v3) :
    readBow01 θ.omega = (θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.c) := by
  have hv3' : θ.v3 ≠ 0 := ne_of_gt hv3
  have hb13 : θ.omega 0 2 / θ.omega 2 2 = θ.b13 := by
    rw [Bow01.omega_02, Bow01.omega_22]; field_simp
  have hb23 : θ.omega 1 2 / θ.omega 2 2 = θ.b23 := by
    rw [Bow01.omega_12, Bow01.omega_22]; field_simp
  have hv1eq : θ.omega 0 0 - (θ.omega 0 2 / θ.omega 2 2) ^ 2 * θ.omega 2 2 = θ.v1 := by
    rw [hb13, Bow01.omega_00, Bow01.omega_22]; ring
  have hv2eq : θ.omega 1 1 - (θ.omega 1 2 / θ.omega 2 2) ^ 2 * θ.omega 2 2 = θ.v2 := by
    rw [hb23, Bow01.omega_11, Bow01.omega_22]; ring
  have hc :
      θ.omega 0 1 - (θ.omega 0 2 / θ.omega 2 2) * (θ.omega 1 2 / θ.omega 2 2) * θ.omega 2 2 =
        θ.c := by
    rw [hb13, hb23, Bow01.omega_01, Bow01.omega_22]; ring
  unfold readBow01
  dsimp only
  rw [hc, hv2eq, hv1eq, hb23, hb13, Bow01.omega_22]

noncomputable def recoverBow01 (cov : Cov) : Bow01 :=
  let Ω := cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ
  let r := readBow01 Ω
  let b13 := r.1
  let b23 := r.2.1
  let v1 := r.2.2.1
  let v2 := r.2.2.2.1
  let v3 := r.2.2.2.2.1
  let c := r.2.2.2.2.2
  let B : M3 := !![0, 0, b13; 0, 0, b23; 0, 0, 0]
  { b13, b23, v1, v2, v3, c,
    gamma := (1 - B) * cov.yx * cov.xx⁻¹,
    phi := cov.xx }

theorem recover_bow01 (θ : Bow01) (h : OnBow01 θ) : recoverBow01 θ.sigma = θ := by
  obtain ⟨hN, hφ⟩ := h
  have hv3 := Bow01.v3_pos θ hN
  have hread := readBow01_omega θ hv3
  have hschur : θ.sigma.yy - θ.sigma.yx * θ.sigma.xx⁻¹ * θ.sigma.yxᵀ = θ.omega := by
    simpa [Bow01.sigma, Bow01.omega] using
      schur_noise (L := θ.L) (G := θ.gamma) (Φ := θ.phi) (N := θ.noise) hφ
  simp only [recoverBow01, hschur, hread]
  have hB : (1 - !![0, 0, θ.b13; 0, 0, θ.b23; 0, 0, 0]) = θ.subB := by
    simpa [Bow01.B] using (Bow01.subB_eq θ).symm
  have hdet : IsUnit θ.phi.det := (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  apply Bow01.ext
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · simp only [Bow01.sigma]
    rw [hB]
    calc
      θ.subB * (θ.L * θ.gamma * θ.phi) * θ.phi⁻¹
          = (θ.subB * θ.L) * θ.gamma * (θ.phi * θ.phi⁻¹) := by simp only [mul_assoc]
      _ = (1 : M3) * θ.gamma * (1 : M3) := by rw [Bow01.subB_mul_L, mul_nonsing_inv _ hdet]
      _ = θ.gamma := by simp
  · rfl

theorem bow01_injective {θ θ' : Bow01} (hθ : OnBow01 θ) (hθ' : OnBow01 θ')
    (h : θ.sigma = θ'.sigma) : θ = θ' := by
  rw [← recover_bow01 θ hθ, ← recover_bow01 θ' hθ', h]

/-! ### Missing edge `(1,2)` -/

@[ext]
structure Bow23 where
  b12 : ℝ
  b13 : ℝ
  v1 : ℝ
  v2 : ℝ
  v3 : ℝ
  c : ℝ
  gamma : M3
  phi : M3

def Bow23.noise (θ : Bow23) : M3 :=
  !![θ.v1, 0, 0;
     0, θ.v2, θ.c;
     0, θ.c, θ.v3]

def Bow23.subB (θ : Bow23) : M3 :=
  !![1, -θ.b12, -θ.b13;
     0, 1, 0;
     0, 0, 1]

def Bow23.L (θ : Bow23) : M3 :=
  !![1, θ.b12, θ.b13;
     0, 1, 0;
     0, 0, 1]

def Bow23.B (θ : Bow23) : M3 :=
  !![0, θ.b12, θ.b13;
     0, 0, 0;
     0, 0, 0]

def Bow23.omega (θ : Bow23) : M3 :=
  θ.L * θ.noise * θ.Lᵀ

def Bow23.sigma (θ : Bow23) : Cov where
  yy := θ.L * (θ.gamma * θ.phi * θ.gammaᵀ + θ.noise) * θ.Lᵀ
  yx := θ.L * θ.gamma * θ.phi
  xx := θ.phi

def OnBow23 (θ : Bow23) : Prop :=
  θ.noise.PosDef ∧ θ.phi.PosDef

lemma Bow23.subB_eq (θ : Bow23) : θ.subB = 1 - θ.B := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Bow23.subB, Bow23.B, sub_apply]

lemma Bow23.subB_mul_L (θ : Bow23) : θ.subB * θ.L = 1 := by
  rw [Bow23.subB, Bow23.L, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma Bow23.L_transpose (θ : Bow23) :
    θ.Lᵀ = !![1, 0, 0; θ.b12, 1, 0; θ.b13, 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

lemma Bow23.omega_explicit (θ : Bow23) :
    θ.omega =
      !![θ.v1 + θ.b12 ^ 2 * θ.v2 + 2 * θ.b12 * θ.b13 * θ.c + θ.b13 ^ 2 * θ.v3,
         θ.b12 * θ.v2 + θ.b13 * θ.c,
         θ.b12 * θ.c + θ.b13 * θ.v3;
         θ.b12 * θ.v2 + θ.b13 * θ.c,
         θ.v2,
         θ.c;
         θ.b12 * θ.c + θ.b13 * θ.v3,
         θ.c,
         θ.v3] := by
  rw [Bow23.omega, Bow23.L_transpose, Bow23.noise, Bow23.L, mul_fin_three, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp <;> ring

lemma Bow23.omega_11 (θ : Bow23) : θ.omega 1 1 = θ.v2 := by
  rw [Bow23.omega_explicit]; simp

lemma Bow23.omega_22 (θ : Bow23) : θ.omega 2 2 = θ.v3 := by
  rw [Bow23.omega_explicit]; simp

lemma Bow23.omega_12 (θ : Bow23) : θ.omega 1 2 = θ.c := by
  rw [Bow23.omega_explicit]; simp

lemma Bow23.omega_01 (θ : Bow23) : θ.omega 0 1 = θ.b12 * θ.v2 + θ.b13 * θ.c := by
  rw [Bow23.omega_explicit]; simp

lemma Bow23.omega_02 (θ : Bow23) : θ.omega 0 2 = θ.b12 * θ.c + θ.b13 * θ.v3 := by
  rw [Bow23.omega_explicit]; simp

lemma Bow23.omega_00 (θ : Bow23) :
    θ.omega 0 0 =
      θ.v1 + θ.b12 ^ 2 * θ.v2 + 2 * θ.b12 * θ.b13 * θ.c + θ.b13 ^ 2 * θ.v3 := by
  rw [Bow23.omega_explicit]; simp

lemma Bow23.v2_pos (θ : Bow23) (h : θ.noise.PosDef) : 0 < θ.v2 := by
  have := posDef_apply_diag h (1 : Fin 3)
  simpa [Bow23.noise] using this

/-- The trailing principal minor is positive because a vanishing minor would
make the quadratic form zero on a nonzero vector. -/
lemma Bow23.den_pos (θ : Bow23) (h : θ.noise.PosDef) : 0 < θ.v2 * θ.v3 - θ.c ^ 2 := by
  have hv2 := Bow23.v2_pos θ h
  let x : Fin 3 → ℝ := ![0, -θ.c, θ.v2]
  have hx : x ≠ 0 := by
    intro h0
    have := congr_fun h0 2
    simp [x, hv2.ne'] at this
  have hpos := h.2 x hx
  have hquad : star x ⬝ᵥ (θ.noise *ᵥ x) = θ.v2 * (θ.v2 * θ.v3 - θ.c ^ 2) := by
    rw [dotProduct, Finset.sum_fin_eq_sum_range, Finset.sum_range_succ, Finset.sum_range_succ,
      Finset.sum_range_succ, Finset.sum_range_zero, star_trivial]
    simp [Bow23.noise, x]
    ring
  rw [hquad] at hpos
  exact (mul_pos_iff_of_pos_left hv2).mp hpos

noncomputable def readBow23 (Ω : M3) : ℝ × ℝ × ℝ × ℝ × ℝ × ℝ :=
  let v2 := Ω 1 1
  let v3 := Ω 2 2
  let c := Ω 1 2
  let den := v2 * v3 - c ^ 2
  let b12 := (Ω 0 1 * v3 - Ω 0 2 * c) / den
  let b13 := (Ω 0 2 * v2 - Ω 0 1 * c) / den
  let v1 := Ω 0 0 - b12 * Ω 0 1 - b13 * Ω 0 2
  (b12, b13, v1, v2, v3, c)

lemma readBow23_omega (θ : Bow23) (hden : θ.v2 * θ.v3 - θ.c ^ 2 ≠ 0) :
    readBow23 θ.omega = (θ.b12, θ.b13, θ.v1, θ.v2, θ.v3, θ.c) := by
  have hv2 : θ.omega 1 1 = θ.v2 := Bow23.omega_11 θ
  have hv3 : θ.omega 2 2 = θ.v3 := Bow23.omega_22 θ
  have hc0 : θ.omega 1 2 = θ.c := Bow23.omega_12 θ
  have hden_eq :
      θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2 = θ.v2 * θ.v3 - θ.c ^ 2 := by
    rw [hv2, hv3, hc0]
  have hb12 :
      (θ.omega 0 1 * θ.omega 2 2 - θ.omega 0 2 * θ.omega 1 2) /
          (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2) =
        θ.b12 := by
    rw [hden_eq, Bow23.omega_01, Bow23.omega_02, hv3, hc0]
    field_simp [hden]
    ring
  have hb13 :
      (θ.omega 0 2 * θ.omega 1 1 - θ.omega 0 1 * θ.omega 1 2) /
          (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2) =
        θ.b13 := by
    rw [hden_eq, Bow23.omega_01, Bow23.omega_02, hv2, hc0]
    field_simp [hden]
    ring
  have hv1eq :
      θ.omega 0 0 -
          ((θ.omega 0 1 * θ.omega 2 2 - θ.omega 0 2 * θ.omega 1 2) /
            (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2)) * θ.omega 0 1 -
          ((θ.omega 0 2 * θ.omega 1 1 - θ.omega 0 1 * θ.omega 1 2) /
            (θ.omega 1 1 * θ.omega 2 2 - θ.omega 1 2 ^ 2)) * θ.omega 0 2 =
        θ.v1 := by
    rw [hb12, hb13, Bow23.omega_00, Bow23.omega_01, Bow23.omega_02]
    ring
  unfold readBow23
  dsimp only
  rw [hv1eq, hb13, hb12, hc0, hv3, hv2]

noncomputable def recoverBow23 (cov : Cov) : Bow23 :=
  let Ω := cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ
  let r := readBow23 Ω
  let b12 := r.1
  let b13 := r.2.1
  let v1 := r.2.2.1
  let v2 := r.2.2.2.1
  let v3 := r.2.2.2.2.1
  let c := r.2.2.2.2.2
  let B : M3 := !![0, b12, b13; 0, 0, 0; 0, 0, 0]
  { b12, b13, v1, v2, v3, c,
    gamma := (1 - B) * cov.yx * cov.xx⁻¹,
    phi := cov.xx }

theorem recover_bow23 (θ : Bow23) (h : OnBow23 θ) : recoverBow23 θ.sigma = θ := by
  obtain ⟨hN, hφ⟩ := h
  have hden : θ.v2 * θ.v3 - θ.c ^ 2 ≠ 0 := (Bow23.den_pos θ hN).ne'
  have hread := readBow23_omega θ hden
  have hschur : θ.sigma.yy - θ.sigma.yx * θ.sigma.xx⁻¹ * θ.sigma.yxᵀ = θ.omega := by
    simpa [Bow23.sigma, Bow23.omega] using
      schur_noise (L := θ.L) (G := θ.gamma) (Φ := θ.phi) (N := θ.noise) hφ
  simp only [recoverBow23, hschur, hread]
  have hB : (1 - !![0, θ.b12, θ.b13; 0, 0, 0; 0, 0, 0]) = θ.subB := by
    simpa [Bow23.B] using (Bow23.subB_eq θ).symm
  have hdet : IsUnit θ.phi.det := (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  apply Bow23.ext
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · simp only [Bow23.sigma]
    rw [hB]
    calc
      θ.subB * (θ.L * θ.gamma * θ.phi) * θ.phi⁻¹
          = (θ.subB * θ.L) * θ.gamma * (θ.phi * θ.phi⁻¹) := by simp only [mul_assoc]
      _ = (1 : M3) * θ.gamma * (1 : M3) := by rw [Bow23.subB_mul_L, mul_nonsing_inv _ hdet]
      _ = θ.gamma := by simp
  · rfl

theorem bow23_injective {θ θ' : Bow23} (hθ : OnBow23 θ) (hθ' : OnBow23 θ')
    (h : θ.sigma = θ'.sigma) : θ = θ' := by
  rw [← recover_bow23 θ hθ, ← recover_bow23 θ' hθ', h]

end CorrelatedResiduals
