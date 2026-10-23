import CyclicDecoderEntryExamples

/-! Exact delayed activation of a previously even source pair. The same first
extrinsic state gives different second check messages because the merged check
sees a negative message from the other source half. This certifies local entry,
not sufficiency of that one message for the final failure. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderEntryDelayed
open CyclicDecoderPersistence CyclicDecoderTubeData
open CyclicDecoderEntryWitnesses.Minimum

def q0 : E → Int := fun _ => CyclicMergedMessages.prior

theorem even_sources : oldTarget 42 = false ∧ oldTarget 119 = false := by
  decide +kernel

theorem same_first_state : ∀ e : E,
    next oldDecoder oldTarget q0 e = next newDecoder newTarget q0 (edgeMap e) :=
  CyclicDecoderEntryExamples.Minimum.same_first_extrinsic

theorem foreign_location : oldDecoder.edgeCheck (257 : E) = (42 : Fin 126) ∧
    oldDecoder.edgeVariable (257 : E) = (196 : V) := by
  decide +kernel

theorem negative_foreign_input : next oldDecoder oldTarget q0 (257 : E) = -1999459 := by
  decide +kernel

theorem witness_location : oldDecoder.edgeCheck (714 : E) = (119 : Fin 126) ∧
    oldDecoder.edgeVariable (714 : E) = (35 : V) ∧ edgeMap (714 : E) = (253 : E) := by
  decide +kernel

theorem foreign_enters_only_merged_check :
    edgeMap (257 : E) ∈ incomingEdges newDecoder (253 : E) ∧
    (257 : E) ∉ incomingEdges oldDecoder (714 : E) := by
  decide +kernel

theorem old_second_inputs :
    (incomingEdges oldDecoder (714 : E)).map (next oldDecoder oldTarget q0) =
      [3332431, 8664321, 8664321, 8664321, 8664321] := by
  decide +kernel

theorem merged_second_inputs :
    (incomingEdges newDecoder (253 : E)).map (next newDecoder newTarget q0) =
      [3332431, 3332431, 3332431, 8664321, 8664321,
       3332431, 3332431, -1999459, 8664321, 8664321, 8664321] := by
  decide +kernel

theorem old_second_message : messages oldDecoder oldTarget
    (next oldDecoder oldTarget q0) (714 : E) = 2665945 := by
  decide +kernel

theorem merged_second_message : messages newDecoder newTarget
    (next newDecoder newTarget q0) (253 : E) = -1599567 := by
  decide +kernel

theorem same_second_word : ∀ v : V,
    CyclicMergedMessages.decision
      (posterior oldDecoder oldTarget (next oldDecoder oldTarget q0) v) =
    CyclicMergedMessages.decision
      (posterior newDecoder newTarget (next newDecoder newTarget q0) v) := by
  apply checked_all
  decide +kernel

/-- At this update precisely the six outputs of original check 119 change. -/
theorem second_difference_iff : ∀ e : E,
    (messages oldDecoder oldTarget (next oldDecoder oldTarget q0) e ≠
      messages newDecoder newTarget (next newDecoder newTarget q0) (edgeMap e)) ↔
    oldDecoder.edgeCheck e = (119 : Fin 126) := by
  apply checked_all
  decide +kernel

theorem second_difference_count :
    (List.ofFn (fun e : E => decide
      (messages oldDecoder oldTarget (next oldDecoder oldTarget q0) e ≠
       messages newDecoder newTarget (next newDecoder newTarget q0) (edgeMap e)))).count true = 6 := by
  simp only [second_difference_iff]
  decide +kernel

/-- Local delayed entry and complete eventual outcomes coexist in the same
fixed physical error. The one message is not asserted to mediate all failure. -/
theorem delayed_sign_reversal_and_stopping :
    (∀ e : E, next oldDecoder oldTarget q0 e =
      next newDecoder newTarget q0 (edgeMap e)) ∧
    messages oldDecoder oldTarget (next oldDecoder oldTarget q0) (714 : E) = 2665945 ∧
    messages newDecoder newTarget (next newDecoder newTarget q0) (253 : E) = -1599567 ∧
    CyclicDecoderReachability.ExactAt oldDecoder oldTarget
      (fun v => decide (v.val ∈ CyclicDecoderTubeData.MinimumHoldout.errorSupport)) 86 ∧
    CyclicDecoderReachability.FailedWithin newDecoder newTarget 100 := by
  exact ⟨same_first_state, old_second_message, merged_second_message,
    CyclicDecoderReachability.stopping_comparison_2435⟩
end CyclicDecoderEntryDelayed
#print axioms CyclicDecoderEntryDelayed.same_second_word
#print axioms CyclicDecoderEntryDelayed.delayed_sign_reversal_and_stopping
