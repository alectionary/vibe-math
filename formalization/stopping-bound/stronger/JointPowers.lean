import JointMatrices
import PowersThree
namespace JointPowers
open Matrix Finset

def leftMarks (γ n : ℕ) : Finset (ZMod n) := PowersThree.support γ n
def rightMarks (γ n : ℕ) : Finset (ZMod n) :=
  (range γ).image (fun i => ((3^(γ+i):ℕ) : ZMod n))
lemma mark_inj (B n i j : ℕ) (hn : 3^B ≤ n) (hi : i<B) (hj : j<B)
    (he : ((3^i:ℕ):ZMod n) = ((3^j:ℕ):ZMod n)) : i=j := by
  have hsi := PowersThree.pair_lt B n i i hn hi hi
  have hsj := PowersThree.pair_lt B n j j hn hj hj
  have hs := PowersThree.cast_sum_injective _ _ _ _ hsi hsj (congrArg (fun x : ZMod n => x+x) he)
  have hp : 3^i=3^j := by omega
  exact (pow_right_strictMono₀ (by omega : (1:ℕ)<3)).injective hp
lemma left_card (γ n : ℕ) (hn : 3^(2*γ) ≤ n) : (leftMarks γ n).card = γ := by
  apply PowersThree.support_card
  exact (pow_le_pow_right₀ (by omega) (by omega : γ≤2*γ)).trans hn
lemma right_card (γ n : ℕ) (hn : 3^(2*γ) ≤ n) : (rightMarks γ n).card = γ := by
  unfold rightMarks
  rw [card_image_of_injOn,card_range]
  intro i hi j hj he
  have h := mark_inj (2*γ) n (γ+i) (γ+j) hn (by have := mem_range.mp hi; omega)
    (by have := mem_range.mp hj; omega) he
  omega
lemma disjoint_marks (γ n : ℕ) (hn : 3^(2*γ) ≤ n) :
    Disjoint (leftMarks γ n) (rightMarks γ n) := by
  apply disjoint_left.mpr
  intro a ha hb
  obtain ⟨i,hi,rfl⟩ := mem_image.mp ha
  obtain ⟨j,hj,he⟩ := mem_image.mp hb
  have hij := mark_inj (2*γ) n (γ+j) i hn (by have := mem_range.mp hj; omega)
    (by have := mem_range.mp hi; omega) he
  have hi' := mem_range.mp hi
  omega
lemma union_subset (γ n : ℕ) : leftMarks γ n ∪ rightMarks γ n ⊆ PowersThree.support (2*γ) n := by
  intro a ha
  rcases mem_union.mp ha with ha | ha
  · obtain ⟨i,hi,rfl⟩ := mem_image.mp ha
    exact mem_image.mpr ⟨i,mem_range.mpr (by have := mem_range.mp hi; omega),rfl⟩
  · obtain ⟨i,hi,rfl⟩ := mem_image.mp ha
    exact mem_image.mpr ⟨γ+i,mem_range.mpr (by have := mem_range.mp hi; omega),rfl⟩
lemma joint_sidon (γ n : ℕ) (hn : 3^(2*γ) ≤ n) :
    SidonStopping.IsSidon (leftMarks γ n ∪ rightMarks γ n) := by
  intro a ha b hb c hc d hd he
  exact PowersThree.sidon (2*γ) n hn a (union_subset γ n ha) b (union_subset γ n hb)
    c (union_subset γ n hc) d (union_subset γ n hd) he

theorem stopping_bound (γ n : ℕ) [NeZero n] (hn : 3^(2*γ) ≤ n)
    (U : Finset (Bool × ZMod n)) (hU : Incidence.Stopping
      (JointSidon.E (leftMarks γ n) (rightMarks γ n)) U) : γ+1 ≤ U.card := by
  have h := JointSidon.stopping_bound _ _ (joint_sidon γ n hn) (disjoint_marks γ n hn)
    (by rw [left_card γ n hn,right_card γ n hn]) U hU
  simpa only [left_card γ n hn] using h

theorem nontrivial_code (γ n : ℕ) [NeZero n] (hn : 3^(2*γ) ≤ n)
    (he : Even γ) (ho : Odd n) :
    JointSidon.X (ZMod 2) (leftMarks γ n) (rightMarks γ n) *
      (JointSidon.Z (leftMarks γ n) (rightMarks γ n))ᵀ = 0 ∧
    (JointSidon.X (ZMod 2) (leftMarks γ n) (rightMarks γ n)).mulVec
      (SidonStopping.leftOnes (G := ZMod n)) = 0 ∧
    (¬ ∃ a, (JointSidon.Z (leftMarks γ n) (rightMarks γ n))ᵀ.mulVec a = SidonStopping.leftOnes) := by
  refine ⟨JointSidon.css _ _,JointSidon.left_kernel _ _ ?_,JointSidon.left_not_stabilizer _ _ ?_ ?_⟩
  · simpa only [left_card γ n hn] using he
  · simpa only [right_card γ n hn] using he
  · simpa using ho
end JointPowers
