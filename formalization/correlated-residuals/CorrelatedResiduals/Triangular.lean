/-
Uniqueness of the unit upper-triangular factorization with positive diagonal,
and the induced identification of every recursive pattern.

Mathlib's `LDL.lower` is an existence construction, and lower-triangularity of
that factor is a TODO in `Mathlib.LinearAlgebra.Matrix.LDL`. It is not used
here. The argument is induction on the last column: the last diagonal entry is
the pivot, the last column of `L` is that column of the Gram matrix divided by
the pivot, and the leading principal block differs from the smaller
factorization by a common rank-one update.
-/

import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Real.StarOrdered
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.PosDef

open Matrix Finset

namespace CorrelatedResiduals

/-- Unit upper-triangular: zero strictly below the diagonal, ones on it. -/
def UnitUpper {n : ℕ} (L : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  (∀ i j, j < i → L i j = 0) ∧ ∀ i, L i i = 1

/-- Strictly upper-triangular structural matrix of a recursive pattern. -/
def StrictUpper {n : ℕ} (B : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  ∀ i j, j ≤ i → B i j = 0

def lead {n : ℕ} (L : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  L.submatrix Fin.castSucc Fin.castSucc

lemma gram_entry {n : ℕ} (L : Matrix (Fin n) (Fin n) ℝ) (d : Fin n → ℝ) (i j : Fin n) :
    (L * diagonal d * Lᵀ) i j = ∑ k, L i k * d k * L j k := by
  rw [mul_apply]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [mul_diagonal, transpose_apply]

lemma gram_last {n : ℕ} {L : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ} {d : Fin (n + 1) → ℝ}
    (hL : UnitUpper L) (i : Fin (n + 1)) :
    (L * diagonal d * Lᵀ) i (Fin.last n) = L i (Fin.last n) * d (Fin.last n) := by
  rw [gram_entry, Fin.sum_univ_castSucc]
  have hzero :
      ∑ k : Fin n, L i k.castSucc * d k.castSucc * L (Fin.last n) k.castSucc = 0 := by
    refine Finset.sum_eq_zero fun k _ => ?_
    rw [hL.1 (Fin.last n) k.castSucc k.castSucc_lt_last]
    ring
  rw [hzero, hL.2 (Fin.last n)]
  ring

lemma lead_unitUpper {n : ℕ} {L : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ}
    (hL : UnitUpper L) : UnitUpper (lead L) := by
  constructor
  · intro i j hij
    exact hL.1 i.castSucc j.castSucc (Fin.castSucc_lt_castSucc_iff.mpr hij)
  · intro i
    exact hL.2 i.castSucc

lemma lead_gram {n : ℕ} {L : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ} {d : Fin (n + 1) → ℝ}
    (i j : Fin n) :
    (L * diagonal d * Lᵀ) i.castSucc j.castSucc =
      (lead L * diagonal (fun k : Fin n => d k.castSucc) * (lead L)ᵀ) i j +
        L i.castSucc (Fin.last n) * d (Fin.last n) * L j.castSucc (Fin.last n) := by
  rw [gram_entry, Fin.sum_univ_castSucc, gram_entry]
  simp [lead, submatrix_apply]

/-- Two unit upper-triangular positive-diagonal factorizations of one Gram matrix agree. -/
theorem unitUpper_factor_unique {n : ℕ}
    {L M : Matrix (Fin n) (Fin n) ℝ} {d e : Fin n → ℝ}
    (hL : UnitUpper L) (hM : UnitUpper M)
    (hd : ∀ i, 0 < d i) (he : ∀ i, 0 < e i)
    (hΩ : L * diagonal d * Lᵀ = M * diagonal e * Mᵀ) :
    L = M ∧ d = e := by
  induction n with
  | zero =>
    constructor
    · ext i j
      exact i.elim0
    · ext i
      exact i.elim0
  | succ n ih =>
    have hde_last : d (Fin.last n) = e (Fin.last n) := by
      have hLlast := gram_last (d := d) hL (Fin.last n)
      have hMlast := gram_last (d := e) hM (Fin.last n)
      rw [hL.2] at hLlast
      rw [hM.2] at hMlast
      have hentry := congr_fun (congr_fun hΩ (Fin.last n)) (Fin.last n)
      rw [hLlast, hMlast] at hentry
      simpa using hentry
    have hcol : ∀ i, L i (Fin.last n) = M i (Fin.last n) := by
      intro i
      have hLi := gram_last (d := d) hL i
      have hMi := gram_last (d := e) hM i
      have hentry := congr_fun (congr_fun hΩ i) (Fin.last n)
      rw [hLi, hMi, hde_last] at hentry
      exact mul_right_cancel₀ (he (Fin.last n)).ne' hentry
    have hlead :
        lead L * diagonal (fun k : Fin n => d k.castSucc) * (lead L)ᵀ =
          lead M * diagonal (fun k : Fin n => e k.castSucc) * (lead M)ᵀ := by
      ext i j
      have hLij := lead_gram (L := L) (d := d) i j
      have hMij := lead_gram (L := M) (d := e) i j
      have hentry := congr_fun (congr_fun hΩ i.castSucc) j.castSucc
      rw [hLij, hMij] at hentry
      have hr :
          L i.castSucc (Fin.last n) * d (Fin.last n) * L j.castSucc (Fin.last n) =
            M i.castSucc (Fin.last n) * e (Fin.last n) * M j.castSucc (Fin.last n) := by
        rw [hcol, hcol, hde_last]
      rw [hr] at hentry
      exact add_right_cancel hentry
    have hrec :=
      ih (lead_unitUpper hL) (lead_unitUpper hM) (fun i => hd i.castSucc)
        (fun i => he i.castSucc) hlead
    refine ⟨?_, ?_⟩
    · ext i j
      cases i using Fin.lastCases with
      | last =>
        cases j using Fin.lastCases with
        | last =>
          rw [hL.2, hM.2]
        | cast j =>
          rw [hL.1 _ _ j.castSucc_lt_last, hM.1 _ _ j.castSucc_lt_last]
      | cast i =>
        cases j using Fin.lastCases with
        | last =>
          exact hcol i.castSucc
        | cast j =>
          have hlead_ij := congr_fun (congr_fun hrec.1 i) j
          simpa [lead, submatrix_apply] using hlead_ij
    · ext i
      cases i using Fin.lastCases with
      | last => exact hde_last
      | cast i =>
        have := congr_fun hrec.2 i
        simpa using this

lemma one_sub_unitUpper {n : ℕ} {B : Matrix (Fin n) (Fin n) ℝ} (hB : StrictUpper B) :
    UnitUpper (1 - B) := by
  constructor
  · intro i j hij
    have hB0 : B i j = 0 := hB i j hij.le
    simp [Matrix.sub_apply, hB0, hij.ne.symm]
  · intro i
    have hB0 : B i i = 0 := hB i i le_rfl
    simp [Matrix.sub_apply, hB0]

lemma det_one_sub {n : ℕ} {B : Matrix (Fin n) (Fin n) ℝ} (hB : StrictUpper B) :
    (1 - B).det = 1 := by
  have hU : UnitUpper (1 - B) := one_sub_unitUpper hB
  have htri : (1 - B).BlockTriangular id := fun i j hij => hU.1 i j hij
  rw [det_of_upperTriangular htri]
  refine Finset.prod_eq_one fun i _ => ?_
  exact hU.2 i

noncomputable def invertible_one_sub {n : ℕ} {B : Matrix (Fin n) (Fin n) ℝ}
    (hB : StrictUpper B) : Invertible (1 - B) :=
  IsUnit.invertible <| (isUnit_iff_isUnit_det (1 - B)).2 <| by
    rw [det_one_sub hB]
    exact isUnit_one

lemma inv_diag_one {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} (hA : UnitUpper A) [Invertible A]
    (i : Fin n) : A⁻¹ i i = 1 := by
  have htri : A.BlockTriangular id := fun a b hab => hA.1 a b hab
  have hinvtri : A⁻¹.BlockTriangular id := blockTriangular_inv_of_blockTriangular htri
  have hmul : (A⁻¹ * A) i i = 1 := by
    rw [inv_mul_of_invertible]
    simp
  rw [Matrix.mul_apply, Finset.sum_eq_single i] at hmul
  · rw [hA.2 i] at hmul
    simpa using hmul
  · intro k _ hk
    rcases lt_trichotomy k i with hlt | heq | hgt
    · have hzero : A⁻¹ i k = 0 := hinvtri hlt
      simp [hzero]
    · exact (hk heq).elim
    · have hzero : A k i = 0 := htri (i := k) (j := i) hgt
      simp [hzero]
  · intro hi
    exact (hi (Finset.mem_univ i)).elim

lemma inv_one_sub_unitUpper {n : ℕ} {B : Matrix (Fin n) (Fin n) ℝ} (hB : StrictUpper B) :
    UnitUpper (1 - B)⁻¹ := by
  haveI := invertible_one_sub hB
  have hU : UnitUpper (1 - B) := one_sub_unitUpper hB
  have htri : (1 - B).BlockTriangular id := fun i j hij => hU.1 i j hij
  have hinvtri : (1 - B)⁻¹.BlockTriangular id := blockTriangular_inv_of_blockTriangular htri
  constructor
  · intro i j hij
    exact hinvtri hij
  · intro i
    exact inv_diag_one hU i

/-- Every recursive pattern with positive diagonal residuals is identified by `L Ψ Lᵀ`. -/
theorem recursive_residual_unique {n : ℕ}
    {B C : Matrix (Fin n) (Fin n) ℝ} {d e : Fin n → ℝ}
    (hB : StrictUpper B) (hC : StrictUpper C)
    (hd : ∀ i, 0 < d i) (he : ∀ i, 0 < e i)
    (h :
      (1 - B)⁻¹ * diagonal d * ((1 - B)⁻¹)ᵀ =
        (1 - C)⁻¹ * diagonal e * ((1 - C)⁻¹)ᵀ) :
    B = C ∧ d = e := by
  haveI := invertible_one_sub hB
  haveI := invertible_one_sub hC
  obtain ⟨hL, hde⟩ :=
    unitUpper_factor_unique (inv_one_sub_unitUpper hB) (inv_one_sub_unitUpper hC) hd he h
  refine ⟨?_, hde⟩
  have hsub : 1 - B = 1 - C := by
    have hInv : ((1 - B)⁻¹)⁻¹ = ((1 - C)⁻¹)⁻¹ := congrArg Inv.inv hL
    simpa [inv_inv_of_invertible] using hInv
  ext i j
  have hentry := congr_fun (congr_fun hsub i) j
  rw [Matrix.sub_apply, Matrix.sub_apply, sub_eq_add_neg, sub_eq_add_neg] at hentry
  exact neg_inj.mp (add_left_cancel hentry)

/-- Joint blocks of a recursive pattern. `p` is the covariate dimension. -/
@[ext]
structure Joint (n p : ℕ) where
  yy : Matrix (Fin n) (Fin n) ℝ
  yx : Matrix (Fin n) (Fin p) ℝ
  xx : Matrix (Fin p) (Fin p) ℝ

/-- A recursive pattern: strictly upper `B`, positive diagonal residuals, rectangular `Γ`, and `Φ`. -/
@[ext]
structure RecModel (n p : ℕ) where
  B : Matrix (Fin n) (Fin n) ℝ
  d : Fin n → ℝ
  gamma : Matrix (Fin n) (Fin p) ℝ
  phi : Matrix (Fin p) (Fin p) ℝ

def OnRec {n p : ℕ} (θ : RecModel n p) : Prop :=
  StrictUpper θ.B ∧ (∀ i, 0 < θ.d i) ∧ θ.phi.PosDef

noncomputable def sigmaRec {n p : ℕ} (θ : RecModel n p) : Joint n p :=
  let L := (1 - θ.B)⁻¹
  { yy := L * (θ.gamma * θ.phi * θ.gammaᵀ + diagonal θ.d) * Lᵀ
    yx := L * θ.gamma * θ.phi
    xx := θ.phi }

/-- Cancelling a positive-definite exogenous block leaves the residual Gram matrix. -/
lemma schur_noise_rect {n p : ℕ}
    {L : Matrix (Fin n) (Fin n) ℝ} {G : Matrix (Fin n) (Fin p) ℝ}
    {Φ : Matrix (Fin p) (Fin p) ℝ} {N : Matrix (Fin n) (Fin n) ℝ} (hΦ : Φ.PosDef) :
    L * (G * Φ * Gᵀ + N) * Lᵀ - (L * G * Φ) * Φ⁻¹ * (L * G * Φ)ᵀ = L * N * Lᵀ := by
  have hdet : IsUnit Φ.det := (isUnit_iff_isUnit_det Φ).1 hΦ.isUnit
  have hsym : Φᵀ = Φ := by
    simpa [conjTranspose_eq_transpose_of_trivial] using hΦ.isHermitian.eq
  have hdist :
      L * (G * Φ * Gᵀ + N) * Lᵀ = L * (G * Φ * Gᵀ) * Lᵀ + L * N * Lᵀ := by
    rw [Matrix.mul_add, Matrix.add_mul]
  rw [hdist]
  have hyx : (L * G * Φ)ᵀ = Φᵀ * (Gᵀ * Lᵀ) := by
    rw [Matrix.transpose_mul, Matrix.transpose_mul]
  rw [hyx, hsym]
  have hcancel :
      (L * G * Φ) * Φ⁻¹ * (Φ * (Gᵀ * Lᵀ)) = L * (G * (Φ * Gᵀ)) * Lᵀ := by
    rw [Matrix.mul_assoc (L * G * Φ) Φ⁻¹ (Φ * (Gᵀ * Lᵀ))]
    rw [Matrix.mul_assoc (L * G) Φ (Φ⁻¹ * (Φ * (Gᵀ * Lᵀ)))]
    rw [← Matrix.mul_assoc Φ Φ⁻¹ (Φ * (Gᵀ * Lᵀ))]
    rw [mul_nonsing_inv Φ hdet]
    rw [Matrix.one_mul]
    rw [← Matrix.mul_assoc Φ Gᵀ Lᵀ]
    rw [← Matrix.mul_assoc (L * G) (Φ * Gᵀ) Lᵀ]
    rw [Matrix.mul_assoc L G (Φ * Gᵀ)]
  have hblock : G * (Φ * Gᵀ) = G * Φ * Gᵀ := by
    rw [← Matrix.mul_assoc G Φ Gᵀ]
  rw [hcancel, hblock, add_sub_cancel_left]

lemma schur_sigmaRec {n p : ℕ} (θ : RecModel n p) (hΦ : θ.phi.PosDef) :
    (sigmaRec θ).yy - (sigmaRec θ).yx * (sigmaRec θ).xx⁻¹ * (sigmaRec θ).yxᵀ =
      (1 - θ.B)⁻¹ * diagonal θ.d * ((1 - θ.B)⁻¹)ᵀ := by
  simpa [sigmaRec] using
    schur_noise_rect (L := (1 - θ.B)⁻¹) (G := θ.gamma) (Φ := θ.phi)
      (N := diagonal θ.d) hΦ

/-- `Φ` is the exogenous block, and `Γ = (I - B) Σ_yx Φ⁻¹`. -/
theorem recover_exogenous {n p : ℕ} (θ : RecModel n p) (h : OnRec θ) :
    θ.phi = (sigmaRec θ).xx ∧
      θ.gamma = (1 - θ.B) * (sigmaRec θ).yx * (sigmaRec θ).xx⁻¹ := by
  obtain ⟨hB, _, hΦ⟩ := h
  haveI := invertible_one_sub hB
  have hdet : IsUnit θ.phi.det := (isUnit_iff_isUnit_det θ.phi).1 hΦ.isUnit
  refine ⟨rfl, ?_⟩
  simp only [sigmaRec]
  have hleft : (1 - θ.B) * (1 - θ.B)⁻¹ = (1 : Matrix (Fin n) (Fin n) ℝ) :=
    mul_inv_of_invertible (1 - θ.B)
  have hright : θ.phi * θ.phi⁻¹ = (1 : Matrix (Fin p) (Fin p) ℝ) :=
    mul_nonsing_inv _ hdet
  conv_rhs =>
    rw [Matrix.mul_assoc (1 - θ.B)⁻¹ θ.gamma θ.phi]
    rw [← Matrix.mul_assoc (1 - θ.B) (1 - θ.B)⁻¹ (θ.gamma * θ.phi)]
    rw [hleft]
    rw [Matrix.one_mul]
    rw [Matrix.mul_assoc θ.gamma θ.phi θ.phi⁻¹]
    rw [hright]
    rw [Matrix.mul_one]

/-- The joint covariance determines `(B, Ψ, Γ, Φ)` for every recursive pattern. -/
theorem sigmaRec_injective {n p : ℕ} {θ θ' : RecModel n p}
    (hθ : OnRec θ) (hθ' : OnRec θ') (h : sigmaRec θ = sigmaRec θ') : θ = θ' := by
  have hθ0 := hθ
  have hθ'0 := hθ'
  obtain ⟨hB, hd, hΦ⟩ := hθ
  obtain ⟨hC, he, hΦ'⟩ := hθ'
  have hgram :
      (1 - θ.B)⁻¹ * diagonal θ.d * ((1 - θ.B)⁻¹)ᵀ =
        (1 - θ'.B)⁻¹ * diagonal θ'.d * ((1 - θ'.B)⁻¹)ᵀ := by
    have hθs := schur_sigmaRec θ hΦ
    have hθs' := schur_sigmaRec θ' hΦ'
    rw [h] at hθs
    exact hθs.symm.trans hθs'
  obtain ⟨hBeq, hdeq⟩ := recursive_residual_unique hB hC hd he hgram
  have hγ : θ.gamma = θ'.gamma := by
    have hg := (recover_exogenous θ hθ0).2
    have hg' := (recover_exogenous θ' hθ'0).2
    rw [hg, hg', h, hBeq]
  have hφ : θ.phi = θ'.phi := by simpa [sigmaRec] using congrArg Joint.xx h
  exact RecModel.ext hBeq hdeq hγ hφ

end CorrelatedResiduals
