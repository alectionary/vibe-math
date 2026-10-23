import CyclicDecoderTubeGraph
import CyclicDecoderParity
import CyclicDecoderTubeData.MinimumHoldout
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderTubes.MinimumHoldout
open CyclicDecoderTubeData.MinimumHoldout

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

theorem step_0 : ∀ e : E,
    (boxes 1 e).lo ≤ (boxNext decoder target (boxes 0) e).lo ∧
    (boxNext decoder target (boxes 0) e).hi ≤ (boxes 1 e).hi := by apply checked_all; decide +kernel

theorem step_1 : ∀ e : E,
    (boxes 2 e).lo ≤ (boxNext decoder target (boxes 1) e).lo ∧
    (boxNext decoder target (boxes 1) e).hi ≤ (boxes 2 e).hi := by apply checked_all; decide +kernel

theorem step_2 : ∀ e : E,
    (boxes 3 e).lo ≤ (boxNext decoder target (boxes 2) e).lo ∧
    (boxNext decoder target (boxes 2) e).hi ≤ (boxes 3 e).hi := by apply checked_all; decide +kernel

theorem step_3 : ∀ e : E,
    (boxes 4 e).lo ≤ (boxNext decoder target (boxes 3) e).lo ∧
    (boxNext decoder target (boxes 3) e).hi ≤ (boxes 4 e).hi := by apply checked_all; decide +kernel

theorem step_4 : ∀ e : E,
    (boxes 5 e).lo ≤ (boxNext decoder target (boxes 4) e).lo ∧
    (boxNext decoder target (boxes 4) e).hi ≤ (boxes 5 e).hi := by apply checked_all; decide +kernel

theorem step_5 : ∀ e : E,
    (boxes 6 e).lo ≤ (boxNext decoder target (boxes 5) e).lo ∧
    (boxNext decoder target (boxes 5) e).hi ≤ (boxes 6 e).hi := by apply checked_all; decide +kernel

theorem step_6 : ∀ e : E,
    (boxes 7 e).lo ≤ (boxNext decoder target (boxes 6) e).lo ∧
    (boxNext decoder target (boxes 6) e).hi ≤ (boxes 7 e).hi := by apply checked_all; decide +kernel

theorem step_7 : ∀ e : E,
    (boxes 8 e).lo ≤ (boxNext decoder target (boxes 7) e).lo ∧
    (boxNext decoder target (boxes 7) e).hi ≤ (boxes 8 e).hi := by apply checked_all; decide +kernel

theorem step_8 : ∀ e : E,
    (boxes 9 e).lo ≤ (boxNext decoder target (boxes 8) e).lo ∧
    (boxNext decoder target (boxes 8) e).hi ≤ (boxes 9 e).hi := by apply checked_all; decide +kernel

theorem step_9 : ∀ e : E,
    (boxes 10 e).lo ≤ (boxNext decoder target (boxes 9) e).lo ∧
    (boxNext decoder target (boxes 9) e).hi ≤ (boxes 10 e).hi := by apply checked_all; decide +kernel

theorem step_10 : ∀ e : E,
    (boxes 11 e).lo ≤ (boxNext decoder target (boxes 10) e).lo ∧
    (boxNext decoder target (boxes 10) e).hi ≤ (boxes 11 e).hi := by apply checked_all; decide +kernel

theorem step_11 : ∀ e : E,
    (boxes 12 e).lo ≤ (boxNext decoder target (boxes 11) e).lo ∧
    (boxNext decoder target (boxes 11) e).hi ≤ (boxes 12 e).hi := by apply checked_all; decide +kernel

theorem step_12 : ∀ e : E,
    (boxes 13 e).lo ≤ (boxNext decoder target (boxes 12) e).lo ∧
    (boxNext decoder target (boxes 12) e).hi ≤ (boxes 13 e).hi := by apply checked_all; decide +kernel

theorem step_13 : ∀ e : E,
    (boxes 14 e).lo ≤ (boxNext decoder target (boxes 13) e).lo ∧
    (boxNext decoder target (boxes 13) e).hi ≤ (boxes 14 e).hi := by apply checked_all; decide +kernel

