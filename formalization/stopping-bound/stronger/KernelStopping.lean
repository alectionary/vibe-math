import BicycleLogical
import BicycleFamily
namespace BinaryStopping
open Matrix Finset
variable {V C : Type*} [Fintype V] [DecidableEq V] [DecidableEq C]
variable (E : V → C → Prop) [DecidableRel E]
def matrix : Matrix C V (ZMod 2) := fun c v => if E v c then 1 else 0
def support (x : V → ZMod 2) : Finset V := univ.filter (fun v => x v ≠ 0)

theorem kernel_stopping (x : V → ZMod 2) (hne : x ≠ 0)
    (hk : (matrix E).mulVec x = 0) : Incidence.Stopping E (support x) := by
  classical
  refine ⟨?_,?_⟩
  · by_contra h
    apply hne
    funext v
    have hn : ¬ v ∈ support x := fun hv => h ⟨v,hv⟩
    simpa [support] using hn
  · intro c hc
    obtain ⟨v,hv⟩ := card_eq_one.mp hc
    have hvm : v ∈ (support x).filter (fun w => E w c) := by rw [hv]; simp
    have hvx : x v ≠ 0 := (mem_filter.mp (mem_filter.mp hvm).1).2
    have hEv := (mem_filter.mp hvm).2
    have hx1 : x v = 1 := (show ∀ y : ZMod 2, y ≠ 0 → y = 1 by decide) _ hvx
    have hrow : ((matrix E).mulVec x) c = 1 := by
      simp only [Matrix.mulVec,dotProduct,matrix]
      rw [sum_eq_single v]
      · simp [hEv,hx1]
      · intro w _ hwv
        by_cases hw : x w = 0
        · simp [hw]
        · have hmem : w ∈ support x := mem_filter.mpr ⟨mem_univ _,hw⟩
          have hnot : ¬ E w c := by
            intro he
            have : w ∈ (support x).filter (fun z => E z c) := mem_filter.mpr ⟨hmem,he⟩
            have : w = v := by simpa [hv] using this
            exact hwv this
          simp [hnot]
      · simp
    rw [hk] at hrow
    exact (by decide : (0:ZMod 2) ≠ 1) hrow
end BinaryStopping

namespace Bicycle.Family
open Matrix Finset
variable {n : ℕ} [NeZero n]
lemma word_support : BinaryStopping.support (@word n) = six := by
  ext v
  simp [BinaryStopping.support,word]
lemma word_weight (h : 39 ∣ n) : (BinaryStopping.support (@word n)).card = 6 := by
  rw [word_support,six_card h]

theorem all_nonzero_kernel_weight_ge_six (h : 39 ∣ n) (x : Var n → ZMod 2)
    (hne : x ≠ 0) (hk : (HX (ZMod 2)).mulVec x = 0) :
    6 ≤ (BinaryStopping.support x).card := by
  have he : BinaryStopping.matrix (@E n) = HX (ZMod 2) := by
    ext c v
    exact (HX_entry c v).symm
  apply stopping_ge_six h
  apply BinaryStopping.kernel_stopping E x hne
  rw [he]
  exact hk

/-- Both CSS sectors coincide. This states the exact logical-distance content
without assuming a dimension formula or identifying a stabilizer with a logical. -/
theorem quantum_distance_six (h : 39 ∣ n) :
    (HX (n := n) (ZMod 2) * (HZ (n := n) (ZMod 2))ᵀ = 0) ∧
    (∀ x : Var n → ZMod 2, x ≠ 0 → (HX (ZMod 2)).mulVec x = 0 →
      6 ≤ (BinaryStopping.support x).card) ∧
    (HX (ZMod 2)).mulVec (@word n) = 0 ∧
    (¬ ∃ a : Check n → ZMod 2, ((HZ (ZMod 2))ᵀ.mulVec a) = (@word n)) ∧
    (BinaryStopping.support (@word n)).card = 6 :=
  ⟨css,all_nonzero_kernel_weight_ge_six h,word_kernel h,word_not_stabilizer h,word_weight h⟩
end Bicycle.Family
