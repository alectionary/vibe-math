module

public import CyclicLift.SixCharacterization
public import Mathlib.Tactic.FinCases

@[expose] public section

namespace CyclicLift

/-- A normalized 2-by-2 exponent matrix, with no assumption on the lift modulus. -/
def normalizedTwo {r : ℕ} (t : ZMod r) (i j : Fin 2) : ZMod r :=
  if i = 1 ∧ j = 1 then t else 0

/-- Symbolic in both modulus and nonzero free label: the 2-by-2 family has no four-cycles.
This theorem by itself does not assert girth eight. -/
theorem normalizedTwo_no_four {r : ℕ} (t : ZMod r) (ht : t ≠ 0) :
    ¬HasFourCycle (xGraph (normalizedTwo t)) := by
  rw [xGraph_hasFourCycle_iff]
  rintro ⟨i0, i1, j0, j1, hi, hj, hz⟩
  fin_cases i0 <;> fin_cases i1 <;> fin_cases j0 <;> fin_cases j1 <;>
    simp_all [baseRectangle, normalizedTwo]

/-- A common variable can connect only checks agreeing in at least one coordinate. -/
theorem xSupport_common_checks {I J : Type*} (v : XVariable I J) (c d : XCheck I J)
    (hc : xSupport v c) (hd : xSupport v d) : c.1 = d.1 ∨ c.2 = d.2 := by
  cases v with
  | inl v => exact Or.inr (hc.symm.trans hd)
  | inr v => exact Or.inl (hc.symm.trans hd)

/-- Three vertices of a 2-by-2 grid cannot form a coordinate-sharing triangle. -/
theorem two_grid_triangle : ∀ a b c : Fin 2 × Fin 2,
    (a.1 = b.1 ∨ a.2 = b.2) → (b.1 = c.1 ∨ b.2 = c.2) →
    (c.1 = a.1 ∨ c.2 = a.2) → a = b ∨ b = c ∨ a = c := by
  decide

/-- No six-cycles for any 2-by-2 exponent matrix, over any cyclic modulus. -/
theorem two_by_two_no_six {r : ℕ} (B : Fin 2 → Fin 2 → ZMod r) :
    ¬HasSixCycle (xGraph B) := by
  apply no_six_of_check_triangle_free
  intro v0 v1 v2 c0 c1 c2 h00 h01 h11 h12 h22 h20
  exact two_grid_triangle c0 c1 c2 (xSupport_common_checks v0 c0 c1 h00 h01)
    (xSupport_common_checks v1 c1 c2 h11 h12) (xSupport_common_checks v2 c2 c0 h22 h20)

abbrev twoCheck {r : ℕ} (i j : Fin 2) (a : ZMod r) :
    (XVariable (Fin 2) (Fin 2) ⊕ XCheck (Fin 2) (Fin 2)) × ZMod r := (.inr (i,j),a)
abbrev twoLeft {r : ℕ} (k j : Fin 2) (a : ZMod r) :
    (XVariable (Fin 2) (Fin 2) ⊕ XCheck (Fin 2) (Fin 2)) × ZMod r := (.inl (.inl (k,j)),a)
abbrev twoRight {r : ℕ} (i l : Fin 2) (a : ZMod r) :
    (XVariable (Fin 2) (Fin 2) ⊕ XCheck (Fin 2) (Fin 2)) × ZMod r := (.inl (.inr (i,l)),a)

/-- A mixed-block eight-cycle, independent of the free exponent and modulus. -/
def normalizedEight {r : ℕ} (t : ZMod r) :
    (xGraph (normalizedTwo t)).Walk (twoCheck 0 0 0) (twoCheck 0 0 0) :=
  eightWalk (b := twoLeft 0 0 0) (c := twoCheck 1 0 0) (d := twoRight 1 0 0)
    (e := twoCheck 1 1 0) (f := twoLeft 0 1 0) (g := twoCheck 0 1 0) (h := twoRight 0 0 0)
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, normalizedTwo])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, normalizedTwo])

theorem normalizedEight_isCycle {r : ℕ} (t : ZMod r) : (normalizedEight t).IsCycle := by
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · simp [normalizedEight, eightWalk, SimpleGraph.Walk.isPath_def]
  · change 3 ≤ 8; omega

@[simp] theorem normalizedEight_length {r : ℕ} (t : ZMod r) : (normalizedEight t).length = 8 := rfl

