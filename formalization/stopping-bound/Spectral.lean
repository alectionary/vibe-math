module

public import Mathlib.Analysis.Matrix.PosDef
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.Ring
public import Mathlib.Tactic.NormNum
public import Mathlib.Tactic.Positivity
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.FieldSimp

@[expose] public section

open scoped BigOperators
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false

open Matrix WithLp

set_option maxHeartbeats 40000

namespace StoppingSpectral

variable {m n : Type*} [Fintype m] [DecidableEq m] [Fintype n] [DecidableEq n]

/-- Real quadratic form of a check-side Gram matrix. -/
def energy (H : Matrix m n ℝ) (x : m → ℝ) : ℝ :=
  ∑ j, (∑ i, H i j * x i)^2

def normSq (x : m → ℝ) : ℝ := ∑ i, (x i)^2

lemma energy_eq_gram (H : Matrix m n ℝ) (x : m → ℝ) :
    energy H x = x ⬝ᵥ ((H * Hᵀ) *ᵥ x) := by
  rw [← Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec]
  have ht : Matrix.vecMul x H = Hᵀ *ᵥ x := by
    simpa using Matrix.vecMul_transpose Hᵀ x
  rw [ht]
  simp [energy, dotProduct, Matrix.mulVec, pow_two]

noncomputable def eigs (H : Matrix m n ℝ) : Fin (Fintype.card m) → ℝ :=
  (isHermitian_mul_conjTranspose_self H).eigenvalues₀

noncomputable def eBasis (H : Matrix m n ℝ) :
    OrthonormalBasis (Fin (Fintype.card m)) ℝ (EuclideanSpace ℝ m) :=
  (isSymmetric_toEuclideanLin_iff.mpr
    (isHermitian_mul_conjTranspose_self H)).eigenvectorBasis finrank_euclideanSpace

lemma eigs_antitone (H : Matrix m n ℝ) : Antitone (eigs H) :=
  (isHermitian_mul_conjTranspose_self H).eigenvalues₀_antitone

lemma gram_apply_basis (H : Matrix m n ℝ) (i : Fin (Fintype.card m)) :
    (H * Hᵀ) *ᵥ (eBasis H i : m → ℝ) = eigs H i • (eBasis H i : m → ℝ) := by
  have h := (isSymmetric_toEuclideanLin_iff.mpr
    (isHermitian_mul_conjTranspose_self H)).apply_eigenvectorBasis finrank_euclideanSpace i
  exact congrArg (fun v : EuclideanSpace ℝ m => (v : m → ℝ)) h

lemma normSq_euclidean (x : EuclideanSpace ℝ m) : normSq (x : m → ℝ) = ‖x‖^2 := by
  simp [normSq, EuclideanSpace.norm_sq_eq, Real.norm_eq_abs, sq_abs]

lemma energy_eigenbasis (H : Matrix m n ℝ) (x : EuclideanSpace ℝ m) :
    energy H (x : m → ℝ) =
      ∑ i, eigs H i * ((eBasis H).repr x i)^2 := by
  rw [energy_eq_gram]
  rw [← show inner ℝ x ((H * Hᵀ).toEuclideanLin x) =
    (x : m → ℝ) ⬝ᵥ ((H * Hᵀ) *ᵥ (x : m → ℝ)) by
      simp [EuclideanSpace.inner_eq_star_dotProduct, Matrix.toLpLin_apply, dotProduct_comm]]
  rw [← (eBasis H).repr.inner_map_map]
  simp only [PiLp.inner_apply, RCLike.inner_apply, conj_trivial]
  have h := (isSymmetric_toEuclideanLin_iff.mpr
    (isHermitian_mul_conjTranspose_self H)).eigenvectorBasis_apply_self_apply
      finrank_euclideanSpace x
  apply Finset.sum_congr rfl
  intro i _
  have hi := h i
  change (eBasis H).repr ((H * Hᵀ).toEuclideanLin x) i = _ at hi
  change (eBasis H).repr ((H * Hᵀ).toEuclideanLin x) i =
    eigs H i * (eBasis H).repr x i at hi
  rw [hi]
  ring

lemma energy_basis (H : Matrix m n ℝ) (i : Fin (Fintype.card m)) :
    energy H (eBasis H i : m → ℝ) = eigs H i := by
  rw [energy_eigenbasis]
  simp [OrthonormalBasis.repr_self]

lemma eigs_trace (H : Matrix m n ℝ) :
    ∑ i, eigs H i = (H * Hᵀ).trace := by
  have h := (isHermitian_mul_conjTranspose_self H).trace_eq_sum_eigenvalues
  simp only [conjTranspose_eq_transpose_of_trivial] at h
  rw [h]
  exact Fintype.sum_equiv
    (Fintype.equivOfCardEq (Fintype.card_fin (Fintype.card m)))
    (eigs H)
    (fun i : m => (isHermitian_mul_conjTranspose_self H).eigenvalues i)
    (fun i => by simp [eigs, Matrix.IsHermitian.eigenvalues])


