module

public import DyadicRank.Basic

@[expose] public section

namespace DyadicRank

local instance (n : Type) [Fintype n] [DecidableEq n] [BinaryIndex n] : Fintype (n → ZMod 2) :=
  binaryFunctionFintype n

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem certificate_one :
    ∀ s : Signature 1, supportSum s = 0 →
      (kernelVectors (dyadicMatrix s)).card ≠ 2 ^ 1 := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem certificate_two :
    ∀ s : Signature 2, supportSum s = 0 →
      (kernelVectors (dyadicMatrix s)).card ≠ 2 ^ 2 := by
  decide +kernel

/-- Every 2-by-2 binary dyadic matrix satisfies the converse. -/
theorem rankSupportAt_one : RankSupportAt 1 := by
  intro s hr hz
  have hsize : Fintype.card (Point 1) = 2 * 1 := by decide +kernel
  have hcard := kernelVectors_card_of_half_rank (dyadicMatrix s) 1 hsize (by
    norm_num at hr
    omega)
  exact certificate_one s hz hcard

/-- Every 4-by-4 binary dyadic matrix satisfies the converse. -/
theorem rankSupportAt_two : RankSupportAt 2 := by
  intro s hr hz
  have hsize : Fintype.card (Point 2) = 2 * 2 := by decide +kernel
  have hcard := kernelVectors_card_of_half_rank (dyadicMatrix s) 2 hsize (by
    norm_num at hr
    omega)
  exact certificate_two s hz hcard

/-- All dimensions up to two, including the vacuous zero-dimensional case. -/
theorem rankSupportAt_le_two {ell : ℕ} (h : ell ≤ 2) : RankSupportAt ell := by
  interval_cases ell
  · exact rankSupportAt_zero
  · exact rankSupportAt_one
  · exact rankSupportAt_two

/-- Public matrix formulation, independent of the caller's finite enumeration. -/
theorem dyadic_rank_support_small {ell : ℕ} [inst : Fintype (Point ell)]
    (bound : ell ≤ 2) (D : Matrix (Point ell) (Point ell) F2)
    (hd : IsDyadic D) (hr : 2 * D.rank = 2 ^ ell) : supportSum (D 0) ≠ 0 := by
  apply (rankSupportAt_iff ell).mp (rankSupportAt_le_two bound) D hd
  have hi : binaryFunctionFintype (Fin ell) = inst := Subsingleton.elim _ _
  change 2 * @Matrix.rank (Point ell) (Point ell) F2
    (binaryFunctionFintype (Fin ell)) _ D = 2 ^ ell
  rw [hi]
  exact hr

end DyadicRank
