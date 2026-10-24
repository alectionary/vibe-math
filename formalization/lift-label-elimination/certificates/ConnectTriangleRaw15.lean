import NFTriangleRaw15
import CycleData
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleRaw15
open NFTriangleRaw15 CycleData
def chosen : Finset (Fin 5) := {0,1,2,3}
def columns : (Fin 11 ⊕ Fin 19) ≃ Fin 30 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 1) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,2,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => fin_cases i <;> decide
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleRaw (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 30 → ZMod N // CycleKernelBridge.Events triangleRaw chosen z}=N^19 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleRaw chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleRaw15.count N)
#print axioms actual_count
end ConnectTriangleRaw15
