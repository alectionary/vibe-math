/-
Freeing any one residual covariance on the equation-(7) tournament destroys
identification, including the exogenous block. For each edge and every real
scale `c`, the bow and the diagonal base induce the same joint covariance
after `Γ` is adjusted, while `B` and `Ψ` differ whenever `c ≠ 0`.
-/

import CorrelatedResiduals.Diagonal

open Matrix

namespace CorrelatedResiduals

def bow12L (c : ℝ) : M3 :=
  !![1, -c, 0; 0, 1, 0; 0, 0, 1]

def bow12G (c : ℝ) : M3 :=
  !![1, c, 0; 0, 1, 0; 0, 0, 1]

def bow12B (c : ℝ) : M3 :=
  !![0, -c, 0; 0, 0, 0; 0, 0, 0]

def bow13L (c : ℝ) : M3 :=
  !![1, 0, c; 0, 1, 0; 0, 0, 1]

def bow13G (c : ℝ) : M3 :=
  !![1, 0, -c; 0, 1, 0; 0, 0, 1]

def bow13B (c : ℝ) : M3 :=
  !![0, 0, c; 0, 0, 0; 0, 0, 0]

def bow23L (c : ℝ) : M3 :=
  !![1, 0, 0; 0, 1, c; 0, 0, 1]

def bow23G (c : ℝ) : M3 :=
  !![1, 0, 0; 0, 1, -c; 0, 0, 1]

def bow23B (c : ℝ) : M3 :=
  !![0, 0, 0; 0, 0, c; 0, 0, 0]

lemma isUnit_transpose_of {A : M3} (h : IsUnit A) : IsUnit Aᵀ := by
  rw [isUnit_iff_isUnit_det]
  simpa [det_transpose] using (isUnit_iff_isUnit_det A).1 h

lemma posDef_mul_transpose {G : M3} (hG : IsUnit G) : (G * Gᵀ).PosDef := by
  have hform : G * Gᵀ = (Gᵀ)ᴴ * Gᵀ := by
    simp [conjTranspose_eq_transpose_of_trivial]
  exact (Matrix.posDef_iff_eq_conjTranspose_mul_self).2 ⟨Gᵀ, isUnit_transpose_of hG, hform.symm⟩

lemma resolved_noise {L G : M3} (h : L * G = 1) :
    L * (G * Gᵀ) * Lᵀ = 1 := by
  calc
    L * (G * Gᵀ) * Lᵀ = (L * G) * (L * G)ᵀ := by
      simp only [mul_assoc, transpose_mul]
    _ = (1 : M3) := by rw [h]; simp

/-- An endogenous match `L Γ = L' Γ'` with the same residual Gram matrix
gives the same joint covariance for every exogenous coefficient and every `Φ`. -/
lemma exogenous_lift {L G L' G' N N' Φ : M3}
    (hG : L * G = L' * G')
    (hN : L * N * Lᵀ = L' * N' * L'ᵀ) :
    L * G * Φ = L' * G' * Φ ∧
      L * (G * Φ * Gᵀ + N) * Lᵀ = L' * (G' * Φ * G'ᵀ + N') * L'ᵀ := by
  refine ⟨congr_arg (· * Φ) hG, ?_⟩
  have hsig :
      L * (G * Φ * Gᵀ) * Lᵀ = L' * (G' * Φ * G'ᵀ) * L'ᵀ := by
    calc
      L * (G * Φ * Gᵀ) * Lᵀ = (L * G) * Φ * (L * G)ᵀ := by
        simp only [mul_assoc, transpose_mul]
      _ = (L' * G') * Φ * (L' * G')ᵀ := by rw [hG]
      _ = L' * (G' * Φ * G'ᵀ) * L'ᵀ := by
        simp only [mul_assoc, transpose_mul]
  calc
    L * (G * Φ * Gᵀ + N) * Lᵀ = L * (G * Φ * Gᵀ) * Lᵀ + L * N * Lᵀ := by
      rw [Matrix.mul_add, Matrix.add_mul]
    _ = L' * (G' * Φ * G'ᵀ) * L'ᵀ + L' * N' * L'ᵀ := by rw [hsig, hN]
    _ = L' * (G' * Φ * G'ᵀ + N') * L'ᵀ := by
      rw [Matrix.mul_add, Matrix.add_mul]