lemma energy_le_of_coeff_zero (H : Matrix m n ℝ) (hm : 2 ≤ Fintype.card m)
    (x : EuclideanSpace ℝ m) (hx : (eBasis H).repr x ⟨0, by omega⟩ = 0) :
    energy H (x : m → ℝ) ≤ eigs H ⟨1, by omega⟩ * normSq (x : m → ℝ) := by
  rw [energy_eigenbasis, normSq_euclidean,
    ← (eBasis H).repr.norm_map, EuclideanSpace.norm_sq_eq]
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro i _
  simp only [Real.norm_eq_abs, sq_abs]
  by_cases hi : i = ⟨0, by omega⟩
  · simp [hi, hx]
  · apply mul_le_mul_of_nonneg_right _ (sq_nonneg _)
    exact eigs_antitone H (show (⟨1, by omega⟩ : Fin (Fintype.card m)) ≤ i by
      apply Fin.le_def.mpr
      have hne : i.val ≠ 0 := by simpa [Fin.ext_iff] using hi
      change 1 ≤ i.val
      omega)

lemma binary_weighted_cauchy (w x : m → ℝ) (hw : ∀ i, w i = 0 ∨ w i = 1) :
    (∑ i, w i * x i)^2 ≤ (∑ i, w i) * ∑ i, w i * (x i)^2 := by
  have h := Finset.sum_mul_sq_le_sq_mul_sq Finset.univ w (fun i => w i * x i)
  have h1 : (∑ i, w i * (w i * x i)) = ∑ i, w i * x i := by
    apply Finset.sum_congr rfl
    intro i _
    rcases hw i with hi | hi <;> simp [hi]
  have h2 : (∑ i, (w i)^2) = ∑ i, w i := by
    apply Finset.sum_congr rfl
    intro i _
    rcases hw i with hi | hi <;> simp [hi]
  have h3 : (∑ i, (w i * x i)^2) = ∑ i, w i * (x i)^2 := by
    apply Finset.sum_congr rfl
    intro i _
    rcases hw i with hi | hi <;> simp [hi]
  rwa [h1, h2, h3] at h

lemma regular_energy_upper (H : Matrix m n ℝ) (γ k : ℝ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k)
    (x : m → ℝ) : energy H x ≤ γ * k * normSq x := by
  calc
    energy H x ≤ ∑ j, γ * ∑ i, H i j * (x i)^2 := by
      apply Finset.sum_le_sum
      intro j _
      simpa [hcol j] using binary_weighted_cauchy (fun i => H i j) x (fun i => hbin i j)
    _ = γ * k * normSq x := by
      simp_rw [← Finset.mul_sum]
      rw [Finset.sum_comm]
      simp_rw [← Finset.sum_mul, hrow]
      simp [normSq, Finset.mul_sum, mul_assoc, mul_comm, mul_left_comm]

lemma regular_trace (H : Matrix m n ℝ) (k : ℝ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hrow : ∀ i, ∑ j, H i j = k) :
    (H * Hᵀ).trace = (Fintype.card m : ℝ) * k := by
  simp only [Matrix.trace, Matrix.diag, Matrix.mul_apply, Matrix.transpose_apply]
  have hh : ∀ i, (∑ j, H i j * H i j) = k := by
    intro i
    rw [← hrow i]
    apply Finset.sum_congr rfl
    intro j _
    rcases hbin i j with h | h <;> simp [h]
  simp [hh]

lemma regular_eigs_le (H : Matrix m n ℝ) (γ k : ℝ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k)
    (i : Fin (Fintype.card m)) : eigs H i ≤ γ * k := by
  have h := regular_energy_upper H γ k hbin hcol hrow (eBasis H i)
  rw [energy_basis, normSq_euclidean, (eBasis H).orthonormal.1 i] at h
  simpa using h

/-- Finite trace bound for the actual second Gram eigenvalue, not a normalized one. -/
theorem regular_trace_obstruction (H : Matrix m n ℝ) (γ k : ℝ)
    (hm : 2 ≤ Fintype.card m)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k) :
    k * ((Fintype.card m : ℝ) - γ) ≤
      ((Fintype.card m : ℝ) - 1) * eigs H ⟨1, by omega⟩ := by
  let z : Fin (Fintype.card m) := ⟨0, by omega⟩
  let o : Fin (Fintype.card m) := ⟨1, by omega⟩
  have hs : ∑ i ∈ Finset.univ.erase z, eigs H i ≤
      ((Fintype.card m : ℝ) - 1) * eigs H o := by
    calc
      _ ≤ ∑ _i ∈ Finset.univ.erase z, eigs H o := by
        apply Finset.sum_le_sum
        intro i hi
        have hne : i ≠ z := (Finset.mem_erase.mp hi).1
        apply eigs_antitone H
        apply Fin.le_def.mpr
        have : i.val ≠ 0 := by simpa [z, Fin.ext_iff] using hne
        change 1 ≤ i.val
        omega
      _ = _ := by simp [Finset.card_erase_of_mem (Finset.mem_univ z), Nat.cast_sub (by omega : 1 ≤ Fintype.card m)]
  have he := Finset.sum_erase_add Finset.univ (eigs H) (Finset.mem_univ z)
  rw [eigs_trace, regular_trace H k hbin hrow] at he
  have hz := regular_eigs_le H γ k hbin hcol hrow z
  dsimp [o] at hs
  nlinarith

