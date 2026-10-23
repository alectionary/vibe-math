import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Group.Subgroup.Defs

/-! Small, reusable ingredients for the standard stabilizer-coset ambiguity bound.
Natural weights represent exact common-denominator probabilities. This file does
not formalize the min-sum executable, the CSS constructions, or the experiment. -/

namespace QuantumSyndromeAmbiguity

/-- Two errors corrected by the same syndrome-dependent recovery differ by a
stabilizer. No injectivity or linearity of the syndrome map is needed. -/
theorem recoverable_same_syndrome {V Y : Type*} [AddCommGroup V]
    (S : AddSubgroup V) (syndrome : V → Y) (decode : Y → V)
    {e f : V} (hsy : syndrome e = syndrome f)
    (he : decode (syndrome e) - e ∈ S)
    (hf : decode (syndrome f) - f ∈ S) : e - f ∈ S := by
  rw [← hsy] at hf
  simpa only [sub_sub_sub_cancel_left] using S.sub_mem hf he

/-- Same syndrome and inequivalent stabilizer classes preclude simultaneous
successful recovery by any deterministic syndrome decoder. -/
theorem collision_forces_failure {V Y : Type*} [AddCommGroup V]
    (S : AddSubgroup V) (syndrome : V → Y) (decode : Y → V)
    {e f : V} (hsy : syndrome e = syndrome f) (hne : e - f ∉ S) :
    ¬ (decode (syndrome e) - e ∈ S ∧ decode (syndrome f) - f ∈ S) := by
  intro h
  exact hne (recoverable_same_syndrome S syndrome decode hsy h.1 h.2)

/-- For a single syndrome bucket, total mass is at most an upper bound on the
chosen class mass plus failure mass. Taking M to be the largest class mass gives
the usual ambiguity lower bound. -/
theorem bucket_mass_bound {E C : Type*} [DecidableEq C]
    (bucket : Finset E) (cls : E → C) (chosen : C) (weight : E → ℕ) (M : ℕ)
    (hmax : (∑ e ∈ bucket.filter (fun e => cls e = chosen), weight e) ≤ M) :
    (∑ e ∈ bucket, weight e) ≤
      M + ∑ e ∈ bucket.filter (fun e => cls e ≠ chosen), weight e := by
  rw [← Finset.sum_filter_add_sum_filter_not bucket (fun e => cls e = chosen) weight]
  exact Nat.add_le_add_right hmax _

/-- Sum the bucket inequality, with an explicit finite error set and syndrome
alphabet. M may be the exact maximum class mass for each syndrome. The displayed
form avoids truncated subtraction of natural weights. -/
theorem finite_error_mass_bound {E Y C : Type*} [DecidableEq Y] [DecidableEq C]
    (errors : Finset E) (syndromes : Finset Y) (syndrome : E → Y)
    (cls : E → C) (chosen : Y → C) (weight : E → ℕ) (M : Y → ℕ)
    (hmaps : ∀ e ∈ errors, syndrome e ∈ syndromes)
    (hmax : ∀ y ∈ syndromes,
      (∑ e ∈ (errors.filter (fun e => syndrome e = y)).filter
        (fun e => cls e = chosen y), weight e) ≤ M y) :
    (∑ e ∈ errors, weight e) ≤ (∑ y ∈ syndromes, M y) +
      ∑ e ∈ errors.filter (fun e => cls e ≠ chosen (syndrome e)), weight e := by
  have h := Finset.sum_le_sum (s := syndromes) (fun y hy =>
    bucket_mass_bound (errors.filter (fun e => syndrome e = y)) cls (chosen y)
      weight (M y) (hmax y hy))
  rw [Finset.sum_fiberwise_of_maps_to hmaps weight, Finset.sum_add_distrib] at h
  have hpart : (∑ y ∈ syndromes,
      ∑ e ∈ (errors.filter (fun e => syndrome e = y)).filter
        (fun e => cls e ≠ chosen y), weight e) =
      ∑ e ∈ errors.filter (fun e => cls e ≠ chosen (syndrome e)), weight e := by
    calc
      _ = ∑ y ∈ syndromes,
          ∑ e ∈ (errors.filter (fun e => cls e ≠ chosen (syndrome e))).filter
            (fun e => syndrome e = y), weight e := by
        apply Finset.sum_congr rfl
        intro y hy
        congr 1
        ext e
        simp only [Finset.mem_filter]
        constructor
        · rintro ⟨⟨he, hsy⟩, hcls⟩
          exact ⟨⟨he, by simpa only [hsy] using hcls⟩, hsy⟩
        · rintro ⟨⟨he, hcls⟩, hsy⟩
          exact ⟨⟨he, hsy⟩, by simpa only [hsy] using hcls⟩
      _ = _ := Finset.sum_fiberwise_of_maps_to
        (fun e he => hmaps e (Finset.mem_filter.mp he).1) weight
  rw [hpart] at h
  exact h

/-- Enlarging the error set cannot reduce its nonnegative failure mass. -/
theorem failure_mass_monotone {E : Type*} (small large : Finset E)
    (fails : E → Prop) [DecidablePred fails] (weight : E → ℕ)
    (h : small ⊆ large) :
    (∑ e ∈ small.filter fails, weight e) ≤ ∑ e ∈ large.filter fails, weight e := by
  apply Finset.sum_le_sum_of_subset
  intro e he
  exact Finset.mem_filter.mpr ⟨h (Finset.mem_filter.mp he).1, (Finset.mem_filter.mp he).2⟩

end QuantumSyndromeAmbiguity

#print axioms QuantumSyndromeAmbiguity.recoverable_same_syndrome
#print axioms QuantumSyndromeAmbiguity.collision_forces_failure
#print axioms QuantumSyndromeAmbiguity.bucket_mass_bound
#print axioms QuantumSyndromeAmbiguity.finite_error_mass_bound
#print axioms QuantumSyndromeAmbiguity.failure_mass_monotone
