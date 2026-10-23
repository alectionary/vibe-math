import CyclicDecoderReachData.Merged
import CyclicDecoderOrbit
import CyclicDecoderTubes.PreviousHoldout
import Mathlib.Tactic.FinCases
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderReachProofs.Merged
open CyclicDecoderReachData.Merged

theorem step_0 : ∀ e : E, next decoder target (state 0) e = state 1 e := by
  apply checked_all
  decide +kernel

theorem step_1 : ∀ e : E, next decoder target (state 1) e = state 2 e := by
  apply checked_all
  decide +kernel

theorem step_2 : ∀ e : E, next decoder target (state 2) e = state 3 e := by
  apply checked_all
  decide +kernel

theorem step_3 : ∀ e : E, next decoder target (state 3) e = state 4 e := by
  apply checked_all
  decide +kernel

theorem step_4 : ∀ e : E, next decoder target (state 4) e = state 5 e := by
  apply checked_all
  decide +kernel

theorem step_5 : ∀ e : E, next decoder target (state 5) e = state 6 e := by
  apply checked_all
  decide +kernel

theorem step_6 : ∀ e : E, next decoder target (state 6) e = state 7 e := by
  apply checked_all
  decide +kernel

theorem step_7 : ∀ e : E, next decoder target (state 7) e = state 8 e := by
  apply checked_all
  decide +kernel

theorem step_8 : ∀ e : E, next decoder target (state 8) e = state 9 e := by
  apply checked_all
  decide +kernel

theorem step_9 : ∀ e : E, next decoder target (state 9) e = state 10 e := by
  apply checked_all
  decide +kernel

theorem step_10 : ∀ e : E, next decoder target (state 10) e = state 11 e := by
  apply checked_all
  decide +kernel

theorem step_11 : ∀ e : E, next decoder target (state 11) e = state 12 e := by
  apply checked_all
  decide +kernel

theorem step_12 : ∀ e : E, next decoder target (state 12) e = state 13 e := by
  apply checked_all
  decide +kernel

theorem step_13 : ∀ e : E, next decoder target (state 13) e = state 14 e := by
  apply checked_all
  decide +kernel

theorem step_14 : ∀ e : E, next decoder target (state 14) e = state 15 e := by
  apply checked_all
  decide +kernel

theorem step_15 : ∀ e : E, next decoder target (state 15) e = state 16 e := by
  apply checked_all
  decide +kernel

theorem step_16 : ∀ e : E, next decoder target (state 16) e = state 17 e := by
  apply checked_all
  decide +kernel

theorem step_17 : ∀ e : E, next decoder target (state 17) e = state 18 e := by
  apply checked_all
  decide +kernel

theorem step_18 : ∀ e : E, next decoder target (state 18) e = state 19 e := by
  apply checked_all
  decide +kernel

theorem step_19 : ∀ e : E, next decoder target (state 19) e = state 20 e := by
  apply checked_all
  decide +kernel

theorem step_20 : ∀ e : E, next decoder target (state 20) e = state 21 e := by
  apply checked_all
  decide +kernel

theorem step_21 : ∀ e : E, next decoder target (state 21) e = state 22 e := by
  apply checked_all
  decide +kernel

theorem step_22 : ∀ e : E, next decoder target (state 22) e = state 23 e := by
  apply checked_all
  decide +kernel

theorem step_23 : ∀ e : E, next decoder target (state 23) e = state 24 e := by
  apply checked_all
  decide +kernel

theorem step_24 : ∀ e : E, next decoder target (state 24) e = state 25 e := by
  apply checked_all
  decide +kernel

theorem step_25 : ∀ e : E, next decoder target (state 25) e = state 26 e := by
  apply checked_all
  decide +kernel

theorem step_26 : ∀ e : E, next decoder target (state 26) e = state 27 e := by
  apply checked_all
  decide +kernel

theorem step_27 : ∀ e : E, next decoder target (state 27) e = state 28 e := by
  apply checked_all
  decide +kernel

theorem step_28 : ∀ e : E, next decoder target (state 28) e = state 29 e := by
  apply checked_all
  decide +kernel

theorem step_29 : ∀ e : E, next decoder target (state 29) e = state 30 e := by
  apply checked_all
  decide +kernel

theorem step_30 : ∀ e : E, next decoder target (state 30) e = state 31 e := by
  apply checked_all
  decide +kernel