section Replicated
variable {R C F : Type*} [Fintype R] [DecidableEq R] [Fintype C] [DecidableEq C]
  [Fintype F] [DecidableEq F]

/-- The exact expanded scalar-factor QC-GHP X matrix; the first block is unrestricted.
`B` is the scalar circulant before the transpose in the source convention. -/
def scalarFactorMatrix (A : Matrix (R × F) (C × F) ℝ) (B : Matrix F F ℝ) :
    Matrix (R × F) ((C × F) ⊕ (R × F)) ℝ :=
  fun (r, f) j => match j with
    | Sum.inl j => A (r, f) j
    | Sum.inr (r', f') => if r = r' then B f' f else 0

noncomputable def fiberLift : (R → ℝ) →ₗ[ℝ] EuclideanSpace ℝ (R × F) where
  toFun u := toLp 2 (fun i => u i.1)
  map_add' u v := by ext i; rfl
  map_smul' a u := by ext i; rfl

lemma scalarFactor_right_action (A : Matrix (R × F) (C × F) ℝ)
    (B : Matrix F F ℝ) (γ : ℝ) (hB : ∀ j, ∑ i, B j i = γ)
    (u : R → ℝ) (j : R × F) :
    (∑ i, scalarFactorMatrix A B i (Sum.inr j) * u i.1) = γ * u j.1 := by
  simp [scalarFactorMatrix, Fintype.sum_prod_type, ← Finset.sum_mul, hB]

lemma scalarFactor_energy_lower (A : Matrix (R × F) (C × F) ℝ)
    (B : Matrix F F ℝ) (γ : ℝ) (hB : ∀ j, ∑ i, B j i = γ)
    (u : R → ℝ) :
    γ^2 * normSq (fiberLift u : R × F → ℝ) ≤
      energy (scalarFactorMatrix A B) (fiberLift u) := by
  have hn : normSq (fiberLift u : R × F → ℝ) =
      (Fintype.card F : ℝ) * ∑ r, (u r)^2 := by
    simp [normSq, fiberLift, Fintype.sum_prod_type, Finset.mul_sum, mul_comm]
  have he : (∑ j : R × F, (∑ i : R × F,
      scalarFactorMatrix A B i (Sum.inr j) * u i.1)^2) =
      γ^2 * normSq (fiberLift u : R × F → ℝ) := by
    simp_rw [scalarFactor_right_action A B γ hB, mul_pow]
    rw [hn]
    simp [Fintype.sum_prod_type, Finset.mul_sum, mul_assoc, mul_comm, mul_left_comm]
  change _ ≤ (∑ j : (C × F) ⊕ (R × F), (∑ i,
    scalarFactorMatrix A B i j * u i.1)^2)
  rw [Fintype.sum_sum_type, he]
  have hp : 0 ≤ ∑ j : C × F, (∑ i : R × F,
      scalarFactorMatrix A B i (Sum.inl j) * u i.1)^2 :=
    Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  linarith

