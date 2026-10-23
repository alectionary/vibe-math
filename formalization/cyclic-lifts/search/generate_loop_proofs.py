"""Generate kernel-checkable graph links and complete 26-update tube proofs."""
from pathlib import Path
import json
HERE=Path(__file__).resolve().parent;LEAN=HERE.parents[1]/'dyadic-rank'

def run():
 records=json.loads((HERE/'loop-lean-witnesses.json').read_text())['records']
 header='''import CyclicDecoderTubeData
import Mathlib.Tactic.FinCases
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderTubeGraph
'''
 chunks=[header]
 for ns in ['Previous','Minimum']:
  chunks.append(f'''namespace {ns}
abbrev decoder := CyclicDecoderTubeData.{ns}.decoder
/-- The check edges are exactly the previously certified actual matrix rows. -/
theorem matrix_rows : ∀ c : C,
    (decoder.checks c).map decoder.edgeVariable = decoder.rows c := by apply checked_all; decide +kernel

theorem check_labels : ∀ c : C,
    (decoder.checks c).all (fun e => decide (decoder.edgeCheck e = c)) = true := by apply checked_all; decide +kernel

theorem check_present : ∀ e : E, e ∈ decoder.checks (decoder.edgeCheck e) := by apply checked_all; decide +kernel

theorem incident_unique : ∀ v : V, (decoder.incident v).Nodup := by apply checked_all; decide +kernel

theorem incident_labels : ∀ v : V,
    (decoder.incident v).all (fun e => decide (decoder.edgeVariable e = v)) = true := by apply checked_all; decide +kernel

theorem incident_present : ∀ e : E, e ∈ decoder.incident (decoder.edgeVariable e) := by apply checked_all; decide +kernel

/-- The model's variable update agrees with posterior-minus-own at every actual edge. -/
theorem actual_variable_update (s : C → Bool) (q : E → Int) (e : E) :
    next decoder s q e = CyclicMergedMessages.clip
      (posterior decoder s q (decoder.edgeVariable e) - messages decoder s q e) :=
  next_eq_posterior_sub decoder s q e
    (incident_unique (decoder.edgeVariable e)) (incident_present e)
end {ns}
''')
 chunks.append('end CyclicDecoderTubeGraph\n')
 (LEAN/'CyclicDecoderTubeGraph.lean').write_text(''.join(chunks))
 folder=LEAN/'CyclicDecoderTubes';folder.mkdir(exist_ok=True)
 modules=[]
 for record in records:
  ns=record['namespace'];base='Previous' if ns.startswith('Previous') else 'Minimum'
  lines=[f'''import CyclicDecoderTubeGraph
import CyclicDecoderParity
import CyclicDecoderTubeData.{ns}
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderTubes.{ns}
open CyclicDecoderTubeData.{ns}

/-- The target syndrome comes from the retained error on the actual matrix. -/
theorem target_matches_error : ∀ c : C,
    target c = CyclicMergedMessages.signs ((decoder.rows c).map
      (fun v => if v.val ∈ errorSupport then (-1 : Int) else 1)) := by apply checked_all; decide +kernel

theorem entry_in_box : InBox (boxes 0) entry := by apply checked_all; decide +kernel

/-- Independent perturbations up to one integer unit, with the original clipping. -/
def NearEntry (q : E → Int) : Prop := ∀ e,
    max (-(CyclicMergedMessages.cap : Int)) (entry e - 1) ≤ q e ∧
    q e ≤ min (CyclicMergedMessages.cap : Int) (entry e + 1)

theorem neighborhood_data : ∀ e : E,
    (boxes 0 e).lo = max (-(CyclicMergedMessages.cap : Int)) (entry e - 1) ∧
    (boxes 0 e).hi = min (CyclicMergedMessages.cap : Int) (entry e + 1) := by apply checked_all; decide +kernel

theorem near_entry_in_box (q : E → Int) (h : NearEntry q) : InBox (boxes 0) q := by
  intro e
  rw [In, (neighborhood_data e).1, (neighborhood_data e).2]
  exact h e
''']
  for k in range(25):
   lines.append(f'''\ntheorem step_{k} : ∀ e : E,
    (boxes {k+1} e).lo ≤ (boxNext decoder target (boxes {k}) e).lo ∧
    (boxNext decoder target (boxes {k}) e).hi ≤ (boxes {k+1} e).hi := by apply checked_all; decide +kernel
''')
  lines.append('''
theorem transitions : ∀ i : Fin 25, ∀ e : E,
    (boxes (i.val+1) e).lo ≤ (boxNext decoder target (boxes i.val) e).lo ∧
    (boxNext decoder target (boxes i.val) e).hi ≤ (boxes (i.val+1) e).hi := by
  intro i
  fin_cases i
'''+''.join(f'  · exact step_{k}\n' for k in range(25)))
  if record.get('alternating_pair'):
   lines.append('''
/-- The local two-variable alternation is uniform over every enclosed state. -/
theorem local_pattern_certificate : ∀ i : Fin 26,
    (decoder.rows pinnedCheck).all (fun v => decide
      (signRange (boxPosterior decoder target (boxes i.val) v) =
        some (localPattern i.val v))) = true := by apply checked_all; decide +kernel

theorem local_changes_even : ∀ i : Fin 25,
    CyclicDecoderParity.bitParity (decoder.rows pinnedCheck)
      (fun v => localPattern i.val v ^^ localPattern (i.val+1) v) = false := by
  apply checked_all
  decide +kernel

theorem pattern_wrong_throughout : ∀ k, k ≤ 25 →
    CyclicDecoderParity.bitParity (decoder.rows pinnedCheck) (localPattern k) ≠ target pinnedCheck := by
  apply CyclicDecoderParity.wrong_parity_persists (decoder.rows pinnedCheck) localPattern
    (target pinnedCheck) 25
  · decide +kernel
  · intro k hk
    exact local_changes_even ⟨k, hk⟩

theorem enclosed_local_pattern (q : E → Int) (h : InBox (boxes 0) q) :
    ∀ k, k ≤ 25 → ∀ v ∈ decoder.rows pinnedCheck,
      CyclicMergedMessages.decision (posterior decoder target (orbit (next decoder target) q k) v) =
        localPattern k v := by
  have inside := tube_contains decoder target boxes q 25 h
    (fun k hk e => transitions ⟨k, hk⟩ e)
  intro k hk v hv
  have known : signRange (boxPosterior decoder target (boxes k) v) = some (localPattern k v) :=
    of_decide_eq_true (List.all_eq_true.mp (local_pattern_certificate ⟨k, by omega⟩) v hv)
  exact signRange_sound _ _ (boxPosterior_sound decoder target (boxes k) _ (inside k hk) v) _ known
''')
  lines.append('''
/-- One actual check has the wrong parity throughout all 26 enclosed updates. -/
theorem pinned_check : ∀ i : Fin 26,
    knownSign ((decoder.rows pinnedCheck).map (boxPosterior decoder target (boxes i.val))) =
      some (!(target pinnedCheck)) := by apply checked_all; decide +kernel

/-- Every state in the supplied box fails syndrome acceptance for updates 75..100. -/
theorem tube_failure (q : E → Int) (h : InBox (boxes 0) q) :
    ∀ k, k ≤ 25 → ¬Accept decoder target (orbit (next decoder target) q k) := by
  apply tube_rejects decoder target boxes q 25 h
  · intro k hk e
    exact transitions ⟨k, hk⟩ e
  · intro k hk
    refine ⟨pinnedCheck, !(target pinnedCheck), pinned_check ⟨k, by omega⟩, ?_⟩
    cases hbit : target pinnedCheck <;> simp [hbit]

theorem robust_remaining_failure (q : E → Int) (h : NearEntry q) :
    ∀ k, k ≤ 25 → ¬Accept decoder target (orbit (next decoder target) q k) :=
  tube_failure q (near_entry_in_box q h)

theorem retained_entry_remaining_failure :
    ∀ k, k ≤ 25 → ¬Accept decoder target (orbit (next decoder target) entry k) :=
  tube_failure entry entry_in_box
''')
  lines.append(f'''end CyclicDecoderTubes.{ns}
#print axioms CyclicDecoderTubes.{ns}.robust_remaining_failure
#print axioms CyclicDecoderTubes.{ns}.retained_entry_remaining_failure
''')
  (folder/(ns+'.lean')).write_text(''.join(lines));modules.append('CyclicDecoderTubes.'+ns)
 (LEAN/'CyclicDecoderTubes.lean').write_text(''.join('import '+m+'\n' for m in modules))
 print('Generated graph bridges and',len(modules),'complete tube proof modules',flush=True)
if __name__=='__main__':run()
