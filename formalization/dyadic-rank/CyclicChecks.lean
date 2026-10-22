module

import CyclicLift

open CyclicLift

-- A source-sized finite-matrix consumer, independent of the proof implementation.
example : Fintype.card (XCheck (Fin 2) (Fin 3) × ZMod 5) = 30 := by
  simpa using (hX_row_count (I := Fin 2) (J := Fin 3) (r := 5))

example : Fintype.card (XVariable (Fin 2) (Fin 3) × ZMod 5) = 65 := by
  simpa using (hX_column_count (I := Fin 2) (J := Fin 3) (r := 5))

-- Symbolic modulus and label, rather than a fixed finite enumeration.
example (r : ℕ) (t : ZMod r) (ht : t ≠ 0) :
    ¬HasFourCycle (xGraph (normalizedTwo t)) := normalizedTwo_no_four t ht

-- The concrete obstruction includes a genuine Mathlib simple six-cycle.
example : (¬HasFourCycle (xGraph ternaryBase)) ∧
    ∃ p : (xGraph ternaryBase).Walk (ternaryCheck 0 0 0) (ternaryCheck 0 0 0),
      p.IsCycle ∧ p.length = 6 := rectangle_exclusion_not_sufficient_for_no_six

#print axioms CyclicLift.VoltageGraph.displacement_nil
#print axioms CyclicLift.VoltageGraph.displacement_cons
#print axioms CyclicLift.VoltageGraph.endpoint_fiber
#print axioms CyclicLift.VoltageGraph.same_fiber_iff
#print axioms CyclicLift.VoltageGraph.lift_walk_exists
#print axioms CyclicLift.VoltageGraph.lift_walk_projects
#print axioms CyclicLift.VoltageGraph.closed_lift_exists
#print axioms CyclicLift.VoltageGraph.closed_lift_projects_iff
#print axioms CyclicLift.VoltageGraph.displacement_append
#print axioms CyclicLift.fourWalk_isCycle
#print axioms CyclicLift.HasFourCycle.native
#print axioms CyclicLift.hasFourCycle_iff_native
#print axioms CyclicLift.variable_check_adj
#print axioms CyclicLift.check_variable_adj
#print axioms CyclicLift.not_variable_variable_adj
#print axioms CyclicLift.not_check_check_adj
#print axioms CyclicLift.rectangle_closes_iff
#print axioms CyclicLift.rectangle_gives_four_cycle
#print axioms CyclicLift.rectangle_of_four_edges
#print axioms CyclicLift.hasFourCycle_iff_rectangle
#print axioms CyclicLift.permutationEntry_neg
#print axioms CyclicLift.hX_left
#print axioms CyclicLift.hX_right
#print axioms CyclicLift.hX_ne_zero_iff
#print axioms CyclicLift.xGraph_eq_matrixTanner
#print axioms CyclicLift.base_rectangle_gives_x_four_cycle
#print axioms CyclicLift.xGraph_hasFourCycle_iff
#print axioms CyclicLift.xGraph_native_fourCycle_iff
#print axioms CyclicLift.hX_row_count
#print axioms CyclicLift.hX_column_count
#print axioms CyclicLift.normalizedTwo_no_four
#print axioms CyclicLift.ternaryBase_rectangles
#print axioms CyclicLift.ternaryBase_no_four
#print axioms CyclicLift.ternarySix_isCycle
#print axioms CyclicLift.ternarySix_length
#print axioms CyclicLift.rectangle_exclusion_not_sufficient_for_no_six
