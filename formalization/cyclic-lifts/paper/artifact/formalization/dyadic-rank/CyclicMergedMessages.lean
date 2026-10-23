import Mathlib.Data.Int.Basic
import Mathlib.Data.List.MinMax
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases

/-! Exact fixed-point check-message mechanisms for the frozen cyclic merger.
These are local update theorems and syndrome-obstruction theorems, not a
formal verification of the C++ program or its full 100-iteration executions. -/
set_option maxRecDepth 20000
set_option maxHeartbeats 8000000
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace CyclicMergedMessages

def cap : Nat := 50 * 2^20
def sentinel : Nat := 1000 * 2^20
def prior : Int := 3332431

def signs : List Int → Bool
  | [] => false
  | x :: xs => decide (x < 0) ^^ signs xs

def magnitude : List Int → Nat
  | [] => sentinel
  | x :: xs => min x.natAbs (magnitude xs)

/-- Alpha 0.8, integer rounding, and the original absolute clip. -/
def normalize (m : Nat) : Nat := min cap ((800*m+500)/1000)

def signed (negative : Bool) (m : Nat) : Int :=
  if negative then -(m : Int) else (m : Int)

def clip (x : Int) : Int := max (-(cap : Int)) (min (cap : Int) x)

def check (syndrome : Bool) (incoming : List Int) : Int :=
  signed (syndrome ^^ signs incoming) (normalize (magnitude incoming))

theorem signs_append (xs ys : List Int) : signs (xs ++ ys) = (signs xs ^^ signs ys) := by
  induction xs with
  | nil => simp [signs]
  | cons x xs ih => simp [signs, ih, Bool.xor_assoc]

theorem magnitude_le_sentinel (xs : List Int) : magnitude xs ≤ sentinel := by
  induction xs with
  | nil => exact le_rfl
  | cons x xs ih => exact le_trans (min_le_right _ _) ih

theorem magnitude_append (xs ys : List Int) :
    magnitude (xs ++ ys) = min (magnitude xs) (magnitude ys) := by
  induction xs with
  | nil => simp [magnitude, min_eq_right (magnitude_le_sentinel ys)]
  | cons x xs ih => simp [magnitude, ih, min_assoc]

theorem normalize_mono {a b : Nat} (h : a ≤ b) : normalize a ≤ normalize b := by
  unfold normalize
  apply min_le_min_left
  omega

theorem normalize_zero : normalize 0 = 0 := by decide

theorem signed_natAbs (s : Bool) (m : Nat) : (signed s m).natAbs = m := by
  cases s <;> simp [signed]

theorem signed_xor (s t : Bool) (m : Nat) :
    signed (s ^^ t) m = if t then -(signed s m) else signed s m := by
  cases s <;> cases t <;> simp [signed]

theorem xor_shuffle (a b c d : Bool) : ((a ^^ b) ^^ (c ^^ d)) = ((a ^^ c) ^^ (b ^^ d)) := by
  cases a <;> cases b <;> cases c <;> cases d <;> decide

/-- Same clipping equation as the original C++ check-message update. -/
theorem check_clip_equation (s : Bool) (xs : List Int) :
    check s xs = clip (signed (s ^^ signs xs) ((800*magnitude xs+500)/1000)) := by
  unfold check normalize
  generalize (s ^^ signs xs) = t
  generalize (800 * magnitude xs + 500) / 1000 = k
  cases t <;> simp only [signed, Bool.false_eq_true, ↓reduceIte,
    clip, cap] <;> omega

/-- An excluded own-side list and the full opposite-side list factor exactly. -/
theorem merged_message (sa sb : Bool) (xs ys : List Int) :
    check (sa ^^ sb) (xs ++ ys) =
      signed ((sa ^^ signs xs) ^^ (sb ^^ signs ys))
        (normalize (min (magnitude xs) (magnitude ys))) := by
  unfold check
  rw [signs_append, magnitude_append, xor_shuffle sa sb (signs xs) (signs ys)]

