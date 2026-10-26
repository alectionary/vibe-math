import PairMatching
import ThroughNine
import FiniteLabels
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

structure TenGeometry (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) where
  K : Fin 3 → Fin 2 → Fin 4
  H : Fin 2 → Fin 2 → Fin 3
  S : Fin 3 → ZMod L
  T : Fin 2 → ZMod L
  orderedK : ∀ j,K j 0<K j 1
  orderedH : ∀ i,H i 0<H i 1
  left_repr : ∀ j k z,u j.succ k z=if (k=K j 0 ∨ k=K j 1) ∧ z=S j then 1 else 0
  right_repr : ∀ i l z,v l i.succ z=if (l=H i 0 ∨ l=H i 1) ∧ z=T i then 1 else 0
  flip : Fin 2 → Fin 3 → Fin 2
  matching : ∀ i j a,
    S j+e i.succ (K j a)=T i-e (H i (if a=flip i j then 0 else 1)) j.succ

/-- Extract the complete pair geometry from the actual normalized weight-ten
profile. The six matching choices are derived from the source kernel. -/
theorem source_ten_geometry (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e))
    (hR0 : ∀ k,e 0 k=0) (hC0 : ∀ l,e l 0=0)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hU0 : leftCount u 0=0) (hV0 : rightCount v 0=0)
    (hU : ∀ j : Fin 3,leftCount u j.succ=2)
    (hV : ∀ i : Fin 2,rightCount v i.succ=2) : Nonempty (TenGeometry e u v) := by
  classical
  have hu0 : ∀ k s,u 0 k s=0 := by
    have h := zero_of_support_card_zero (fun q : Fin 4 × ZMod L => u 0 q.1 q.2) hU0
    intro k s
    exact congrFun h (k,s)
  have hv0 : ∀ l s,v l 0 s=0 := by
    have h := zero_of_support_card_zero (fun q : Fin 3 × ZMod L => v q.1 0 q.2) hV0
    intro l s
    exact congrFun h (l,s)
  have hleft (j : Fin 3) : ∃ a b s,a<b ∧
      ∀ k z,u j.succ k z=if (k=a ∨ k=b) ∧ z=s then 1 else 0 := by
    obtain ⟨a,b,s,hab,hf⟩ := left_pair_same_fiber e hR0 u v hk hv0 j.succ (hU j)
    rcases lt_or_gt_of_ne hab with h|h
    · exact ⟨a,b,s,h,hf⟩
    · exact ⟨b,a,s,h,by simpa only [or_comm] using hf⟩
  have hright (i : Fin 2) : ∃ a b s,a<b ∧
      ∀ l z,v l i.succ z=if (l=a ∨ l=b) ∧ z=s then 1 else 0 := by
    obtain ⟨a,b,s,hab,hf⟩ := right_pair_same_fiber e hC0 u v hk hu0 i.succ (hV i)
    rcases lt_or_gt_of_ne hab with h|h
    · exact ⟨a,b,s,h,hf⟩
    · exact ⟨b,a,s,h,by simpa only [or_comm] using hf⟩
  choose a b S hab hu using hleft
  choose l m T hlm hv using hright
  have hm (i : Fin 2) (j : Fin 3) : ∃ f : Fin 2,∀ t : Fin 2,
      S j+e i.succ ((![a j,b j]) t)=
        T i-e ((![l i,m i]) (if t=f then 0 else 1)) j.succ := by
    have hcase := source_pair_cross_matching e h4 hR0 hC0 u v hk j.succ (by simp)
      i.succ (by simp) (a j) (b j) (ne_of_lt (hab j)) (l i) (m i) (ne_of_lt (hlm i))
      (S j) (T i) (hu j) (hv i)
    rcases hcase with ⟨h0,h1⟩|⟨h0,h1⟩
    · refine ⟨0,?_⟩
      intro t
      fin_cases t
      · simpa using h0
      · simpa using h1
    · refine ⟨1,?_⟩
      intro t
      fin_cases t
      · simpa using h0
      · simpa using h1
  choose flip hf using hm
  exact ⟨{
    K := fun j => ![a j,b j]
    H := fun i => ![l i,m i]
    S := S
    T := T
    orderedK := by simpa using hab
    orderedH := by simpa using hlm
    left_repr := by simpa using hu
    right_repr := by simpa using hv
    flip := flip
    matching := hf
  }⟩

#print axioms source_ten_geometry
end TruncatedDistance
