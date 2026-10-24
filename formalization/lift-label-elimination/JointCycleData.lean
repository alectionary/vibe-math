import CycleData
import SparseCSSMatrices
import StarVoltageData
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
namespace JointCycleData
open scoped BigOperators
def rows : Fin 2 → Fin 3 → Fin 30 → ℤ :=
  CycleData.get3 [[[1,-1,0,-1,1,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[1,0,-1,-1,0,1,0,0,0,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,1,1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],[[0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,-1,0,0,0,0,-1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,0,0,0,1,-1,0,0,0,0,-1,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,-1,0,0,0,0,0,0,0,-1,1]]]
def dualH := SparseCSSMatrices.dual PaschCubicTrade.baseA
def variableAt (i : Fin 4) : Fin 10 := ⟨i.val+6,by omega⟩
def checks : Fin 6 → Fin 10 := fun e => match e.val with
 | 0 => 4
 | 1 => 5
 | 2 => 6
 | 3 => 7
 | 4 => 8
 | 5 => 9
 | _ => 0
variable {R : Type*} [CommRing R]
def d (z : Fin 30 → R) := PaschLiftCriterion.differences
  (fun i c => -StarVoltageData.labelsRaw z c (variableAt i)) checks
def residual (z : Fin 30 → R) (j : Fin 3) : R := match j.val with
 | 0 => d z 0+d z 3-d z 1
 | 1 => d z 0+d z 4-d z 2
 | _ => d z 1+d z 5-d z 2
theorem dual_rows (z : Fin 30 → R) (j : Fin 3) :
 (∑ k, (rows 1 j k : R)*z k)=residual z j := by
 fin_cases j <;> norm_num [rows,CycleData.get3,residual,d,PaschLiftCriterion.differences,
   variableAt,checks,StarVoltageData.labelsRaw,Fin.sum_univ_succ] <;> ring
theorem dual_balanced (z : Fin 30 → R) : PaschVoltage.Balanced (d z) ↔
 ∀ j : Fin 3, ∑ k, (rows 1 j k : R)*z k=0 := by
 simp_rw [dual_rows]
 constructor
 · rintro ⟨a,b,c⟩ j; fin_cases j <;> simp only [residual]
   · exact sub_eq_zero.mpr a
   · exact sub_eq_zero.mpr b
   · exact sub_eq_zero.mpr c
 · intro h; exact ⟨sub_eq_zero.mp (h 0),sub_eq_zero.mp (h 1),sub_eq_zero.mp (h 2)⟩
#print axioms dual_rows
#print axioms dual_balanced
end JointCycleData
