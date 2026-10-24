import CycleData
import PaschReindex
import SupportVoltageCount
import PaschCubicTrade
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace TriangleVoltageData
open scoped BigOperators
abbrev H := PaschCubicTrade.baseB
def variableAt : Fin 5 → Fin 4 → Fin 10 := fun r i => match r.val,i.val with
  | 0,0 => 0
  | 0,1 => 1
  | 0,2 => 2
  | 0,3 => 3
  | 1,0 => 0
  | 1,1 => 7
  | 1,2 => 8
  | 1,3 => 9
  | 2,0 => 1
  | 2,1 => 5
  | 2,2 => 6
  | 2,3 => 9
  | 3,0 => 2
  | 3,1 => 4
  | 3,2 => 6
  | 3,3 => 8
  | 4,0 => 3
  | 4,1 => 4
  | 4,2 => 5
  | 4,3 => 7
  | _,_ => 0
def checks : Fin 5 → Fin 6 → Fin 10 := fun r e => match r.val,e.val with
  | 0,0 => 5
  | 0,1 => 4
  | 0,2 => 3
  | 0,3 => 2
  | 0,4 => 1
  | 0,5 => 0
  | 1,0 => 3
  | 1,1 => 4
  | 1,2 => 5
  | 1,3 => 7
  | 1,4 => 8
  | 1,5 => 9
  | 2,0 => 1
  | 2,1 => 2
  | 2,2 => 5
  | 2,3 => 6
  | 2,4 => 8
  | 2,5 => 9
  | 3,0 => 0
  | 3,1 => 2
  | 3,2 => 4
  | 3,3 => 6
  | 3,4 => 7
  | 3,5 => 9
  | 4,0 => 0
  | 4,1 => 1
  | 4,2 => 3
  | 4,3 => 6
  | 4,4 => 7
  | 4,5 => 8
  | _,_ => 0
def edges : Fin 30 → Fin 10 × Fin 10 := fun i => match i.val with
  | 0 => (0,3)
  | 1 => (0,4)
  | 2 => (0,5)
  | 3 => (1,1)
  | 4 => (1,2)
  | 5 => (1,5)
  | 6 => (2,0)
  | 7 => (2,2)
  | 8 => (2,4)
  | 9 => (3,0)
  | 10 => (3,1)
  | 11 => (3,3)
  | 12 => (4,0)
  | 13 => (4,6)
  | 14 => (4,7)
  | 15 => (5,1)
  | 16 => (5,6)
  | 17 => (5,8)
  | 18 => (6,2)
  | 19 => (6,6)
  | 20 => (6,9)
  | 21 => (7,3)
  | 22 => (7,7)
  | 23 => (7,8)
  | 24 => (8,4)
  | 25 => (8,7)
  | 26 => (8,9)
  | 27 => (9,5)
  | 28 => (9,8)
  | 29 => (9,9)
  | _ => (0,0)
theorem edges_unique : Function.Injective edges := by decide
theorem edges_complete : ∀ v c, c∈H v → ∃ i, edges i=(v,c) := by decide
def labelsRaw {R : Type*} [CommRing R] (z : Fin 30 → R) (v c : Fin 10) : R :=
  match v.val,c.val with
  | 0,3 => z 0
  | 0,4 => z 1
  | 0,5 => z 2
  | 1,1 => z 3
  | 1,2 => z 4
  | 1,5 => z 5
  | 2,0 => z 6
  | 2,2 => z 7
  | 2,4 => z 8
  | 3,0 => z 9
  | 3,1 => z 10
  | 3,3 => z 11
  | 4,0 => z 12
  | 4,6 => z 13
  | 4,7 => z 14
  | 5,1 => z 15
  | 5,6 => z 16
  | 5,8 => z 17
  | 6,2 => z 18
  | 6,6 => z 19
  | 6,9 => z 20
  | 7,3 => z 21
  | 7,7 => z 22
  | 7,8 => z 23
  | 8,4 => z 24
  | 8,7 => z 25
  | 8,9 => z 26
  | 9,5 => z 27
  | 9,8 => z 28
  | 9,9 => z 29
  | _,_ => 0
def labelsGauge {R : Type*} [CommRing R] (z : Fin 11 → R) (v c : Fin 10) : R :=
  match v.val,c.val with
  | 2,4 => z 0
  | 3,1 => z 1
  | 3,3 => z 2
  | 5,6 => z 3
  | 6,6 => z 4
  | 7,7 => z 5
  | 7,8 => z 6
  | 8,7 => z 7
  | 8,9 => z 8
  | 9,8 => z 9
  | 9,9 => z 10
  | _,_ => 0
