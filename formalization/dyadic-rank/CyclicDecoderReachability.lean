import CyclicDecoderReachProofs.Original
import CyclicDecoderReachProofs.Merged
import CyclicDecoderReachProofs.MinimumOriginal
import CyclicDecoderReachProofs.MinimumMerged

/-! Complete finite mathematical comparisons for fixed retained fresh errors.
Independent replay checks the C++ implementation bridge. No C++ semantics,
compiler or random sampler is introduced as a Lean axiom. -/
namespace CyclicDecoderReachability
open CyclicDecoderPersistence CyclicDecoderTubeData

/-- Declarative first-match semantics, including the initial zero-estimate test. -/
def ExactAt {Check : Type} (d : Decoder E V Check) (s : Check → Bool)
    (error : V → Bool) (iterations : Nat) : Prop :=
  0 < iterations ∧ (¬(∀ c, false = s c)) ∧
  (∀ k, k+1 < iterations → ¬Accept d s (orbit (next d s) (fun _ => CyclicMergedMessages.prior) k)) ∧
  Accept d s (orbit (next d s) (fun _ => CyclicMergedMessages.prior) (iterations-1)) ∧
  (∀ v, CyclicMergedMessages.decision
    (posterior d s (orbit (next d s) (fun _ => CyclicMergedMessages.prior) (iterations-1)) v) = error v)

def FailedWithin {Check : Type} (d : Decoder E V Check) (s : Check → Bool) (limit : Nat) : Prop :=
  (¬(∀ c, false = s c)) ∧
  (∀ k, k < limit → ¬Accept d s (orbit (next d s) (fun _ => CyclicMergedMessages.prior) k))

/-- The unchanged first-match stopping rule recovers exactly in one representation and fails in the other. -/
theorem stopping_comparison_1804 :
    ExactAt CyclicDecoderOriginal.decoder CyclicDecoderOriginal.target
      (fun v => decide (v.val ∈ CyclicDecoderTubeData.PreviousHoldout.errorSupport)) 65 ∧
    FailedWithin CyclicDecoderTubeData.PreviousHoldout.decoder CyclicDecoderTubeData.PreviousHoldout.target 100 := by
  constructor
  · refine ⟨by decide, CyclicDecoderReachProofs.Original.zero_estimate_rejected, ?_, ?_, ?_⟩
    · intro k hk
      exact CyclicDecoderReachProofs.Original.first_match_65.1 k (by omega)
    · exact CyclicDecoderReachProofs.Original.first_match_65.2
    · exact CyclicDecoderReachProofs.Original.exact_recovery_from_prior
  · exact ⟨CyclicDecoderReachProofs.Merged.zero_estimate_rejected,
      CyclicDecoderReachProofs.Merged.no_match_through_100⟩

/-- Identical full kernels preserve all syndrome-matching solution sets. -/
theorem same_solutions_previous (error estimate : CyclicMergedWitnesses.W) :
    (∀ i : Fin 126, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Previous.originalData i) error =
      CyclicMergedMessages.parity (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Previous.originalData i) estimate) ↔
    (∀ i : Fin 125, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Previous.mergedData i) error =
      CyclicMergedMessages.parity (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Previous.mergedData i) estimate) := by
  have binary : ∀ a b : ZMod 2, a + b = 0 ↔ a = b := by decide +kernel
  have h := CyclicMergedWitnesses.Previous.kernel_equivalent (fun v => error v + estimate v)
  simpa only [CyclicMergedMessages.parity_add, binary] using h

/-- The actual parity-check representations have the same complete kernel. -/
theorem same_code_previous : ∀ x : CyclicMergedWitnesses.W,
    (∀ i : Fin 126, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Previous.originalData i) x = 0) ↔
    (∀ i : Fin 125, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Previous.mergedData i) x = 0) :=
  CyclicMergedWitnesses.Previous.kernel_equivalent

