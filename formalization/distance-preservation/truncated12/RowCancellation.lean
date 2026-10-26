import PureDistance
import SpanCoefficients
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

theorem binary_support_add_le {A : Type*} [Fintype A] [DecidableEq A]
    (f g : A → ZMod 2) :
    (CoverWeight.support (f+g)).card≤(CoverWeight.support f).card+(CoverWeight.support g).card := by
  have hs : CoverWeight.support (f+g)⊆CoverWeight.support f ∪ CoverWeight.support g := by
    intro q hq
    have hfg : f q+g q≠0 := (Finset.mem_filter.mp hq).2
    by_cases hf : f q=0
    · apply Finset.mem_union_right
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,fun hg => hfg (by rw [hf,hg];rfl)⟩
    · exact Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨Finset.mem_univ _,hf⟩)
  exact (Finset.card_le_card hs).trans (Finset.card_union_le _ _)

theorem leftCount_add_le (u a : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) :
    leftCount (u+a) j≤leftCount u j+leftCount a j := by
  exact binary_support_add_le (fun p : Fin 4 × ZMod L => u j p.1 p.2)
    (fun p : Fin 4 × ZMod L => a j p.1 p.2)

theorem span_is_source_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (h : GeneralLP.InSpanX e u v) :
    ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0 := by
  obtain ⟨w,rfl,rfl⟩ := (full_span_coefficients e u v).mp h
  rintro ⟨⟨j,i⟩,t⟩
  rw [GeneralLP.z_action]
  exact GeneralLP.coefficient_commutation e w j i t

/-- Cancel any complete stabilizer having at most one coordinate in the
exceptional U group. The source profile supplies at most five there. -/
theorem single_exception_cancellation (e : Fin 3 → Fin 4 → ZMod L)
    (D : ℕ) (hD : 6<D) (hC : ClassicalAtLeast e D)
    (u a : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v b : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hSpan : GeneralLP.InSpanX e a b) (j₀ : Fin 4)
    (hU : leftCount u j₀≤5) (hA : leftCount a j₀≤1)
    (hOutside : ∀ j,j≠j₀ → u j=a j) (hRight : v=b) :
    GeneralLP.InSpanX e u v := by
  subst v
  have hy := span_is_source_kernel e a b hSpan
  have hj : GeneralLP.join (u+a) 0=fun q => GeneralLP.join u b q+GeneralLP.join a b q := by
    funext q
    rcases q with ⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩
    · rfl
    · exact (CharTwo.add_self_eq_zero (b l i s)).symm
  have hnew : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join (u+a) 0 q)=0 := by
    intro c
    rw [hj]
    simp only [mul_add,Finset.sum_add_distrib,hk c,hy c,add_zero]
  have hzero (j : Fin 4) (hne : j≠j₀) : (u+a) j=0 := by
    funext k s
    change u j k s+a j k s=0
    rw [hOutside j hne]
    exact CharTwo.add_self_eq_zero _
  have hc0 (j : Fin 4) (hne : j≠j₀) : leftCount (u+a) j=0 := by
    unfold leftCount
    have he : (fun p : Fin 4 × ZMod L => (u+a) j p.1 p.2)=0 := by rw [hzero j hne];rfl
    rw [he]
    simp [CoverWeight.support]
  have hsum : (∑ j,leftCount (u+a) j)=leftCount (u+a) j₀ := by
    apply Finset.sum_eq_single j₀
    · intro j hj hne
      exact hc0 j hne
    · intro hn
      exact False.elim (hn (Finset.mem_univ _))
  have hw : (CoverWeight.support (GeneralLP.join (u+a) 0)).card<D := by
    rw [support_weight_counts,hsum]
    have hadd := leftCount_add_le u a j₀
    have hr : (∑ i,rightCount (0 : Fin 3 → Fin 3 → ZMod L → ZMod 2) i)=0 := by
      simp [rightCount,CoverWeight.support]
    rw [hr,add_zero]
    omega
  have hz := pure_left_zero_below_classical e D hC (u+a) hnew hw
  have hua : u=a := by
    funext j k s
    have he : u j k s+a j k s=0 := congrFun (congrFun (congrFun hz j) k) s
    have he' := congrArg (fun z : ZMod 2 => z+a j k s) he
    simpa only [add_assoc,CharTwo.add_self_eq_zero,add_zero,zero_add] using he'
  simpa only [hua] using hSpan

def rowU (e : Fin 3 → Fin 4 → ZMod L) (H : Fin 3) (K : Fin 4) (z : ZMod L)
    (j k : Fin 4) (s : ZMod L) : ZMod 2 := GeneralLP.HX e ((H,K),z) (.inl ((j,k),s))
def rowV (e : Fin 3 → Fin 4 → ZMod L) (H : Fin 3) (K : Fin 4) (z : ZMod L)
    (l i : Fin 3) (s : ZMod L) : ZMod 2 := GeneralLP.HX e ((H,K),z) (.inr ((l,i),s))

theorem source_row_full_span (e : Fin 3 → Fin 4 → ZMod L) (H : Fin 3) (K : Fin 4) (z : ZMod L) :
    GeneralLP.InSpanX e (rowU e H K z) (rowV e H K z) := by
  refine ⟨fun c => if c=((H,K),z) then 1 else 0,?_⟩
  intro q
  have he : GeneralLP.join (rowU e H K z) (rowV e H K z) q=GeneralLP.HX e ((H,K),z) q := by
    cases q <;> rfl
  rw [he]
  simp [ite_mul]

theorem source_row_left_count (e : Fin 3 → Fin 4 → ZMod L) (H : Fin 3) (K : Fin 4)
    (z : ZMod L) (j : Fin 4) : leftCount (rowU e H K z) j=1 := by
  unfold leftCount
  apply Finset.card_eq_one.mpr
  refine ⟨(K,z-e H j),?_⟩
  ext p
  rcases p with ⟨k,s⟩
  rw [CoverWeight.support,Finset.mem_filter]
  have ht : z=s+e H j ↔ s=z-e H j := by
    rw [eq_sub_iff_add_eq]
    exact eq_comm
  simp [rowU,GeneralLP.HX,GeneralLP.P,SourceModel.P,ht,eq_comm]

#print axioms single_exception_cancellation
#print axioms source_row_full_span
#print axioms source_row_left_count
end TruncatedDistance
