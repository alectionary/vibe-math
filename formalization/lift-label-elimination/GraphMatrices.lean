import SparseCSSMatrices
import ScalarTranspose
import VoltageQCIncidence

set_option maxHeartbeats 0
namespace GraphMatrices
open Matrix SparseCSSMatrices CyclicCSSCommute CyclicRecurrence
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]
variable (N : ℕ) [NeZero N]

def minusGraph (H : V → Finset C) (z : V → C → ZMod N) :=
  VoltageQCIncidence.columns H z (ScalarIncidence.columns N)

def plusGraph (H : V → Finset C) (z : V → C → ZMod N) :=
  VoltageQCIncidence.columns H z (ScalarTranspose.columns N)

theorem minus_matrix (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N) :
    PaschKernelCount.checkMatrix (minusGraph N H z)=
      (checksX H z (-1) (-3) : Matrix _ _ F) := by
  ext a w
  rcases a with ⟨c,s⟩
  cases w with
  | inl v =>
    change (if (c,s)∈PaschLiftProjection.columns H z v then (1 : F) else 0)=
      if c∈H v.1 ∧ s=v.2+z v.1 c then 1 else 0
    simp only [PaschLiftProjection.mem_columns]
  | inr v =>
    rcases v with ⟨d,t⟩
    by_cases hcd : c=d
    · subst d
      have h := ScalarIncidence.entry N hN s t
      simpa [PaschKernelCount.checkMatrix,minusGraph,VoltageQCIncidence.columns,checksX,fromCols,
        CyclicCSSCommute.scalar,translation,sub_eq_add_neg] using h
    · simp [PaschKernelCount.checkMatrix,minusGraph,VoltageQCIncidence.columns,checksX,fromCols,
        CyclicCSSCommute.scalar,translation,hcd,Ne.symm hcd]

theorem plus_matrix (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N) :
    PaschKernelCount.checkMatrix (plusGraph N H z)=
      (checksX H z 1 3 : Matrix _ _ F) := by
  ext a w
  rcases a with ⟨c,s⟩
  cases w with
  | inl v =>
    change (if (c,s)∈PaschLiftProjection.columns H z v then (1 : F) else 0)=
      if c∈H v.1 ∧ s=v.2+z v.1 c then 1 else 0
    simp only [PaschLiftProjection.mem_columns]
  | inr v =>
    rcases v with ⟨d,t⟩
    by_cases hcd : c=d
    · subst d
      have h := ScalarTranspose.entry N hN s t
      simpa [PaschKernelCount.checkMatrix,plusGraph,VoltageQCIncidence.columns,checksX,fromCols,
        CyclicCSSCommute.scalar,translation] using h
    · simp [PaschKernelCount.checkMatrix,plusGraph,VoltageQCIncidence.columns,checksX,fromCols,
        CyclicCSSCommute.scalar,translation,hcd,Ne.symm hcd]

theorem z_as_swapped_x (H : V → Finset C) (z : V → C → ZMod N) :
    (checksZ H z (-1) (-3) : Matrix _ _ F)=
      (checksX (dual H) (inverseLabels z) 1 3).submatrix id Sum.swap := by
  ext a w
  cases w with
  | inl v =>
    have ht := congrFun (congrFun (transpose_scalar (R := F) (G := ZMod N) V (-1) (-3)) a) v
    simpa [checksZ,checksX,fromRows,fromCols,Matrix.submatrix_apply,Matrix.transpose_apply]
      using ht
  | inr c =>
    have ht := congrFun (congrFun (transpose_cover (R := F) H z) a) c
    simpa only [checksZ,checksX,fromRows,fromCols,Matrix.submatrix_apply,
      Matrix.transpose_apply,Sum.swap_inr,Sum.elim_inl,Sum.elim_inr,id_eq] using ht

#print axioms minus_matrix
#print axioms plus_matrix
#print axioms z_as_swapped_x
end GraphMatrices
