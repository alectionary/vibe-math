import CyclicDecoderTubeData
import Mathlib.Tactic.FinCases
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderTubeGraph
namespace Previous
abbrev decoder := CyclicDecoderTubeData.Previous.decoder
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
end Previous
namespace Minimum
abbrev decoder := CyclicDecoderTubeData.Minimum.decoder
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
end Minimum
end CyclicDecoderTubeGraph