theorem step_31 : ∀ e : E, next decoder target (state 31) e = state 32 e := by
  apply checked_all
  decide +kernel

theorem step_32 : ∀ e : E, next decoder target (state 32) e = state 33 e := by
  apply checked_all
  decide +kernel

theorem step_33 : ∀ e : E, next decoder target (state 33) e = state 34 e := by
  apply checked_all
  decide +kernel

theorem step_34 : ∀ e : E, next decoder target (state 34) e = state 35 e := by
  apply checked_all
  decide +kernel

theorem step_35 : ∀ e : E, next decoder target (state 35) e = state 36 e := by
  apply checked_all
  decide +kernel

theorem step_36 : ∀ e : E, next decoder target (state 36) e = state 37 e := by
  apply checked_all
  decide +kernel

theorem step_37 : ∀ e : E, next decoder target (state 37) e = state 38 e := by
  apply checked_all
  decide +kernel

theorem step_38 : ∀ e : E, next decoder target (state 38) e = state 39 e := by
  apply checked_all
  decide +kernel

theorem step_39 : ∀ e : E, next decoder target (state 39) e = state 40 e := by
  apply checked_all
  decide +kernel

theorem step_40 : ∀ e : E, next decoder target (state 40) e = state 41 e := by
  apply checked_all
  decide +kernel

theorem step_41 : ∀ e : E, next decoder target (state 41) e = state 42 e := by
  apply checked_all
  decide +kernel

theorem step_42 : ∀ e : E, next decoder target (state 42) e = state 43 e := by
  apply checked_all
  decide +kernel

theorem step_43 : ∀ e : E, next decoder target (state 43) e = state 44 e := by
  apply checked_all
  decide +kernel

theorem step_44 : ∀ e : E, next decoder target (state 44) e = state 45 e := by
  apply checked_all
  decide +kernel

theorem step_45 : ∀ e : E, next decoder target (state 45) e = state 46 e := by
  apply checked_all
  decide +kernel

theorem step_46 : ∀ e : E, next decoder target (state 46) e = state 47 e := by
  apply checked_all
  decide +kernel

theorem step_47 : ∀ e : E, next decoder target (state 47) e = state 48 e := by
  apply checked_all
  decide +kernel

theorem step_48 : ∀ e : E, next decoder target (state 48) e = state 49 e := by
  apply checked_all
  decide +kernel

theorem step_49 : ∀ e : E, next decoder target (state 49) e = state 50 e := by
  apply checked_all
  decide +kernel

theorem step_50 : ∀ e : E, next decoder target (state 50) e = state 51 e := by
  apply checked_all
  decide +kernel

theorem step_51 : ∀ e : E, next decoder target (state 51) e = state 52 e := by
  apply checked_all
  decide +kernel

theorem step_52 : ∀ e : E, next decoder target (state 52) e = state 53 e := by
  apply checked_all
  decide +kernel

theorem step_53 : ∀ e : E, next decoder target (state 53) e = state 54 e := by
  apply checked_all
  decide +kernel

theorem step_54 : ∀ e : E, next decoder target (state 54) e = state 55 e := by
  apply checked_all
  decide +kernel

theorem step_55 : ∀ e : E, next decoder target (state 55) e = state 56 e := by
  apply checked_all
  decide +kernel

theorem step_56 : ∀ e : E, next decoder target (state 56) e = state 57 e := by
  apply checked_all
  decide +kernel

theorem step_57 : ∀ e : E, next decoder target (state 57) e = state 58 e := by
  apply checked_all
  decide +kernel

theorem step_58 : ∀ e : E, next decoder target (state 58) e = state 59 e := by
  apply checked_all
  decide +kernel

theorem step_59 : ∀ e : E, next decoder target (state 59) e = state 60 e := by
  apply checked_all
  decide +kernel

theorem step_60 : ∀ e : E, next decoder target (state 60) e = state 61 e := by
  apply checked_all
  decide +kernel

theorem step_61 : ∀ e : E, next decoder target (state 61) e = state 62 e := by
  apply checked_all
  decide +kernel

theorem step_62 : ∀ e : E, next decoder target (state 62) e = state 63 e := by
  apply checked_all
  decide +kernel

