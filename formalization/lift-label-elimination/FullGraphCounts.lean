import QCSupportCount
import GraphMatrices
import PaschReindex40

set_option maxHeartbeats 0
namespace FullGraphCounts
open PaschKernelCount GraphMatrices SparseCSSMatrices
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]
variable (N : ℕ) [NeZero N]

def negEquiv : ZMod N ≃ ZMod N where
  toFun := Neg.neg
  invFun := Neg.neg
  left_inv := neg_neg
  right_inv := neg_neg

theorem scalar_count : count40 (ScalarIncidence.columns N)=count40 (ScalarTranspose.columns N) := by
  apply PaschReindex40.count40_eq _ _ (negEquiv N) (negEquiv N)
  intro t
  simp [ScalarTranspose.columns,negEquiv]

def graphZ (H : V → Finset C) (z : V → C → ZMod N) :=
  fun w : (V × ZMod N) ⊕ (C × ZMod N) =>
    plusGraph N (dual H) (inverseLabels z) (Sum.swap w)

theorem swap_count (H : V → Finset C) (z : V → C → ZMod N) :
    count40 (graphZ N H z)=count40 (plusGraph N (dual H) (inverseLabels z)) := by
  apply PaschReindex40.count40_eq _ _ (Equiv.sumComm _ _) (Equiv.refl _)
  intro w
  simp [graphZ]

theorem fullX (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N)
    (hd : ∀ v, (H v).card=3) (hl : ∀ v w, v≠w → (H v ∩ H w).card≤1) :
    count40 (minusGraph N H z)=count40 (PaschLiftProjection.columns H z)+
      Fintype.card C*count40 (ScalarIncidence.columns N) :=
  QCSupportCount.count40_full H z _ hd (ScalarIncidence.cubic N hN) hl (ScalarIncidence.linear N hN)

theorem fullZ (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N)
    (hd : ∀ c, ((dual H) c).card=3)
    (hl : ∀ c d, c≠d → ((dual H) c ∩ (dual H) d).card≤1) :
    count40 (graphZ N H z)=count40 (PaschLiftProjection.columns (dual H) (inverseLabels z))+
      Fintype.card V*count40 (ScalarIncidence.columns N) := by
  rw [swap_count]
  change count40 (VoltageQCIncidence.columns (dual H) (inverseLabels z) (ScalarTranspose.columns N))=_
  rw [QCSupportCount.count40_full _ _ _ hd (ScalarTranspose.cubic N hN)
    hl (ScalarTranspose.linear N hN),← scalar_count N]

#print axioms scalar_count
#print axioms swap_count
#print axioms fullX
#print axioms fullZ
end FullGraphCounts
