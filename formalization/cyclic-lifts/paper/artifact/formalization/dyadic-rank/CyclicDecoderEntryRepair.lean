import CyclicDecoderEntryExamples

/-! Concrete counterexamples to sufficiency of an immediate source pulse for
fixed-budget failure. Each error has one bit in each source support. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderEntryRepair
open CyclicDecoderPersistence CyclicDecoderTubeData

namespace Previous
abbrev oldDecoder := CyclicDecoderEntryWitnesses.Previous.oldDecoder
abbrev newDecoder := CyclicDecoderEntryWitnesses.Previous.newDecoder
def error (v : V) : Bool := decide (v.val = 0 ∨ v.val = 33)
def target {Check : Type} (d : Decoder E V Check) (c : Check) : Bool :=
  ((d.rows c).map error).foldl Bool.xor false
abbrev oldTarget := target oldDecoder
abbrev newTarget := target newDecoder

theorem double_odd : oldTarget 0 = true ∧ oldTarget 75 = true := by
  decide +kernel

theorem old_first_recovered : ∀ v : V,
    CyclicMergedMessages.decision (posterior oldDecoder oldTarget
      (fun _ => CyclicMergedMessages.prior) v) = error v := by
  apply checked_all
  decide +kernel

theorem merged_second_recovered : ∀ v : V,
    CyclicMergedMessages.decision (posterior newDecoder newTarget
      (next newDecoder newTarget (fun _ => CyclicMergedMessages.prior)) v) = error v := by
  apply checked_all
  decide +kernel

theorem old_first_accepts : Accept oldDecoder oldTarget
    (fun _ => CyclicMergedMessages.prior) := by
  apply checked_all
  decide +kernel

theorem merged_first_rejects : ¬ Accept newDecoder newTarget
    (fun _ => CyclicMergedMessages.prior) := by
  unfold Accept
  decide +kernel

theorem merged_second_accepts : Accept newDecoder newTarget
    (next newDecoder newTarget (fun _ => CyclicMergedMessages.prior)) := by
  apply checked_all
  decide +kernel

theorem repaired_despite_immediate_pulse :
    (oldTarget 0 = true ∧ oldTarget 75 = true) ∧
    CyclicDecoderReachability.ExactAt oldDecoder oldTarget error 1 ∧
    CyclicDecoderReachability.ExactAt newDecoder newTarget error 2 := by
  refine ⟨double_odd, ?_, ?_⟩
  · refine ⟨by decide, by decide +kernel, ?_, ?_, ?_⟩
    · intro k hk; omega
    · exact old_first_accepts
    · exact old_first_recovered
  · refine ⟨by decide, by decide +kernel, ?_, ?_, ?_⟩
    · intro k hk
      have : k = 0 := by omega
      subst k
      exact merged_first_rejects
    · exact merged_second_accepts
    · exact merged_second_recovered
end Previous

namespace Minimum
abbrev oldDecoder := CyclicDecoderEntryWitnesses.Minimum.oldDecoder
abbrev newDecoder := CyclicDecoderEntryWitnesses.Minimum.newDecoder
def error (v : V) : Bool := decide (v.val = 0 ∨ v.val = 35)
def target {Check : Type} (d : Decoder E V Check) (c : Check) : Bool :=
  ((d.rows c).map error).foldl Bool.xor false
abbrev oldTarget := target oldDecoder
abbrev newTarget := target newDecoder

theorem double_odd : oldTarget 42 = true ∧ oldTarget 119 = true := by
  decide +kernel

theorem old_first_recovered : ∀ v : V,
    CyclicMergedMessages.decision (posterior oldDecoder oldTarget
      (fun _ => CyclicMergedMessages.prior) v) = error v := by
  apply checked_all
  decide +kernel

theorem merged_second_recovered : ∀ v : V,
    CyclicMergedMessages.decision (posterior newDecoder newTarget
      (next newDecoder newTarget (fun _ => CyclicMergedMessages.prior)) v) = error v := by
  apply checked_all
  decide +kernel

theorem old_first_accepts : Accept oldDecoder oldTarget
    (fun _ => CyclicMergedMessages.prior) := by
  apply checked_all
  decide +kernel

theorem merged_first_rejects : ¬ Accept newDecoder newTarget
    (fun _ => CyclicMergedMessages.prior) := by
  unfold Accept
  decide +kernel

theorem merged_second_accepts : Accept newDecoder newTarget
    (next newDecoder newTarget (fun _ => CyclicMergedMessages.prior)) := by
  apply checked_all
  decide +kernel

theorem repaired_despite_immediate_pulse :
    (oldTarget 42 = true ∧ oldTarget 119 = true) ∧
    CyclicDecoderReachability.ExactAt oldDecoder oldTarget error 1 ∧
    CyclicDecoderReachability.ExactAt newDecoder newTarget error 2 := by
  refine ⟨double_odd, ?_, ?_⟩
  · refine ⟨by decide, by decide +kernel, ?_, ?_, ?_⟩
    · intro k hk; omega
    · exact old_first_accepts
    · exact old_first_recovered
  · refine ⟨by decide, by decide +kernel, ?_, ?_, ?_⟩
    · intro k hk
      have : k = 0 := by omega
      subst k
      exact merged_first_rejects
    · exact merged_second_accepts
    · exact merged_second_recovered
end Minimum
end CyclicDecoderEntryRepair
#print axioms CyclicDecoderEntryRepair.Previous.repaired_despite_immediate_pulse
#print axioms CyclicDecoderEntryRepair.Minimum.repaired_despite_immediate_pulse