lemma bow12_resolve (c : ℝ) : bow12L c * bow12G c = 1 := by
  rw [bow12L, bow12G, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma bow13_resolve (c : ℝ) : bow13L c * bow13G c = 1 := by
  rw [bow13L, bow13G, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma bow23_resolve (c : ℝ) : bow23L c * bow23G c = 1 := by
  rw [bow23L, bow23G, mul_fin_three]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

lemma gram_isUnit {L G : M3} (h : L * G = 1) : IsUnit G := by
  rw [isUnit_iff_isUnit_det]
  have hdet := congr_arg det h
  rw [det_mul, det_one] at hdet
  exact isUnit_of_mul_eq_one_right _ _ hdet

lemma bow12_B (c : ℝ) : 1 - bow12B c = bow12G c := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [bow12B, bow12G, sub_apply]

lemma bow13_B (c : ℝ) : 1 - bow13B c = bow13G c := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [bow13B, bow13G, sub_apply]

lemma bow23_B (c : ℝ) : 1 - bow23B c = bow23G c := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [bow23B, bow23G, sub_apply]

/-- Edge `y1 → y0` with residual covariance freed. `Γ' = bow12G c * Γ`. -/
theorem bow12_same_law (c : ℝ) (G Φ : M3) :
    bow12L c * (bow12G c * G) * Φ = G * Φ ∧
      bow12L c * ((bow12G c * G) * Φ * (bow12G c * G)ᵀ + bow12G c * (bow12G c)ᵀ) * (bow12L c)ᵀ =
        G * Φ * Gᵀ + 1 := by
  have hG : bow12L c * (bow12G c * G) = (1 : M3) * G := by
    rw [← mul_assoc, bow12_resolve c, one_mul]
  have hN : bow12L c * (bow12G c * (bow12G c)ᵀ) * (bow12L c)ᵀ = (1 : M3) :=
    resolved_noise (bow12_resolve c)
  have hbaseN : (1 : M3) * (1 : M3) * (1 : M3)ᵀ = (1 : M3) := by simp
  obtain ⟨hyx, hyy⟩ := exogenous_lift (L := bow12L c) (G := bow12G c * G)
    (L' := (1 : M3)) (G' := G) (N := bow12G c * (bow12G c)ᵀ) (N' := (1 : M3)) (Φ := Φ)
    hG (hN.trans hbaseN.symm)
  constructor
  · simpa using hyx
  · simpa using hyy

theorem bow13_same_law (c : ℝ) (G Φ : M3) :
    bow13L c * (bow13G c * G) * Φ = G * Φ ∧
      bow13L c * ((bow13G c * G) * Φ * (bow13G c * G)ᵀ + bow13G c * (bow13G c)ᵀ) * (bow13L c)ᵀ =
        G * Φ * Gᵀ + 1 := by
  have hG : bow13L c * (bow13G c * G) = (1 : M3) * G := by
    rw [← mul_assoc, bow13_resolve c, one_mul]
  have hN : bow13L c * (bow13G c * (bow13G c)ᵀ) * (bow13L c)ᵀ = (1 : M3) :=
    resolved_noise (bow13_resolve c)
  have hbaseN : (1 : M3) * (1 : M3) * (1 : M3)ᵀ = (1 : M3) := by simp
  obtain ⟨hyx, hyy⟩ := exogenous_lift (L := bow13L c) (G := bow13G c * G)
    (L' := (1 : M3)) (G' := G) (N := bow13G c * (bow13G c)ᵀ) (N' := (1 : M3)) (Φ := Φ)
    hG (hN.trans hbaseN.symm)
  constructor
  · simpa using hyx
  · simpa using hyy

theorem bow23_same_law (c : ℝ) (G Φ : M3) :
    bow23L c * (bow23G c * G) * Φ = G * Φ ∧
      bow23L c * ((bow23G c * G) * Φ * (bow23G c * G)ᵀ + bow23G c * (bow23G c)ᵀ) * (bow23L c)ᵀ =
        G * Φ * Gᵀ + 1 := by
  have hG : bow23L c * (bow23G c * G) = (1 : M3) * G := by
    rw [← mul_assoc, bow23_resolve c, one_mul]
  have hN : bow23L c * (bow23G c * (bow23G c)ᵀ) * (bow23L c)ᵀ = (1 : M3) :=
    resolved_noise (bow23_resolve c)
  have hbaseN : (1 : M3) * (1 : M3) * (1 : M3)ᵀ = (1 : M3) := by simp
  obtain ⟨hyx, hyy⟩ := exogenous_lift (L := bow23L c) (G := bow23G c * G)
    (L' := (1 : M3)) (G' := G) (N := bow23G c * (bow23G c)ᵀ) (N' := (1 : M3)) (Φ := Φ)
    hG (hN.trans hbaseN.symm)
  constructor
  · simpa using hyx
  · simpa using hyy

theorem bow12_diff (c : ℝ) (hc : c ≠ 0) : bow12B c ≠ 0 := by
  intro h
  have := congr_fun (congr_fun h 0) 1
  simp [bow12B, hc] at this

theorem bow13_diff (c : ℝ) (hc : c ≠ 0) : bow13B c ≠ 0 := by
  intro h
  have := congr_fun (congr_fun h 0) 2
  simp [bow13B, hc] at this

theorem bow23_diff (c : ℝ) (hc : c ≠ 0) : bow23B c ≠ 0 := by
  intro h
  have := congr_fun (congr_fun h 1) 2
  simp [bow23B, hc] at this

theorem bow12_gamma_diff (c : ℝ) (hc : c ≠ 0) (G : M3) (hG : IsUnit G) :
    bow12G c * G ≠ G := by
  intro h
  have hdet : IsUnit G.det := (isUnit_iff_isUnit_det G).1 hG
  have h1 : bow12G c = 1 := by
    have := congr_arg (· * G⁻¹) h
    simpa [mul_assoc, mul_nonsing_inv _ hdet] using this
  have := congr_fun (congr_fun h1 0) 1
  simp [bow12G, hc] at this

theorem bow13_gamma_diff (c : ℝ) (hc : c ≠ 0) (G : M3) (hG : IsUnit G) :
    bow13G c * G ≠ G := by
  intro h
  have hdet : IsUnit G.det := (isUnit_iff_isUnit_det G).1 hG
  have h1 : bow13G c = 1 := by
    have := congr_arg (· * G⁻¹) h
    simpa [mul_assoc, mul_nonsing_inv _ hdet] using this
  have := congr_fun (congr_fun h1 0) 2
  simp [bow13G, hc] at this

theorem bow23_gamma_diff (c : ℝ) (hc : c ≠ 0) (G : M3) (hG : IsUnit G) :
    bow23G c * G ≠ G := by
  intro h
  have hdet : IsUnit G.det := (isUnit_iff_isUnit_det G).1 hG
  have h1 : bow23G c = 1 := by
    have := congr_arg (· * G⁻¹) h
    simpa [mul_assoc, mul_nonsing_inv _ hdet] using this
  have := congr_fun (congr_fun h1 1) 2
  simp [bow23G, hc] at this

theorem bow12_psi_posDef (c : ℝ) : (bow12G c * (bow12G c)ᵀ).PosDef :=
  posDef_mul_transpose (gram_isUnit (bow12_resolve c))

theorem bow13_psi_posDef (c : ℝ) : (bow13G c * (bow13G c)ᵀ).PosDef :=
  posDef_mul_transpose (gram_isUnit (bow13_resolve c))

theorem bow23_psi_posDef (c : ℝ) : (bow23G c * (bow23G c)ᵀ).PosDef :=
  posDef_mul_transpose (gram_isUnit (bow23_resolve c))

end CorrelatedResiduals
