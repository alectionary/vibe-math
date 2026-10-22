module

public import CyclicLift.LiftedProduct
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

def sixWalk {W : Type*} {G : SimpleGraph W} {a b c d e f : W}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d)
    (hde : G.Adj d e) (hef : G.Adj e f) (hfa : G.Adj f a) : G.Walk a a :=
  .cons hab (.cons hbc (.cons hcd (.cons hde (.cons hef (.cons hfa .nil)))))

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
