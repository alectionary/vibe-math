import GeneralLP
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : Nat} [NeZero L]

def squareSwap : Qubit L ≃ Qubit L := Equiv.sumCongr
  (Equiv.prodCongr (Equiv.prodComm (Fin 4) (Fin 4)) (Equiv.refl (ZMod L)))
  (Equiv.prodCongr (Equiv.prodComm (Fin 3) (Fin 3)) (Equiv.refl (ZMod L)))
def checkSwap : SourceModel.XCheck L ≃ SourceModel.ZCheck L :=
  Equiv.prodCongr (Equiv.prodComm (Fin 3) (Fin 4)) (Equiv.refl (ZMod L))

theorem hx_swap (e : Fin 3 → Fin 4 → ZMod L) (c : SourceModel.XCheck L)
    (q : Qubit L) : GeneralLP.HX e c (squareSwap q)=GeneralLP.HZ e (checkSwap c) q := by
  cases q <;> rfl
theorem hz_swap (e : Fin 3 → Fin 4 → ZMod L) (c : SourceModel.ZCheck L)
    (q : Qubit L) : GeneralLP.HZ e c (squareSwap q)=GeneralLP.HX e (checkSwap.symm c) q := by
  cases q <;> rfl
theorem squareSwap_twice (q : Qubit L) : squareSwap (squareSwap q)=q := by
  cases q <;> rfl

def fullSpanX (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) : Prop :=
  ∃ w : SourceModel.XCheck L → ZMod 2, ∀ q, x q=∑ c, w c*GeneralLP.HX e c q
def fullSpanZ (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) : Prop :=
  ∃ w : SourceModel.ZCheck L → ZMod 2, ∀ q, x q=∑ c, w c*GeneralLP.HZ e c q

theorem full_span_swap (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) :
    fullSpanX e x ↔ fullSpanZ e (fun q => x (squareSwap q)) := by
  constructor
  · rintro ⟨w,hw⟩
    refine ⟨fun c => w (checkSwap.symm c),?_⟩
    intro q
    change x (squareSwap q) = ∑ c, w (checkSwap.symm c)*GeneralLP.HZ e c q
    rw [hw]
    exact Fintype.sum_equiv checkSwap _ _ (fun c => by simp [hx_swap])
  · rintro ⟨w,hw⟩
    refine ⟨fun c => w (checkSwap c),?_⟩
    intro q
    have h := hw (squareSwap q)
    dsimp only at h
    rw [squareSwap_twice] at h
    rw [h]
    exact Fintype.sum_equiv checkSwap.symm _ _ (fun c => by simp [hz_swap])

theorem kernel_swap (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) :
    (∀ c : SourceModel.ZCheck L, (∑ q,GeneralLP.HZ e c q*x q)=0) ↔
    (∀ c : SourceModel.XCheck L, (∑ q,GeneralLP.HX e c q*x (squareSwap q))=0) := by
  constructor
  · intro h c
    rw [← h (checkSwap c)]
    exact Fintype.sum_equiv squareSwap _ _ (fun q => by
      have hm := hx_swap e c (squareSwap q)
      simpa only [squareSwap_twice] using
        congrArg (fun z => z*x (squareSwap q)) hm)
  · intro h c
    rw [← h (checkSwap.symm c)]
    exact (Fintype.sum_equiv squareSwap _ _ (fun q => by
      have hm := hx_swap e (checkSwap.symm c) (squareSwap q)
      simpa only [squareSwap_twice,Equiv.apply_symm_apply] using
        congrArg (fun z => z*x (squareSwap q)) hm)).symm

theorem swap_weight (x : Qubit L → ZMod 2) :
    (CoverWeight.support (fun q => x (squareSwap q))).card =
      (CoverWeight.support x).card := by
  exact Finset.card_equiv squareSwap (fun q => by simp [CoverWeight.support])

#print axioms full_span_swap
#print axioms kernel_swap
#print axioms swap_weight
end TruncatedDistance
