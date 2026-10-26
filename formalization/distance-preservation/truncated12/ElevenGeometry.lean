import K23LeafMatches
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

def lowColumn (j : Fin 3) : Fin 4 := ⟨j.val,by omega⟩
def elevenRow (o : Fin 2) (a : Fin 2) (i : Fin 3) : Fin 3 :=
  if a=0 then ⟨(i.val+o.val+1)%3,Nat.mod_lt _ (by decide)⟩
  else ⟨(i.val+3-(o.val+1))%3,Nat.mod_lt _ (by decide)⟩

structure ElevenGeometry (e : Fin 3 → Fin 4 → ZMod L) where
  singleK : Fin 3 → Fin 4
  singleS : Fin 3 → ZMod L
  rightH : Fin 3 → Fin 3
  rightT : Fin 3 → ZMod L
  singleK_injective : Function.Injective singleK
  rightH_injective : Function.Injective rightH
  centerK : Fin 2 → Fin 4
  centerS : Fin 2 → ZMod L
  leafK : Fin 3 → Fin 4
  leafS : Fin 3 → ZMod L
  orientation : Fin 2
  adjacent_labels : ∀ a i,leafK i≠centerK a
  single_matching : ∀ j i,singleS j+e i (singleK j)=rightT i-e (rightH i) (lowColumn j)
  internal_matching : ∀ a i,centerS a+e (elevenRow orientation a i) (centerK a)=
    leafS i+e (elevenRow orientation a i) (leafK i)
  leaf_matching : ∀ i,leafS i+e i (leafK i)=rightT i-e (rightH i) 3

theorem k23_has_orientation {e : Fin 3 → Fin 4 → ZMod L}
    {u : Fin 4 → Fin 4 → ZMod L → ZMod 2} {n : K23Numbering e u}
    (c : K23InternalChecks e u n) :
    ∃ o : Fin 2,∀ a i,(c.check a (leafByRow c i)).1.2=elevenRow o a i := by
  rcases row_orientations c with h|h
  · refine ⟨0,?_⟩
    intro a i
    fin_cases a
    · apply Fin.ext
      change (c.check 0 (leafByRow c i)).1.2.val=(i.val+0+1)%3
      simpa using (h i).1
    · apply Fin.ext
      change (c.check 1 (leafByRow c i)).1.2.val=(i.val+3-(0+1))%3
      have hi := (h i).2
      omega
  · refine ⟨1,?_⟩
    intro a i
    fin_cases a
    · apply Fin.ext
      change (c.check 0 (leafByRow c i)).1.2.val=(i.val+1+1)%3
      have hi := (h i).1
      omega
    · apply Fin.ext
      change (c.check 1 (leafByRow c i)).1.2.val=(i.val+3-(1+1))%3
      have hi := (h i).2
      omega

theorem adjacent_numbered_labels_distinct (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (n : K23Numbering e u)
    (x y : Fin 5) (hxy : x≠y) (c : SourceModel.ZCheck L)
    (hx : ZEdge e (numberedQubit n x) c) (hy : ZEdge e (numberedQubit n y) c) : n.K x≠n.K y := by
  intro hK
  apply hxy
  apply n.injective
  refine Prod.ext hK ?_
  have h1 := hx.2
  have h2 := hy.2
  change c.2=n.S x+e c.1.2 (n.K x) at h1
  change c.2=n.S y+e c.1.2 (n.K y) at h2
  rw [hK] at h1
  linear_combination -h1+h2

/-- Actual K2,3 checks and singleton source matching supply the full oriented
weight-eleven geometry. Every matching equation is derived from incidences. -/
theorem actual_eleven_geometry (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (n : K23Numbering e u) (c : K23InternalChecks e u n)
    (K : Fin 3 → Fin 4) (S : Fin 3 → ZMod L) (H : Fin 3 → Fin 3) (T : Fin 3 → ZMod L)
    (hK : Function.Injective K) (hH : Function.Injective H)
    (hMatch : ∀ j i,S j+e i (K j)=T i-e (H i) (lowColumn j))
    (hv : ∀ i l t,v l i t=if l=H i ∧ t=T i then 1 else 0) : Nonempty (ElevenGeometry e) := by
  obtain ⟨o,ho⟩ := k23_has_orientation c
  refine ⟨{
    singleK := K
    singleS := S
    rightH := H
    rightT := T
    singleK_injective := hK
    rightH_injective := hH
    centerK := fun a => n.K (k23Center a)
    centerS := fun a => n.S (k23Center a)
    leafK := fun i => n.K (k23Leaf (leafByRow c i))
    leafS := fun i => n.S (k23Leaf (leafByRow c i))
    orientation := o
    adjacent_labels := ?_
    single_matching := hMatch
    internal_matching := ?_
    leaf_matching := actual_leaf_cross_matches e h4 h6 u v hk hw n c H T hv
  }⟩
  · intro a i
    exact (adjacent_numbered_labels_distinct e u n (k23Center a) (k23Leaf (leafByRow c i))
      (k23_center_ne_leaf a _) (c.check a (leafByRow c i))
      (c.center_edge a _) (c.leaf_edge a _)).symm
  · intro a i
    have h1 := (c.center_edge a (leafByRow c i)).2
    have h2 := (c.leaf_edge a (leafByRow c i)).2
    change (c.check a (leafByRow c i)).2=n.S (k23Center a)+
      e (c.check a (leafByRow c i)).1.2 (n.K (k23Center a)) at h1
    change (c.check a (leafByRow c i)).2=n.S (k23Leaf (leafByRow c i))+
      e (c.check a (leafByRow c i)).1.2 (n.K (k23Leaf (leafByRow c i))) at h2
    rw [ho a i] at h1 h2
    exact h1.symm.trans h2

#print axioms actual_eleven_geometry
end TruncatedDistance
