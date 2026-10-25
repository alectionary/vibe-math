import SourceDistance
import SourceCoordinates
set_option maxHeartbeats 0
namespace SourceSymmetry
variable {L : Nat} [NeZero L]
open FamilyWords

def swapQ : Qubit L ≃ Qubit L := Equiv.sumCongr
  (Equiv.prodCongr (Equiv.prodComm (Fin 4) (Fin 4)) (Equiv.refl (ZMod L)))
  (Equiv.prodCongr (Equiv.prodComm (Fin 3) (Fin 3)) (Equiv.refl (ZMod L)))

theorem join_transpose (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (q : Qubit L) :
    SourceModel.join (DistanceFamily.transpose u) (DistanceFamily.transpose v) q =
      SourceModel.join u v (swapQ q) := by
  cases q <;> rfl

theorem transpose_weight (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    (CoverWeight.support (SourceModel.join (DistanceFamily.transpose u) (DistanceFamily.transpose v))).card =
      (CoverWeight.support (SourceModel.join u v)).card := by
  exact Finset.card_equiv swapQ (fun q => by simp [CoverWeight.support,join_transpose])

theorem transpose_twice {n : Nat} (u : Fin n → Fin n → ZMod L → ZMod 2) :
    DistanceFamily.transpose (DistanceFamily.transpose u) = u := by
  funext i j s
  rfl

def XHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ u : Fin 4 → Fin 4 → ZMod L → ZMod 2,
    ∃ v : Fin 3 → Fin 3 → ZMod L → ZMod 2,
      SourceDistance.LogicalX u v ∧ (CoverWeight.support (SourceModel.join u v)).card=n

def ZHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ u : Fin 4 → Fin 4 → ZMod L → ZMod 2,
    ∃ v : Fin 3 → Fin 3 → ZMod L → ZMod 2,
      SourceDistance.LogicalZ u v ∧ (CoverWeight.support (SourceModel.join u v)).card=n

/-- The source X and Z logical weight spectra agree via square-block transpose. -/
theorem sector_weights (n : Nat) : ZHasWeight L n ↔ XHasWeight L n := by
  constructor
  · rintro ⟨u,v,hz,hw⟩
    refine ⟨DistanceFamily.transpose u,DistanceFamily.transpose v,?_,?_⟩
    · exact (SourceDistance.logicalX_iff _ _).mpr ((SourceDistance.logicalZ_iff u v).mp hz)
    · exact (transpose_weight u v).trans hw
  · rintro ⟨u,v,hx,hw⟩
    refine ⟨DistanceFamily.transpose u,DistanceFamily.transpose v,?_,?_⟩
    · apply (SourceDistance.logicalZ_iff _ _).mpr
      rw [transpose_twice u,transpose_twice v]
      exact (SourceDistance.logicalX_iff u v).mp hx
    · exact (transpose_weight u v).trans hw

#print axioms transpose_weight
#print axioms sector_weights
end SourceSymmetry
