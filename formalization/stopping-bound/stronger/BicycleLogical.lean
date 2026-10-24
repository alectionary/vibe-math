import BicycleDegrees
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
namespace Bicycle.Family
open Matrix Finset
variable {n : ℕ} [NeZero n]
lemma sixList_nodup (h : 39 ∣ n) : (@sixList n).Nodup := by
  apply List.Nodup.of_map (projV h)
  rw [project_sixList]
  decide +kernel

lemma HX_count (h : 39 ∣ n) (c : Check n) (v : Var n) :
    HX (ZMod 2) c v = ((col v).countP (· = c) : ℕ) := by
  rw [HX_entry]
  have hp : (fun x : Check n => decide (x = c)) = (fun x => x == c) := by
    funext x; exact (Bool.beq_eq_decide_eq x c).symm
  rw [hp,← List.count_eq_countP]
  by_cases he : E v c
  · rw [if_pos he,List.count_eq_one_of_mem (col_nodup h v) he]
    rfl
  · rw [if_neg he,List.count_eq_zero.mpr he]
    rfl

lemma six_count_even (c : Check n) : ((@sixList n).flatMap col).countP (· = c) % 2 = 0 := by
  simp only [sixList,List.flatMap_cons,List.flatMap_nil,List.append_nil,List.countP_append,
    col,Bool.false_eq_true,↓reduceIte,List.countP_cons,List.countP_nil,zero_add,add_zero]
  norm_num
  omega

def word : Var n → ZMod 2 := fun v => if v ∈ six then 1 else 0

lemma six_row_sum (h : 39 ∣ n) (c : Check n) : ∑ v ∈ six, HX (ZMod 2) c v = 0 := by
  have he : (∑ v ∈ six, HX (ZMod 2) c v) =
      (((@sixList n).flatMap col).countP (· = c) : ZMod 2) := by
    simp only [HX_count h]
    rw [six,List.sum_toFinset _ (sixList_nodup h),List.countP_flatMap]
    simp [Function.comp_def]
  rw [he,ZMod.natCast_eq_zero_iff]
  exact Nat.dvd_of_mod_eq_zero (six_count_even c)

theorem word_kernel (h : 39 ∣ n) : (HX (ZMod 2)).mulVec (@word n) = 0 := by
  funext c
  simp only [Matrix.mulVec,dotProduct,word,mul_ite,mul_one,mul_zero,Pi.zero_apply]
  rw [← Finset.sum_filter]
  simpa using six_row_sum h c
end Bicycle.Family

namespace Bicycle.Family
open Matrix Finset
variable {n : ℕ} [NeZero n]
def leftParity (x : Var n → ZMod 2) : ZMod 2 :=
  ∑ v, if v.1 then 0 else x v

theorem word_parity (h : 39 ∣ n) : leftParity (@word n) = 1 := by
  have he : leftParity (@word n) = ∑ v ∈ (@six n), if v.1 then (0 : ZMod 2) else 1 := by
    unfold leftParity word
    have hi (v : Var n) : (if v.1 then (0 : ZMod 2) else if v ∈ six then 1 else 0) =
        if v ∈ six then (if v.1 then 0 else 1) else 0 := by
      cases v.1 <;> simp
    simp_rw [hi]
    rw [← sum_filter]
    simp
  rw [he,six,List.sum_toFinset _ (sixList_nodup h)]
  norm_num [sixList] <;> decide +kernel

theorem row_parity (h : 39 ∣ n) (c : Check n) :
    leftParity (fun v => HZ (ZMod 2) c v) = 0 := by
  have he : leftParity (fun v => HZ (ZMod 2) c v) =
      ∑ v ∈ (row c).toFinset, if v.1 then (0 : ZMod 2) else 1 := by
    unfold leftParity HZ
    have hi (v : Var n) : (if v.1 then (0 : ZMod 2) else HX (ZMod 2) c v) =
        if v ∈ (row c).toFinset then (if v.1 then 0 else 1) else 0 := by
      rw [HX_entry]
      have hr : v ∈ (row c).toFinset ↔ E v c := by
        simp only [List.mem_toFinset]
        exact ⟨row_sound v c,row_complete v c⟩
      simp only [hr]
      cases v.1 <;> simp
    simp_rw [hi]
    rw [← sum_filter]
    apply sum_congr
    · ext v; simp
    · intro v hv; rfl
  rw [he,List.sum_toFinset _ (row_nodup h c)]
  norm_num [row] <;> decide +kernel

theorem stabilizer_parity (h : 39 ∣ n) (a : Check n → ZMod 2) :
    leftParity ((HZ (ZMod 2))ᵀ.mulVec a) = 0 := by
  unfold leftParity
  simp only [Matrix.mulVec,dotProduct,transpose_apply]
  have hi (v : Var n) : (if v.1 then (0 : ZMod 2) else ∑ c, HZ (ZMod 2) c v * a c) =
      ∑ c, (if v.1 then 0 else HZ (ZMod 2) c v) * a c := by
    cases v.1 <;> simp
  simp_rw [hi]
  rw [sum_comm]
  simp_rw [← sum_mul]
  change (∑ c, leftParity (fun v => HZ (ZMod 2) c v) * a c) = 0
  simp_rw [row_parity h]
  simp

theorem word_not_stabilizer (h : 39 ∣ n) :
    ¬ ∃ a : Check n → ZMod 2, ((HZ (ZMod 2))ᵀ.mulVec a) = (@word n) := by
  rintro ⟨a,ha⟩
  have hp := stabilizer_parity h a
  rw [ha,word_parity h] at hp
  exact (by decide : (1:ZMod 2) ≠ 0) hp
end Bicycle.Family
