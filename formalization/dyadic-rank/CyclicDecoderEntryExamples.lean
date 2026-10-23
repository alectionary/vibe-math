import CyclicDecoderEntryBridge

/-! Two complete fixed-error entry mechanisms, joined to the existing checked
100-update stopping comparisons. No claim of aggregate explanatory coverage. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderEntryExamples
open CyclicDecoderPersistence CyclicDecoderTubeData

namespace Previous
open CyclicDecoderEntryWitnesses.Previous

/-- All first-round hard decisions agree, despite different internal messages. -/
theorem same_first_word : ∀ v : V,
    CyclicMergedMessages.decision (posterior oldDecoder oldTarget
      (fun _ => CyclicMergedMessages.prior) v) =
    CyclicMergedMessages.decision (posterior newDecoder newTarget
      (fun _ => CyclicMergedMessages.prior) v) := by
  apply checked_all
  decide +kernel

theorem initial_source_active : (oldTarget 0 || oldTarget 75) = true := by
  decide +kernel

theorem different_first_extrinsic :
    next oldDecoder oldTarget (fun _ => CyclicMergedMessages.prior) (87 : E) ≠
    next newDecoder newTarget (fun _ => CyclicMergedMessages.prior) (edgeMap (87 : E)) := by
  decide +kernel

/-- A soft-only initial pulse, later inherited hard-decision change, and the
complete fixed-budget success/failure comparison occur in this same error. -/
theorem soft_only_entry_to_fixed_budget_failure :
    (∀ v : V,
      CyclicMergedMessages.decision (posterior oldDecoder oldTarget
        (fun _ => CyclicMergedMessages.prior) v) =
      CyclicMergedMessages.decision (posterior newDecoder newTarget
        (fun _ => CyclicMergedMessages.prior) v)) ∧
    (next oldDecoder oldTarget (fun _ => CyclicMergedMessages.prior) (87 : E) ≠
      next newDecoder newTarget (fun _ => CyclicMergedMessages.prior) (edgeMap (87 : E))) ∧
    CyclicDecoderReachability.ExactAt oldDecoder oldTarget
      (fun v => decide (v.val ∈ CyclicDecoderTubeData.PreviousHoldout.errorSupport)) 65 ∧
    CyclicDecoderReachability.FailedWithin newDecoder newTarget 100 := by
  exact ⟨same_first_word, different_first_extrinsic,
    CyclicDecoderReachability.stopping_comparison_1804⟩
end Previous

namespace Minimum
open CyclicDecoderEntryWitnesses.Minimum

theorem target_translation : ∀ c : C,
    CyclicDecoderEntryBridge.Minimum.liftedTarget oldTarget c = newTarget c := by
  apply checked_all
  decide +kernel

/-- Here even the full first extrinsic state agrees; the perturbation is activated later. -/
theorem same_first_extrinsic : ∀ e : E,
    next oldDecoder oldTarget (fun _ => CyclicMergedMessages.prior) e =
    next newDecoder newTarget (fun _ => CyclicMergedMessages.prior) (edgeMap e) := by
  intro e
  have h := CyclicDecoderEntryBridge.Minimum.inactive_next_agrees oldTarget
    (by decide +kernel) (by decide +kernel) e
  have target_eq : CyclicDecoderEntryBridge.Minimum.liftedTarget oldTarget = newTarget :=
    funext target_translation
  simpa only [target_eq] using h

theorem delayed_entry_to_fixed_budget_failure :
    (∀ e : E,
      next oldDecoder oldTarget (fun _ => CyclicMergedMessages.prior) e =
      next newDecoder newTarget (fun _ => CyclicMergedMessages.prior) (edgeMap e)) ∧
    CyclicDecoderReachability.ExactAt oldDecoder oldTarget
      (fun v => decide (v.val ∈ CyclicDecoderTubeData.MinimumHoldout.errorSupport)) 86 ∧
    CyclicDecoderReachability.FailedWithin newDecoder newTarget 100 := by
  exact ⟨same_first_extrinsic, CyclicDecoderReachability.stopping_comparison_2435⟩
end Minimum
end CyclicDecoderEntryExamples
#print axioms CyclicDecoderEntryExamples.Previous.soft_only_entry_to_fixed_budget_failure
#print axioms CyclicDecoderEntryExamples.Minimum.delayed_entry_to_fixed_budget_failure
