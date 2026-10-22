module

public import DyadicRank.Basic
public import Mathlib.Algebra.CharP.Two

@[expose] public section

namespace DyadicRank

local instance structuralFunctionFintype (n : Type) [Fintype n] [DecidableEq n] [BinaryIndex n] : Fintype (n → ZMod 2) :=
  binaryFunctionFintype n

/-- Sum of coefficients in F2: zero means even signature weight. -/
def coefficientParity {ell : ℕ} (s : Signature ell) : F2 := ∑ x, s x

@[simp] theorem point_add_self {ell : ℕ} (x : Point ell) : x + x = 0 := by
  funext i
  exact CharTwo.add_self_eq_zero (x i)

@[simp] theorem point_add_cancel_left {ell : ℕ} (x y : Point ell) : x + (x + y) = y := by
  rw [← add_assoc, point_add_self, zero_add]

@[simp] theorem point_add_cancel_right {ell : ℕ} (x y : Point ell) : x + y + y = x := by
  rw [add_assoc, point_add_self, add_zero]

/-- Cardinality is independent of the computational enumeration. -/
theorem card_point (ell : ℕ) : Fintype.card (Point ell) = 2 ^ ell := by
  calc
    Fintype.card (Point ell) = @Fintype.card (Point ell) Pi.instFintype :=
      @Fintype.card_congr (Point ell) (Point ell) _ Pi.instFintype (Equiv.refl _)
    _ = 2 ^ ell := by simp [Point, F2]

/-- Translating binary index vectors permutes the summation domain. -/
theorem sum_translate {ell : ℕ} (f : Point ell → F2) (a : Point ell) :
    (∑ x, f (a + x)) = ∑ x, f x := by
  exact Fintype.sum_equiv (Equiv.addLeft a) _ _ (fun _ => rfl)

