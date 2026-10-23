"""Exact prefixes and complete mathematical comparisons for retained examples."""
from pathlib import Path
HERE=Path(__file__).resolve().parent;LEAN=HERE.parents[1]/'dyadic-rank'

def run():
 (LEAN/'CyclicDecoderOrbit.lean').write_text('''import CyclicDecoderPersistence
namespace CyclicDecoderOrbit
open CyclicDecoderPersistence

theorem prior_clipping_identity :
    CyclicMergedMessages.clip CyclicMergedMessages.prior = CyclicMergedMessages.prior := by decide +kernel

theorem orbit_add {S : Type*} (f : S → S) (x : S) (n m : Nat) :
    orbit f x (n+m) = orbit f (orbit f x n) m := by
  induction m with
  | zero => rfl
  | succ m ih =>
    change f (orbit f x (n+m)) = f (orbit f (orbit f x n) m)
    exact congrArg f ih
end CyclicDecoderOrbit
''')
 folder=LEAN/'CyclicDecoderReachProofs';folder.mkdir(exist_ok=True)
 cases=[('','Previous',65,1804)]
 if (LEAN/'CyclicDecoderReachData/MinimumOriginal.lean').exists():cases.append(('Minimum','Minimum',86,2435))
 for suffix,base,iterations,index in cases:
  for label,last in [('Original',iterations-1),('Merged',74)]:
   ns=suffix+label;case=base+'Holdout'
   lines=[f'''import CyclicDecoderReachData.{ns}
import CyclicDecoderOrbit
import CyclicDecoderTubes.{case}
import Mathlib.Tactic.FinCases
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderReachProofs.{ns}
open CyclicDecoderReachData.{ns}
''']
   for k in range(last):lines.append(f'''
theorem step_{k} : ∀ e : E, next decoder target (state {k}) e = state {k+1} e := by
  apply checked_all
  decide +kernel
''')
   lines.append(f'''
theorem transitions : ∀ i : Fin {last}, ∀ e : E,
    next decoder target (state i.val) e = state (i.val+1) e := by
  intro i
  fin_cases i
'''+''.join(f'  · exact step_{k}\n' for k in range(last)))
   lines.append(f'''
/-- Every prefix state is reached from the fixed, already clipped initial prior. -/
theorem exact_prefix : ∀ k, k ≤ {last} →
    orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) k = state k := by
  intro k
  induction k with
  | zero => intro _; rfl
  | succ k ih =>
    intro hk
    rw [orbit, ih (by omega)]
    funext e
    exact transitions ⟨k, by omega⟩ e

theorem reject_certificate : ∀ i : Fin {last},
    CyclicMergedMessages.signs ((decoder.rows (failedChecks.get i.val)).map
      (posterior decoder target (state i.val))) ≠ target (failedChecks.get i.val) := by
  apply checked_all
  decide +kernel

theorem prefix_rejected (i : Fin {last}) : ¬Accept decoder target (state i.val) := by
  intro accepted
  exact reject_certificate i (accepted (failedChecks.get i.val))

theorem target_nonzero : target nonzeroCheck = true := by decide +kernel

theorem zero_estimate_rejected : ¬(∀ c : CyclicDecoderReachData.{ns}.C, false = target c) := by
  intro h
  have bad : false = true := (h nonzeroCheck).trans target_nonzero
  cases bad
''')
   if label=='Original':lines.append(f'''
theorem terminal_accepts : Accept decoder target (state {last}) := by
  apply checked_all
  decide +kernel

theorem terminal_exact : ∀ v : V,
    CyclicMergedMessages.decision (posterior decoder target (state {last}) v) =
      decide (v.val ∈ CyclicDecoderTubeData.{case}.errorSupport) := by
  apply checked_all
  decide +kernel

/-- The first syndrome match is update {iterations}, with exact error recovery. -/
theorem first_match_{iterations} :
    (∀ k, k < {last} → ¬Accept decoder target
      (orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) k)) ∧
    Accept decoder target (orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) {last}) := by
  constructor
  · intro k hk
    rw [exact_prefix k (by omega)]
    exact prefix_rejected ⟨k, hk⟩
  · rw [exact_prefix {last} (by omega)]
    exact terminal_accepts

theorem exact_recovery_from_prior : ∀ v : V,
    CyclicMergedMessages.decision (posterior decoder target
      (orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) {last}) v) =
      decide (v.val ∈ CyclicDecoderTubeData.{case}.errorSupport) := by
  rw [exact_prefix {last} (by omega)]
  exact terminal_exact
''')
   else:lines.append(f'''
theorem entry_agrees : ∀ e : E, state 74 e = CyclicDecoderTubeData.{case}.entry e := by
  apply checked_all
  decide +kernel

theorem beyond_entry (j : Nat) :
    orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) (74+j) =
      orbit (next decoder target) CyclicDecoderTubeData.{case}.entry j := by
  rw [CyclicDecoderOrbit.orbit_add, exact_prefix 74 (by omega), funext entry_agrees]

/-- All 100 mathematical decoder outputs reject, starting at the fixed prior. -/
theorem no_match_through_100 : ∀ k, k < 100 →
    ¬Accept decoder target (orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) k) := by
  intro k hk
  by_cases early : k < 74
  · rw [exact_prefix k (by omega)]
    exact prefix_rejected ⟨k, early⟩
  · have split : k = 74+(k-74) := by omega
    rw [split, beyond_entry]
    exact CyclicDecoderTubes.{case}.retained_entry_remaining_failure (k-74) (by omega)
''')
   lines.append(f'end CyclicDecoderReachProofs.{ns}\n')
   endpoint='exact_recovery_from_prior' if label=='Original' else 'no_match_through_100'
   lines.append(f'#print axioms CyclicDecoderReachProofs.{ns}.{endpoint}\n')
   (folder/(ns+'.lean')).write_text(''.join(lines))
 root=['import CyclicDecoderReachProofs.'+suffix+label+'\n' for suffix,base,it,index in cases for label in ['Original','Merged']]
 root.append('''
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
''')
 for suffix,base,iterations,index in cases:
  graph='CyclicDecoderOriginal'+suffix;case=base+'Holdout'
  root.append(f'''
/-- The unchanged first-match stopping rule recovers exactly in one representation and fails in the other. -/
theorem stopping_comparison_{index} :
    ExactAt {graph}.decoder {graph}.target
      (fun v => decide (v.val ∈ CyclicDecoderTubeData.{case}.errorSupport)) {iterations} ∧
    FailedWithin CyclicDecoderTubeData.{case}.decoder CyclicDecoderTubeData.{case}.target 100 := by
  constructor
  · refine ⟨by decide, CyclicDecoderReachProofs.{suffix}Original.zero_estimate_rejected, ?_, ?_, ?_⟩
    · intro k hk
      exact CyclicDecoderReachProofs.{suffix}Original.first_match_{iterations}.1 k (by omega)
    · exact CyclicDecoderReachProofs.{suffix}Original.first_match_{iterations}.2
    · exact CyclicDecoderReachProofs.{suffix}Original.exact_recovery_from_prior
  · exact ⟨CyclicDecoderReachProofs.{suffix}Merged.zero_estimate_rejected,
      CyclicDecoderReachProofs.{suffix}Merged.no_match_through_100⟩

/-- Identical full kernels preserve all syndrome-matching solution sets. -/
theorem same_solutions_{base.lower()} (error estimate : CyclicMergedWitnesses.W) :
    (∀ i : Fin 126, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.{base}.originalData i) error =
      CyclicMergedMessages.parity (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.{base}.originalData i) estimate) ↔
    (∀ i : Fin 125, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.{base}.mergedData i) error =
      CyclicMergedMessages.parity (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.{base}.mergedData i) estimate) := by
  have binary : ∀ a b : ZMod 2, a + b = 0 ↔ a = b := by decide +kernel
  have h := CyclicMergedWitnesses.{base}.kernel_equivalent (fun v => error v + estimate v)
  simpa only [CyclicMergedMessages.parity_add, binary] using h

/-- The actual parity-check representations have the same complete kernel. -/
theorem same_code_{base.lower()} : ∀ x : CyclicMergedWitnesses.W,
    (∀ i : Fin 126, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.{base}.originalData i) x = 0) ↔
    (∀ i : Fin 125, CyclicMergedMessages.parity
      (CyclicMergedWitnesses.rowSet CyclicMergedWitnesses.{base}.mergedData i) x = 0) :=
  CyclicMergedWitnesses.{base}.kernel_equivalent

theorem paired_error_{index} :
    (∀ v : V, CyclicMergedMessages.decision
      (posterior {graph}.decoder {graph}.target
        (orbit (next {graph}.decoder {graph}.target)
          (fun _ => CyclicMergedMessages.prior) {iterations-1}) v) =
        decide (v.val ∈ CyclicDecoderTubeData.{case}.errorSupport)) ∧
    (∀ k, k < 100 → ¬Accept CyclicDecoderTubeData.{case}.decoder
      CyclicDecoderTubeData.{case}.target
      (orbit (next CyclicDecoderTubeData.{case}.decoder CyclicDecoderTubeData.{case}.target)
        (fun _ => CyclicMergedMessages.prior) k)) :=
  ⟨CyclicDecoderReachProofs.{suffix}Original.exact_recovery_from_prior,
    CyclicDecoderReachProofs.{suffix}Merged.no_match_through_100⟩
''')
 root.append('end CyclicDecoderReachability\n')
 root.extend(f'#print axioms CyclicDecoderReachability.stopping_comparison_{index}\n#print axioms CyclicDecoderReachability.paired_error_{index}\n' for suffix,base,it,index in cases)
 (LEAN/'CyclicDecoderReachability.lean').write_text(''.join(root))
 print('Generated',len(cases),'original-recovery and complete merged-failure comparisons',flush=True)
if __name__=='__main__':run()
