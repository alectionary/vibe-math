module

public import DyadicRank.Enumeration
public import Mathlib.LinearAlgebra.Matrix.Rank
public import Mathlib.FieldTheory.Finiteness
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
public import Mathlib.Algebra.Field.ZMod
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.NormNum

/-!
# The dyadic rank/support conjecture

Source: Gomez-Fonseca, Matthews, Morris and Pllaha, arXiv:2605.01942v1,
Definition 2.1 and Remark 3.4. Ranks are ordinary ranks over `ZMod 2`.
The conjecture is defined as a proposition, not an axiom; Recursive.lean proves it.
-/

@[expose] public section

namespace DyadicRank

local instance (n : Type) [Fintype n] [DecidableEq n] [BinaryIndex n] : Fintype (n → ZMod 2) :=
  binaryFunctionFintype n

abbrev F2 := ZMod 2
abbrev Point (ell : ℕ) := Fin ell → F2
abbrev Signature (ell : ℕ) := Point ell → F2

/-- The signature determines every entry by addition of binary index vectors. -/
def dyadicMatrix {ell : ℕ} (s : Signature ell) : Matrix (Point ell) (Point ell) F2 :=
  fun x y => s (x + y)

/-- The paper's definition, for an arbitrary matrix on the same index type. -/
def IsDyadic {ell : ℕ} (D : Matrix (Point ell) (Point ell) F2) : Prop :=
  ∀ x y, D x y = D 0 (x + y)

@[simp] theorem dyadicMatrix_zero_row {ell : ℕ} (s : Signature ell) :
    dyadicMatrix s 0 = s := by
  funext y
  simp [dyadicMatrix]

theorem isDyadic_dyadicMatrix {ell : ℕ} (s : Signature ell) :
    IsDyadic (dyadicMatrix s) := by
  intro x y
  simp [dyadicMatrix]

theorem eq_dyadicMatrix_of_isDyadic {ell : ℕ}
    {D : Matrix (Point ell) (Point ell) F2} (h : IsDyadic D) :
    D = dyadicMatrix (D 0) := by
  funext x y
  exact h x y

/-- Positions in the signature at which the coefficient is nonzero. -/
def signatureSupport {ell : ℕ} (s : Signature ell) : Finset (Point ell) :=
  Finset.univ.filter fun x => s x ≠ 0

/-- Vector sum in F_2^ell, not the sum of the signature coefficients. -/
def supportSum {ell : ℕ} (s : Signature ell) : Point ell :=
  ∑ x ∈ signatureSupport s, x

/-- The full converse in one dimension parameter, written without natural-number division. -/
def RankSupportAt (ell : ℕ) : Prop :=
  ∀ s : Signature ell,
    2 * (dyadicMatrix s).rank = 2 ^ ell → supportSum s ≠ 0

/-- The unrestricted positive-dimensional proposition, proved in Recursive.lean. -/
def RankSupportConjecture : Prop :=
  ∀ ell : ℕ, 0 < ell → RankSupportAt ell

/-- Signature form is equivalent to the statement for arbitrary dyadic matrices. -/
theorem rankSupportAt_iff (ell : ℕ) : RankSupportAt ell ↔
    ∀ D : Matrix (Point ell) (Point ell) F2, IsDyadic D →
      2 * D.rank = 2 ^ ell → supportSum (D 0) ≠ 0 := by
  constructor
  · intro h D hd hr
    apply h (D 0)
    rwa [← eq_dyadicMatrix_of_isDyadic hd]
  · intro h s hr
    simpa using h (dyadicMatrix s) (isDyadic_dyadicMatrix s) hr

/-- At dimension zero the doubled-rank antecedent is impossible. -/
theorem rankSupportAt_zero : RankSupportAt 0 := by
  intro s h
  simp only [pow_zero] at h
  omega

/-- A computable enumeration of the right kernel, used for small certificates. -/
def kernelVectors {n : Type} [Fintype n] [DecidableEq n] [Fintype (n → F2)] (A : Matrix n n F2) :
    Finset (n → F2) :=
  Finset.univ.filter fun v => A.mulVec v = 0

/-- Enumeration agrees with the cardinality predicted by the algebraic kernel dimension. -/
theorem kernelVectors_card {n : Type} [Fintype n] [DecidableEq n] [Fintype (n → F2)]
    (A : Matrix n n F2) :
    (kernelVectors A).card = 2 ^ Module.finrank F2 (LinearMap.ker A.mulVecLin) := by
  classical
  let : Fintype (LinearMap.ker A.mulVecLin) := Fintype.ofFinite _
  have hset : (↑(kernelVectors A) : Set (n → F2)) =
      (LinearMap.ker A.mulVecLin : Set (n → F2)) := by
    ext v
    simp [kernelVectors]
  have hcard : (kernelVectors A).card = Fintype.card (LinearMap.ker A.mulVecLin) := by
    have he : ↥(↑(kernelVectors A) : Set (n → F2)) ≃ LinearMap.ker A.mulVecLin :=
      Equiv.cast (congrArg (fun t : Set (n → F2) => ↥t) hset)
    exact (Fintype.card_coe (kernelVectors A)).symm.trans (Fintype.card_congr he)
  rw [hcard, Module.card_eq_pow_finrank (K := F2)]
  norm_num [F2]

/-- A half-rank matrix has the kernel cardinality used by the finite check. -/
theorem kernelVectors_card_of_half_rank {n : Type} [Fintype n] [DecidableEq n] [Fintype (n → F2)]
    (A : Matrix n n F2) (k : ℕ) (hsize : Fintype.card n = 2 * k)
    (hrank : A.rank = k) : (kernelVectors A).card = 2 ^ k := by
  have hnull := A.mulVecLin.finrank_range_add_finrank_ker
  have hdim : Module.finrank F2 (n → F2) = Fintype.card n := by simp
  change A.rank + Module.finrank F2 (LinearMap.ker A.mulVecLin) = _ at hnull
  rw [hdim, hsize, hrank] at hnull
  have hk : Module.finrank F2 (LinearMap.ker A.mulVecLin) = k := by omega
  rw [kernelVectors_card, hk]


end DyadicRank
