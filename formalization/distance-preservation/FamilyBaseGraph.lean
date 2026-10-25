import FamilyWords
import FamilyStopping11
import Mathlib.Logic.Equiv.Fin.Basic

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace FamilyBaseGraph
abbrev Var := Fin 4 × ZMod 11
abbrev Check := Fin 3 × ZMod 11
def varEquiv : Var ≃ Fin 44 := finProdFinEquiv
def checkEquiv : Check ≃ Fin 33 := finProdFinEquiv
def e (i : Fin 3) (j : Fin 4) : ZMod 11 := FamilyWords.exponent i j
def E (v : Var) (c : Check) : Prop := c.2 = v.2 + e c.1 v.1
instance : DecidableRel E := fun _ _ => inferInstanceAs (Decidable (_ = _))

theorem incidence_bridge : ∀ v : Fin 44, ∀ c : Fin 33,
    FamilyStopping11.E v c ↔ E (varEquiv.symm v) (checkEquiv.symm c) := by
  apply BinaryWords.forall_fin_two_of_all
  decide +kernel

theorem stopping_transport {V C W D : Type*}
    [DecidableEq V] [DecidableEq C] [DecidableEq W] [DecidableEq D]
    (E : V → C → Prop) [DecidableRel E] (F : W → D → Prop) [DecidableRel F]
    (ev : V ≃ W) (ec : C ≃ D) (he : ∀ v c, F (ev v) (ec c) ↔ E v c)
    (T : Finset V) (hT : SmallStopping.Stopping E T) :
    SmallStopping.Stopping F (T.image ev) := by
  refine ⟨hT.1.image ev,?_⟩
  intro d
  obtain ⟨c,rfl⟩ := ec.surjective d
  have hh : (T.image ev).filter (fun w => F w (ec c)) =
      (T.filter (fun v => E v c)).image ev := by
    ext w
    simp only [Finset.mem_filter,Finset.mem_image]
    constructor
    · rintro ⟨⟨v,hv,rfl⟩,hF⟩
      exact ⟨v,⟨hv,(he v c).mp hF⟩,rfl⟩
    · rintro ⟨v,⟨hv,hE⟩,rfl⟩
      exact ⟨⟨v,hv,rfl⟩,(he v c).mpr hE⟩
  rw [hh,Finset.card_image_of_injective _ ev.injective]
  exact hT.2 c

theorem stopping_lower_six (T : Finset Var) (hT : SmallStopping.Stopping E T) : 6 ≤ T.card := by
  have he : ∀ v c, FamilyStopping11.E (varEquiv v) (checkEquiv c) ↔ E v c := by
    intro v c
    simpa using incidence_bridge (varEquiv v) (checkEquiv c)
  have h := FamilyStopping11.stopping_lower_six (T.image varEquiv)
    (stopping_transport E FamilyStopping11.E varEquiv checkEquiv he T hT)
  simpa [Finset.card_image_of_injective _ varEquiv.injective] using h

#print axioms incidence_bridge
#print axioms stopping_lower_six
end FamilyBaseGraph