/-- Non-asymptotic obstruction: at least two row blocks force sigma₂² ≥ γ².
The theorem is about the ordered spectrum of the actual expanded matrix. -/
theorem replicated_scalar_second_lower [Nonempty F]
    (A : Matrix (R × F) (C × F) ℝ) (B : Matrix F F ℝ) (γ : ℝ)
    (hr : 2 ≤ Fintype.card R) (hB : ∀ j, ∑ i, B j i = γ) :
    γ^2 ≤ eigs (scalarFactorMatrix A B) ⟨1, by
      simp only [Fintype.card_prod]
      have := Fintype.card_pos (α := F)
      nlinarith⟩ := by
  let H := scalarFactorMatrix A B
  have hm : 2 ≤ Fintype.card (R × F) := by
    simp only [Fintype.card_prod]
    have := Fintype.card_pos (α := F)
    nlinarith
  let f : (R → ℝ) →ₗ[ℝ] ℝ :=
    { toFun := fun u => (eBasis H).repr (fiberLift u) ⟨0, by omega⟩
      map_add' := by intros; simp
      map_smul' := by intros; simp }
  have hk : LinearMap.ker f ≠ ⊥ := LinearMap.ker_ne_bot_of_finrank_lt (by
    simpa using (show 1 < Fintype.card R by omega))
  obtain ⟨u, hu, hune⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hk
  have hu0 : (eBasis H).repr (fiberLift u) ⟨0, by omega⟩ = 0 := hu
  have hx : fiberLift u ≠ (0 : EuclideanSpace ℝ (R × F)) := by
    intro h
    apply hune
    ext r
    have hh := congrArg (fun x : EuclideanSpace ℝ (R × F) => x (r, Classical.choice inferInstance)) h
    exact hh
  have hp : 0 < normSq (fiberLift u : R × F → ℝ) := by
    rw [normSq_euclidean]
    exact sq_pos_of_pos (norm_pos_iff.mpr hx)
  have hl := scalarFactor_energy_lower A B γ hB u
  have hh := energy_le_of_coeff_zero H hm (fiberLift u) hu0
  nlinarith

/-- Positive integral column weights cannot satisfy the source inequality. -/
theorem replicated_scalar_no_source_regime [Nonempty F]
    (A : Matrix (R × F) (C × F) ℝ) (B : Matrix F F ℝ) (γ : ℕ)
    (hr : 2 ≤ Fintype.card R) (hγ : 0 < γ)
    (hB : ∀ j, ∑ i, B j i = (γ : ℝ)) :
    ¬ eigs (scalarFactorMatrix A B) ⟨1, by
      simp only [Fintype.card_prod]
      have := Fintype.card_pos (α := F)
      nlinarith⟩ < (γ : ℝ) / 2 := by
  have h := replicated_scalar_second_lower A B (γ : ℝ) hr hB
  have hg : (1 : ℝ) ≤ γ := by exact_mod_cast hγ
  nlinarith

end Replicated

/-- Necessary density for one-row scalar-factor matrices (`q = n₁+1 ≥ 2`). -/
theorem one_row_density (ell γ q s : ℝ) (he : 1 < ell) (hg : 0 < γ)
    (hgell : γ ≤ ell) (hq : 2 ≤ q)
    (htrace : q * γ * (ell - γ) ≤ (ell - 1) * s)
    (hgap : s < γ / 2) :
    ell - (ell - 1) / (2*q) < γ ∧ (3*ell+1)/4 < γ := by
  have hmul : (ell - 1) * s < (ell - 1) * (γ / 2) :=
    mul_lt_mul_of_pos_left hgap (by linarith)
  have hqg : 2 * γ * (ell - γ) ≤ q * γ * (ell - γ) := by
    apply mul_le_mul_of_nonneg_right _ (sub_nonneg.mpr hgell)
    exact mul_le_mul_of_nonneg_right hq hg.le
  constructor
  · apply (sub_lt_iff_lt_add).mpr
    have hqpos : 0 < 2*q := by linarith
    have hdiv : ell - γ < (ell-1)/(2*q) := by
      apply (lt_div_iff₀ hqpos).mpr
      nlinarith
    linarith
  · nlinarith

/-- The source large root cannot exceed two in the remaining one-row regime. -/
theorem one_row_large_root_le_two (ell γ q s : ℝ) (he : 1 < ell) (hg : 0 < γ)
    (hgell : γ ≤ ell) (hq : 2 ≤ q) (hs : 0 ≤ s)
    (htrace : q * γ * (ell - γ) ≤ (ell - 1) * s)
    (hgap : s < γ / 2) :
    (ell / γ) * (1 + Real.sqrt (1 - 2*s/γ)) ≤ 2 := by
  have hd := (one_row_density ell γ q s he hg hgell hq htrace hgap).2
  have hqg : 2 * γ * (ell - γ) ≤ q * γ * (ell - γ) := by
    apply mul_le_mul_of_nonneg_right _ (sub_nonneg.mpr hgell)
    exact mul_le_mul_of_nonneg_right hq hg.le
  have ht : 2 * γ * (ell - γ) ≤ (ell - 1) * s := hqg.trans htrace
  have haux : γ * (ell - 1) ≤ ell^2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hgell) (show 0 ≤ ell - 1 by linarith)]
  have ht' := mul_le_mul_of_nonneg_left ht hg.le
  have hs' := mul_le_mul_of_nonneg_right haux hs
  have hdisc : 2 * γ^2 * (ell - γ) ≤ ell^2 * s := by nlinarith
  have he0 : 0 < ell := by linarith
  have hr : 0 ≤ 2*γ/ell - 1 := by
    apply sub_nonneg.mpr
    apply (le_div_iff₀ he0).mpr
    linarith
  have hb : 1 - 2*s/γ ≤ (2*γ/ell - 1)^2 := by
    apply (mul_le_mul_iff_right₀ (show 0 < γ * ell^2 by positivity)).mp
    field_simp
    nlinarith
  have hsqrt : Real.sqrt (1 - 2*s/γ) ≤ 2*γ/ell - 1 :=
    (Real.sqrt_le_iff).mpr ⟨hr, hb⟩
  have hfac := mul_le_mul_of_nonneg_left hsqrt (show 0 ≤ ell/γ by positivity)
  have hid : (ell/γ) * (1 + (2*γ/ell - 1)) = 2 := by field_simp; ring
  nlinarith

/-- A finite one-row code matrix, not just an assumed spectral parameter tuple. -/
theorem one_row_matrix_obstruction {ell q : ℕ} (H : Matrix (Fin ell) (Fin q × Fin ell) ℝ)
    (γ : ℝ) (hell : 2 ≤ ell) (hq : 2 ≤ q) (hg : 0 < γ) (hgell : γ ≤ ell)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ)
    (hrow : ∀ i, ∑ j, H i j = (q : ℝ)*γ)
    (hgap : eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩ < γ/2) :
    ((3*(ell : ℝ)+1)/4 < γ) ∧
    ((ell : ℝ)/γ) * (1 + Real.sqrt (1 - 2 * eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩ / γ)) ≤ 2 := by
  let s := eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩
  have he : (1 : ℝ) < ell := by exact_mod_cast hell
  have hqr : (2 : ℝ) ≤ q := by exact_mod_cast hq
  have ht := regular_trace_obstruction H γ ((q : ℝ)*γ) (by simp only [Fintype.card_fin]; omega) hbin hcol hrow
  simp only [Fintype.card_fin] at ht
  have hs : 0 ≤ s := by
    dsimp [s]
    rw [← energy_basis H ⟨1, by simp only [Fintype.card_fin]; omega⟩]
    exact Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  exact ⟨(one_row_density ell γ q s he hg hgell hqr ht hgap).2,
    one_row_large_root_le_two ell γ q s he hg hgell hqr hs ht hgap⟩

