import SourceSeven
import SourceProfiles
import PauliBridge
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

theorem zero_of_support_card_zero {A : Type*} [Fintype A] [DecidableEq A]
    (f : A → ZMod 2) (hf : (CoverWeight.support f).card=0) : f=0 := by
  have hs := Finset.card_eq_zero.mp hf
  funext a
  by_contra hn
  have hm : a∈CoverWeight.support f := Finset.mem_filter.mpr ⟨Finset.mem_univ _,hn⟩
  rw [hs] at hm
  exact Finset.notMem_empty a hm

theorem left_zero_of_count_sum_zero (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (h : (∑ j,leftCount u j)=0) : u=0 := by
  have hz (j : Fin 4) : leftCount u j=0 := by
    have ht := Finset.single_le_sum (fun k _ => Nat.zero_le (leftCount u k)) (Finset.mem_univ j)
    omega
  funext j k s
  have hf := zero_of_support_card_zero (fun q : Fin 4 × ZMod L => u j q.1 q.2) (hz j)
  exact congrFun hf (k,s)

theorem right_zero_of_count_sum_zero (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (h : (∑ i,rightCount v i)=0) : v=0 := by
  have hz (i : Fin 3) : rightCount v i=0 := by
    have ht := Finset.single_le_sum (fun k _ => Nat.zero_le (rightCount v k)) (Finset.mem_univ i)
    omega
  funext l i s
  have hf := zero_of_support_card_zero (fun q : Fin 3 × ZMod L => v q.1 i q.2) (hz i)
  exact congrFun hf (l,s)

theorem zero_full_source_span (e : Fin 3 → Fin 4 → ZMod L) :
    GeneralLP.InSpanX e 0 0 := by
  refine ⟨0,?_⟩
  intro q
  cases q <;> simp [GeneralLP.join,SourceModel.join]

/-- A completed intermediate source theorem through weight nine. The requested
through-weight-eleven statement remains stronger and is not inferred here. -/
theorem source_kernel_below_ten_is_stabilizer
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D) (hT : TransposeAtLeast e D)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card<min D 10) :
    GeneralLP.InSpanX e u v := by
  have hwD : (CoverWeight.support (GeneralLP.join u v)).card<D := (lt_min_iff.mp hw).1
  have hw10 : (CoverWeight.support (GeneralLP.join u v)).card<10 := (lt_min_iff.mp hw).2
  by_cases hU : 0<∑ j,leftCount u j
  · by_cases hV : 0<∑ i,rightCount v i
    · rcases source_mixed_count_profiles e h4 h6 u v hk (by omega) hU hV with h7|h10|h11
      · apply source_seven_singleton_profile_stabilizer e h4 h6 hR0 hC0 hCP hP u v hk
        · intro j
          have hm := (sortedCounts_mem (leftCount u) (leftCount u j)).mpr ⟨j,rfl⟩
          have he := congrArg (fun p : List ℕ × List ℕ => p.1) h7
          change sortedCounts (leftCount u)=[1,1,1,1] at he
          rw [he] at hm
          simpa using hm
        · intro i
          have hm := (sortedCounts_mem (rightCount v) (rightCount v i)).mpr ⟨i,rfl⟩
          have he := congrArg (fun p : List ℕ × List ℕ => p.2) h7
          change sortedCounts (rightCount v)=[1,1,1] at he
          rw [he] at hm
          simpa using hm
      · have ht := congrArg (fun p : List ℕ × List ℕ => p.1.sum+p.2.sum) h10
        simp only [sortedCounts_sum,List.sum_cons,List.sum_nil] at ht
        have hcounts := support_weight_counts u v
        omega
      · have ht := congrArg (fun p : List ℕ × List ℕ => p.1.sum+p.2.sum) h11
        simp only [sortedCounts_sum,List.sum_cons,List.sum_nil] at ht
        have hcounts := support_weight_counts u v
        omega
    · have hv : v=0 := right_zero_of_count_sum_zero v (by omega)
      subst v
      have hu := pure_left_zero_below_classical e D hC u hk hwD
      rw [hu]
      exact zero_full_source_span e
  · have hu : u=0 := left_zero_of_count_sum_zero u (by omega)
    subst u
    have hv := pure_right_zero_below_transpose e D hT v hk hwD
    rw [hv]
    exact zero_full_source_span e

/-- Actual X logicals have weight at least min(D,10), with both actual classical
kernels bounded below by D. No claim of min(D,12) is made by this theorem. -/
theorem source_x_bound_ten
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D) (hT : TransposeAtLeast e D)
    (x : Qubit L → ZMod 2) (hx : pureX e x) : min D 10≤(CoverWeight.support x).card := by
  by_contra hn
  let u := fun j k s => x (.inl ((j,k),s))
  let v := fun l i s => x (.inr ((l,i),s))
  have hj : GeneralLP.join u v=x := by funext q;cases q <;> rfl
  have hs := source_kernel_below_ten_is_stabilizer e h4 h6 hR0 hC0 hCP hP D hC hT
    u v (by simpa only [hj] using hx.1) (by rw [hj];omega)
  apply hx.2
  obtain ⟨w,hw⟩ := hs
  exact ⟨w,by simpa only [hj] using hw⟩

/-- Complete intermediate Pauli union-weight bound, retaining both full spans. -/
theorem source_pauli_bound_ten
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D) (hT : TransposeAtLeast e D)
    (x z : Qubit L → ZMod 2)
    (hx : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hz : ∀ c,(∑ q,GeneralLP.HX e c q*z q)=0)
    (hn : ¬(fullSpanX e x ∧ fullSpanZ e z)) :
    min D 10≤((CoverWeight.support x)∪(CoverWeight.support z)).card := by
  exact pauli_bound_of_x_bound e (min D 10)
    (source_x_bound_ten e h4 h6 hR0 hC0 hCP hP D hC hT) x z hx hz hn

#print axioms source_kernel_below_ten_is_stabilizer
#print axioms source_x_bound_ten
#print axioms source_pauli_bound_ten
end TruncatedDistance