/-- Joining checks never increases a message magnitude at the same input state. -/
theorem merged_magnitude_le (sa sb : Bool) (xs ys : List Int) :
    (check (sa ^^ sb) (xs ++ ys)).natAbs ≤ (check sa xs).natAbs := by
  rw [merged_message]
  simp only [check, signed_natAbs]
  exact normalize_mono (min_le_left _ _)

theorem unchanged_when_other_even_and_not_weaker (sa sb : Bool) (xs ys : List Int)
    (heven : (sb ^^ signs ys) = false) (hmin : magnitude xs ≤ magnitude ys) :
    check (sa ^^ sb) (xs ++ ys) = check sa xs := by
  rw [merged_message, heven, min_eq_left hmin]
  simp [check]

theorem reversal_when_other_odd_and_not_weaker (sa sb : Bool) (xs ys : List Int)
    (hodd : (sb ^^ signs ys) = true) (hmin : magnitude xs ≤ magnitude ys) :
    check (sa ^^ sb) (xs ++ ys) = -(check sa xs) := by
  rw [merged_message, hodd, min_eq_left hmin, signed_xor]
  simp [check]

theorem bottleneck_zero (sa sb : Bool) (xs ys : List Int) (hzero : magnitude ys = 0) :
    check (sa ^^ sb) (xs ++ ys) = 0 := by
  rw [merged_message, hzero]
  simp [normalize_zero, signed]

def Opposite (x y : Int) : Prop := (x < 0 ∧ 0 < y) ∨ (y < 0 ∧ 0 < x)

/-- Every changed message is covered: opposite sign or strictly smaller magnitude. -/
theorem changed_message_classification (sa sb : Bool) (xs ys : List Int)
    (hdiff : check (sa ^^ sb) (xs ++ ys) ≠ check sa xs) :
    Opposite (check sa xs) (check (sa ^^ sb) (xs ++ ys)) ∨
      (check (sa ^^ sb) (xs ++ ys)).natAbs < (check sa xs).natAbs := by
  have hle := merged_magnitude_le sa sb xs ys
  unfold check at *
  generalize normalize (magnitude xs) = a at *
  generalize normalize (magnitude (xs ++ ys)) = b at *
  generalize (sa ^^ signs xs) = s at *
  generalize ((sa ^^ sb) ^^ signs (xs ++ ys)) = t at *
  cases s <;> cases t <;> simp [signed, Opposite] at * <;> omega

def decision (posterior : Int) : Bool := decide (posterior < 0)

/-- The first-round cubic threshold, with the actual fixed-point constants. -/
theorem first_round_threshold (s a b : Bool) :
    decision (prior + signed s 2665945 + signed a 2665945 + signed b 2665945) =
      (s && a && b) := by
  cases s <;> cases a <;> cases b <;> decide

theorem first_round_difference (sa sb a b : Bool) :
    decision (prior + signed sa 2665945 + signed a 2665945 + signed b 2665945) ≠
      decision (prior + signed (sa ^^ sb) 2665945 + signed a 2665945 + signed b 2665945) ↔
      sb = true ∧ a = true ∧ b = true := by
  cases sa <;> cases sb <;> cases a <;> cases b <;> decide

/-- Weakening a negative correcting message can prevent its hard decision,
even when importing the other side does not reverse the sign. -/
theorem attenuation_blocks_flip (sa sb : Bool) (xs ys : List Int) (base : Int)
    (hown : (sa ^^ signs xs) = true) (hother : (sb ^^ signs ys) = false)
    (hlow : (normalize (min (magnitude xs) (magnitude ys)) : Int) ≤ base)
    (hhigh : base < (normalize (magnitude xs) : Int)) :
    decision (base + check sa xs) = true ∧
      decision (base + check (sa ^^ sb) (xs ++ ys)) = false := by
  rw [merged_message, hown, hother]
  constructor <;> simp [check, hown, signed, decision] <;> omega

