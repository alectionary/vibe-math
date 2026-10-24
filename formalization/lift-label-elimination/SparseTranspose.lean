import StarCheckKernel
import PaschLiftProjection
import Mathlib.LinearAlgebra.Matrix.ToLin

set_option maxHeartbeats 0
namespace SparseTranspose
open CyclicRecurrence
open scoped BigOperators
open Matrix
variable {V C G : Type*} [Fintype V] [Fintype C] [Fintype G]
  [DecidableEq V] [DecidableEq C] [DecidableEq G] [AddCommGroup G]

def incidence (H : V → Finset C) (z : V → C → G) : Matrix (C × G) (V × G) F :=
  fun a b => if a∈PaschLiftProjection.columns H z b then 1 else 0

/-- The transpose is the actual binary transpose of the sparse cover incidence. -/
theorem transpose_apply (H : V → Finset C) (z : V → C → G)
    (f : C × G → F) (v : V) (t : G) :
    ((incidence H z).transpose *ᵥ f) (v,t) =
      ∑ c ∈ H v, f (c,t+z v c) := by
  simp only [Matrix.mulVec, dotProduct, Matrix.transpose_apply,
    incidence, Fintype.sum_prod_type]
  simp only [PaschLiftProjection.mem_columns]
  simp [ite_and, Finset.sum_ite_irrel, Finset.sum_ite_eq', Finset.sum_ite_eq,
    Finset.sum_filter]

#print axioms transpose_apply
end SparseTranspose
