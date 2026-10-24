import NFDualRaw1
import JointCycleData
import CycleKernelBridge
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectJointDual
open NFDualRaw1
def chosen : Finset (Fin 2) := {1}
def columns : (Fin 3 ⊕ Fin 27) ≃ Fin 30 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 2 × Fin 3 := fun m =>
 (⟨ix m / 3+1,by cases m with
   | inl i => fin_cases i <;> decide
   | inr i => exact Fin.elim0 i
 ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=JointCycleData.rows (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
 Nat.card {z : Fin 30 → ZMod N // CycleKernelBridge.Events JointCycleData.rows chosen z}=N^27 := by
 have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) JointCycleData.rows chosen
   (A.submatrix id columns.symm) rowAt rows_match rows_complete
 have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
 exact (Nat.card_congr (e1.trans e2)).trans (NFDualRaw1.count N)
#print axioms actual_count
end ConnectJointDual
