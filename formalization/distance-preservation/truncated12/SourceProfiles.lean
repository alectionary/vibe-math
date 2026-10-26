import LocalMantel
import CountPatterns
import Mathlib.Data.List.Sort
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

def sortedCounts {n : ℕ} (f : Fin n → ℕ) : List ℕ := (List.ofFn f).mergeSort (· ≥ ·)

lemma sortedCounts_perm {n : ℕ} (f : Fin n → ℕ) :
    (sortedCounts f).Perm (List.ofFn f) := List.mergeSort_perm _ _
lemma sortedCounts_pairwise {n : ℕ} (f : Fin n → ℕ) :
    (sortedCounts f).Pairwise (· ≥ ·) := List.pairwise_mergeSort' _ _
lemma sortedCounts_length {n : ℕ} (f : Fin n → ℕ) : (sortedCounts f).length=n := by
  simpa using (sortedCounts_perm f).length_eq
lemma sortedCounts_sum {n : ℕ} (f : Fin n → ℕ) : (sortedCounts f).sum=∑ i,f i := by
  rw [(sortedCounts_perm f).sum_eq,List.sum_ofFn]
lemma sortedCounts_mem {n : ℕ} (f : Fin n → ℕ) (x : ℕ) :
    x∈sortedCounts f ↔ ∃ i,f i=x := by
  rw [(sortedCounts_perm f).mem_iff,List.mem_ofFn]
lemma sortedCounts_map_sum {n : ℕ} (f : Fin n → ℕ) (g : ℕ → ℕ) :
    ((sortedCounts f).map g).sum=∑ i,g (f i) := by
  rw [((sortedCounts_perm f).map g).sum_eq,List.map_ofFn,List.sum_ofFn]
  rfl

/-- This theorem starts with the actual expanded source kernel, not a
postulated abstract count profile. It classifies all mixed supports up to 11. -/
theorem source_mixed_count_profiles (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (hU : 0<∑ j,leftCount u j) (hV : 0<∑ i,rightCount v i) :
    (sortedCounts (leftCount u),sortedCounts (rightCount v))=([1,1,1,1],[1,1,1]) ∨
    (sortedCounts (leftCount u),sortedCounts (rightCount v))=([2,2,2,0],[2,2,0]) ∨
    (sortedCounts (leftCount u),sortedCounts (rightCount v))=([5,1,1,1],[1,1,1]) := by
  have htotal : (∑ j,leftCount u j)+(∑ i,rightCount v i)≤11 := by
    simpa only [support_weight_counts] using hw
  have hsy : ∀ j i t, GeneralLP.Syndrome e u v j i t=0 := by
    intro j i t
    exact (GeneralLP.z_action e u v j i t).symm.trans (hk ((j,i),t))
  obtain ⟨p,hp,hap,hbp⟩ := common_count_parity e u v hsy
  have hboundA (x : ℕ) (hx : x∈sortedCounts (leftCount u)) : x≤11 := by
    obtain ⟨j,rfl⟩ := (sortedCounts_mem _ _).mp hx
    have hs : leftCount u j≤∑ k,leftCount u k :=
      Finset.single_le_sum (fun k _ => Nat.zero_le _) (Finset.mem_univ j)
    omega
  have hboundB (x : ℕ) (hx : x∈sortedCounts (rightCount v)) : x≤11 := by
    obtain ⟨i,rfl⟩ := (sortedCounts_mem _ _).mp hx
    have hs : rightCount v i≤∑ k,rightCount v k :=
      Finset.single_le_sum (fun k _ => Nat.zero_le _) (Finset.mem_univ i)
    omega
  have hparA (x : ℕ) (hx : x∈sortedCounts (leftCount u)) : x%2=p := by
    obtain ⟨j,rfl⟩ := (sortedCounts_mem _ _).mp hx
    exact hap j
  have hparB (x : ℕ) (hx : x∈sortedCounts (rightCount v)) : x%2=p := by
    obtain ⟨i,rfl⟩ := (sortedCounts_mem _ _).mp hx
    exact hbp i
  have hm := mem_countCases (sortedCounts (leftCount u)) (sortedCounts (rightCount v)) p hp
    (sortedCounts_length _) (sortedCounts_length _) (sortedCounts_pairwise _)
    (sortedCounts_pairwise _) hboundA hboundB hparA hparB
    (by simpa only [sortedCounts_sum] using hU)
    (by simpa only [sortedCounts_sum] using hV)
    (by simpa only [sortedCounts_sum] using htotal)
  apply classified_of_mem_countCases _ hm
  apply Bool.and_eq_true_iff.mpr
  constructor
  · apply List.all_eq_true.mpr
    intro a ha
    obtain ⟨j,rfl⟩ := (sortedCounts_mem _ _).mp ha
    apply decide_eq_true_iff.mpr
    simpa only [sortedCounts_map_sum,pow_two] using source_left_local_mantel e h4 h6 u v hk hw j
  · apply List.all_eq_true.mpr
    intro b hb
    obtain ⟨i,rfl⟩ := (sortedCounts_mem _ _).mp hb
    apply decide_eq_true_iff.mpr
    simpa only [sortedCounts_map_sum,pow_two] using source_right_local_mantel e h4 h6 u v hk hw i

#print axioms source_mixed_count_profiles
end TruncatedDistance