/-- Shared variable-node updates applied to two different check-message maps.
This abstract iteration is used only for a locality theorem: it does not claim
to be an extracted or fully verified C++ implementation. -/
def trajectory {Q E : Type*} (checks : Q → E → Int)
    (update : (E → Int) → Q) (initial : Q) : Nat → Q
  | 0 => initial
  | n+1 => update (checks (trajectory checks update initial n))

theorem state_difference_has_affected_origin {Q E : Type*}
    (original merged : Q → E → Int) (update : (E → Int) → Q) (initial : Q)
    (affected : E → Prop)
    (hcommon : ∀ q e, ¬affected e → original q e = merged q e)
    (n : Nat)
    (hdiff : trajectory original update initial n ≠ trajectory merged update initial n) :
    ∃ k, k < n ∧ trajectory original update initial k = trajectory merged update initial k ∧
      ∃ e, affected e ∧
        original (trajectory original update initial k) e ≠
          merged (trajectory merged update initial k) e := by
  classical
  induction n with
  | zero => exact (hdiff rfl).elim
  | succ n ih =>
    by_cases hprev : trajectory original update initial n = trajectory merged update initial n
    · have hmessages : original (trajectory original update initial n) ≠
          merged (trajectory merged update initial n) := by
        intro h
        exact hdiff (congrArg update h)
      have hw : ∃ e, affected e ∧
          original (trajectory original update initial n) e ≠
            merged (trajectory merged update initial n) e := by
        by_contra hnone
        apply hmessages
        funext e
        by_cases ha : affected e
        · by_contra h
          exact hnone ⟨e, ha, h⟩
        · rw [← hprev]
          exact hcommon _ e ha
      exact ⟨n, Nat.lt_succ_self n, hprev, hw⟩
    · obtain ⟨k, hkn, heq, hw⟩ := ih hprev
      exact ⟨k, Nat.lt_trans hkn (Nat.lt_succ_self n), heq, hw⟩

open scoped BigOperators

theorem decision_difference_has_affected_input {E : Type*} [DecidableEq E]
    (incident : Finset E) (original merged : E → Int) (affected : E → Prop)
    (hcommon : ∀ e ∈ incident, ¬affected e → original e = merged e)
    (hdiff : decision (prior + ∑ e ∈ incident, original e) ≠
      decision (prior + ∑ e ∈ incident, merged e)) :
    ∃ e ∈ incident, affected e ∧ original e ≠ merged e := by
  classical
  by_contra hnone
  apply hdiff
  congr 2
  apply Finset.sum_congr rfl
  intro e he
  by_cases ha : affected e
  · by_contra h
    exact hnone ⟨e, he, ha, h⟩
  · exact hcommon e he ha

section Syndrome
variable {V C : Type*} [DecidableEq V]
abbrev Word (V : Type*) := V → ZMod 2

def parity (row : Finset V) (x : Word V) : ZMod 2 := ∑ v ∈ row, x v

theorem parity_add (row : Finset V) (x y : Word V) :
    parity row (fun v => x v + y v) = parity row x + parity row y := by
  exact Finset.sum_add_distrib

/-- An accepting decision becomes rejected if its change has odd overlap with a check. -/
theorem odd_overlap_obstructs_syndrome (row : Finset V) (error old change : Word V)
    (haccepted : parity row (fun v => error v + old v) = 0)
    (hchange : parity row change = 1) :
    parity row (fun v => error v + (old v + change v)) = 1 := by
  have h := parity_add row (fun v => error v + old v) change
  simpa [haccepted, hchange, add_assoc] using h

theorem one_bit_change_is_odd (row : Finset V) (v : V) (hv : v ∈ row) :
    parity row (fun w => if w = v then (1 : ZMod 2) else 0) = 1 := by
  simp [parity, hv]

end Syndrome

end CyclicMergedMessages
#print axioms CyclicMergedMessages.merged_message
#print axioms CyclicMergedMessages.merged_magnitude_le
#print axioms CyclicMergedMessages.changed_message_classification
#print axioms CyclicMergedMessages.odd_overlap_obstructs_syndrome
#print axioms CyclicMergedMessages.attenuation_blocks_flip
#print axioms CyclicMergedMessages.state_difference_has_affected_origin