lemma binary_column_sum_le_card (H : Matrix m n ℝ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1) (j : n) :
    (∑ i, H i j) ≤ (Fintype.card m : ℝ) := by
  calc
    _ ≤ ∑ _i : m, (1 : ℝ) := by
      apply Finset.sum_le_sum
      intro i _
      rcases hbin i j with hi | hi <;> simp [hi]
    _ = _ := by simp

lemma regular_edge_count (H : Matrix m n ℝ) (γ k : ℝ)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k) :
    (Fintype.card m : ℝ) * k = (Fintype.card n : ℝ) * γ := by
  calc
    _ = ∑ i, ∑ j, H i j := by simp [hrow]
    _ = ∑ j, ∑ i, H i j := Finset.sum_comm
    _ = _ := by simp [hcol]

/-- Source-level one-row hypotheses: positivity, binary biregularity, and q≥2 blocks.
The density cap and k=qγ are derived, not postulated. -/
theorem one_row_biregular_obstruction {ell q : ℕ}
    (H : Matrix (Fin ell) (Fin q × Fin ell) ℝ) (γ k : ℝ)
    (hell : 2 ≤ ell) (hq : 2 ≤ q) (hg : 0 < γ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k)
    (hgap : eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩ < γ/2) :
    ((3*(ell : ℝ)+1)/4 < γ) ∧
    ((ell : ℝ)/γ) *
      (1 + Real.sqrt (1 - 2 * eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩ / γ)) ≤ 2 := by
  have he : (0 : ℝ) < ell := by exact_mod_cast (show 0 < ell by omega)
  have hcount := regular_edge_count H γ k hcol hrow
  simp only [Fintype.card_fin, Fintype.card_prod, Nat.cast_mul] at hcount
  have hk : k = (q : ℝ)*γ := by nlinarith
  have hγell : γ ≤ ell := by
    have h := binary_column_sum_le_card H hbin (⟨0, by omega⟩, ⟨0, by omega⟩)
    simpa [hcol] using h
  exact one_row_matrix_obstruction H γ hell hq hg hγell hbin hcol
    (fun i => by rw [hrow, hk]) hgap

/-- Source-level multi-row hypothesis: the scalar row weight is forced by H_X column regularity. -/
theorem qc_scalar_factor_no_source_regime
    {R C F : Type*} [Fintype R] [DecidableEq R] [Fintype C] [DecidableEq C]
    [Fintype F] [DecidableEq F] [Nonempty F]
    (A : Matrix (R × F) (C × F) ℝ) (B : Matrix F F ℝ) (γ : ℕ)
    (hr : 2 ≤ Fintype.card R) (hγ : 0 < γ)
    (hcol : ∀ j, ∑ i, scalarFactorMatrix A B i j = (γ : ℝ)) :
    ¬ eigs (scalarFactorMatrix A B) ⟨1, by
      simp only [Fintype.card_prod]
      have := Fintype.card_pos (α := F)
      nlinarith⟩ < (γ : ℝ) / 2 := by
  have hR : Nonempty R := Fintype.card_pos_iff.mp (by omega)
  let r := Classical.choice hR
  have hB : ∀ j, ∑ i, B j i = (γ : ℝ) := by
    intro j
    have h := hcol (Sum.inr (r, j))
    simpa [scalarFactorMatrix, Fintype.sum_prod_type] using h
  exact replicated_scalar_no_source_regime A B γ hr hγ hB

lemma eigs_det (H : Matrix m n ℝ) :
    ∏ i, eigs H i = (H * Hᵀ).det := by
  have h := (isHermitian_mul_conjTranspose_self H).det_eq_prod_eigenvalues
  simp only [conjTranspose_eq_transpose_of_trivial] at h
  rw [h]
  exact Fintype.prod_equiv
    (Fintype.equivOfCardEq (Fintype.card_fin (Fintype.card m)))
    (eigs H)
    (fun i : m => (isHermitian_mul_conjTranspose_self H).eigenvalues i)
    (fun i => by simp [eigs, Matrix.IsHermitian.eigenvalues])

/-- A dense four-column illustration; this is not an LDPC family. -/
def denseExample : Matrix (Fin 2) (Fin 4) ℝ := fun _ _ => 1

noncomputable def denseEigs : Fin 2 → ℝ := eigs denseExample

