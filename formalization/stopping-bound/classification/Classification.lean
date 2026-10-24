module
public import ClassificationKernel
@[expose] public section
set_option linter.unusedSimpArgs false
namespace Incidence.Classification
open Incidence
lemma shift_rowSupport (t c : Check) :
    (rowSupport c).image (shiftV t) = rowSupport (c+t) := by
  rw [rowSupport_image,rowSupport_image,Finset.image_image]
  congr 1
  funext v
  simp [Function.comp_def,shiftV,add_assoc]

theorem size_six_classification (T : Finset Var) (hT : Stopping E T) (h6 : T.card = 6) :
    ∃ c : Check, T = rowSupport c := by
  classical
  obtain ⟨v,hv⟩ := hT.1
  let t : Check := (-v.2.1,-v.2.2)
  let U := T.image (shiftV t)
  have hU : Stopping E U := stopping_image E (shiftV t) (shiftC t) (shift_incidence t) T hT
  have root : (v.1,0,0) ∈ U := by
    have hv' : shiftV t v ∈ U := Finset.mem_image.mpr ⟨v,hv,rfl⟩
    simpa [t,shiftV] using hv'
  have hcard : U.card ≤ 1+5 := by
    dsimp [U];rw [Finset.card_image_of_injective _ (shiftV t).injective,h6]
  obtain ⟨c,hc⟩ := classifiesList_sound E pickList row good
    (fun T => ∃ c : Check, T = rowSupport c) pickList_singleton row_complete good_sound
    5 [(v.1,0,0)] U hU (by simp) (by simpa) (by simpa using hcard)
    (normalized_classification_certificate v.1)
  refine ⟨c + (-t),?_⟩
  have hh := congrArg (fun S : Finset Var => S.image (shiftV (-t))) hc
  rw [shift_rowSupport] at hh
  have hinv : U.image (shiftV (-t)) = T := by
    dsimp [U];rw [Finset.image_image]
    have hf : (fun x => shiftV (-t) (shiftV t x)) = id := by
      funext x;simp [shiftV,add_assoc]
    simp only [Function.comp_def,hf,Finset.image_id]
  rwa [hinv] at hh
end Incidence.Classification