def repSet (r) := Finset.univ.image (variableAt r)
theorem rep_injective : ∀ r : Fin 5, Function.Injective (variableAt r) := by decide
theorem repSet_injective : Function.Injective (repSet : Fin 5 → Finset (Fin 10)) := by decide
theorem rep_card : ∀ r : Fin 5, (repSet r).card=4 := by decide
theorem complete_supports : (GlobalCounting.fourSupports.filter (PaschKernelCount.elementary40Check H))=
    (Finset.univ : Finset (Fin 5)).image repSet := by decide
theorem rep_even : ∀ r : Fin 5, PaschClassification.EvenChecks (fun i => H (variableAt r i)) := by
  change ∀ r : Fin 5, ∀ c : Fin 10,
    (FourColumnClassification.support (fun i => H (variableAt r i)) c).card%2=0
  decide
theorem pair_checks : ∀ r : Fin 5,
    H (variableAt r 0) ∩ H (variableAt r 1)={checks r 0} ∧
    H (variableAt r 0) ∩ H (variableAt r 2)={checks r 1} ∧
    H (variableAt r 0) ∩ H (variableAt r 3)={checks r 2} ∧
    H (variableAt r 1) ∩ H (variableAt r 2)={checks r 3} ∧
    H (variableAt r 1) ∩ H (variableAt r 3)={checks r 4} ∧
    H (variableAt r 2) ∩ H (variableAt r 3)={checks r 5} := by decide
variable {R : Type*} [CommRing R]
def dRaw (z : Fin 30 → R) (r : Fin 5) :=
  PaschLiftCriterion.differences (fun i c => labelsRaw z (variableAt r i) c) (checks r)
def residualRaw (z : Fin 30 → R) (r : Fin 5) (j : Fin 3) : R := match j.val with
  | 0 => dRaw z r 0+dRaw z r 3-dRaw z r 1
  | 1 => dRaw z r 0+dRaw z r 4-dRaw z r 2
  | _ => dRaw z r 1+dRaw z r 5-dRaw z r 2
theorem rowsRaw (z : Fin 30 → R) (r : Fin 5) (j : Fin 3) :
    (∑ k, (CycleData.triangleRaw r j k : R)*z k)=residualRaw z r j := by
  fin_cases r <;> fin_cases j <;>
    norm_num [CycleData.triangleRaw,CycleData.get3,Fin.sum_univ_succ,residualRaw,dRaw,
      PaschLiftCriterion.differences,variableAt,checks,labelsRaw] <;> ring
theorem balancedRaw (z : Fin 30 → R) (r : Fin 5) :
    PaschVoltage.Balanced (dRaw z r) ↔
      ∀ j : Fin 3, ∑ k, (CycleData.triangleRaw r j k : R)*z k=0 := by
  simp_rw [rowsRaw]
  constructor
  · rintro ⟨h0,h1,h2⟩ j; fin_cases j <;> simp only [residualRaw]
    · exact sub_eq_zero.mpr h0
    · exact sub_eq_zero.mpr h1
    · exact sub_eq_zero.mpr h2
  · intro h
    exact ⟨sub_eq_zero.mp (h 0),sub_eq_zero.mp (h 1),sub_eq_zero.mp (h 2)⟩
#print axioms rowsRaw
#print axioms balancedRaw
def dGauge (z : Fin 11 → R) (r : Fin 5) :=
  PaschLiftCriterion.differences (fun i c => labelsGauge z (variableAt r i) c) (checks r)
def residualGauge (z : Fin 11 → R) (r : Fin 5) (j : Fin 3) : R := match j.val with
  | 0 => dGauge z r 0+dGauge z r 3-dGauge z r 1
  | 1 => dGauge z r 0+dGauge z r 4-dGauge z r 2
  | _ => dGauge z r 1+dGauge z r 5-dGauge z r 2
theorem rowsGauge (z : Fin 11 → R) (r : Fin 5) (j : Fin 3) :
    (∑ k, (CycleData.triangleGauge r j k : R)*z k)=residualGauge z r j := by
  fin_cases r <;> fin_cases j <;>
    norm_num [CycleData.triangleGauge,CycleData.get3,Fin.sum_univ_succ,residualGauge,dGauge,
      PaschLiftCriterion.differences,variableAt,checks,labelsGauge] <;> ring
theorem balancedGauge (z : Fin 11 → R) (r : Fin 5) :
    PaschVoltage.Balanced (dGauge z r) ↔
      ∀ j : Fin 3, ∑ k, (CycleData.triangleGauge r j k : R)*z k=0 := by
  simp_rw [rowsGauge]
  constructor
  · rintro ⟨h0,h1,h2⟩ j; fin_cases j <;> simp only [residualGauge]
    · exact sub_eq_zero.mpr h0
    · exact sub_eq_zero.mpr h1
    · exact sub_eq_zero.mpr h2
  · intro h
    exact ⟨sub_eq_zero.mp (h 0),sub_eq_zero.mp (h 1),sub_eq_zero.mp (h 2)⟩
#print axioms rowsGauge
#print axioms balancedGauge
#print axioms complete_supports
end TriangleVoltageData
