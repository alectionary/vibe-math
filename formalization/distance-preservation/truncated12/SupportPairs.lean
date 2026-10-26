import SupportSingletons
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {A : Type*} [Fintype A] [DecidableEq A]

theorem binary_pair_representation (f : A → ZMod 2)
    (h : (CoverWeight.support f).card=2) :
    ∃ a b,a≠b ∧ ∀ q,f q=if q=a ∨ q=b then 1 else 0 := by
  obtain ⟨a,b,hab,hs⟩ := Finset.card_eq_two.mp h
  refine ⟨a,b,hab,?_⟩
  intro q
  have hm : q∈CoverWeight.support f ↔ q=a ∨ q=b := by rw [hs];simp
  by_cases hq : q=a ∨ q=b
  · have hf := (Finset.mem_filter.mp (hm.mpr hq)).2
    rw [if_pos hq]
    exact CoverWeight.nonzero_one _ hf
  · have hf : f q=0 := by
      by_contra hn
      exact hq (hm.mp (Finset.mem_filter.mpr ⟨Finset.mem_univ _,hn⟩))
    rw [if_neg hq,hf]

variable {L : ℕ} [NeZero L]

theorem pair_fibers_equal (f : A × ZMod L → ZMod 2)
    (a b : A) (s t : ZMod L)
    (hf : ∀ q,f q=if q=(a,s) ∨ q=(b,t) then 1 else 0)
    (he : ∀ z,(∑ k : A,f (k,z))=0) : s=t := by
  by_contra hn
  have hone : (∑ k : A,f (k,s))=1 := by
    simp_rw [hf]
    simp [hn]
  have hz := he s
  rw [hone] at hz
  exact one_ne_zero hz

theorem left_pair_same_fiber (e : Fin 3 → Fin 4 → ZMod L)
    (hR0 : ∀ k,e 0 k=0)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hv : ∀ l s,v l 0 s=0) (j : Fin 4) (hu : leftCount u j=2) :
    ∃ a b s,a≠b ∧ ∀ k z,u j k z=if (k=a ∨ k=b) ∧ z=s then 1 else 0 := by
  obtain ⟨⟨a,s⟩,⟨b,t⟩,hab,hf⟩ := binary_pair_representation (fun q : Fin 4 × ZMod L => u j q.1 q.2) hu
  have he (z : ZMod L) : (∑ k : Fin 4,u j k z)=0 := by
    have h := (GeneralLP.z_action e u v j 0 z).symm.trans (hk ((j,0),z))
    simpa [GeneralLP.Syndrome,hR0,hv] using h
  have hst := pair_fibers_equal (fun q : Fin 4 × ZMod L => u j q.1 q.2) a b s t hf he
  subst t
  refine ⟨a,b,s,fun h => hab (by cases h;rfl),?_⟩
  intro k z
  simpa only [Prod.mk.injEq,or_and_right] using hf (k,z)

theorem right_pair_same_fiber (e : Fin 3 → Fin 4 → ZMod L)
    (hC0 : ∀ l,e l 0=0)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hu : ∀ k s,u 0 k s=0) (i : Fin 3) (hv : rightCount v i=2) :
    ∃ a b s,a≠b ∧ ∀ l z,v l i z=if (l=a ∨ l=b) ∧ z=s then 1 else 0 := by
  obtain ⟨⟨a,s⟩,⟨b,t⟩,hab,hf⟩ := binary_pair_representation (fun q : Fin 3 × ZMod L => v q.1 i q.2) hv
  have he (z : ZMod L) : (∑ l : Fin 3,v l i z)=0 := by
    have h := (GeneralLP.z_action e u v 0 i z).symm.trans (hk ((0,i),z))
    simpa [GeneralLP.Syndrome,hC0,hu] using h
  have hst := pair_fibers_equal (fun q : Fin 3 × ZMod L => v q.1 i q.2) a b s t hf he
  subst t
  refine ⟨a,b,s,fun h => hab (by cases h;rfl),?_⟩
  intro l z
  simpa only [Prod.mk.injEq,or_and_right] using hf (l,z)

#print axioms left_pair_same_fiber
#print axioms right_pair_same_fiber
end TruncatedDistance
