module

public import DyadicRank.Structural
public import Mathlib.Data.Fin.Tuple.Basic
public import Mathlib.Tactic.Abel

@[expose] public section

namespace DyadicRank

local instance recursiveFunctionFintype (n : Type) [Fintype n] [DecidableEq n] [BinaryIndex n] :
    Fintype (n → ZMod 2) := binaryFunctionFintype n

/-- Exactness of a square-zero endomorphism, expressed as the required preimage property. -/
def KernelInRange {V : Type*} [AddCommGroup V] [Module F2 V] (f : V →ₗ[F2] V) : Prop :=
  ∀ v, f v = 0 → ∃ w, f w = v

/-- Exactness descends through a square-zero commuting upper triangular extension. -/
theorem kernelInRange_descends {V : Type*} [AddCommGroup V] [Module F2 V]
    (C B : V →ₗ[F2] V) (hc : ∀ v, B (C v) = C (B v)) (hb : ∀ v, B (B v) = 0)
    (h : ∀ v, C v = 0 → ∃ a b, C a + B b = v ∧ C b = 0) : KernelInRange C := by
  intro v hv
  obtain ⟨a, b, hab, hcb⟩ := h v hv
  obtain ⟨c, d, hcd, _⟩ := h b hcb
  have hbb : B b = B (C c) := by
    rw [← hcd, map_add, hb, add_zero]
  refine ⟨a + B c, ?_⟩
  rw [map_add, ← hc, ← hbb]
  exact hab

def sliceZero {ell : ℕ} (v : Point (ell + 1) → F2) : Point ell → F2 :=
  fun x => v (Fin.cons 0 x)

def sliceOne {ell : ℕ} (v : Point (ell + 1) → F2) : Point ell → F2 :=
  fun x => v (Fin.cons 1 x)

def lowerSignature {ell : ℕ} (s : Signature (ell + 1)) : Signature ell :=
  sliceZero s + sliceOne s

/-- Split the first binary coordinate in a sum over all index vectors. -/
theorem sum_split_head {ell : ℕ} (f : Point (ell + 1) → F2) :
    (∑ x, f x) = ∑ y : Point ell, (f (Fin.cons 0 y) + f (Fin.cons 1 y)) := by
  let e : Point (ell + 1) ≃ F2 × Point ell :=
    { toFun := fun x => (x 0, Fin.tail x)
      invFun := fun p => Fin.cons p.1 p.2
      left_inv := Fin.cons_self_tail
      right_inv := by intro p; simp }
  calc
    (∑ x, f x) = ∑ p : F2 × Point ell, f (Fin.cons p.1 p.2) :=
      Fintype.sum_equiv e _ _ (fun x => by simp [e])
    _ = _ := by
      rw [Fintype.sum_prod_type]
      change (∑ a : Fin 2, ∑ y : Point ell, f (Fin.cons a y)) = _
      rw [Fin.sum_univ_two, ← Finset.sum_add_distrib]
      rfl

@[simp] theorem point_cons_add {ell : ℕ} (a b : F2) (x y : Point ell) :
    (Fin.cons a x : Point (ell + 1)) + Fin.cons b y = Fin.cons (a + b) (x + y) := by
  ext i
  refine Fin.cases ?_ (fun j => ?_) i <;> simp

@[simp] theorem vector_add_self {α : Type*} (v : α → F2) : v + v = 0 := by
  ext x
  exact CharTwo.add_self_eq_zero (v x)

/-- Any two dyadic convolution operators commute. -/
theorem dyadic_mul_comm {ell : ℕ} (s t : Signature ell) :
    dyadicMatrix s * dyadicMatrix t = dyadicMatrix t * dyadicMatrix s := by
  ext x y
  change (∑ z, s (x + z) * t (z + y)) = ∑ z, t (x + z) * s (z + y)
  have h := sum_translate (fun z => s (x + z) * t (z + y)) (x + y)
  simpa [add_left_comm, add_comm, mul_comm] using h.symm

@[simp] theorem dyadicMatrix_add {ell : ℕ} (s t : Signature ell) :
    dyadicMatrix (s + t) = dyadicMatrix s + dyadicMatrix t := rfl

