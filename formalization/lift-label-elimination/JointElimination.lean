import ConcreteElimination
import JointLabelCount
import FamilyGraphs

set_option maxHeartbeats 0
namespace JointElimination
open FinitePaschRepresentatives
abbrev H := JointCycleData.dualH
abbrev v : Fin 1 → Fin 4 → Fin 10 := fun _ => JointCycleData.variableAt
abbrev c : Fin 1 → Fin 6 → Fin 10 := fun _ => JointCycleData.checks

theorem rep_injective : ∀ r, Function.Injective (v r) := by decide

theorem rep_even : ∀ r, PaschClassification.EvenChecks (fun i => H (v r i)) := by
  change ∀ r : Fin 1, ∀ d : Fin 10,
    (FourColumnClassification.support (fun i => H (v r i)) d).card%2=0
  decide

theorem pair_checks : ∀ r, PairChecks H (v r) (c r) := by
  unfold PairChecks
  decide

theorem complete_supports : SumCounting.good H=
    (Finset.univ : Finset (Fin 1)).image (fun r => Finset.univ.image (v r)) := by decide

variable (N : ℕ) [NeZero N]
theorem dual_iff (z : Fin 30 → ZMod N) :
    Eliminates H (SparseCSSMatrices.inverseLabels (StarVoltageData.labelsRaw z)) ↔
      ¬JointLabelCount.Second N z := by
  have h := eliminates_iff H (SparseCSSMatrices.inverseLabels (StarVoltageData.labelsRaw z))
    FamilyGraphs.dual_cubic FamilyGraphs.dual_linear v rep_injective c rep_even pair_checks complete_supports
  constructor
  · intro he
    exact h.mp he 0
  · intro he
    apply h.mpr
    intro r
    fin_cases r
    exact he

theorem count_both :
    (Nat.card {z : Fin 30 → ZMod N //
      Eliminates StarVoltageData.H (StarVoltageData.labelsRaw z) ∧
      Eliminates H (SparseCSSMatrices.inverseLabels (StarVoltageData.labelsRaw z))} : ℤ)=
      (N : ℤ)^30-2*(N : ℤ)^27+(N : ℤ)^24 := by
  have he (z : Fin 30 → ZMod N) :
      (Eliminates StarVoltageData.H (StarVoltageData.labelsRaw z) ∧
       Eliminates H (SparseCSSMatrices.inverseLabels (StarVoltageData.labelsRaw z))) ↔
       (¬JointLabelCount.First N z ∧ ¬JointLabelCount.Second N z) :=
    and_congr (ConcreteElimination.star_raw_iff N z) (dual_iff N z)
  rw [Nat.card_congr (Equiv.subtypeEquivRight he)]
  exact JointLabelCount.avoiding_both N

#print axioms complete_supports
#print axioms dual_iff
#print axioms count_both
end JointElimination
