import PaschComplexCount
import FanoBlock
import GramCounterexample12

set_option maxHeartbeats 0
namespace PaschConsumers
open PaschKernelCount

def onePasch (v : Fin 4) : Finset (Fin 6) :=
  match v.val with
  | 0 => {0,1,2}
  | 1 => {0,3,4}
  | 2 => {1,3,5}
  | _ => {2,4,5}

theorem onePasch_cubic : ∀ v, (onePasch v).card = 3 := by decide
theorem onePasch_linear : ∀ u v, u ≠ v → (onePasch u ∩ onePasch v).card ≤ 1 := by decide
theorem onePasch_count : count40 onePasch = 1 := by decide

def falseK4 (v : Fin 4) : Finset (Fin 9) :=
  match v.val with
  | 0 => {0,1,2}
  | 1 => {0,3,4}
  | 2 => {0,5,6}
  | _ => {0,7,8}

theorem falseK4_cubic : ∀ v, (falseK4 v).card = 3 := by decide
theorem falseK4_linear : ∀ u v, u ≠ v → (falseK4 u ∩ falseK4 v).card ≤ 1 := by decide
theorem falseK4_projected : ∀ u v, u ≠ v → (falseK4 u ∩ falseK4 v).Nonempty := by decide
theorem falseK4_count : count40 falseK4 = 0 := by decide

theorem fano_count : count40 FanoBlock.columns = 7 := by decide

theorem fano_kernel_weightFour : weightFourKernelCount FanoBlock.columns = 7 := by
  rw [← count40_eq_weightFourKernelCount _ FanoBlock.cubic FanoBlock.linear]
  exact fano_count

/-- Checkable bridge from our incidence count to the actual binary matrix. -/
theorem onePasch_kernel : weightFourKernelCount onePasch = 1 := by
  rw [← count40_eq_weightFourKernelCount _ onePasch_cubic onePasch_linear]
  exact onePasch_count

#print axioms onePasch_count
#print axioms falseK4_count
#print axioms falseK4_projected
#print axioms fano_kernel_weightFour
end PaschConsumers
