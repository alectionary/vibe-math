module

public import IncidenceList

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false

namespace Incidence
-- This evaluates only two roots, after a proved cyclic translation below.
set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
 theorem normalized_roots_reject :
    ∀ b : Bool, survivesList pickList row 4 [(b,0,0)] = false := by
  decide +kernel


theorem running_lower_six (T : Finset Var) (hT : Stopping E T) : 6 ≤ T.card := by
  classical
  obtain ⟨v,hv⟩ := hT.1
  let e := shiftV (-v.2.1,-v.2.2)
  let U := T.image e
  have hU : Stopping E U := stopping_image E e (shiftC (-v.2.1,-v.2.2))
    (shift_incidence (-v.2.1,-v.2.2)) T hT
  have root : (v.1,0,0) ∈ U := by
    have : e v ∈ U := Finset.mem_image.mpr ⟨v,hv,rfl⟩
    simpa [e, shiftV] using this
  by_contra hn
  have hcard : U.card ≤ 1+4 := by
    dsimp [U]
    rw [Finset.card_image_of_injective _ e.injective]
    omega
  have h := survivesList_of_stopping E pickList row pickList_singleton row_complete 4
    [(v.1,0,0)] U hU (by simp) (by simpa) (by simpa using hcard)
  rw [normalized_roots_reject] at h
  contradiction


end Incidence