/-- The first moment in the split coordinate is the parity of the one slice. -/
theorem parity_sliceOne {ell : ℕ} (s : Signature (ell + 1)) :
    coefficientParity (sliceOne s) = supportSum s 0 := by
  rw [supportSum_apply, sum_split_head]
  simp [coefficientParity, sliceOne]

theorem parity_lower {ell : ℕ} (s : Signature (ell + 1)) :
    coefficientParity (lowerSignature s) = coefficientParity s := by
  unfold coefficientParity
  rw [sum_split_head]
  rfl

theorem supportSum_lower {ell : ℕ} (s : Signature (ell + 1)) :
    supportSum (lowerSignature s) = Fin.tail (supportSum s) := by
  funext i
  change supportSum (lowerSignature s) i = supportSum s i.succ
  rw [supportSum_apply, supportSum_apply, sum_split_head]
  simp only [lowerSignature, sliceZero, sliceOne, Pi.add_apply, Fin.cons_succ, add_mul]

/-- The usual two-by-two dyadic block recursion, on the zero slice. -/
theorem sliceZero_mulVec {ell : ℕ} (s : Signature (ell + 1)) (v : Point (ell + 1) → F2) :
    sliceZero ((dyadicMatrix s).mulVec v) =
      (dyadicMatrix (sliceZero s)).mulVec (sliceZero v) +
      (dyadicMatrix (sliceOne s)).mulVec (sliceOne v) := by
  funext x
  change (∑ z, s (Fin.cons 0 x + z) * v z) = _
  rw [sum_split_head]
  simp only [point_cons_add, zero_add]
  simp only [sliceZero, sliceOne, Matrix.mulVec, dotProduct, dyadicMatrix,
    Pi.add_apply, Finset.sum_add_distrib]

/-- The usual two-by-two dyadic block recursion, on the one slice. -/
theorem sliceOne_mulVec {ell : ℕ} (s : Signature (ell + 1)) (v : Point (ell + 1) → F2) :
    sliceOne ((dyadicMatrix s).mulVec v) =
      (dyadicMatrix (sliceOne s)).mulVec (sliceZero v) +
      (dyadicMatrix (sliceZero s)).mulVec (sliceOne v) := by
  funext x
  change (∑ z, s (Fin.cons 1 x + z) * v z) = _
  rw [sum_split_head]
  simp only [point_cons_add, add_zero, CharTwo.add_self_eq_zero]
  simp only [sliceZero, sliceOne, Matrix.mulVec, dotProduct, dyadicMatrix,
    Pi.add_apply, Finset.sum_add_distrib]

/-- Duplicate a vector on the two binary slices. -/
def duplicate {ell : ℕ} (v : Point ell → F2) : Point (ell + 1) → F2 :=
  fun x => v (Fin.tail x)

@[simp] theorem sliceZero_duplicate {ell : ℕ} (v : Point ell → F2) :
    sliceZero (duplicate v) = v := by funext x; simp [sliceZero, duplicate]

@[simp] theorem sliceOne_duplicate {ell : ℕ} (v : Point ell → F2) :
    sliceOne (duplicate v) = v := by funext x; simp [sliceOne, duplicate]

/-- Values on both slices determine the entire vector. -/
theorem slices_ext {ell : ℕ} {v w : Point (ell + 1) → F2}
    (h₀ : sliceZero v = sliceZero w) (h₁ : sliceOne v = sliceOne w) : v = w := by
  have h : ∀ a x, v (Fin.cons a x) = w (Fin.cons a x) := by
    intro a x
    rcases binaryValue a with ha | ha
    · subst a; exact congrFun h₀ x
    · subst a; exact congrFun h₁ x
  funext x
  simpa only [Fin.cons_self_tail] using h (x 0) (Fin.tail x)

@[simp] theorem sliceZero_zero {ell : ℕ} : sliceZero (0 : Point (ell + 1) → F2) = 0 := rfl
@[simp] theorem sliceOne_zero {ell : ℕ} : sliceOne (0 : Point (ell + 1) → F2) = 0 := rfl

