/-
C16Frames: Lean versions of the written proofs in
  formalization/canonical-width/c16/paper/symmetric-frames.tex

  * `gram_one_iff_sum_outer` / `frame_of_perm_block` — Proposition (reduction), frame direction:
    a permutation (identity) Gram block gives dual bases, i.e. Σ xᵢ zᵢᵀ = I.
  * `induced_matching_le_rank`, `induced_matching_le_dim` — Proposition (reduction), size bound:
    an induced matching has at most rank G ≤ n pairs.
  * `IsFrame`, `IsFrame.map`, `IsFrame.swap`, `fixed_*` — Lemma (symmetry classes).
  * `exists_pair_of_residual_entry`, `first_member_unique` — Lemma (branching).
  * `remaining_card_le_finrank` — Lemma (rank pruning).
The exhaustive computations of the paper are not formalized here.
-/
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.Data.ZMod.Basic

open Matrix

namespace C16Frames

section Reduction
variable {K : Type*} [Field K]

/-- Rows `X i`, `Z i` with Gram matrix `X Zᵀ = 1` are dual bases: `Σᵢ xᵢ zᵢᵀ = Xᵀ Z = 1`. -/
theorem gram_one_iff_sum_outer {n : ℕ} (X Z : Matrix (Fin n) (Fin n) K) :
    X * Zᵀ = 1 ↔ Xᵀ * Z = 1 := by
  constructor
  · intro h
    have h2 : Zᵀ * X = 1 := mul_eq_one_comm.mp h
    simpa [Matrix.transpose_mul] using congrArg Matrix.transpose h2
  · intro h
    have h2 : Zᵀ * X = 1 := by simpa [Matrix.transpose_mul] using congrArg Matrix.transpose h
    exact mul_eq_one_comm.mp h2

/-- If the Gram block of the chosen rows is a permutation matrix, re-pairing the `Z` rows by the
permutation gives an identity Gram block (and hence a canonical frame by the previous lemma). -/
theorem frame_of_perm_block {n : ℕ} (X Z : Matrix (Fin n) (Fin n) K) (σ : Equiv.Perm (Fin n))
    (h : ∀ a b, (X * Zᵀ) a b = if σ a = b then 1 else 0) :
    X * (Z.submatrix σ id)ᵀ = 1 := by
  ext a b
  have := h a (σ b)
  simp only [Matrix.mul_apply, Matrix.transpose_apply, Matrix.submatrix_apply, id] at this ⊢
  rw [this, Matrix.one_apply]
  simp [σ.injective.eq_iff]

/-- An induced matching of size `m` (an `m × m` identity submatrix of `G`) has `m ≤ rank G`. -/
theorem induced_matching_le_rank {m p q : ℕ} (G : Matrix (Fin p) (Fin q) K)
    (S : Fin m → Fin p) (T : Fin m → Fin q) (h : G.submatrix S T = 1) : m ≤ G.rank := by
  let Rs : Matrix (Fin m) (Fin p) K := Matrix.of fun a i => if S a = i then 1 else 0
  let Ct : Matrix (Fin q) (Fin m) K := Matrix.of fun j b => if T b = j then 1 else 0
  have hsub : Rs * G * Ct = G.submatrix S T := by
    ext a b
    simp only [Rs, Ct, Matrix.mul_apply, Matrix.of_apply, Matrix.submatrix_apply, ite_mul, one_mul,
      zero_mul, mul_ite, mul_one, mul_zero, Finset.sum_ite_eq, Finset.mem_univ, ite_true]
  have h1 : (Rs * G * Ct).rank ≤ G.rank :=
    (Matrix.rank_mul_le_left _ _).trans (Matrix.rank_mul_le_right _ _)
  rw [hsub, h, Matrix.rank_one, Fintype.card_fin] at h1
  exact h1

/-- For `G = X Zᵀ` with vectors in `Kⁿ`, an induced matching has at most `n` pairs. -/
theorem induced_matching_le_dim {m p q n : ℕ} (X : Matrix (Fin p) (Fin n) K)
    (Z : Matrix (Fin q) (Fin n) K) (S : Fin m → Fin p) (T : Fin m → Fin q)
    (h : (X * Zᵀ).submatrix S T = 1) : m ≤ n := by
  have := induced_matching_le_rank (X * Zᵀ) S T h
  have h2 : (X * Zᵀ).rank ≤ n :=
    (Matrix.rank_mul_le_left _ _).trans (by simpa using Matrix.rank_le_width X)
  omega

end Reduction