theorem step_14 : ∀ e : E,
    (boxes 15 e).lo ≤ (boxNext decoder target (boxes 14) e).lo ∧
    (boxNext decoder target (boxes 14) e).hi ≤ (boxes 15 e).hi := by apply checked_all; decide +kernel

theorem step_15 : ∀ e : E,
    (boxes 16 e).lo ≤ (boxNext decoder target (boxes 15) e).lo ∧
    (boxNext decoder target (boxes 15) e).hi ≤ (boxes 16 e).hi := by apply checked_all; decide +kernel

theorem step_16 : ∀ e : E,
    (boxes 17 e).lo ≤ (boxNext decoder target (boxes 16) e).lo ∧
    (boxNext decoder target (boxes 16) e).hi ≤ (boxes 17 e).hi := by apply checked_all; decide +kernel

theorem step_17 : ∀ e : E,
    (boxes 18 e).lo ≤ (boxNext decoder target (boxes 17) e).lo ∧
    (boxNext decoder target (boxes 17) e).hi ≤ (boxes 18 e).hi := by apply checked_all; decide +kernel

theorem step_18 : ∀ e : E,
    (boxes 19 e).lo ≤ (boxNext decoder target (boxes 18) e).lo ∧
    (boxNext decoder target (boxes 18) e).hi ≤ (boxes 19 e).hi := by apply checked_all; decide +kernel

theorem step_19 : ∀ e : E,
    (boxes 20 e).lo ≤ (boxNext decoder target (boxes 19) e).lo ∧
    (boxNext decoder target (boxes 19) e).hi ≤ (boxes 20 e).hi := by apply checked_all; decide +kernel

theorem step_20 : ∀ e : E,
    (boxes 21 e).lo ≤ (boxNext decoder target (boxes 20) e).lo ∧
    (boxNext decoder target (boxes 20) e).hi ≤ (boxes 21 e).hi := by apply checked_all; decide +kernel

theorem step_21 : ∀ e : E,
    (boxes 22 e).lo ≤ (boxNext decoder target (boxes 21) e).lo ∧
    (boxNext decoder target (boxes 21) e).hi ≤ (boxes 22 e).hi := by apply checked_all; decide +kernel

theorem step_22 : ∀ e : E,
    (boxes 23 e).lo ≤ (boxNext decoder target (boxes 22) e).lo ∧
    (boxNext decoder target (boxes 22) e).hi ≤ (boxes 23 e).hi := by apply checked_all; decide +kernel

theorem step_23 : ∀ e : E,
    (boxes 24 e).lo ≤ (boxNext decoder target (boxes 23) e).lo ∧
    (boxNext decoder target (boxes 23) e).hi ≤ (boxes 24 e).hi := by apply checked_all; decide +kernel

theorem step_24 : ∀ e : E,
    (boxes 25 e).lo ≤ (boxNext decoder target (boxes 24) e).lo ∧
    (boxNext decoder target (boxes 24) e).hi ≤ (boxes 25 e).hi := by apply checked_all; decide +kernel

theorem transitions : ∀ i : Fin 25, ∀ e : E,
    (boxes (i.val+1) e).lo ≤ (boxNext decoder target (boxes i.val) e).lo ∧
    (boxNext decoder target (boxes i.val) e).hi ≤ (boxes (i.val+1) e).hi := by
  intro i
  fin_cases i
  · exact step_0
  · exact step_1
  · exact step_2
  · exact step_3
  · exact step_4
  · exact step_5
  · exact step_6
  · exact step_7
  · exact step_8
  · exact step_9
  · exact step_10
  · exact step_11
  · exact step_12
  · exact step_13
  · exact step_14
  · exact step_15
  · exact step_16
  · exact step_17
  · exact step_18
  · exact step_19
  · exact step_20
  · exact step_21
  · exact step_22
  · exact step_23
  · exact step_24

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
end CyclicDecoderTubes.MinimumHoldout
#print axioms CyclicDecoderTubes.MinimumHoldout.robust_remaining_failure
#print axioms CyclicDecoderTubes.MinimumHoldout.retained_entry_remaining_failure