theorem step_63 : ∀ e : E, next decoder target (state 63) e = state 64 e := by
  apply checked_all
  decide +kernel

theorem step_64 : ∀ e : E, next decoder target (state 64) e = state 65 e := by
  apply checked_all
  decide +kernel

theorem step_65 : ∀ e : E, next decoder target (state 65) e = state 66 e := by
  apply checked_all
  decide +kernel

theorem step_66 : ∀ e : E, next decoder target (state 66) e = state 67 e := by
  apply checked_all
  decide +kernel

theorem step_67 : ∀ e : E, next decoder target (state 67) e = state 68 e := by
  apply checked_all
  decide +kernel

theorem step_68 : ∀ e : E, next decoder target (state 68) e = state 69 e := by
  apply checked_all
  decide +kernel

theorem step_69 : ∀ e : E, next decoder target (state 69) e = state 70 e := by
  apply checked_all
  decide +kernel

theorem step_70 : ∀ e : E, next decoder target (state 70) e = state 71 e := by
  apply checked_all
  decide +kernel

theorem step_71 : ∀ e : E, next decoder target (state 71) e = state 72 e := by
  apply checked_all
  decide +kernel

theorem step_72 : ∀ e : E, next decoder target (state 72) e = state 73 e := by
  apply checked_all
  decide +kernel

theorem step_73 : ∀ e : E, next decoder target (state 73) e = state 74 e := by
  apply checked_all
  decide +kernel

theorem transitions : ∀ i : Fin 74, ∀ e : E,
    next decoder target (state i.val) e = state (i.val+1) e := by
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
  · exact step_25
  · exact step_26
  · exact step_27
  · exact step_28
  · exact step_29
  · exact step_30
  · exact step_31
  · exact step_32
  · exact step_33
  · exact step_34
  · exact step_35
  · exact step_36
  · exact step_37
  · exact step_38
  · exact step_39
  · exact step_40
  · exact step_41
  · exact step_42
  · exact step_43
  · exact step_44
  · exact step_45
  · exact step_46
  · exact step_47
  · exact step_48
  · exact step_49
  · exact step_50
  · exact step_51
  · exact step_52
  · exact step_53
  · exact step_54
  · exact step_55
  · exact step_56
  · exact step_57
  · exact step_58
  · exact step_59
  · exact step_60
  · exact step_61
  · exact step_62
  · exact step_63
  · exact step_64
  · exact step_65
  · exact step_66
  · exact step_67
  · exact step_68
  · exact step_69
  · exact step_70
  · exact step_71
  · exact step_72
  · exact step_73

/-- Every prefix state is reached from the fixed, already clipped initial prior. -/
theorem exact_prefix : ∀ k, k ≤ 74 →
    orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) k = state k := by
  intro k
  induction k with
  | zero => intro _; rfl
  | succ k ih =>
    intro hk
    rw [orbit, ih (by omega)]
    funext e
    exact transitions ⟨k, by omega⟩ e

theorem reject_certificate : ∀ i : Fin 74,
    CyclicMergedMessages.signs ((decoder.rows (failedChecks.get i.val)).map
      (posterior decoder target (state i.val))) ≠ target (failedChecks.get i.val) := by
  apply checked_all
  decide +kernel

theorem prefix_rejected (i : Fin 74) : ¬Accept decoder target (state i.val) := by
  intro accepted
  exact reject_certificate i (accepted (failedChecks.get i.val))

theorem target_nonzero : target nonzeroCheck = true := by decide +kernel

theorem zero_estimate_rejected : ¬(∀ c : CyclicDecoderReachData.Merged.C, false = target c) := by
  intro h
  have bad : false = true := (h nonzeroCheck).trans target_nonzero
  cases bad

theorem entry_agrees : ∀ e : E, state 74 e = CyclicDecoderTubeData.PreviousHoldout.entry e := by
  apply checked_all
  decide +kernel

theorem beyond_entry (j : Nat) :
    orbit (next decoder target) (fun _ => CyclicMergedMessages.prior) (74+j) =
      orbit (next decoder target) CyclicDecoderTubeData.PreviousHoldout.entry j := by
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
    exact CyclicDecoderTubes.PreviousHoldout.retained_entry_remaining_failure (k-74) (by omega)
end CyclicDecoderReachProofs.Merged
#print axioms CyclicDecoderReachProofs.Merged.no_match_through_100
