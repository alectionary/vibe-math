import GaugeTransport
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

def gaugeQubit (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L) : Qubit L ≃ Qubit L where
  toFun q := match q with
    | .inl ((j,k),s) => .inl ((j,k),s+c j+c k)
    | .inr ((l,i),s) => .inr ((l,i),s-r l-r i)
  invFun q := match q with
    | .inl ((j,k),s) => .inl ((j,k),s-c j-c k)
    | .inr ((l,i),s) => .inr ((l,i),s+r l+r i)
  left_inv := by
    rintro (⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩) <;> dsimp <;> congr 2 <;> ring
  right_inv := by
    rintro (⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩) <;> dsimp <;> congr 2 <;> ring

theorem gauge_weight (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    (CoverWeight.support (GeneralLP.join (gaugeU u c) (gaugeV v r))).card=
      (CoverWeight.support (GeneralLP.join u v)).card := by
  have he : GeneralLP.join (gaugeU u c) (gaugeV v r)=
      fun q => GeneralLP.join u v (gaugeQubit r c q) := by
    funext q
    cases q <;> rfl
  rw [he]
  exact Finset.card_equiv (gaugeQubit r c) (fun q => by simp [CoverWeight.support])

#print axioms gauge_weight
end TruncatedDistance
