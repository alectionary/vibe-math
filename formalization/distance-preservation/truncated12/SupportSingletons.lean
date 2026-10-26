import BucketCounts
import SingletonLabels
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {A : Type*} [Fintype A] [DecidableEq A]

theorem binary_singleton_representation (f : A → ZMod 2)
    (h : (CoverWeight.support f).card=1) :
    ∃ a, ∀ q,f q=if q=a then 1 else 0 := by
  obtain ⟨a,ha⟩ := Finset.card_eq_one.mp h
  refine ⟨a,?_⟩
  intro q
  by_cases hq : q=a
  · subst q
    have hm : a∈CoverWeight.support f := by rw [ha];simp
    have hf := (Finset.mem_filter.mp hm).2
    simpa using CoverWeight.nonzero_one (f a) hf
  · have hz : f q=0 := by
      by_contra hn
      have hm : q∈CoverWeight.support f := Finset.mem_filter.mpr ⟨Finset.mem_univ _,hn⟩
      rw [ha,Finset.mem_singleton] at hm
      exact hq hm
    simp only [if_neg hq,hz]

variable {L : ℕ} [NeZero L]

theorem left_count_one_representation (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (j : Fin 4) (h : leftCount u j=1) :
    ∃ k s, ∀ k' s',u j k' s'=if k'=k ∧ s'=s then 1 else 0 := by
  obtain ⟨⟨k,s⟩,hr⟩ := binary_singleton_representation (fun p : Fin 4 × ZMod L => u j p.1 p.2) h
  refine ⟨k,s,?_⟩
  intro k' s'
  simpa only [Prod.mk.injEq] using hr (k',s')

theorem right_count_one_representation (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (i : Fin 3) (h : rightCount v i=1) :
    ∃ l t, ∀ l' t',v l' i t'=if l'=l ∧ t'=t then 1 else 0 := by
  obtain ⟨⟨l,t⟩,hr⟩ := binary_singleton_representation (fun p : Fin 3 × ZMod L => v p.1 i p.2) h
  refine ⟨l,t,?_⟩
  intro l' t'
  simpa only [Prod.mk.injEq] using hr (l',t')

theorem singleton_source_check_matches (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (j k : Fin 4) (i l : Fin 3) (s t : ZMod L)
    (hU : ∀ k' s',u j k' s'=if k'=k ∧ s'=s then 1 else 0)
    (hV : ∀ l' t',v l' i t'=if l'=l ∧ t'=t then 1 else 0) :
    s+e i k=t-e l j := by
  have hu : (∑ k' : Fin 4,u j k' (s+e i k-e i k'))=1 := by
    simp_rw [hU,ite_and]
    simp
  have hv : (∑ l' : Fin 3,v l' i (s+e i k+e l' j))=
      if s+e i k+e l j=t then 1 else 0 := by
    simp_rw [hV,ite_and]
    simp
  have hsy := (GeneralLP.z_action e u v j i (s+e i k)).symm.trans (hk ((j,i),s+e i k))
  change (∑ k' : Fin 4,u j k' (s+e i k-e i k'))+
    (∑ l' : Fin 3,v l' i (s+e i k+e l' j))=0 at hsy
  rw [hu,hv] at hsy
  have he : s+e i k+e l j=t := by
    by_contra hn
    rw [if_neg hn,add_zero] at hsy
    exact one_ne_zero hsy
  exact eq_sub_iff_add_eq.mpr he

/-- Actual source singleton supports supply both label maps, their fibers and
the equations required by the constant/injective alternative. -/
theorem actual_singleton_label_alternative {J : Type*} [Nonempty J] [Nontrivial J]
    (e : Fin 3 → Fin 4 → ZMod L) (h4 : TannerSix.NoFour (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (a : J → Fin 4) (ha : Function.Injective a)
    (hU : ∀ j,leftCount u (a j)=1) (hV : ∀ i,rightCount v i=1) :
    ∃ k : J → Fin 4, ∃ s : J → ZMod L, ∃ l : Fin 3 → Fin 3, ∃ t : Fin 3 → ZMod L,
      (∀ j k' s',u (a j) k' s'=if k'=k j ∧ s'=s j then 1 else 0) ∧
      (∀ i l' t',v l' i t'=if l'=l i ∧ t'=t i then 1 else 0) ∧
      (∀ j i,s j+e i (k j)=t i-e (l i) (a j)) ∧
      ((∃ K H,(∀ j,k j=K) ∧ (∀ i,l i=H)) ∨
        (Function.Injective k ∧ Function.Injective l)) := by
  classical
  choose k s hu using (fun j => left_count_one_representation u (a j) (hU j))
  choose l t hv using (fun i => right_count_one_representation v i (hV i))
  have hc (j : J) (i : Fin 3) : s j+e i (k j)=t i-e (l i) (a j) :=
    singleton_source_check_matches e u v hk (a j) (k j) i (l i) (s j) (t i) (hu j) (hv i)
  exact ⟨k,s,l,t,hu,hv,hc,singleton_labels_constant_or_injective e h4 a ha
    (fun i : Fin 3 => i) Function.injective_id k l s t hc⟩

#print axioms singleton_source_check_matches
#print axioms actual_singleton_label_alternative
end TruncatedDistance