theorem paired_error_1804 :
    (∀ v : V, CyclicMergedMessages.decision
      (posterior CyclicDecoderOriginal.decoder CyclicDecoderOriginal.target
        (orbit (next CyclicDecoderOriginal.decoder CyclicDecoderOriginal.target)
          (fun _ => CyclicMergedMessages.prior) 64) v) =
        decide (v.val ∈ CyclicDecoderTubeData.PreviousHoldout.errorSupport)) ∧
    (∀ k, k < 100 → ¬Accept CyclicDecoderTubeData.PreviousHoldout.decoder
      CyclicDecoderTubeData.PreviousHoldout.target
      (orbit (next CyclicDecoderTubeData.PreviousHoldout.decoder CyclicDecoderTubeData.PreviousHoldout.target)
        (fun _ => CyclicMergedMessages.prior) k)) :=
  ⟨CyclicDecoderReachProofs.Original.exact_recovery_from_prior,
    CyclicDecoderReachProofs.Merged.no_match_through_100⟩

/-- The unchanged first-match stopping rule recovers exactly in one representation and fails in the other. -/
theorem stopping_comparison_2435 :
    ExactAt CyclicDecoderOriginalMinimum.decoder CyclicDecoderOriginalMinimum.target
      (fun v => decide (v.val ∈ CyclicDecoderTubeData.MinimumHoldout.errorSupport)) 86 ∧
    FailedWithin CyclicDecoderTubeData.MinimumHoldout.decoder CyclicDecoderTubeData.MinimumHoldout.target 100 := by
  constructor
  · refine ⟨by decide, CyclicDecoderReachProofs.MinimumOriginal.zero_estimate_rejected, ?_, ?_, ?_⟩
    · intro k hk
      exact CyclicDecoderReachProofs.MinimumOriginal.first_match_86.1 k (by omega)
    · exact CyclicDecoderReachProofs.MinimumOriginal.first_match_86.2
    · exact CyclicDecoderReachProofs.MinimumOriginal.exact_recovery_from_prior
  · exact ⟨CyclicDecoderReachProofs.MinimumMerged.zero_estimate_rejected,
      CyclicDecoderReachProofs.MinimumMerged.no_match_through_100⟩

/-- Identical full kernels preserve all syndrome-matching solution sets. -/
theorem same_solutions_minimum (error estimate : CyclicMergedWitnesses.W) :
    (∀ i : Fin 126, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Minimum.originalData i) error =
      CyclicMergedMessages.parity (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Minimum.originalData i) estimate) ↔
    (∀ i : Fin 125, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Minimum.mergedData i) error =
      CyclicMergedMessages.parity (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Minimum.mergedData i) estimate) := by
  have binary : ∀ a b : ZMod 2, a + b = 0 ↔ a = b := by decide +kernel
  have h := CyclicMergedWitnesses.Minimum.kernel_equivalent (fun v => error v + estimate v)
  simpa only [CyclicMergedMessages.parity_add, binary] using h

/-- The actual parity-check representations have the same complete kernel. -/
theorem same_code_minimum : ∀ x : CyclicMergedWitnesses.W,
    (∀ i : Fin 126, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Minimum.originalData i) x = 0) ↔
    (∀ i : Fin 125, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.Minimum.mergedData i) x = 0) :=
  CyclicMergedWitnesses.Minimum.kernel_equivalent

theorem paired_error_2435 :
    (∀ v : V, CyclicMergedMessages.decision
      (posterior CyclicDecoderOriginalMinimum.decoder CyclicDecoderOriginalMinimum.target
        (orbit (next CyclicDecoderOriginalMinimum.decoder CyclicDecoderOriginalMinimum.target)
          (fun _ => CyclicMergedMessages.prior) 85) v) =
        decide (v.val ∈ CyclicDecoderTubeData.MinimumHoldout.errorSupport)) ∧
    (∀ k, k < 100 → ¬Accept CyclicDecoderTubeData.MinimumHoldout.decoder
      CyclicDecoderTubeData.MinimumHoldout.target
      (orbit (next CyclicDecoderTubeData.MinimumHoldout.decoder CyclicDecoderTubeData.MinimumHoldout.target)
        (fun _ => CyclicMergedMessages.prior) k)) :=
  ⟨CyclicDecoderReachProofs.MinimumOriginal.exact_recovery_from_prior,
    CyclicDecoderReachProofs.MinimumMerged.no_match_through_100⟩
end CyclicDecoderReachability
#print axioms CyclicDecoderReachability.stopping_comparison_1804
#print axioms CyclicDecoderReachability.paired_error_1804
#print axioms CyclicDecoderReachability.stopping_comparison_2435
#print axioms CyclicDecoderReachability.paired_error_2435