/-- A uniform, kernel-checked girth-eight family, not a finite search certificate. -/
theorem normalizedTwo_girth {r : ℕ} (t : ZMod r) (ht : t ≠ 0) :
    (xGraph (normalizedTwo t)).girth = 8 :=
  girth_eq_eight_of_short_cycles _ (tannerColoring _ _) (normalizedTwo_no_four t ht)
    (two_by_two_no_six _) (normalizedEight t) (normalizedEight_isCycle t) (normalizedEight_length t)

/-- The same girth result for the explicitly expanded binary parity-check matrix. -/
theorem normalizedTwo_matrix_girth {r : ℕ} (t : ZMod r) (ht : t ≠ 0) :
    (matrixTanner (hX (normalizedTwo t))).girth = 8 := by
  rw [← xGraph_eq_matrixTanner]
  exact normalizedTwo_girth t ht

/-- A concrete ternary exponent matrix: rows 0, (0,1,2), (0,2,1). -/
def ternaryBase (i j : Fin 3) : ZMod 3 := (i.val * j.val : ℕ)

set_option maxRecDepth 2000 in
/-- No distinct-row/distinct-column rectangle has zero alternating sum. -/
theorem ternaryBase_rectangles : ∀ i0 i1 j0 j1 : Fin 3,
    i0 ≠ i1 → j0 ≠ j1 → baseRectangle ternaryBase i0 i1 j0 j1 ≠ 0 := by
  decide

/-- Absence of four-cycles in the full lifted-product X Tanner graph. -/
theorem ternaryBase_no_four : ¬HasFourCycle (xGraph ternaryBase) := by
  rw [xGraph_hasFourCycle_iff]
  rintro ⟨i0, i1, j0, j1, hi, hj, hz⟩
  exact ternaryBase_rectangles i0 i1 j0 j1 hi hj hz

abbrev ternaryCheck (i j : Fin 3) (a : ZMod 3) :
    (XVariable (Fin 3) (Fin 3) ⊕ XCheck (Fin 3) (Fin 3)) × ZMod 3 :=
  (.inr (i, j), a)

abbrev ternaryLeft (k j : Fin 3) (a : ZMod 3) :
    (XVariable (Fin 3) (Fin 3) ⊕ XCheck (Fin 3) (Fin 3)) × ZMod 3 :=
  (.inl (.inl (k, j)), a)

/-- An explicit six-edge walk whose vertices were independently found by finite enumeration. -/
def ternarySix : (xGraph ternaryBase).Walk (ternaryCheck 0 0 0) (ternaryCheck 0 0 0) :=
  sixWalk (b := ternaryLeft 0 0 0) (c := ternaryCheck 1 0 0)
    (d := ternaryLeft 1 0 2) (e := ternaryCheck 2 0 1) (f := ternaryLeft 2 0 0)

    (by simp only [xGraph, check_variable_adj, xSupport, xLabel, ternaryBase]; decide)
    (by simp only [xGraph, variable_check_adj, xSupport, xLabel, ternaryBase]; decide)
    (by simp only [xGraph, check_variable_adj, xSupport, xLabel, ternaryBase]; decide)
    (by simp only [xGraph, variable_check_adj, xSupport, xLabel, ternaryBase]; decide)
    (by simp only [xGraph, check_variable_adj, xSupport, xLabel, ternaryBase]; decide)
    (by simp only [xGraph, variable_check_adj, xSupport, xLabel, ternaryBase]; decide)

/-- The walk is a native simple cycle: rectangle exclusion alone does not rule out six-cycles. -/
theorem ternarySix_isCycle : ternarySix.IsCycle := by
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · simp [ternarySix, sixWalk, SimpleGraph.Walk.isPath_def]
  · decide

@[simp] theorem ternarySix_length : ternarySix.length = 6 := rfl

/-- A formally checked counterexample to the tempting *stronger simplification*, not to P34:
nonzero base rectangles do not suffice for eliminating six-cycles. -/
theorem rectangle_exclusion_not_sufficient_for_no_six :
    (¬HasFourCycle (xGraph ternaryBase)) ∧
      ∃ p : (xGraph ternaryBase).Walk (ternaryCheck 0 0 0) (ternaryCheck 0 0 0),
        p.IsCycle ∧ p.length = 6 :=
  ⟨ternaryBase_no_four, ternarySix, ternarySix_isCycle, ternarySix_length⟩

end CyclicLift