/-- A support-vector sum is the vector of first weighted coefficient moments. -/
theorem supportSum_apply {ell : ℕ} (s : Signature ell) (i : Fin ell) :
    supportSum s i = ∑ x, s x * x i := by
  classical
  simp only [supportSum, signatureSupport, Finset.sum_apply, Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro x _
  rcases binaryValue (s x) with h | h <;> simp [h]

/-- Coefficient parity is the support cardinality reduced modulo two. -/
theorem coefficientParity_eq_card {ell : ℕ} (s : Signature ell) :
    coefficientParity s = (signatureSupport s).card := by
  classical
  unfold coefficientParity
  calc
    (∑ x, s x) = ∑ x, if s x ≠ 0 then (1 : F2) else 0 := by
      apply Finset.sum_congr rfl
      intro x _
      rcases binaryValue (s x) with h | h <;> simp [h]
    _ = ∑ x ∈ signatureSupport s, (1 : F2) := by
      simp only [signatureSupport, Finset.sum_filter]
    _ = (signatureSupport s).card := by simp

/-- The constant function is an eigenvector with eigenvalue equal to coefficient parity. -/
theorem mulVec_constant {ell : ℕ} (s : Signature ell) (c : F2) :
    (dyadicMatrix s).mulVec (fun _ => c) = fun _ => coefficientParity s * c := by
  funext x
  simp only [Matrix.mulVec, dotProduct, dyadicMatrix]
  rw [← Finset.sum_mul, sum_translate]
  rfl

/-- Under translation, a linear coordinate gains its parity-weighted translation constant. -/
theorem mulVec_coordinate {ell : ℕ} (s : Signature ell) (i : Fin ell) :
    (dyadicMatrix s).mulVec (fun y => y i) =
      fun x => supportSum s i + coefficientParity s * x i := by
  funext x
  change (∑ y, s (x + y) * y i) = _
  calc
    (∑ y, s (x + y) * y i) =
        ∑ y, s (x + y) * ((x + y) i + x i) := by
      apply Finset.sum_congr rfl
      intro y _
      congr 1
      simp only [Pi.add_apply]
      rw [add_comm (x i), CharTwo.add_cancel_right]
    _ = ∑ z, s z * (z i + x i) := sum_translate (fun z => s z * (z i + x i)) x
    _ = _ := by
      simp only [mul_add, Finset.sum_add_distrib, ← Finset.sum_mul,
        ← supportSum_apply, coefficientParity]

/-- Zero parity and zero support sum put every affine coordinate in the kernel. -/
theorem coordinate_mem_kernel {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 0) (hm : supportSum s = 0) (i : Fin ell) :
    (fun x : Point ell => x i) ∈ LinearMap.ker (dyadicMatrix s).mulVecLin := by
  change (dyadicMatrix s).mulVec (fun x => x i) = 0
  rw [mulVec_coordinate, hp, hm]
  simp
  rfl

/-- Every constant vector is killed by an even-parity dyadic matrix. -/
theorem constant_mem_kernel {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 0) (c : F2) :
    (fun _ : Point ell => c) ∈ LinearMap.ker (dyadicMatrix s).mulVecLin := by
  change (dyadicMatrix s).mulVec (fun _ => c) = 0
  rw [mulVec_constant, hp]
  simp only [zero_mul]
  rfl

/-- All affine linear functions lie in the kernel when parity and first moments vanish. -/
theorem affine_mem_kernel {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 0) (hm : supportSum s = 0)
    (c : F2) (a : Fin ell → F2) :
    (fun _ : Point ell => c) + (∑ i, a i • (fun x : Point ell => x i)) ∈
      LinearMap.ker (dyadicMatrix s).mulVecLin := by
  apply Submodule.add_mem _ (constant_mem_kernel s hp c)
  apply Submodule.sum_mem
  intro i _
  exact Submodule.smul_mem _ _ (coordinate_mem_kernel s hp hm i)

/-- Off-diagonal terms cancel in pairs under the fixed-point-free translation. -/
theorem dyadic_square_off_diagonal {ell : ℕ} (s : Signature ell)
    (x y : Point ell) (hxy : x ≠ y) :
    (dyadicMatrix s * dyadicMatrix s) x y = 0 := by
  classical
  change (∑ z, s (x + z) * s (z + y)) = 0
  apply Finset.sum_involution (fun z _ => x + y + z)
  · intro z _
    have ha : x + (x + y + z) = z + y := by
      simp [add_left_comm, add_comm]
    have hb : x + y + z + y = x + z := by
      simp [add_left_comm, add_comm]
    rw [ha, hb, mul_comm (s (z + y))]
    exact CharTwo.add_self_eq_zero _
  · intro z _ _ hfix
    have h : x + y = 0 := add_right_cancel (hfix.trans (zero_add z).symm)
    have : x = y := by
      have hh := congrArg (fun w => w + y) h
      simpa only [point_add_cancel_right, zero_add] using hh
    exact hxy this
  · intro _ _
    exact Finset.mem_univ _
  · intro z _
    simp [add_left_comm, add_comm]

/-- The square of a dyadic matrix is parity times the identity, in every dimension. -/
theorem dyadic_square {ell : ℕ} (s : Signature ell) :
    dyadicMatrix s * dyadicMatrix s = coefficientParity s • (1 : Matrix _ _ F2) := by
  classical
  ext x y
  by_cases h : x = y
  · subst y
    change (∑ z, s (x + z) * s (z + x)) = _
    have hs : ∀ a : F2, a * a = a := by
      intro a
      rcases binaryValue a with ha | ha <;> simp [ha]
    simp only [add_comm _ x, hs]
    rw [sum_translate]
    simp [coefficientParity]
  · rw [dyadic_square_off_diagonal s x y h]
    simp [h]

/-- The image of a square-zero operator lies in its kernel. -/
theorem range_le_kernel_of_square_zero {n : Type} [Fintype n] [DecidableEq n]
    (A : Matrix n n F2) (h : A * A = 0) :
    LinearMap.range A.mulVecLin ≤ LinearMap.ker A.mulVecLin := by
  rw [LinearMap.range_le_ker_iff, ← Matrix.mulVecLin_mul, h]
  simp

/-- Rank-nullity turns that inclusion into the half-rank upper bound. -/
theorem twice_rank_le_of_square_zero {n : Type} [Fintype n] [DecidableEq n]
    (A : Matrix n n F2) (h : A * A = 0) : 2 * A.rank ≤ Fintype.card n := by
  have hi := Submodule.finrank_mono (range_le_kernel_of_square_zero A h)
  have hn := A.mulVecLin.finrank_range_add_finrank_ker
  have hd : Module.finrank F2 (n → F2) = Fintype.card n := by simp
  change A.rank + Module.finrank F2 (LinearMap.ker A.mulVecLin) = _ at hn
  change A.rank ≤ _ at hi
  rw [hd] at hn
  omega

/-- Half rank is exactly the vanishing of the image/kernel obstruction. -/
theorem half_rank_iff_range_eq_kernel {n : Type} [Fintype n] [DecidableEq n]
    (A : Matrix n n F2) (h : A * A = 0) :
    2 * A.rank = Fintype.card n ↔ LinearMap.range A.mulVecLin = LinearMap.ker A.mulVecLin := by
  have hn := A.mulVecLin.finrank_range_add_finrank_ker
  have hd : Module.finrank F2 (n → F2) = Fintype.card n := by simp
  change A.rank + Module.finrank F2 (LinearMap.ker A.mulVecLin) = _ at hn
  rw [hd] at hn
  constructor
  · intro hr
    apply Submodule.eq_of_le_of_finrank_eq (range_le_kernel_of_square_zero A h)
    change A.rank = _
    omega
  · intro he
    have he' := congrArg (fun p : Submodule F2 (n → F2) => Module.finrank F2 p) he
    change A.rank = _ at he'
    omega

/-- Even coefficient parity gives a square-zero dyadic operator. -/
theorem dyadic_square_zero {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 0) : dyadicMatrix s * dyadicMatrix s = 0 := by
  rw [dyadic_square, hp, zero_smul]

/-- Odd coefficient parity gives an involution. -/
theorem dyadic_square_one {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 1) : dyadicMatrix s * dyadicMatrix s = 1 := by
  rw [dyadic_square, hp, one_smul]

/-- Involutions have full rank; odd signatures therefore cannot be counterexamples. -/
theorem rank_eq_card_of_square_one {n : Type} [Fintype n] [DecidableEq n]
    (A : Matrix n n F2) (h : A * A = 1) : A.rank = Fintype.card n := by
  have hl := Matrix.rank_mul_le_left A A
  rw [h, Matrix.rank_one] at hl
  exact le_antisymm (Matrix.rank_le_card_width A) hl

theorem dyadic_rank_of_parity_one {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 1) : (dyadicMatrix s).rank = 2 ^ ell := by
  have h := rank_eq_card_of_square_one _ (dyadic_square_one s hp)
  simpa only [card_point] using h

/-- Any half-rank signature has even parity. -/
theorem parity_zero_of_half_rank {ell : ℕ} (s : Signature ell)
    (hr : 2 * (dyadicMatrix s).rank = 2 ^ ell) : coefficientParity s = 0 := by
  rcases binaryValue (coefficientParity s) with h | h
  · exact h
  · have hf := dyadic_rank_of_parity_one s h
    have hn : 0 < 2 ^ ell := by positivity
    omega

/-- The universal upper bound in the only parity relevant to the conjecture. -/
theorem dyadic_twice_rank_le {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 0) : 2 * (dyadicMatrix s).rank ≤ 2 ^ ell := by
  have h := twice_rank_le_of_square_zero _ (dyadic_square_zero s hp)
  simpa only [card_point] using h

/-- Strict image/kernel containment is exactly strict rank deficit. -/
theorem strict_rank_iff_range_lt_kernel {n : Type} [Fintype n] [DecidableEq n]
    (A : Matrix n n F2) (hsq : A * A = 0) :
    2 * A.rank < Fintype.card n ↔ LinearMap.range A.mulVecLin < LinearMap.ker A.mulVecLin := by
  have hle := range_le_kernel_of_square_zero A hsq
  have hbound := twice_rank_le_of_square_zero A hsq
  have heq := half_rank_iff_range_eq_kernel A hsq
  constructor
  · intro h
    refine ⟨hle, ?_⟩
    intro hback
    have he : LinearMap.range A.mulVecLin = LinearMap.ker A.mulVecLin := le_antisymm hle hback
    have hh := heq.mpr he
    omega
  · intro h
    have hh : 2 * A.rank ≠ Fintype.card n := by
      intro hr
      exact (ne_of_lt h) (heq.mp hr)
    omega

/-- Exact reformulation: it remains to prove a strict deficit for zero first moments. -/
theorem rankSupportAt_iff_strict_deficit (ell : ℕ) : RankSupportAt ell ↔
    ∀ s : Signature ell, coefficientParity s = 0 → supportSum s = 0 →
      2 * (dyadicMatrix s).rank < 2 ^ ell := by
  constructor
  · intro h s hp hm
    have hb := dyadic_twice_rank_le s hp
    have hn : 2 * (dyadicMatrix s).rank ≠ 2 ^ ell := fun hr => h s hr hm
    omega
  · intro h s hr hm
    have hp := parity_zero_of_half_rank s hr
    have hd := h s hp hm
    omega

/-- Exact obstruction formulation, still unproved in unrestricted dimension. -/
theorem rankSupportAt_iff_kernel_obstruction (ell : ℕ) : RankSupportAt ell ↔
    ∀ s : Signature ell, coefficientParity s = 0 → supportSum s = 0 →
      LinearMap.range (dyadicMatrix s).mulVecLin < LinearMap.ker (dyadicMatrix s).mulVecLin := by
  rw [rankSupportAt_iff_strict_deficit]
  apply forall_congr'
  intro s
  apply forall_congr'
  intro hp
  apply forall_congr'
  intro _
  have h := strict_rank_iff_range_lt_kernel _ (dyadic_square_zero s hp)
  simpa only [card_point] using h

end DyadicRank
