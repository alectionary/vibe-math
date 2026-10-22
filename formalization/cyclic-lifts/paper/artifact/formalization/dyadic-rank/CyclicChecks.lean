module

import CyclicLift

open CyclicLift

-- A source-sized finite-matrix consumer, independent of the proof implementation.
example : Fintype.card (XCheck (Fin 2) (Fin 3) × ZMod 5) = 30 := by
  simp [XCheck, Fintype.card_prod]

example : Fintype.card (XVariable (Fin 2) (Fin 3) × ZMod 5) = 65 := by
  simp [XVariable, Fintype.card_prod]

-- Symbolic modulus and label, rather than a fixed finite enumeration.
example (r : ℕ) (t : ZMod r) (ht : t ≠ 0) :
    ¬HasFourCycle (xGraph (normalizedTwo t)) := normalizedTwo_no_four t ht

-- The concrete obstruction includes a genuine Mathlib simple six-cycle.
example : (¬HasFourCycle (xGraph ternaryBase)) ∧
    ∃ p : (xGraph ternaryBase).Walk (ternaryCheck 0 0 0) (ternaryCheck 0 0 0),
      p.IsCycle ∧ p.length = 6 := rectangle_exclusion_not_sufficient_for_no_six

-- A uniform girth theorem, plus its binary-matrix interpretation.
example (r : ℕ) (t : ZMod r) (ht : t ≠ 0) :
    (xGraph (normalizedTwo t)).girth = 8 := normalizedTwo_girth t ht

example : (matrixTanner (hX (normalizedTwo (1 : ZMod 7)))).girth = 8 :=
  normalizedTwo_matrix_girth 1 (by decide)

-- The larger candidate, including the actual expanded parity-check matrix.
example : (xGraph sevenBase).girth = 8 := sevenBase_girth
example : (matrixTanner (hX sevenBase)).girth = 8 := sevenBase_matrix_girth

-- The concrete matrix is exactly the originally searched candidate.
example : ∀ i j : Fin 3, sevenBase i j =
    (![![(0 : ZMod 7), 0, 0], ![0, 1, 2], ![0, 3, 6]] : Matrix (Fin 3) (Fin 3) (ZMod 7)) i j := by
  decide

-- Its dimensions agree with the binary block model.
example : Fintype.card (XCheck (Fin 3) (Fin 3) × ZMod 7) = 63 := by
  simp [XCheck, Fintype.card_prod]
example : Fintype.card (XVariable (Fin 3) (Fin 3) × ZMod 7) = 126 := by
  simp [XVariable, Fintype.card_prod]

-- The exact native six-cycle characterization is usable at arbitrary sizes.
example {I J : Type*} {r : ℕ} (B : I → J → ZMod r) :
    (∃ v, ∃ p : (xGraph B).Walk v v, p.IsCycle ∧ p.length = 6) ↔
      ∃ i0 i1 i2 j0 j1 j2, i0 ≠ i1 ∧ i1 ≠ i2 ∧ i0 ≠ i2 ∧
        j0 ≠ j1 ∧ j1 ≠ j2 ∧ j0 ≠ j2 ∧ baseHexagon B i0 i1 i2 j0 j1 j2 = 0 :=
  xGraph_native_sixCycle_iff B

-- Arbitrary dimensions and arbitrary exponents: the actual binary-matrix criterion.
example {I J : Type*} [Nontrivial I] [Nontrivial J] {r : ℕ} (B : I → J → ZMod r) :
    (matrixTanner (hX B)).girth = 8 ↔
      (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
      (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
        baseHexagon B a b c d e f ≠ 0) := matrixTanner_hX_girth_characterization B

-- Reprove the larger example by the general theorem, with no bespoke upper-bound argument.
example : (xGraph sevenBase).girth = 8 :=
  (xGraph_girth_characterization sevenBase).mpr ⟨sevenBase_rectangles, sevenBase_hexagons⟩

-- The upper bound works for arbitrary, unnormalized exponents over a composite modulus.
example (B : Fin 3 → Fin 4 → ZMod 6) : (xGraph B).egirth ≤ 8 := xGraph_egirth_le_eight B

-- The characterization also detects failure: zero rectangles prevent exact girth eight.
example : (xGraph (fun (_ _ : Fin 2) => (0 : ZMod 7))).girth ≠ 8 := by
  intro h
  have hc := ((xGraph_girth_characterization _).mp h).1
  exact hc 0 1 0 1 (by decide) (by decide) (by simp [baseRectangle])

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
#print axioms CyclicLift.sixWalk_isCycle
#print axioms CyclicLift.hasSixCycle_iff_native
#print axioms CyclicLift.hexagon_closes_iff
#print axioms CyclicLift.hexagon_gives_six_cycle
#print axioms CyclicLift.neighboring_checks_project_injective
#print axioms CyclicLift.no_six_of_check_triangle_free
#print axioms CyclicLift.girth_eq_eight_of_short_cycles
#print axioms CyclicLift.neighboring_variables_project_injective
#print axioms CyclicLift.hexagon_of_six_edges
#print axioms CyclicLift.hasSixCycle_iff_hexagon
#print axioms CyclicLift.xGraph_hasSixCycle_iff
#print axioms CyclicLift.xGraph_native_sixCycle_iff
#print axioms CyclicLift.normalizedTwo_no_four
#print axioms CyclicLift.xSupport_common_checks
#print axioms CyclicLift.two_grid_triangle
#print axioms CyclicLift.two_by_two_no_six
#print axioms CyclicLift.normalizedEight_isCycle
#print axioms CyclicLift.normalizedEight_length
#print axioms CyclicLift.normalizedTwo_girth
#print axioms CyclicLift.normalizedTwo_matrix_girth
#print axioms CyclicLift.ternaryBase_rectangles
#print axioms CyclicLift.ternaryBase_no_four
#print axioms CyclicLift.ternarySix_isCycle
#print axioms CyclicLift.ternarySix_length
#print axioms CyclicLift.rectangle_exclusion_not_sufficient_for_no_six
#print axioms CyclicLift.sevenBase_rectangles
#print axioms CyclicLift.sevenBase_hexagons
#print axioms CyclicLift.sevenBase_no_four
#print axioms CyclicLift.sevenBase_no_six
#print axioms CyclicLift.sevenEight_isCycle
#print axioms CyclicLift.sevenEight_length
#print axioms CyclicLift.sevenBase_girth
#print axioms CyclicLift.sevenBase_matrix_girth
#print axioms CyclicLift.mixedEight_isCycle
#print axioms CyclicLift.mixedEight_length
#print axioms CyclicLift.xGraph_girth_le_eight
#print axioms CyclicLift.xGraph_girth_eq_eight_iff_no_short
#print axioms CyclicLift.xGraph_girth_eq_eight_iff
#print axioms CyclicLift.matrixTanner_hX_girth_eq_eight_iff
#print axioms CyclicLift.baseHexagon_eq_rectangle_add
#print axioms CyclicLift.xGraph_girth_eq_eight_iff_rectangles
#print axioms CyclicLift.xGraph_exists_eight_cycle
#print axioms CyclicLift.xGraph_egirth_le_eight
#print axioms CyclicLift.xGraph_girth_characterization
#print axioms CyclicLift.matrixTanner_hX_girth_characterization
