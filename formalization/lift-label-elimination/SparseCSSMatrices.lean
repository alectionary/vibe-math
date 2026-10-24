import SparseCSS
import CyclicCSSCommute

set_option maxHeartbeats 0
namespace SparseCSSMatrices
open Matrix CyclicCSSCommute CyclicRecurrence
variable {V C G R : Type*} [Fintype V] [Fintype C] [Fintype G]
  [DecidableEq V] [DecidableEq C] [DecidableEq G] [AddCommGroup G] [CommRing R]

def dual (H : V → Finset C) (c : C) : Finset V :=
  Finset.univ.filter (fun v => c∈H v)

def inverseLabels (z : V → C → G) (c : C) (v : V) : G := -z v c

theorem transpose_translation (K : Type*) [DecidableEq K] (h : G) :
    (translation K h : Matrix (K × G) (K × G) R).transpose=translation K (-h) := by
  ext a b
  simp only [Matrix.transpose_apply,translation]
  congr 1
  apply propext
  constructor
  · rintro ⟨h1,h2⟩
    refine ⟨h1.symm,?_⟩
    rw [h2]; abel
  · rintro ⟨h1,h2⟩
    refine ⟨h1.symm,?_⟩
    rw [h2]; abel

theorem transpose_scalar (K : Type*) [DecidableEq K] (h k : G) :
    (CyclicCSSCommute.scalar K h k : Matrix (K × G) (K × G) R).transpose=CyclicCSSCommute.scalar K (-h) (-k) := by
  simp only [CyclicCSSCommute.scalar,Matrix.transpose_add,transpose_translation,neg_zero]

theorem transpose_cover (H : V → Finset C) (z : V → C → G) :
    (cover H z : Matrix (C × G) (V × G) R).transpose=cover (dual H) (inverseLabels z) := by
  ext a b
  simp only [Matrix.transpose_apply,cover,dual,Finset.mem_filter,Finset.mem_univ,true_and,
    inverseLabels]
  congr 1
  apply propext
  constructor
  · rintro ⟨hc,he⟩
    refine ⟨hc,?_⟩
    rw [he]; abel
  · rintro ⟨hc,he⟩
    refine ⟨hc,?_⟩
    rw [he]; abel

def checksX (H : V → Finset C) (z : V → C → G) (h k : G) :
    Matrix (C × G) (Sum (V × G) (C × G)) R :=
  fromCols (cover H z) (CyclicCSSCommute.scalar C h k)

def checksZ (H : V → Finset C) (z : V → C → G) (h k : G) :
    Matrix (V × G) (Sum (V × G) (C × G)) R :=
  (fromRows (CyclicCSSCommute.scalar V h k) (cover H z)).transpose

theorem css_commutes (H : V → Finset C) (z : V → C → G) (h k : G) :
    (checksX H z h k : Matrix _ _ F)*(checksZ (R := F) H z h k).transpose=0 := by
  simpa only [checksX,checksZ,Matrix.transpose_transpose] using
    CyclicCSSCommute.css_commutes H z h k

variable (N : ℕ) [NeZero N]

theorem x_adjoint (H : V → Finset C) (z : V → C → ZMod N) :
    (checksX H z (-1) (-3) : Matrix _ _ F).transpose=SparseCSS.adjoint N H z false := by
  ext w a
  cases w with
  | inl v => rfl
  | inr v => simp [checksX,fromCols,CyclicCSSCommute.scalar,translation,SparseCSS.adjoint,SparseCSS.shift,
      Matrix.transpose_apply,sub_eq_add_neg,eq_comm]

theorem z_swapped_adjoint (H : V → Finset C) (z : V → C → ZMod N) :
    (checksZ H z (-1) (-3) : Matrix _ _ F).transpose=
      (SparseCSS.adjoint N (dual H) (inverseLabels z) true).submatrix Sum.swap id := by
  ext w a
  cases w with
  | inl v =>
    change (CyclicCSSCommute.scalar V (-1) (-3) : Matrix _ _ F) v a=_
    have ht := congrFun (congrFun (transpose_scalar (R := F) (G := ZMod N) V (1 : ZMod N) 3) v) a
    simpa [CyclicCSSCommute.scalar,translation,SparseCSS.adjoint,SparseCSS.shift,Matrix.submatrix_apply,
      Matrix.transpose_apply,eq_comm] using ht.symm
  | inr c =>
    have ht := congrFun (congrFun (transpose_cover (R := F) H z) a) c
    simpa only [checksZ,Matrix.transpose_transpose,fromRows,Sum.elim_inr,Matrix.submatrix_apply,
      Sum.swap_inr,id_eq,SparseCSS.adjoint,Matrix.transpose_apply,cover] using ht

#print axioms transpose_cover
#print axioms css_commutes
#print axioms x_adjoint
#print axioms z_swapped_adjoint
end SparseCSSMatrices