lemma denseExample_second : eigs denseExample ⟨1, by norm_num⟩ = 0 := by
  have ht : (∑ i : Fin 2, denseEigs i) = 8 := by
    change (∑ i, eigs denseExample i) = 8
    rw [eigs_trace]
    norm_num [denseExample, Matrix.trace, Matrix.diag, Matrix.mul_apply, Fin.sum_univ_succ]
  have hd : (∏ i : Fin 2, denseEigs i) = 0 := by
    change (∏ i, eigs denseExample i) = 0
    rw [eigs_det]
    norm_num [denseExample, Matrix.det_fin_two, Matrix.mul_apply, Fin.sum_univ_succ]
  rw [Fin.sum_univ_two] at ht
  rw [Fin.prod_univ_two] at hd
  have ho : denseEigs 1 ≤ denseEigs 0 :=
    eigs_antitone denseExample (show (0 : Fin 2) ≤ 1 by decide)
  change denseEigs 1 = 0
  rcases mul_eq_zero.mp hd with h | h
  · linarith
  · exact h

/-- A nonempty support is stopping exactly when no check has induced degree one. -/
def IsStopping {α : Type*} [One α] (M : Matrix m n α) (S : Finset n) : Prop := by
  classical
  exact S.Nonempty ∧ ∀ i, (S.filter (fun j => M i j = 1)).card ≠ 1

lemma denseExample_stopping (S : Finset (Fin 4)) :
    IsStopping denseExample S ↔ 2 ≤ S.card := by
  classical
  simp only [IsStopping, denseExample, eq_self_iff_true, Finset.filter_true, forall_const]
  constructor
  · rintro ⟨hS, h⟩
    have hp := Finset.card_pos.mpr hS
    omega
  · intro h
    exact ⟨Finset.card_pos.mp (by omega), by omega⟩

def denseExampleBinary : Matrix (Fin 2) (Fin 4) (ZMod 2) := fun _ _ => 1

lemma denseExample_css : denseExampleBinary * denseExampleBinaryᵀ = 0 := by
  ext i j
  norm_num [denseExampleBinary, Matrix.mul_apply, Fin.sum_univ_succ]
  decide

/-- The raw strict inequality and small-branch exclusion can occur, with only bound two. -/
theorem denseExample_source_certificate :
    eigs denseExample ⟨1, by norm_num⟩ < (2 : ℝ)/2 ∧
    (2:ℝ)/2 * (1 - Real.sqrt (1 - 2*eigs denseExample ⟨1, by norm_num⟩/2)) = 0 ∧
    (2:ℝ)/2 * (1 + Real.sqrt (1 - 2*eigs denseExample ⟨1, by norm_num⟩/2)) = 2 := by
  rw [denseExample_second]
  norm_num

/-- Source a+ with C = sigma₂² m² / gamma². -/
noncomputable def sourceLargeRoot (m γ s : ℝ) : ℝ :=
  (m + Real.sqrt (m^2 - 2*γ*(s*m^2/γ^2))) / γ

lemma sourceLargeRoot_eq (m γ s : ℝ) (hm : 0 ≤ m) (hg : 0 < γ) :
    sourceLargeRoot m γ s = (m/γ)*(1+Real.sqrt (1-2*s/γ)) := by
  have h : m^2 - 2*γ*(s*m^2/γ^2) = m^2*(1-2*s/γ) := by
    field_simp
  rw [sourceLargeRoot, h, Real.sqrt_mul (sq_nonneg m), Real.sqrt_sq hm]
  ring

/-- Source a- with the same C as Proposition 5.1. -/
noncomputable def sourceSmallRoot (m γ s : ℝ) : ℝ :=
  (m - Real.sqrt (m^2 - 2*γ*(s*m^2/γ^2))) / γ

lemma sourceSmallRoot_eq (m γ s : ℝ) (hm : 0 ≤ m) (hg : 0 < γ) :
    sourceSmallRoot m γ s = (m/γ)*(1-Real.sqrt (1-2*s/γ)) := by
  have h := sourceLargeRoot_eq m γ s hm hg
  dsimp [sourceLargeRoot] at h
  rw [add_div] at h
  dsimp [sourceSmallRoot]
  rw [sub_div]
  nlinarith

lemma one_row_roots (ell γ q s : ℝ) (he : 1 < ell) (hg : 0 < γ)
    (hgell : γ ≤ ell) (hq : 2 ≤ q) (hs : 0 ≤ s)
    (htrace : q * γ * (ell - γ) ≤ (ell - 1) * s)
    (hgap : s < γ/2) :
    1 < sourceLargeRoot ell γ s ∧ sourceLargeRoot ell γ s ≤ 2 ∧
    0 ≤ (ell/γ)*(1-Real.sqrt (1-2*s/γ)) ∧
      (ell/γ)*(1-Real.sqrt (1-2*s/γ)) < 2 := by
  rw [sourceLargeRoot_eq ell γ s (by linarith) hg]
  have hD : 0 < 1-2*s/γ := by
    apply sub_pos.mpr
    apply (div_lt_iff₀ hg).mpr
    nlinarith
  have hroot : 0 < Real.sqrt (1-2*s/γ) := Real.sqrt_pos.mpr hD
  have hfactor : 1 ≤ ell/γ := by apply (le_div_iff₀ hg).mpr; linarith
  have hfactor0 : 0 < ell/γ := by positivity
  have hsmallfactor : ell/γ < 2 := by
    apply (div_lt_iff₀ hg).mpr
    have hd := (one_row_density ell γ q s he hg hgell hq htrace hgap).2
    linarith
  have hrootle : Real.sqrt (1-2*s/γ) ≤ 1 := by
    apply Real.sqrt_le_iff.mpr
    constructor
    · norm_num
    · have hquot : 0 ≤ 2*s/γ := by positivity
      nlinarith
  refine ⟨?_, one_row_large_root_le_two ell γ q s he hg hgell hq hs htrace hgap, ?_, ?_⟩
  · nlinarith [mul_pos hfactor0 hroot]
  · exact mul_nonneg hfactor0.le (sub_nonneg.mpr hrootle)
  · nlinarith [mul_nonneg hfactor0.le hroot.le]

