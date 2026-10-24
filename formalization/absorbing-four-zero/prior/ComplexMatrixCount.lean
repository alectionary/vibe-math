import ComplexCyclicCount
import ComplexDFT
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Data.Matrix.Mul

set_option maxHeartbeats 0
open scoped BigOperators Matrix
namespace AbsorbingFourier
variable {N : ℕ} [NeZero N]
variable {P R : Type*} [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

theorem standard_transformedAction_eq_mulVec
    (sockets : P → Finset (R × ZMod N)) (f : P → ZMod N → ℂ) (j : ZMod N) :
    transformedAction ZMod.stdAddChar sockets f j =
      (evaluatedMatrix ZMod.stdAddChar sockets j) *ᵥ
        (fun p => dft ZMod.stdAddChar (f p) j) := by
  rfl

noncomputable def evaluatedVector (sockets : P → Finset (R × ZMod N))
    (W : Finset (P × ZMod N)) (j : ZMod N) : EuclideanSpace ℂ R :=
  WithLp.toLp 2 ((evaluatedMatrix ZMod.stdAddChar sockets j) *ᵥ
    (fun p => dft ZMod.stdAddChar (indicator W p) j))

theorem evaluatedVector_norm_sq (sockets : P → Finset (R × ZMod N))
    (W : Finset (P × ZMod N)) (j : ZMod N) :
    ‖evaluatedVector sockets W j‖ ^ 2 =
      ∑ r : R, ‖transformedAction ZMod.stdAddChar sockets (indicator W) j r‖ ^ 2 := by
  rw [EuclideanSpace.norm_sq_eq]
  rfl

noncomputable def rootVectorEnergy (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) : ℝ :=
  if (p,0) ≠ (q,d) ∧
      (CyclicNormalization.incidence sockets (p,0) ∩
       CyclicNormalization.incidence sockets (q,d)).Nonempty then
    ∑ j : ZMod N, ‖evaluatedVector sockets
      (PairFormula.properCommon (CyclicNormalization.incidence sockets) (p,0) (q,d)) j‖ ^ 2
  else 0

theorem rootVectorEnergy_eq (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) :
    rootVectorEnergy sockets p q d = rootNormEnergy sockets p q d := by
  classical
  unfold rootVectorEnergy rootNormEnergy
  split_ifs
  · simp only [evaluatedVector_norm_sq]
    exact Finset.sum_comm
  · rfl

/-- Source formula with the usual Euclidean norm of the actual evaluated
matrix-vector product. The factor N and all transforms are unnormalized. -/
theorem complex_matrix_count_formula (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (CyclicNormalization.incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v →
      (CyclicNormalization.incidence sockets u ∩ CyclicNormalization.incidence sockets v).card ≤ 1) :
    (GlobalCounting.count42 (CyclicNormalization.incidence sockets) : ℝ) =
      ((N : ℝ) * (CyclicNormalization.normalizedQuadratic sockets : ℝ) -
        ∑ p : P, ∑ q : P, ∑ d : ZMod N, rootVectorEnergy sockets p q d) / 4 := by
  simp only [rootVectorEnergy_eq]
  exact complex_cyclic_count_formula sockets hd h4

#print axioms standard_transformedAction_eq_mulVec
#print axioms evaluatedVector_norm_sq
#print axioms rootVectorEnergy_eq
#print axioms complex_matrix_count_formula
end AbsorbingFourier
