import Question

/-! Small independent consumers of the general theorem. These do not search
for an even-support construction. -/
namespace CSSOddSupport.Consumers

def maskWord (n k : Nat) : Word n := fun i => (BitVec.ofNat n k).getLsbD i.val

def simplex : List (Word 7) := [85,102,51,120,45,30,75].map (maskWord 7)
def fullSeven : Word 7 := maskWord 7 127

theorem simplex_css : CSS simplex simplex := by
  apply (css_iff_check_all _ _).mpr
  decide

theorem seven_is_odd : Odd fullSeven := by
  unfold Odd
  decide

theorem seven_is_absorbing : Absorbing simplex fullSeven := by
  unfold Absorbing
  decide

theorem seven_has_zero_odd_checks : bValue simplex fullSeven = 0 := by decide

theorem seven_is_logical : LogicalZ simplex simplex fullSeven := by
  exact identical_matrix_odd_zero_b simplex_css fullSeven seven_is_odd seven_has_zero_odd_checks

theorem seven_no_decoder_corrects_all (decoder : Decoder 7) :
  ¬ CorrectsSupported simplex simplex decoder fullSeven := by
  exact no_universal_supported_recovery simplex_css (identical_rows_same_span simplex)
    fullSeven seven_is_odd seven_has_zero_odd_checks decoder

theorem seven_hard_stopping_logical_failure : ¬ Question.HardSuccess simplex fullSeven := by
  intro h
  have hz := (zero_b_iff_zero_syndrome simplex fullSeven).mp seven_has_zero_odd_checks
  exact seven_is_logical.2 ((Question.zero_syndrome_hard_success_iff simplex fullSeven hz).mp h)

theorem seven_edge_stopping_logical_failure : ¬ Question.EdgeSuccess simplex fullSeven := by
  intro h
  have hz := (zero_b_iff_zero_syndrome simplex fullSeven).mp seven_has_zero_odd_checks
  exact seven_is_logical.2 ((Question.zero_syndrome_edge_success_iff simplex fullSeven hz).mp h)

theorem seven_logical_pair : LogicalZ simplex simplex fullSeven ∧
  LogicalZ simplex simplex fullSeven ∧ dot fullSeven fullSeven = true := by
  exact ⟨seven_is_logical,seven_is_logical,odd_dot_self fullSeven seven_is_odd⟩

-- Empty physical length satisfies no odd premise; this is not an excluded hidden case.
theorem zero_length_not_odd (a : Word 0) : ¬ Odd a := by
  simp [Odd, weight, weightOn, List.finRange]

-- Equality of spans need not mean equality of displayed check lists.
def pairRow : Word 2 := maskWord 2 3

theorem one_pair_row_css : CSS [pairRow] [pairRow] := by
  apply (css_iff_check_all _ _).mpr
  decide

theorem even_zero_syndrome_stabilizer :
  ZeroSyndrome [pairRow] pairRow ∧ Span [pairRow] pairRow ∧ weight pairRow % 2 = 0 := by
  refine ⟨?_, Span.row (by simp), ?_⟩
  · unfold ZeroSyndrome
    intro r hr
    simp only [List.mem_singleton] at hr
    subst r
    decide
  · decide

theorem duplicate_row_same_span : SameSpan [pairRow] [pairRow,pairRow] := by
  intro w
  constructor
  · intro h
    exact span_minimal Span.zero (by intro r hr; exact Span.row (by simpa using hr))
      (by intro _ _ hx hy; exact Span.xor hx hy) h
  · intro h
    exact span_minimal Span.zero (by intro r hr; exact Span.row (by simpa using hr))
      (by intro _ _ hx hy; exact Span.xor hx hy) h

theorem duplicate_lists_differ : ([pairRow] : List (Word 2)) ≠ [pairRow,pairRow] := by
  intro h
  have := congrArg List.length h
  contradiction

-- A permutation exchanging X/Z spaces is a strictly different hypothesis.
def oddLeft : Word 6 := maskWord 6 7
def oddRight : Word 6 := maskWord 6 56

def halfSwap (i : Fin 6) : Fin 6 := ⟨(i.val+3)%6,by omega⟩
def permuteHalves (w : Word 6) : Word 6 := fun i => w (halfSwap i)

theorem permutation_only_css : CSS [oddLeft] [oddRight] := by
  apply (css_iff_check_all _ _).mpr
  decide

theorem halves_exchange_rows : permuteHalves oddLeft = oddRight ∧
  permuteHalves oddRight = oddLeft := by
  constructor
  · funext i
    decide +revert
  · funext i
    decide +revert

theorem permutation_only_has_odd_stabilizer : Odd oddRight ∧ Span [oddRight] oddRight := by
  constructor
  · unfold Odd
    decide
  · exact Span.row (by simp)

theorem permutation_only_spaces_differ : ¬ SameSpan [oddLeft] [oddRight] := by
  exact odd_stabilizer_forbids_equal_spaces permutation_only_css oddRight
    permutation_only_has_odd_stabilizer.2 permutation_only_has_odd_stabilizer.1

end CSSOddSupport.Consumers
