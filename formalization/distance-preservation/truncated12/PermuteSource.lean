import GeneralSymmetry
import ActualIncidence
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

def permE (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (i : Fin 3) (j : Fin 4) := e (r i) (c j)
def permQubit (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4)) : Qubit L ≃ Qubit L :=
  Equiv.sumCongr (Equiv.prodCongr (Equiv.prodCongr c c) (Equiv.refl _))
    (Equiv.prodCongr (Equiv.prodCongr r r) (Equiv.refl _))
def permXCheck (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4)) :
    SourceModel.XCheck L ≃ SourceModel.XCheck L :=
  Equiv.prodCongr (Equiv.prodCongr r c) (Equiv.refl _)
def permZCheck (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4)) :
    SourceModel.ZCheck L ≃ SourceModel.ZCheck L :=
  Equiv.prodCongr (Equiv.prodCongr c r) (Equiv.refl _)

theorem perm_hx (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (a : SourceModel.XCheck L) (q : Qubit L) :
    GeneralLP.HX (permE e r c) a q=
      GeneralLP.HX e (permXCheck r c a) (permQubit r c q) := by
  rcases q with ⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩ <;>
    simp [GeneralLP.HX,permE,permXCheck,permQubit]

theorem perm_hz (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (a : SourceModel.ZCheck L) (q : Qubit L) :
    GeneralLP.HZ (permE e r c) a q=
      GeneralLP.HZ e (permZCheck r c a) (permQubit r c q) := by
  rcases q with ⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩ <;>
    simp [GeneralLP.HZ,permE,permZCheck,permQubit]

theorem perm_z_action (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (x : Qubit L → ZMod 2) (a : SourceModel.ZCheck L) :
    (∑ q,GeneralLP.HZ (permE e r c) a q*x (permQubit r c q))=
      ∑ q,GeneralLP.HZ e (permZCheck r c a) q*x q := by
  simp only [perm_hz]
  exact Fintype.sum_equiv (permQubit r c) _ _ (fun q => rfl)

theorem perm_z_kernel (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (x : Qubit L → ZMod 2) :
    (∀ a,(∑ q,GeneralLP.HZ (permE e r c) a q*x (permQubit r c q))=0) ↔
      (∀ a,(∑ q,GeneralLP.HZ e a q*x q)=0) := by
  simp only [perm_z_action]
  constructor
  · intro h a
    simpa using h ((permZCheck r c).symm a)
  · intro h a
    exact h (permZCheck r c a)

theorem perm_full_span_x (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (x : Qubit L → ZMod 2) :
    fullSpanX (permE e r c) (fun q => x (permQubit r c q)) ↔ fullSpanX e x := by
  constructor
  · rintro ⟨w,hw⟩
    refine ⟨fun a => w ((permXCheck r c).symm a),?_⟩
    intro q
    have h := hw ((permQubit r c).symm q)
    simp only [Equiv.apply_symm_apply] at h
    rw [h]
    exact Fintype.sum_equiv (permXCheck r c) _ _ (fun a => by simp [perm_hx])
  · rintro ⟨w,hw⟩
    refine ⟨fun a => w (permXCheck r c a),?_⟩
    intro q
    change x (permQubit r c q)=∑ a,w (permXCheck r c a)*GeneralLP.HX (permE e r c) a q
    rw [hw]
    exact Fintype.sum_equiv (permXCheck r c).symm _ _ (fun a => by simp [perm_hx])

theorem perm_weight (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (x : Qubit L → ZMod 2) :
    (CoverWeight.support (fun q => x (permQubit r c q))).card=(CoverWeight.support x).card := by
  exact Finset.card_equiv (permQubit r c) (fun q => by simp [CoverWeight.support])


def permCVariable (c : Equiv.Perm (Fin 4)) : (Fin 4 × ZMod L) ≃ (Fin 4 × ZMod L) :=
  Equiv.prodCongr c (Equiv.refl _)
def permCCheck (r : Equiv.Perm (Fin 3)) : (Fin 3 × ZMod L) ≃ (Fin 3 × ZMod L) :=
  Equiv.prodCongr r (Equiv.refl _)

theorem perm_c_incidence (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (v : Fin 4 × ZMod L) (a : Fin 3 × ZMod L) :
    CEdge (permE e r c) v a ↔ CEdge e (permCVariable c v) (permCCheck r a) := Iff.rfl

theorem perm_no_four (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (h4 : NoFour (CEdge e)) : NoFour (CEdge (permE e r c)) := by
  intro v w a b hvw hab hva hwa hwb hvb
  exact h4 _ _ _ _ (fun h => hvw ((permCVariable c).injective h))
    (fun h => hab ((permCCheck r).injective h)) hva hwa hwb hvb

theorem perm_no_six (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) (h6 : NoSix (CEdge e)) : NoSix (CEdge (permE e r c)) := by
  intro v w z a b d hvw hwz hzv hab hbd hda hva hwa hwb hzb hzd hvd
  exact h6 _ _ _ _ _ _ (fun h => hvw ((permCVariable c).injective h))
    (fun h => hwz ((permCVariable c).injective h)) (fun h => hzv ((permCVariable c).injective h))
    (fun h => hab ((permCCheck r).injective h)) (fun h => hbd ((permCCheck r).injective h))
    (fun h => hda ((permCCheck r).injective h)) hva hwa hwb hzb hzd hvd

#print axioms perm_no_six

#print axioms perm_hx
#print axioms perm_hz
#print axioms perm_z_kernel
#print axioms perm_full_span_x
#print axioms perm_weight
end TruncatedDistance
