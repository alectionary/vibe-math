import CyclicMergedMessages
import CyclicDecoderPersistence
import Mathlib.Tactic.Ring

/-! Early trajectory analysis for the unchanged syndrome min-sum decoder.
These general algebra/locality results support diagnostic decompositions.
They do not turn a retrospective direction score into a failure certificate. -/
namespace CyclicDecoderEntry
open CyclicMergedMessages
open scoped BigOperators

def orbit {Q : Type*} (step : Q → Q) (initial : Q) : Nat → Q
  | 0 => initial
  | k+1 => step (orbit step initial k)

/-- A coordinate can be affected directly or inherit an earlier dependency. -/
def cone {E : Type*} (depends : E → E → Prop) (affected : E → Prop) : Nat → E → Prop
  | 0, _ => False
  | k+1, e => affected e ∨ ∃ f, depends e f ∧ cone depends affected k f

/-- Shared initialization and local equations confine every difference to a
finite dependency cone. No contraction assumption is required. -/
theorem equal_outside_cone {E : Type*}
    (original merged : (E → Int) → E → Int) (initial : E → Int)
    (depends : E → E → Prop) (affected : E → Prop)
    (local_eq : ∀ q z e, ¬affected e →
      (∀ f, depends e f → q f = z f) → original q e = merged z e) :
    ∀ k e, ¬cone depends affected k e →
      orbit original initial k e = orbit merged initial k e := by
  intro k
  induction k with
  | zero => intro e _; rfl
  | succ k ih =>
    intro e outside
    apply local_eq
    · intro h
      exact outside (Or.inl h)
    · intro f hf
      apply ih
      intro inherited
      exact outside (Or.inr ⟨f, hf, inherited⟩)

def posterior {E : Type*} (incident : Finset E) (base : Int) (r : E → Int) : Int :=
  base + ∑ e ∈ incident, r e

/-- Split evaluation on the merged input is the intermediate state: the
decomposition is exact for signed messages, not just a norm bound. -/
theorem posterior_decomposition {E : Type*} (incident : Finset E) (base : Int)
    (old splitOnMerged merged : E → Int) :
    posterior incident base merged - posterior incident base old =
      (∑ e ∈ incident, (merged e - splitOnMerged e)) +
      (∑ e ∈ incident, (splitOnMerged e - old e)) := by
  simp only [posterior, Finset.sum_sub_distrib]
  ring

/-- Direct forcing is supported only on the changed checks' edges when the
common-check equations agree at the same incoming state. -/
theorem forcing_supported {E : Type*} [DecidableEq E]
    (incident : Finset E) (changed : E → Prop) [DecidablePred changed]
    (split merged : E → Int)
    (common : ∀ e ∈ incident, ¬changed e → merged e = split e) :
    (∑ e ∈ incident, (merged e - split e)) =
      ∑ e ∈ incident.filter changed, (merged e - split e) := by
  symm
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro e he hn
  have hc : ¬changed e := by
    intro hc
    exact hn (Finset.mem_filter.mpr ⟨he, hc⟩)
  rw [common e he hc, sub_self]

/-- With the zero convention of the decoder, a nonnegative old posterior
crosses to decision one exactly when total signed forcing exceeds its margin. -/
theorem positive_margin_crossing (old split merged : Int) (positive : 0 ≤ old) :
    decision merged ≠ decision old ↔
      (merged - split) + (split - old) < -old := by
  simp only [decision, ne_eq, decide_eq_decide]
  omega

/-- The analogous strict negative-margin crossing includes zero on the new side. -/
theorem negative_margin_crossing (old split merged : Int) (negative : old < 0) :
    decision merged ≠ decision old ↔
      -old ≤ (merged - split) + (split - old) := by
  simp only [decision, ne_eq, decide_eq_decide]
  omega

/-- A certified perturbation bound smaller than the decision margin preserves
the hard decision. This is local sign stability, not eventual convergence. -/
theorem stable_outside_margin (old merged radius : Int)
    (bounded : |merged - old| ≤ radius)
    (margin : radius ≤ old ∨ old < -radius) :
    decision merged = decision old := by
  have hr : 0 ≤ radius := le_trans (abs_nonneg _) bounded
  rw [abs_le] at bounded
  simp only [decision, decide_eq_decide]
  rcases margin with hp | hn <;> omega

/-- The same intermediate evaluation splits a scalar syndrome-weight gap.
This identity is descriptive and supplies no causal independence claim. -/
theorem weight_gap_decomposition (old split merged : Int) :
    merged - old = (merged - split) + (split - old) := by omega

/-- The scalar first-round XOR merger can remove both negative source messages. -/
theorem first_round_double_odd (a b : Bool) :
    decision (prior + signed true 2665945 + signed a 2665945 + signed b 2665945) =
      (a && b) ∧
    decision (prior + signed (true ^^ true) 2665945 + signed a 2665945 + signed b 2665945) =
      false := by
  cases a <;> cases b <;> decide

/-- With two even source syndromes and the fixed uniform prior, the first
merged source output equals the original output on either side. -/
theorem first_round_double_even_message :
    check false (List.replicate 11 prior) = check false (List.replicate 5 prior) := by
  decide +kernel

