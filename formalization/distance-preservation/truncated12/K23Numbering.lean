import ExceptionalGraph
import SourcePartners
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

theorem left_support_coordinates (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (j : Fin 4) (q : Qubit L) (hq : q∈leftSupport u j) :
    ∃ k s,q=.inl ((j,k),s) ∧ u j k s≠0 := by
  rcases q with ⟨⟨j',k⟩,s⟩|⟨⟨l,i⟩,s⟩
  · obtain ⟨rfl,h⟩ := (left_mem_leftSupport u j j' k s).mp hq
    exact ⟨k,s,rfl,h⟩
  · exact False.elim (right_mem_leftSupport u j l i s hq)

structure K23Numbering (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) where
  K : Fin 5 → Fin 4
  S : Fin 5 → ZMod L
  nonzero : ∀ x,u 3 (K x) (S x)≠0
  injective : Function.Injective (fun x => (K x,S x))
  covers : ∀ k s,u 3 k s≠0 → ∃ x,K x=k ∧ S x=s
  adjacency : ∀ x y,
    (x≠y ∧ ∃ c,ZEdge e (.inl ((3,K x),S x)) c ∧ ZEdge e (.inl ((3,K y),S y)) c) ↔
      x.val%2≠y.val%2

/-- Pull the actual five-coordinate source support through the checked Turán
isomorphism. Even vertices are the three leaves; odd vertices are the centers. -/
theorem actual_k23_numbering (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (hU : leftCount u 3=5) (hV : ∀ i,rightCount v i=1) : Nonempty (K23Numbering e u) := by
  classical
  obtain ⟨f⟩ := exceptional_group_is_k23 e h4 h6 u v hk hw 3 hU hV
  have hcoords (x : Fin 5) : ∃ k s,(f.symm x).val=.inl ((3,k),s) ∧ u 3 k s≠0 :=
    left_support_coordinates u 3 (f.symm x).val (f.symm x).property
  choose K S hq using hcoords
  refine ⟨{
    K := K
    S := S
    nonzero := fun x => (hq x).2
    injective := ?_
    covers := ?_
    adjacency := ?_
  }⟩
  · intro x y he
    apply f.symm.injective
    apply Subtype.ext
    rw [(hq x).1,(hq y).1]
    have ha := congrArg Prod.fst he
    have hb := congrArg Prod.snd he
    change K x=K y at ha
    change S x=S y at hb
    rw [ha,hb]
  · intro k s hn
    let z : leftSupport u 3 := ⟨.inl ((3,k),s),by simp [hn]⟩
    refine ⟨f z,?_⟩
    have he := (hq (f z)).1
    simp only [f.symm_apply_apply] at he
    change Sum.inl ((3,k),s)=Sum.inl ((3,K (f z)),S (f z)) at he
    have hp := Sum.inl.inj he
    exact ⟨(congrArg (fun p => p.1.2) hp).symm,(congrArg Prod.snd hp).symm⟩
  · intro x y
    have hx : (f.symm x).val=.inl ((3,K x),S x) := (hq x).1
    have hy : (f.symm y).val=.inl ((3,K y),S y) := (hq y).1
    have hn : f.symm x≠f.symm y ↔ x≠y := f.symm.injective.ne_iff
    change (x≠y ∧ ∃ c,ZEdge e (.inl ((3,K x),S x)) c ∧ ZEdge e (.inl ((3,K y),S y)) c) ↔
      (SimpleGraph.turanGraph 5 2).Adj x y
    rw [← f.symm.map_adj_iff]
    change (x≠y ∧ _) ↔ (f.symm x≠f.symm y ∧ _)
    rw [hn,hx,hy]

#print axioms actual_k23_numbering
end TruncatedDistance
