/-
Identification transports along a relabeling of the three traits. Every
recursive pattern on three traits is a relabeling of a subgraph of the
equation-(7) order: choose a topological order, move it to `0 ← 1 ← 2`, and
apply the triangular inverse. Zero structural coefficients are already allowed
by `Params`.
-/

import CorrelatedResiduals.Diagonal
import Mathlib.LinearAlgebra.Matrix.Reindex

open Matrix

namespace CorrelatedResiduals

def relabel (e : Fin 3 ≃ Fin 3) (A : M3) : M3 :=
  reindex e e A

def relabelCov (e : Fin 3 ≃ Fin 3) (S : Cov) : Cov where
  yy := relabel e S.yy
  yx := relabel e S.yx
  xx := relabel e S.xx

lemma relabel_mul (e : Fin 3 ≃ Fin 3) (A B : M3) :
    relabel e (A * B) = relabel e A * relabel e B := by
  simp [relabel]

lemma relabel_one (e : Fin 3 ≃ Fin 3) : relabel e (1 : M3) = 1 := by
  simp [relabel]

lemma relabel_transpose (e : Fin 3 ≃ Fin 3) (A : M3) :
    relabel e Aᵀ = (relabel e A)ᵀ := by
  ext i j
  simp [relabel, reindex_apply, submatrix_apply]

lemma relabel_add (e : Fin 3 ≃ Fin 3) (A B : M3) :
    relabel e (A + B) = relabel e A + relabel e B := by
  simp [relabel, reindex_apply, submatrix_add]

lemma relabel_sub (e : Fin 3 ≃ Fin 3) (A B : M3) :
    relabel e (A - B) = relabel e A - relabel e B := by
  ext i j
  simp [relabel, reindex_apply, sub_apply, submatrix_apply]

lemma relabel_symm_apply (e : Fin 3 ≃ Fin 3) (A : M3) :
    relabel e.symm (relabel e A) = A := by
  simp [relabel, reindex_apply, submatrix_submatrix, Equiv.symm_symm]

lemma relabel_subB (e : Fin 3 ≃ Fin 3) (θ : Params) :
    relabel e (subB θ) = 1 - relabel e (Bmat θ) := by
  rw [subB_eq_one_sub, relabel_sub, relabel_one]

lemma relabel_L_inv (e : Fin 3 ≃ Fin 3) (θ : Params) :
    relabel e (Lmat θ) = (1 - relabel e (Bmat θ))⁻¹ := by
  rw [← relabel_subB]
  refine (inv_eq_right_inv ?_).symm
  rw [← relabel_mul, subB_mul_L, relabel_one]

lemma sigma_relabel (e : Fin 3 ≃ Fin 3) (θ : Params) :
    relabelCov e (sigma θ) = {
      yy := relabel e (Lmat θ) *
        (relabel e θ.gamma * relabel e θ.phi * (relabel e θ.gamma)ᵀ +
          relabel e (psi θ)) * (relabel e (Lmat θ))ᵀ
      yx := relabel e (Lmat θ) * relabel e θ.gamma * relabel e θ.phi
      xx := relabel e θ.phi } := by
  simp only [relabelCov, sigma, relabel_mul, relabel_add, relabel_transpose]

/-- Undo the trait relabeling and apply the ordered triangular inverse. -/
noncomputable def recoverRelabeled (e : Fin 3 ≃ Fin 3) (cov : Cov) : Params :=
  recover (relabelCov e.symm cov)

theorem recover_relabeled (e : Fin 3 ≃ Fin 3) (θ : Params) (h : OnDomain θ) :
    recoverRelabeled e (relabelCov e (sigma θ)) = θ := by
  simp only [recoverRelabeled, relabelCov, relabel_symm_apply, recover_sigma θ h]

end CorrelatedResiduals