section Classes
/-! Frames as vertex sets in the anticommutation graph, and the three involution classes. -/
variable {ι K : Type*} [Zero K]

/-- `(S, T)` carries a frame of size `k`: every chosen X index has exactly one chosen Z
neighbour and every chosen Z index exactly one chosen X neighbour. The matching is determined by
the vertex sets (it is the `∃!` witness). -/
def IsFrame (G : ι → ι → K) (S T : Finset ι) (k : ℕ) : Prop :=
  S.card = k ∧ (∀ i ∈ S, ∃! j, j ∈ T ∧ G i j ≠ 0) ∧ (∀ j ∈ T, ∃! i, i ∈ S ∧ G i j ≠ 0)

/-- A symmetry `(π, π')` of `G` maps frames to frames. -/
theorem IsFrame.map {G : ι → ι → K} {S T : Finset ι} {k : ℕ} (π π' : ι ≃ ι)
    (hG : ∀ i j, G (π i) (π' j) = G i j) (hF : IsFrame G S T k) :
    IsFrame G (S.map π.toEmbedding) (T.map π'.toEmbedding) k := by
  obtain ⟨hc, hS, hT⟩ := hF
  refine ⟨by simpa using hc, ?_, ?_⟩
  · intro i hi
    obtain ⟨i0, hi0, rfl⟩ := Finset.mem_map.mp hi
    obtain ⟨j0, ⟨hj0, hg⟩, hu⟩ := hS i0 hi0
    refine ⟨π' j0, ⟨Finset.mem_map_of_mem _ hj0, by simpa [hG] using hg⟩, ?_⟩
    intro j ⟨hj, hgj⟩
    obtain ⟨j1, hj1, rfl⟩ := Finset.mem_map.mp hj
    have : j1 = j0 := hu j1 ⟨hj1, by simpa [hG] using hgj⟩
    simp [this]
  · intro j hj
    obtain ⟨j0, hj0, rfl⟩ := Finset.mem_map.mp hj
    obtain ⟨i0, ⟨hi0, hg⟩, hu⟩ := hT j0 hj0
    refine ⟨π i0, ⟨Finset.mem_map_of_mem _ hi0, by simpa [hG] using hg⟩, ?_⟩
    intro i ⟨hi, hgi⟩
    obtain ⟨i1, hi1, rfl⟩ := Finset.mem_map.mp hi
    have : i1 = i0 := hu i1 ⟨hi1, by simpa [hG] using hgi⟩
    simp [this]

/-- When `G` is symmetric, exchanging the two sides maps a frame on `(S, T)` to one on `(T, S)`. -/
theorem IsFrame.swap {G : ι → ι → K} {S T : Finset ι} {k : ℕ} (hsym : ∀ i j, G i j = G j i)
    (hF : IsFrame G S T k) (hcard : T.card = k) : IsFrame G T S k := by
  obtain ⟨_, hS, hT⟩ := hF
  refine ⟨hcard, ?_, ?_⟩
  · intro i hi
    simpa [hsym] using hT i hi
  · intro j hj
    simpa [hsym] using hS j hj

/-- Lemma (classes), (ii): the swap `s` sends the vertex-set pair `(S, T)` to `(T, S)`, so a frame
is `s`-fixed iff `S = T`. -/
theorem fixed_swap_iff (S T : Finset ι) : ((T, S) = (S, T)) ↔ S = T := by
  constructor
  · intro h; exact (Prod.mk.inj h).2
  · intro h; subst h; rfl

/-- Lemma (classes), (i): `T⁸` acts by an involution `τ` on both sides. -/
theorem fixed_half_iff (τ : ι ≃ ι) (S T : Finset ι) :
    ((S.map τ.toEmbedding, T.map τ.toEmbedding) = (S, T)) ↔
      S.map τ.toEmbedding = S ∧ T.map τ.toEmbedding = T := Prod.mk.injEq _ _ _ _ ▸ Iff.rfl

/-- Lemma (classes), (iii): `s T⁸` sends `(S, T)` to `(τ T, τ S)`; for an involution `τ` it is
fixed iff `T = τ S`. -/
theorem fixed_swapHalf_iff (τ : ι ≃ ι) (hτ : ∀ i, τ (τ i) = i) (S T : Finset ι) :
    ((T.map τ.toEmbedding, S.map τ.toEmbedding) = (S, T)) ↔ T = S.map τ.toEmbedding := by
  have hinv : ∀ U : Finset ι, (U.map τ.toEmbedding).map τ.toEmbedding = U := by
    intro U
    rw [Finset.map_map]
    have : τ.toEmbedding.trans τ.toEmbedding = Function.Embedding.refl ι := by
      ext i; simp [hτ]
    rw [this, Finset.map_refl]
  constructor
  · intro h; exact ((Prod.mk.inj h).2).symm
  · intro h
    subst h
    simp [hinv]

end Classes

section Search

/-- Every nonzero element of `ZMod 2` is `1`. -/
theorem zmod2_eq_one_of_ne_zero (a : ZMod 2) (h : a ≠ 0) : a = 1 := by
  fin_cases a
  · exact absurd rfl h
  · rfl

/-- Lemma (branching): if the residual entry `R c k = Σ_{p ∈ F} x_p(c) z_p(k)` over the
remaining frame pairs `F` is `1`, some remaining pair has `x_p(c) = z_p(k) = 1`. -/
theorem exists_pair_of_residual_entry {α n : Type*} (F : Finset α) (x z : α → n → ZMod 2)
    (c k : n) (h : ∑ p ∈ F, x p c * z p k = 1) : ∃ p ∈ F, x p c = 1 ∧ z p k = 1 := by
  obtain ⟨p, hp, hne⟩ := Finset.exists_ne_zero_of_sum_ne_zero (by rw [h]; decide)
  refine ⟨p, hp, ?_, ?_⟩
  · exact zmod2_eq_one_of_ne_zero _ (left_ne_zero_of_mul hne)
  · exact zmod2_eq_one_of_ne_zero _ (right_ne_zero_of_mul hne)

/-- Lemma (branching), sibling exclusion: if the children `L 0, …, L (r-1)` are tried in order
and the `u`-th subtree excludes the earlier children, a completion `A` that contains some child is
visited in exactly one subtree, namely that of the first child it contains. -/
theorem first_member_unique {α : Type*} {r : ℕ} (L : Fin r → α) (A : Set α)
    (h : ∃ u, L u ∈ A) : ∃! u, L u ∈ A ∧ ∀ v, v < u → L v ∉ A := by
  classical
  let P : ℕ → Prop := fun t => ∃ hu : t < r, L ⟨t, hu⟩ ∈ A
  have hex : ∃ t, P t := by obtain ⟨u, hu⟩ := h; exact ⟨u, u.2, hu⟩
  let t := Nat.find hex
  obtain ⟨ht, hA⟩ := Nat.find_spec hex
  refine ⟨⟨t, ht⟩, ⟨hA, ?_⟩, ?_⟩
  · intro v hv hvA
    exact Nat.find_min hex (show v.1 < t from hv) ⟨v.2, hvA⟩
  · rintro w ⟨hwA, hwmin⟩
    apply Fin.ext
    apply le_antisymm
    · by_contra hlt
      exact hwmin ⟨t, ht⟩ (not_le.mp hlt) hA
    · exact Nat.find_min' hex ⟨w.2, hwA⟩

/-- Lemma (rank pruning): in a frame with Gram matrix `X Zᵀ = 1` on `Kⁿ`, the rows outside the
chosen set `P` are linearly independent; so any pool set `X'` containing them spans at least
`n - |P|` dimensions. -/
theorem remaining_card_le_finrank {K : Type*} [Field K] {n : ℕ} (X Z : Matrix (Fin n) (Fin n) K)
    (h : X * Zᵀ = 1) (P : Finset (Fin n)) (X' : Set (Fin n → K))
    (hX' : ∀ i, i ∉ P → X i ∈ X') :
    n - P.card ≤ Module.finrank K (Submodule.span K X') := by
  have hdet : X.det ≠ 0 := by
    have : X.det * Zᵀ.det = 1 := by rw [← Matrix.det_mul, h, Matrix.det_one]
    exact left_ne_zero_of_mul_eq_one this
  have hli : LinearIndependent K (fun i => X i) :=
    Matrix.linearIndependent_rows_of_det_ne_zero hdet
  let Q := {i : Fin n // i ∉ P}
  have hliQ : LinearIndependent K (fun q : Q => X q.1) := hli.comp _ Subtype.val_injective
  have hspan : Submodule.span K (Set.range fun q : Q => X q.1) ≤ Submodule.span K X' := by
    apply Submodule.span_mono
    rintro _ ⟨q, rfl⟩
    exact hX' q.1 q.2
  have hcard : Fintype.card Q = n - P.card := by
    simp [Q, Fintype.card_subtype_compl, Fintype.card_fin]
  rw [← hcard, ← finrank_span_eq_card hliQ]
  exact Submodule.finrank_mono hspan

end Search

end C16Frames