/-- Every positive-column-weight binary Tanner graph already has stopping distance at least 2. -/
lemma stopping_card_ge_two (H : Matrix m n ℝ) (γ : ℝ) (hg : 0 < γ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ)
    (S : Finset n) (hS : IsStopping H S) : 2 ≤ S.card := by
  classical
  obtain ⟨hSn, hst⟩ := hS
  have hpos := Finset.card_pos.mpr hSn
  by_contra h
  have hcard : S.card = 1 := by omega
  obtain ⟨j, hj⟩ := Finset.card_eq_one.mp hcard
  have hex : ∃ i, H i j = 1 := by
    by_contra! hn
    have hz : ∀ i, H i j = 0 := by
      intro i
      exact (hbin i j).resolve_right (hn i)
    have hc := hcol j
    simp [hz] at hc
    linarith
  obtain ⟨i, hi⟩ := hex
  have hs := hst i
  simp [hj, Finset.filter_singleton, hi] at hs

/-- Main non-improvement conclusion for one row block, with the exact source root.
Its lower bound holds before using the source spectral stopping inequality. -/
theorem one_row_stopping_bound_redundant {ell q : ℕ}
    (H : Matrix (Fin ell) (Fin q × Fin ell) ℝ) (γ k : ℝ)
    (hell : 2 ≤ ell) (hq : 2 ≤ q) (hg : 0 < γ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k)
    (hgap : eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩ < γ/2)
    (S : Finset (Fin q × Fin ell)) (hS : IsStopping H S) :
    sourceLargeRoot ell γ (eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩) ≤ 2 ∧
    2 ≤ S.card ∧
    sourceLargeRoot ell γ (eigs H ⟨1, by simp only [Fintype.card_fin]; omega⟩) ≤ (S.card : ℝ) := by
  have hb := (one_row_biregular_obstruction H γ k hell hq hg hbin hcol hrow hgap).2
  rw [← sourceLargeRoot_eq ell γ _ (by positivity) hg] at hb
  have hc := stopping_card_ge_two H γ hg hbin hcol S hS
  exact ⟨hb, hc, hb.trans (by exact_mod_cast hc)⟩

/-- Cardinality-based statement avoids any unstated flattening or relabeling of checks/variables. -/
theorem one_row_cardinal_obstruction (H : Matrix m n ℝ) (γ k : ℝ) (q : ℕ)
    (hm : 2 ≤ Fintype.card m) (hq : 2 ≤ q)
    (hsize : Fintype.card n = q * Fintype.card m) (hg : 0 < γ)
    (hbin : ∀ i j, H i j = 0 ∨ H i j = 1)
    (hcol : ∀ j, ∑ i, H i j = γ) (hrow : ∀ i, ∑ j, H i j = k)
    (hgap : eigs H ⟨1, by omega⟩ < γ/2) :
    (3*(Fintype.card m : ℝ)+1)/4 < γ ∧
    1 < sourceLargeRoot (Fintype.card m) γ (eigs H ⟨1, by omega⟩) ∧
    sourceLargeRoot (Fintype.card m) γ (eigs H ⟨1, by omega⟩) ≤ 2 ∧
    0 ≤ ((Fintype.card m : ℝ)/γ)*(1-Real.sqrt (1-2*eigs H ⟨1, by omega⟩/γ)) ∧
    ((Fintype.card m : ℝ)/γ)*(1-Real.sqrt (1-2*eigs H ⟨1, by omega⟩/γ)) < 2 := by
  have he : (1 : ℝ) < Fintype.card m := by exact_mod_cast (show 1 < Fintype.card m by omega)
  have hqr : (2 : ℝ) ≤ q := by exact_mod_cast hq
  have he0 : (0 : ℝ) < Fintype.card m := by linarith
  have hcount := regular_edge_count H γ k hcol hrow
  rw [hsize, Nat.cast_mul] at hcount
  have hk : k = (q : ℝ)*γ := by nlinarith
  have hn : Nonempty n := Fintype.card_pos_iff.mp (by
    rw [hsize]; have : 0 < q := by omega
    exact Nat.mul_pos this (by omega))
  have hγell : γ ≤ Fintype.card m := by
    have h := binary_column_sum_le_card H hbin (Classical.choice hn)
    rwa [hcol] at h
  have ht := regular_trace_obstruction H γ k hm hbin hcol hrow
  rw [hk] at ht
  have hs : 0 ≤ eigs H ⟨1, by omega⟩ := by
    rw [← energy_basis H ⟨1, by omega⟩]
    exact Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  exact ⟨(one_row_density _ γ q _ he hg hγell hqr ht hgap).2,
    one_row_roots _ γ q _ he hg hγell hqr hs ht hgap⟩

