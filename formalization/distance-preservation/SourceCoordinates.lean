import SourceSectors
set_option maxHeartbeats 0
namespace SourceModel
variable {L : Nat} [NeZero L]
open FamilyWords

theorem qubit_card : Fintype.card (Qubit L) = 25*L := by
  simp [Qubit,Fintype.card_sum,Fintype.card_prod]
  omega

theorem xcheck_card : Fintype.card (XCheck L) = 12*L := by
  simp [XCheck,Fintype.card_prod]

theorem zcheck_card : Fintype.card (ZCheck L) = 12*L := by
  simp [ZCheck,Fintype.card_prod]

/-- The two square blocks parameterize every quantum binary vector. -/
theorem join_surjective (w : Qubit L → ZMod 2) :
    ∃ u : Fin 4 → Fin 4 → ZMod L → ZMod 2,
      ∃ v : Fin 3 → Fin 3 → ZMod L → ZMod 2, SourceModel.join u v = w := by
  refine ⟨(fun i j s => w (.inl ((i,j),s))),
    (fun i j s => w (.inr ((i,j),s))),?_⟩
  funext q
  cases q <;> rfl

#print axioms qubit_card
#print axioms join_surjective
end SourceModel
