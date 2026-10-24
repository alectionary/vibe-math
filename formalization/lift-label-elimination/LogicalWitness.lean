import BinaryDistance
import Mathlib.LinearAlgebra.Matrix.ToLin

set_option maxHeartbeats 0
namespace LogicalWitness
open Matrix BinaryDistance
open scoped BigOperators
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

/-- A binary kernel witness separates a word from the stabilizer row space. -/
theorem not_in_row_space (Z : Matrix C V (ZMod 2)) (w u : V → ZMod 2)
    (hu : Z*ᵥu=0) (hwu : dotProduct w u=1) :
    w∉LinearMap.range Z.transpose.mulVecLin := by
  rintro ⟨a,ha⟩
  change Z.transpose*ᵥa=w at ha
  have hh : dotProduct w u=0 := by
    rw [← ha,dotProduct_comm,dotProduct_transpose_mulVec,hu]
    simp
  rw [hwu] at hh
  exact one_ne_zero hh

/-- Exact CSS distance six, formulated as the minimum nontrivial logical weight.
The hypotheses quantify over the actual two binary matrices and row spaces. -/
theorem distance_six (X : Matrix C V (ZMod 2)) {D : Type*} [Fintype D] [DecidableEq D]
    (Z : Matrix D V (ZMod 2))
    (hx : ∀ w : V → ZMod 2, X*ᵥw=0 → w≠0 → 6≤weight w)
    (hz : ∀ w : V → ZMod 2, Z*ᵥw=0 → w≠0 → 6≤weight w)
    (w : V → ZMod 2) (hw : X*ᵥw=0) (hn : w∉LinearMap.range Z.transpose.mulVecLin)
    (hsize : weight w=6) :
    (∀ a : V → ZMod 2,
      ((X*ᵥa=0 ∧ a∉LinearMap.range Z.transpose.mulVecLin) ∨
       (Z*ᵥa=0 ∧ a∉LinearMap.range X.transpose.mulVecLin)) → 6≤weight a) ∧
    (X*ᵥw=0 ∧ w∉LinearMap.range Z.transpose.mulVecLin ∧ weight w=6) := by
  refine ⟨?_,hw,hn,hsize⟩
  intro a ha
  rcases ha with ha | ha
  · apply hx a ha.1
    intro h
    apply ha.2
    rw [h]
    exact ⟨0,by simp⟩
  · apply hz a ha.1
    intro h
    apply ha.2
    rw [h]
    exact ⟨0,by simp⟩

#print axioms not_in_row_space
#print axioms distance_six
end LogicalWitness