/-- The exact unflattened source matrix with r₁=1 and n₁≥1: its surviving regime is
strictly dense, its source large root is in (1,2], and every nonempty stopping set
is already on the large branch by the elementary singleton obstruction. -/
theorem scalar_one_row_source_obstruction
    {C F : Type*} [Fintype C] [DecidableEq C] [Nonempty C]
    [Fintype F] [DecidableEq F]
    (A : Matrix (Fin 1 × F) (C × F) ℝ) (B : Matrix F F ℝ) (γ k : ℝ)
    (hF : 2 ≤ Fintype.card F) (hg : 0 < γ)
    (hbin : ∀ i j, scalarFactorMatrix A B i j = 0 ∨ scalarFactorMatrix A B i j = 1)
    (hcol : ∀ j, ∑ i, scalarFactorMatrix A B i j = γ)
    (hrow : ∀ i, ∑ j, scalarFactorMatrix A B i j = k)
    (hgap : eigs (scalarFactorMatrix A B) ⟨1, by simp only [Fintype.card_prod, Fintype.card_fin, one_mul]; omega⟩ < γ/2) :
    let s := eigs (scalarFactorMatrix A B) ⟨1, by simp only [Fintype.card_prod, Fintype.card_fin, one_mul]; omega⟩
    (3*(Fintype.card F : ℝ)+1)/4 < γ ∧
    1 < sourceLargeRoot (Fintype.card F) γ s ∧
    sourceLargeRoot (Fintype.card F) γ s ≤ 2 ∧
    ∀ S, IsStopping (scalarFactorMatrix A B) S →
      2 ≤ S.card ∧
      sourceSmallRoot (Fintype.card F) γ s < (S.card : ℝ) ∧
      sourceLargeRoot (Fintype.card F) γ s ≤ (S.card : ℝ) := by
  dsimp only
  have hsize : Fintype.card ((C × F) ⊕ (Fin 1 × F)) =
      (Fintype.card C + 1) * Fintype.card (Fin 1 × F) := by
    simp [Fintype.card_sum, Fintype.card_prod, Nat.add_mul]
  have hh := one_row_cardinal_obstruction (scalarFactorMatrix A B) γ k
    (Fintype.card C+1) (by simp only [Fintype.card_prod, Fintype.card_fin, one_mul]; omega)
    (by have := Fintype.card_pos (α := C); omega) hsize hg hbin hcol hrow hgap
  simp only [Fintype.card_prod, Fintype.card_fin, one_mul] at hh
  refine ⟨hh.1, hh.2.1, hh.2.2.1, ?_⟩
  intro S hS
  have hc := stopping_card_ge_two (scalarFactorMatrix A B) γ hg hbin hcol S hS
  have hcr : (2 : ℝ) ≤ S.card := by exact_mod_cast hc
  rw [sourceSmallRoot_eq _ γ _ (by positivity) hg]
  exact ⟨hc, hh.2.2.2.2.trans_le hcr, hh.2.2.1.trans hcr⟩

section Circulant
variable {G : Type*} [Fintype G] [DecidableEq G] [AddCommGroup G]

/-- Binary cyclic-lift incidence matrix, interpreted over the reals for its spectrum. -/
def supportCirculant (S : Finset G) : Matrix G G ℝ :=
  fun i j => if i-j ∈ S then 1 else 0

lemma supportCirculant_row_sum (S : Finset G) (i : G) :
    (∑ j, supportCirculant S i j) = (S.card : ℝ) := by
  let e : G ≃ G :=
    { toFun := fun j => i-j
      invFun := fun j => i-j
      left_inv := by intro j; simp
      right_inv := by intro j; simp }
  calc
    _ = ∑ j : G, if j ∈ S then (1 : ℝ) else 0 := by
      exact Fintype.sum_equiv e _ _ (fun _ => rfl)
    _ = _ := by simp

end Circulant

/-- The scalar polynomial of the running 882-qubit source example alone forces σ₂²≥9.
This consumer works for every first block, including the displayed 7×7 monomial base. -/
theorem running_882_scalar_obstruction
    (A : Matrix (Fin 7 × ZMod 63) (Fin 7 × ZMod 63) ℝ) :
    (9 : ℝ) ≤ eigs (scalarFactorMatrix A
      (supportCirculant ({0, 1, 6} : Finset (ZMod 63)))) ⟨1, by norm_num⟩ := by
  have hc : ({0, 1, 6} : Finset (ZMod 63)).card = 3 := by decide
  have h := replicated_scalar_second_lower A
    (supportCirculant ({0, 1, 6} : Finset (ZMod 63))) (3 : ℝ) (by norm_num)
    (fun j => by rw [supportCirculant_row_sum, hc]; norm_num)
  norm_num at h
  exact h

lemma denseExample_minimum :
    IsStopping denseExample ({0, 1} : Finset (Fin 4)) ∧
    ∀ S, IsStopping denseExample S → 2 ≤ S.card := by
  constructor
  · rw [denseExample_stopping]; decide
  · intro S hS; exact (denseExample_stopping S).mp hS

end StoppingSpectral