/-- The sum of the output slices is the smaller operator on the sum of input slices. -/
theorem sum_slices_mulVec {ell : ℕ} (s : Signature (ell + 1)) (v : Point (ell + 1) → F2) :
    sliceZero ((dyadicMatrix s).mulVec v) + sliceOne ((dyadicMatrix s).mulVec v) =
      (dyadicMatrix (lowerSignature s)).mulVec (sliceZero v + sliceOne v) := by
  rw [sliceZero_mulVec, sliceOne_mulVec]
  simp only [lowerSignature, dyadicMatrix_add, Matrix.add_mulVec, Matrix.mulVec_add]
  abel

/-- Triangular form under the change of coordinates (v₀,v₁) ↦ (v₀,v₀+v₁). -/
theorem triangular_zero_row {ell : ℕ} (s : Signature (ell + 1)) (v : Point (ell + 1) → F2) :
    sliceZero ((dyadicMatrix s).mulVec v) =
      (dyadicMatrix (lowerSignature s)).mulVec (sliceZero v) +
      (dyadicMatrix (sliceOne s)).mulVec (sliceZero v + sliceOne v) := by
  rw [sliceZero_mulVec]
  simp only [lowerSignature, dyadicMatrix_add, Matrix.add_mulVec, Matrix.mulVec_add]
  have h := vector_add_self ((dyadicMatrix (sliceOne s)).mulVec (sliceZero v))
  calc
    _ = (dyadicMatrix (sliceZero s)).mulVec (sliceZero v) +
        ((dyadicMatrix (sliceOne s)).mulVec (sliceZero v) +
         (dyadicMatrix (sliceOne s)).mulVec (sliceZero v)) +
        (dyadicMatrix (sliceOne s)).mulVec (sliceOne v) := by rw [h]; simp only [add_zero]
    _ = _ := by abel

/-- A cycle for the smaller operator duplicates to a cycle for the larger one. -/
theorem duplicate_cycle {ell : ℕ} (s : Signature (ell + 1)) (v : Point ell → F2)
    (hv : (dyadicMatrix (lowerSignature s)).mulVec v = 0) :
    (dyadicMatrix s).mulVec (duplicate v) = 0 := by
  apply slices_ext
  · rw [sliceZero_mulVec, sliceZero_duplicate, sliceOne_duplicate]
    have h := hv
    simpa only [lowerSignature, dyadicMatrix_add, Matrix.add_mulVec, sliceZero_zero, sliceOne_zero] using h
  · rw [sliceOne_mulVec, sliceZero_duplicate, sliceOne_duplicate, add_comm]
    have h := hv
    simpa only [lowerSignature, dyadicMatrix_add, Matrix.add_mulVec, sliceZero_zero, sliceOne_zero] using h

/-- Vanishing of the first support moment makes exactness descend one dimension. -/
theorem kernelInRange_lower {ell : ℕ} (s : Signature (ell + 1))
    (hm : supportSum s = 0) (he : KernelInRange (dyadicMatrix s).mulVecLin) :
    KernelInRange (dyadicMatrix (lowerSignature s)).mulVecLin := by
  have hp : coefficientParity (sliceOne s) = 0 := by rw [parity_sliceOne, hm]; rfl
  apply kernelInRange_descends (dyadicMatrix (lowerSignature s)).mulVecLin
    (dyadicMatrix (sliceOne s)).mulVecLin
  · intro v
    simp only [Matrix.mulVecLin_apply]
    rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, dyadic_mul_comm]
  · intro v
    simp only [Matrix.mulVecLin_apply]
    rw [Matrix.mulVec_mulVec, dyadic_square_zero _ hp]
    simp
  · intro v hv
    obtain ⟨w, hw⟩ := he (duplicate v) (by
      simpa only [Matrix.mulVecLin_apply] using duplicate_cycle s v (by
        simpa only [Matrix.mulVecLin_apply] using hv))
    simp only [Matrix.mulVecLin_apply] at hw
    refine ⟨sliceZero w, sliceZero w + sliceOne w, ?_, ?_⟩
    · have h := congrArg sliceZero hw
      rw [triangular_zero_row, sliceZero_duplicate] at h
      simpa only [Matrix.mulVecLin_apply] using h
    · have h := congrArg (fun u => sliceZero u + sliceOne u) hw
      rw [sum_slices_mulVec, sliceZero_duplicate, sliceOne_duplicate, vector_add_self] at h
      simpa only [Matrix.mulVecLin_apply] using h

