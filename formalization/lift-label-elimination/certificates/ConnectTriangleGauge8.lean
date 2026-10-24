import NFTriangleGauge8
import CycleData
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge8
open NFTriangleGauge8 CycleData
def chosen : Finset (Fin 5) := {3}
def columns : (Fin 3 ⊕ Fin 8) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^8 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge8.count N)
#print axioms actual_count
end ConnectTriangleGauge8
