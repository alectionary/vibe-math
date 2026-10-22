module

public import CyclicLift.SmallCases

@[expose] public section
namespace CyclicLift

/-- The 3-by-3 candidate over Z/7Z, with rows (0,0,0), (0,1,2), (0,3,6). -/
def sevenBase (i j : Fin 3) : ZMod 7 :=
  (if i = 2 then 3 else (i.val : ZMod 7)) * (j.val : ZMod 7)

set_option maxRecDepth 4000 in
set_option maxHeartbeats 2000000 in
/-- Kernel reduction checks every distinct-row/distinct-column rectangle. -/
theorem sevenBase_rectangles : ∀ i0 i1 j0 j1 : Fin 3,
    i0 ≠ i1 → j0 ≠ j1 → baseRectangle sevenBase i0 i1 j0 j1 ≠ 0 := by
  decide

set_option maxRecDepth 4000 in
set_option maxHeartbeats 2000000 in
/-- Kernel reduction checks all ordered triples of distinct rows and columns. -/
theorem sevenBase_hexagons : ∀ i0 i1 i2 j0 j1 j2 : Fin 3,
    i0 ≠ i1 → i1 ≠ i2 → i0 ≠ i2 → j0 ≠ j1 → j1 ≠ j2 → j0 ≠ j2 →
      baseHexagon sevenBase i0 i1 i2 j0 j1 j2 ≠ 0 := by
  decide

theorem sevenBase_no_four : ¬HasFourCycle (xGraph sevenBase) := by
  rw [xGraph_hasFourCycle_iff]
  rintro ⟨i0,i1,j0,j1,hi,hj,hz⟩
  exact sevenBase_rectangles i0 i1 j0 j1 hi hj hz

theorem sevenBase_no_six : ¬HasSixCycle (xGraph sevenBase) := by
  rw [xGraph_hasSixCycle_iff]
  rintro ⟨i0,i1,i2,j0,j1,j2,hi01,hi12,hi02,hj01,hj12,hj02,hz⟩
  exact sevenBase_hexagons i0 i1 i2 j0 j1 j2 hi01 hi12 hi02 hj01 hj12 hj02 hz

abbrev sevenCheck (i j : Fin 3) (a : ZMod 7) :
    (XVariable (Fin 3) (Fin 3) ⊕ XCheck (Fin 3) (Fin 3)) × ZMod 7 := (.inr (i,j),a)
abbrev sevenLeft (k j : Fin 3) (a : ZMod 7) :
    (XVariable (Fin 3) (Fin 3) ⊕ XCheck (Fin 3) (Fin 3)) × ZMod 7 := (.inl (.inl (k,j)),a)
abbrev sevenRight (i l : Fin 3) (a : ZMod 7) :
    (XVariable (Fin 3) (Fin 3) ⊕ XCheck (Fin 3) (Fin 3)) × ZMod 7 := (.inl (.inr (i,l)),a)

/-- A mixed-block simple eight-cycle, with all fiber coordinates zero. -/
def sevenEight : (xGraph sevenBase).Walk (sevenCheck 0 0 0) (sevenCheck 0 0 0) :=
  eightWalk (b := sevenLeft 0 0 0) (c := sevenCheck 1 0 0) (d := sevenRight 1 0 0)
    (e := sevenCheck 1 1 0) (f := sevenLeft 0 1 0) (g := sevenCheck 0 1 0)
    (h := sevenRight 0 0 0)
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, check_variable_adj, xSupport, xLabel, sevenBase])
    (by simp [xGraph, variable_check_adj, xSupport, xLabel, sevenBase])

theorem sevenEight_isCycle : sevenEight.IsCycle := by
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · simp [sevenEight, eightWalk, SimpleGraph.Walk.isPath_def]
  · change 3 ≤ 8; omega

@[simp] theorem sevenEight_length : sevenEight.length = 8 := rfl

/-- Exact native girth of the full 189-vertex lifted-product X Tanner graph. -/
theorem sevenBase_girth : (xGraph sevenBase).girth = 8 :=
  girth_eq_eight_of_short_cycles _ (tannerColoring _ _) sevenBase_no_four sevenBase_no_six
    sevenEight sevenEight_isCycle sevenEight_length

/-- Exact girth for the Tanner graph of the candidate's expanded binary matrix. -/
theorem sevenBase_matrix_girth : (matrixTanner (hX sevenBase)).girth = 8 := by
  rw [← xGraph_eq_matrixTanner]
  exact sevenBase_girth

end CyclicLift
