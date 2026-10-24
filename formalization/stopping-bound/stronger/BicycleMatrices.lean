import BicycleFamilyCore
import GramObstruction
import Mathlib.Data.Real.Basic
namespace Bicycle.Family
open Matrix
variable {n : ℕ}
def coef {R : Type*} [Zero R] [One R] (i : Check n) : R :=
  if i = 0 ∨ i = 1 ∨ i = 4 ∨ i = 6 then 1 else 0
def A (R : Type*) [Zero R] [One R] : Matrix (Check n) (Check n) R := circulant coef
def HX (R : Type*) [Zero R] [One R] : Matrix (Check n) (Var n) R := GramStopping.paired (A R)
def HZ (R : Type*) [Zero R] [One R] : Matrix (Check n) (Var n) R := HX R

def BadX (R : Type*) [Zero R] [One R] : Matrix (Check n) (Var n) R := GramStopping.doubled (A R)
def BadZ (R : Type*) [Zero R] [One R] : Matrix (Check n) (Var n) R := GramStopping.doubled (A R)ᵀ

theorem HX_entry {R : Type*} [Zero R] [One R] (c : Check n) (v : Var n) :
    HX R c v = if E v c then 1 else 0 := by
  rcases v with ⟨b,j⟩
  cases b
  · simp [HX,GramStopping.paired,A,Matrix.circulant,coef,E,col,sub_eq_iff_eq_add,eq_comm,add_comm]
  · simp [HX,GramStopping.paired,A,Matrix.circulant,coef,E,col,sub_eq_iff_eq_add,
      eq_sub_iff_add_eq,eq_comm,add_comm]

theorem HX_binary {R : Type*} [Zero R] [One R] (c : Check n) (v : Var n) :
    HX R c v = 0 ∨ HX R c v = 1 := by
  rw [HX_entry]
  split <;> simp

theorem HX2_incidence (c : Check n) (v : Var n) : HX (n := n) (ZMod 2) c v = 1 ↔ E v c := by
  rw [HX_entry]
  split <;> simp_all

theorem css [NeZero n] : HX (n := n) (ZMod 2) * (HZ (n := n) (ZMod 2))ᵀ = 0 :=
  GramStopping.paired_css coef

theorem bad_css [NeZero n] : BadX (n := n) (ZMod 2) * (BadZ (n := n) (ZMod 2))ᵀ = 0 :=
  GramStopping.doubled_css (A (ZMod 2))

theorem real_gram_equal [NeZero n] :
    HX (n := n) ℝ * (HX (n := n) ℝ)ᵀ = BadX (n := n) ℝ * (BadX (n := n) ℝ)ᵀ :=
  GramStopping.circulant_gram_equal coef
end Bicycle.Family
