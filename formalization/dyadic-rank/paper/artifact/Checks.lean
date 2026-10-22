module

import DyadicRank

open DyadicRank

-- Check the public statement against arbitrary dyadic matrices.
example : ∀ D : Matrix (Point 2) (Point 2) F2, IsDyadic D →
    2 * D.rank = 4 → supportSum (D 0) ≠ 0 := by
  intro D hd hr
  exact dyadic_rank_support_small (by omega) D hd hr

example : Fintype.card (Signature 1) = 4 := by norm_num [Signature, Point, F2]
example : Fintype.card (Signature 2) = 16 := by norm_num [Signature, Point, F2]

#print axioms mem_binaryAssignments
#print axioms rankSupportAt_iff
#print axioms kernelVectors_card
#print axioms kernelVectors_card_of_half_rank
#print axioms certificate_one
#print axioms certificate_two
#print axioms rankSupportAt_zero
#print axioms rankSupportAt_one
#print axioms rankSupportAt_two
#print axioms rankSupportAt_le_two
#print axioms dyadic_rank_support_small

-- General structural results and the elementary ideal obstruction.
#print axioms point_add_self
#print axioms point_add_cancel_left
#print axioms point_add_cancel_right
#print axioms card_point
#print axioms sum_translate
#print axioms supportSum_apply
#print axioms coefficientParity_eq_card
#print axioms mulVec_constant
#print axioms mulVec_coordinate
#print axioms coordinate_mem_kernel
#print axioms constant_mem_kernel
#print axioms affine_mem_kernel
#print axioms dyadic_square_off_diagonal
#print axioms dyadic_square
#print axioms range_le_kernel_of_square_zero
#print axioms twice_rank_le_of_square_zero
#print axioms half_rank_iff_range_eq_kernel
#print axioms dyadic_square_zero
#print axioms dyadic_square_one
#print axioms rank_eq_card_of_square_one
#print axioms dyadic_rank_of_parity_one
#print axioms parity_zero_of_half_rank
#print axioms dyadic_twice_rank_le
#print axioms strict_rank_iff_range_lt_kernel
#print axioms rankSupportAt_iff_strict_deficit
#print axioms rankSupportAt_iff_kernel_obstruction
#print axioms square_mem_span_squares
#print axioms square_mem_product_of_mem_square
#print axioms square_mem_generator_product

-- Unbounded consumer checks using ordinary matrix notation and the source's rank N/2.
example : RankSupportConjecture := rankSupportConjecture_proved

example (ell : ℕ) (hpos : 0 < ell)
    (D : Matrix (Point ell) (Point ell) F2) (hd : IsDyadic D)
    (hr : D.rank = 2 ^ ell / 2) : supportSum (D 0) ≠ 0 :=
  dyadic_rank_support_half hpos D hd hr

example (ell : ℕ) (s : Signature ell)
    (hr : 2 * (dyadicMatrix s).rank = 2 ^ ell) : supportSum s ≠ 0 := by
  simpa only [dyadicMatrix_zero_row] using
    dyadic_rank_support (dyadicMatrix s) (isDyadic_dyadicMatrix s) hr

-- Every recursive lemma, including the unrestricted theorem, receives an axiom audit.
#print axioms kernelInRange_descends
#print axioms sum_split_head
#print axioms point_cons_add
#print axioms vector_add_self
#print axioms dyadic_mul_comm
#print axioms dyadicMatrix_add
#print axioms parity_sliceOne
#print axioms parity_lower
#print axioms supportSum_lower
#print axioms sliceZero_mulVec
#print axioms sliceOne_mulVec
#print axioms sliceZero_duplicate
#print axioms sliceOne_duplicate
#print axioms slices_ext
#print axioms sliceZero_zero
#print axioms sliceOne_zero
#print axioms sum_slices_mulVec
#print axioms triangular_zero_row
#print axioms duplicate_cycle
#print axioms kernelInRange_lower
#print axioms not_kernelInRange_zero_moments
#print axioms rankSupportAt_all
#print axioms rankSupportConjecture_proved
#print axioms dyadic_strict_rank_of_zero_moments
#print axioms dyadic_rank_support
#print axioms dyadic_rank_support_half