/-- A zero-parity signature with zero first moments cannot be exact in any dimension. -/
theorem not_kernelInRange_zero_moments (ell : ℕ) :
    ∀ s : Signature ell, coefficientParity s = 0 → supportSum s = 0 →
      ¬ KernelInRange (dyadicMatrix s).mulVecLin := by
  induction ell with
  | zero =>
    intro s hp _ he
    have hs : ∀ x : Point 0, s x = 0 := by
      intro x
      have hu : (Finset.univ : Finset (Point 0)) = {x} := by
        ext y
        simp only [Finset.mem_univ, Finset.mem_singleton, true_iff]
        exact Subsingleton.elim y x
      unfold coefficientParity at hp
      rwa [hu, Finset.sum_singleton] at hp
    have hm : dyadicMatrix s = 0 := by
      ext x y
      exact hs (x + y)
    have hz : (dyadicMatrix s).mulVecLin = 0 := by rw [hm, Matrix.mulVecLin_zero]
    obtain ⟨w, hw⟩ := he (fun _ => 1) (by rw [hz]; rfl)
    have h := congrFun hw 0
    rw [hz] at h
    norm_num at h
  | succ ell ih =>
    intro s hp hm he
    apply ih (lowerSignature s)
    · rwa [parity_lower]
    · rw [supportSum_lower, hm]
      rfl
    · exact kernelInRange_lower s hm he

/-- The full rank/support converse, for every binary dimension. -/
theorem rankSupportAt_all (ell : ℕ) : RankSupportAt ell := by
  intro s hr hm
  have hp := parity_zero_of_half_rank s hr
  have hs := dyadic_square_zero s hp
  have hc : 2 * (dyadicMatrix s).rank = Fintype.card (Point ell) := by
    rwa [card_point]
  have he := (half_rank_iff_range_eq_kernel (dyadicMatrix s) hs).mp hc
  apply not_kernelInRange_zero_moments ell s hp hm
  intro v hv
  have hv' : v ∈ LinearMap.ker (dyadicMatrix s).mulVecLin := hv
  rw [← he] at hv'
  exact hv'

/-- The unrestricted positive-dimensional conjecture is proved. -/
theorem rankSupportConjecture_proved : RankSupportConjecture := by
  intro ell _
  exact rankSupportAt_all ell

/-- The strict rank deficit is now proved in every dimension. -/
theorem dyadic_strict_rank_of_zero_moments {ell : ℕ} (s : Signature ell)
    (hp : coefficientParity s = 0) (hm : supportSum s = 0) :
    2 * (dyadicMatrix s).rank < 2 ^ ell :=
  (rankSupportAt_iff_strict_deficit ell).mp (rankSupportAt_all ell) s hp hm

/-- The theorem for any dyadic matrix and any caller's finite enumeration. -/
theorem dyadic_rank_support {ell : ℕ} [inst : Fintype (Point ell)]
    (D : Matrix (Point ell) (Point ell) F2) (hd : IsDyadic D)
    (hr : 2 * D.rank = 2 ^ ell) : supportSum (D 0) ≠ 0 := by
  apply (rankSupportAt_iff ell).mp (rankSupportAt_all ell) D hd
  have hi : binaryFunctionFintype (Fin ell) = inst := Subsingleton.elim _ _
  change 2 * @Matrix.rank (Point ell) (Point ell) F2
    (binaryFunctionFintype (Fin ell)) _ D = 2 ^ ell
  rw [hi]
  exact hr

/-- The source's half-rank form, including the positive-dimension hypothesis. -/
theorem dyadic_rank_support_half {ell : ℕ} [Fintype (Point ell)]
    (hpos : 0 < ell) (D : Matrix (Point ell) (Point ell) F2) (hd : IsDyadic D)
    (hr : D.rank = 2 ^ ell / 2) : supportSum (D 0) ≠ 0 := by
  apply dyadic_rank_support D hd
  cases ell with
  | zero => omega
  | succ k =>
    rw [hr, pow_succ]
    omega

end DyadicRank
