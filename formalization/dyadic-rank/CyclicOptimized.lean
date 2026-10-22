module

public import CyclicLift

@[expose] public section
open CyclicLift

namespace CyclicOptimized

/-- The two rate-preserving minima from the exhaustive normalized 3x3,
lift-size-14 Python search. This file verifies girth, not optimality,
connectedness, binary ranks or decoder performance. -/
def candidate (t : Fin 2) (i j : Fin 3) : ZMod 14 :=
  if i = 0 ∨ j = 0 then 0
  else if t = 0 then
    if i = 1 then (if j = 1 then 1 else 3)
    else (if j = 1 then 6 else 10)
  else
    if i = 1 then (if j = 1 then 1 else 4)
    else (if j = 1 then 6 else 2)

set_option maxRecDepth 10000
set_option maxHeartbeats 0

theorem candidate_rectangles : ∀ (t : Fin 2) (a b c d : Fin 3),
    a ≠ b → c ≠ d → baseRectangle (candidate t) a b c d ≠ 0 := by
  decide

theorem candidate_hexagons : ∀ (t : Fin 2) (a b c d e f : Fin 3),
    a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
    baseHexagon (candidate t) a b c d e f ≠ 0 := by
  decide

theorem candidate_matrix_girth (t : Fin 2) :
    (matrixTanner (hX (candidate t))).girth = 8 := by
  apply (matrixTanner_hX_girth_characterization (candidate t)).mpr
  exact ⟨candidate_rectangles t, candidate_hexagons t⟩

#print axioms candidate_rectangles
#print axioms candidate_hexagons
#print axioms candidate_matrix_girth

end CyclicOptimized
