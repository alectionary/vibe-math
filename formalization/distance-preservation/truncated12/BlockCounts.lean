import BlockParity
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : Nat} [NeZero L]

def leftCount (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) : ℕ :=
  (CoverWeight.support (fun q : Fin 4 × ZMod L => u j q.1 q.2)).card
def rightCount (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) : ℕ :=
  (CoverWeight.support (fun q : Fin 3 × ZMod L => v q.1 i q.2)).card

lemma support_card_sum {A : Type*} [Fintype A] [DecidableEq A] (x : A → ZMod 2) :
    (CoverWeight.support x).card = ∑ a, if x a≠0 then (1 : ℕ) else 0 := by
  exact Finset.card_filter (fun a => x a≠0) Finset.univ

theorem leftMass_count (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) :
    leftMass u j=(leftCount u j : ZMod 2) := by
  simpa [leftMass,leftCount,CoverWeight.support,Fintype.sum_prod_type] using
    CoverWeight.sum_eq_card_support Finset.univ (fun q : Fin 4 × ZMod L => u j q.1 q.2)
theorem rightMass_count (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) :
    rightMass v i=(rightCount v i : ZMod 2) := by
  simpa [rightMass,rightCount,CoverWeight.support,Fintype.sum_prod_type] using
    CoverWeight.sum_eq_card_support Finset.univ (fun q : Fin 3 × ZMod L => v q.1 i q.2)

theorem support_weight_counts (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    (CoverWeight.support (GeneralLP.join u v)).card =
      (∑ j, leftCount u j)+(∑ i, rightCount v i) := by
  rw [support_card_sum,Fintype.sum_sum_type]
  unfold leftCount rightCount
  simp_rw [support_card_sum]
  simp only [Fintype.sum_prod_type,GeneralLP.join,SourceModel.join]
  congr 1
  exact Finset.sum_comm (f := fun l i : Fin 3 =>
    ∑ s : ZMod L, if v l i s≠0 then (1 : ℕ) else 0)

theorem common_count_parity (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ j i t, GeneralLP.Syndrome e u v j i t=0) :
    ∃ p : ℕ, p<2 ∧ (∀ j, leftCount u j%2=p) ∧ (∀ i, rightCount v i%2=p) := by
  obtain ⟨p,hL,hR⟩ := common_block_parity e u v hk
  refine ⟨p.val,ZMod.val_lt p,?_,?_⟩
  · intro j
    have h := congrArg (fun z : ZMod 2 => z.val) ((leftMass_count u j).symm.trans (hL j))
    simpa only [ZMod.val_natCast] using h
  · intro i
    have h := congrArg (fun z : ZMod 2 => z.val) ((rightMass_count v i).symm.trans (hR i))
    simpa only [ZMod.val_natCast] using h

#print axioms support_weight_counts
#print axioms common_count_parity
end TruncatedDistance
