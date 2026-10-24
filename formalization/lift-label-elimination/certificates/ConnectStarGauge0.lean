import NFStarGauge0
import CycleData
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectStarGauge0
open NFStarGauge0 CycleData
def chosen : Finset (Fin 1) := ∅
def columns : (Fin 0 ⊕ Fin 11) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 0 ⊕ Fin 0) → Fin 1 × Fin 3 := fun m =>
  (⟨([] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => exact Fin.elim0 i
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=starGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events starGauge chosen z}=N^11 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) starGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFStarGauge0.count N)
#print axioms actual_count
end ConnectStarGauge0