/-- Uniform positive incoming messages make the first check output independent
of whether the excluded-edge list has five or eleven entries. -/
theorem first_message_formula (s : Bool) :
    check s (List.replicate 5 prior) = signed s 2665945 ∧
    check s (List.replicate 11 prior) = signed s 2665945 := by
  cases s <;> decide +kernel

/-- Initial source activity is precisely immediate source-message divergence;
the inactive class starts with identical messages. -/
theorem immediate_source_divergence (sa sb : Bool) :
    (signed sa 2665945 ≠ signed (sa ^^ sb) 2665945 ∨
      signed sb 2665945 ≠ signed (sa ^^ sb) 2665945) ↔
      (sa || sb) = true := by
  cases sa <;> cases sb <;> decide

/-- Six messages reverse on one source side for a single odd syndrome, and
twelve reverse when both source syndromes are odd. -/
theorem first_changed_source_edges (sa sb : Bool) :
    6 * (if signed sa 2665945 ≠ signed (sa ^^ sb) 2665945 then 1 else 0) +
    6 * (if signed sb 2665945 ≠ signed (sa ^^ sb) 2665945 then 1 else 0) =
      (if sa && sb then 12 else if sa || sb then 6 else 0 : Nat) := by
  cases sa <;> cases sb <;> decide

/-- In degree three the initial source pulse immediately reaches each of
the other two outgoing variable messages, without clipping at these values. -/
theorem first_extrinsic_pulse (sa sb common : Bool) :
    |clip (prior + signed common 2665945 + signed sa 2665945) -
      clip (prior + signed common 2665945 + signed (sa ^^ sb) 2665945)| =
      (if sb then 5331890 else 0 : Int) := by
  cases sa <;> cases sb <;> cases common <;> decide +kernel

theorem signs_perm {xs ys : List Int} (h : xs.Perm ys) : signs xs = signs ys := by
  induction h with
  | nil => rfl
  | cons a _ ih => simp [signs, ih]
  | swap a b xs => simp [signs, Bool.xor_left_comm]
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem magnitude_perm {xs ys : List Int} (h : xs.Perm ys) : magnitude xs = magnitude ys := by
  induction h with
  | nil => rfl
  | cons a _ ih => simp [magnitude, ih]
  | swap a b xs => simp [magnitude, min_left_comm]
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem check_perm (s : Bool) {xs ys : List Int} (h : xs.Perm ys) :
    check s xs = check s ys := by
  simp only [check, signs_perm h, magnitude_perm h]

section DecoderLocality
variable {E V C : Type*} [DecidableEq E]
open CyclicDecoderPersistence

def updateDepends (d : Decoder E V C) (e f : E) : Prop :=
  ∃ g ∈ variableOthers d e, f ∈ incomingEdges d g

theorem map_same_on {A B : Type*} (xs : List A) (f g : A → B)
    (same : ∀ a ∈ xs, f a = g a) : xs.map f = xs.map g := by
  induction xs with
  | nil => rfl
  | cons a xs ih =>
    have head := same a (by simp)
    have tail : ∀ x ∈ xs, f x = g x := by intro x hx; exact same x (by simp [hx])
    simp only [List.map_cons, head, ih tail]

/-- Exact locality of the actual sign/minimum/rounding check equation. -/
theorem check_message_local (d : Decoder E V C) (s : C → Bool)
    (q z : E → Int) (e : E)
    (same : ∀ f ∈ incomingEdges d e, q f = z f) :
    messages d s q e = messages d s z e := by
  unfold messages
  rw [map_same_on (incomingEdges d e) q z same]

/-- Exact locality of the extrinsic variable update used in the frozen model. -/
theorem next_local (d : Decoder E V C) (s : C → Bool)
    (q z : E → Int) (e : E)
    (same : ∀ f, updateDepends d e f → q f = z f) :
    next d s q e = next d s z e := by
  unfold next
  have h : ((variableOthers d e).map (messages d s q)) =
      ((variableOthers d e).map (messages d s z)) := by
    apply map_same_on
    intro g hg
    apply check_message_local
    intro f hf
    exact same f ⟨g, hg, hf⟩
  rw [h]
end DecoderLocality

end CyclicDecoderEntry
#print axioms CyclicDecoderEntry.equal_outside_cone
#print axioms CyclicDecoderEntry.posterior_decomposition
#print axioms CyclicDecoderEntry.forcing_supported
#print axioms CyclicDecoderEntry.positive_margin_crossing
#print axioms CyclicDecoderEntry.negative_margin_crossing
#print axioms CyclicDecoderEntry.stable_outside_margin
#print axioms CyclicDecoderEntry.first_round_double_odd
#print axioms CyclicDecoderEntry.first_round_double_even_message
#print axioms CyclicDecoderEntry.next_local
#print axioms CyclicDecoderEntry.immediate_source_divergence
#print axioms CyclicDecoderEntry.first_changed_source_edges
#print axioms CyclicDecoderEntry.first_extrinsic_pulse
