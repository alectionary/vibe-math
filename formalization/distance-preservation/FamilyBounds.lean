import SourceDistance
import TransposeDistance
set_option maxHeartbeats 0
namespace DistanceFamily
variable {L : Nat} [NeZero L]

theorem fiberPair_weight : (CoverWeight.support (fiberPair (L := L))).card = 2*L := by
  have hs : CoverWeight.support (fiberPair (L := L)) =
      (Finset.univ.filter (fun i : Fin 4 => i=0 ∨ i=1)) ×ˢ (Finset.univ : Finset (ZMod L)) := by
    ext v
    simp [CoverWeight.support,fiberPair] <;> tauto
  have hr : (Finset.univ.filter (fun i : Fin 4 => i=0 ∨ i=1)).card = 2 := by decide +kernel
  rw [hs,Finset.card_product,hr]
  simp

theorem classical_distance_upper : classicalDistance L ≤ 2*L := by
  have h : ClassicalHasWeight L (2*L) :=
    ⟨fiberPair,fiberPair_kernel,fiberPair_nonzero,fiberPair_weight⟩
  exact Nat.find_min' _ h

/-- This is the actual binary transpose of the classical source matrix. -/
theorem transpose_c_action (x : Fin 3 → ZMod L → ZMod 2) (v : Fin 4 × ZMod L) :
    (∑ c, SourceDistance.C c v * x c.1 c.2) = FamilyTranspose.boundary x v.1 v.2 := by
  simp [Fintype.sum_prod_type,SourceDistance.C,SourceModel.P,FamilyTranspose.boundary]

/-- The mixed logical obstruction persists even when the transpose classical
code has no smaller nonzero word than the original classical distance. -/
theorem stronger_counterfamily (hL : 11 ∣ L) :
    quantumDistance L < classicalDistance L ∧
    (∀ x : Fin 3 → ZMod L → ZMod 2, FamilyTranspose.Kernel x → x ≠ 0 →
      classicalDistance L ≤ (CoverWeight.support (FamilyTranspose.word x)).card) := by
  refine ⟨distance_drop hL,?_⟩
  intro x hx hn
  rw [FamilyTranspose.nonzero_weight x hx hn]
  exact classical_distance_upper

#print axioms classical_distance_upper
#print axioms transpose_c_action
#print axioms stronger_counterfamily
end DistanceFamily
