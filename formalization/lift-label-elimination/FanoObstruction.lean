import QCSupportCount
import ScalarTranspose
import GraphMatrices

set_option maxHeartbeats 0
namespace FanoObstruction
open PaschKernelCount

theorem negative_scalar (H : Fin 10 → Finset (Fin 10)) (z : Fin 10 → Fin 10 → ZMod 7)
    (hd : ∀ v, (H v).card=3) (hl : ∀ u v, u≠v → (H u ∩ H v).card≤1) :
    70≤count40 (GraphMatrices.minusGraph 7 H z) := by
  change 70≤count40 (VoltageQCIncidence.columns H z (ScalarIncidence.columns 7))
  rw [QCSupportCount.count40_full H z _ hd (ScalarIncidence.cubic 7 (by decide))
    hl (ScalarIncidence.linear 7 (by decide)),ScalarTranspose.fano_count,Fintype.card_fin]
  omega

theorem positive_scalar (H : Fin 10 → Finset (Fin 10)) (z : Fin 10 → Fin 10 → ZMod 7)
    (hd : ∀ v, (H v).card=3) (hl : ∀ u v, u≠v → (H u ∩ H v).card≤1) :
    70≤count40 (GraphMatrices.plusGraph 7 H z) := by
  change 70≤count40 (VoltageQCIncidence.columns H z (ScalarTranspose.columns 7))
  rw [QCSupportCount.count40_full H z _ hd (ScalarTranspose.cubic 7 (by decide))
    hl (ScalarTranspose.linear 7 (by decide)),ScalarTranspose.fano_transpose_count,Fintype.card_fin]
  omega

#print axioms negative_scalar
#print axioms positive_scalar
end FanoObstruction
