import GraphMatrices
import QCRegularity

set_option maxHeartbeats 0
namespace SparseRowDegrees
open Matrix SparseCSSMatrices CyclicCSSCommute CyclicRecurrence
variable {V C G : Type*} [Fintype V] [Fintype C] [Fintype G]
  [DecidableEq V] [DecidableEq C] [DecidableEq G] [AddCommGroup G]

noncomputable def columnWeight {A B : Type*} (M : Matrix A B F) (b : B) := Nat.card {a : A // M a b=1}
noncomputable def rowWeight {A B : Type*} (M : Matrix A B F) (a : A) := Nat.card {b : B // M a b=1}

noncomputable def blockEquiv {A B D : Type*} (M : Matrix D A F) (K : Matrix D B F) (d : D) :
    {a : A ⊕ B // fromCols M K d a=1} ≃
      Sum {a : A // M d a=1} {b : B // K d b=1} where
  toFun a := match a with
    | ⟨.inl a,h⟩ => .inl ⟨a,h⟩
    | ⟨.inr b,h⟩ => .inr ⟨b,h⟩
  invFun a := match a with
    | .inl ⟨a,h⟩ => ⟨.inl a,h⟩
    | .inr ⟨b,h⟩ => ⟨.inr b,h⟩
  left_inv a := by rcases a with ⟨a,h⟩; cases a <;> rfl
  right_inv a := by cases a <;> rfl

theorem block_row {A B D : Type*} [Finite A] [Finite B]
    (M : Matrix D A F) (K : Matrix D B F) (d : D) :
    rowWeight (fromCols M K) d=columnWeight M.transpose d+columnWeight K.transpose d := by
  exact (Nat.card_congr (blockEquiv M K d)).trans Nat.card_sum

theorem check_column (H : V → Finset C) (v : V) :
    columnWeight (PaschKernelCount.checkMatrix H) v=(H v).card := by
  classical
  rw [columnWeight,Nat.card_eq_fintype_card,Fintype.card_subtype]
  simp [PaschKernelCount.checkMatrix]

theorem cover_column (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3) (v : V × G) :
    columnWeight (cover H z : Matrix (C × G) (V × G) F) v=3 := by
  have he : (cover H z : Matrix (C × G) (V × G) F)=
      PaschKernelCount.checkMatrix (PaschLiftProjection.columns H z) := by
    ext a b
    rcases a with ⟨c,s⟩
    simp only [cover,PaschKernelCount.checkMatrix,PaschLiftProjection.mem_columns]
  rw [he,check_column]
  exact PaschLiftProjection.cubic H z hd v

variable (N : ℕ) [NeZero N]

theorem scalar_column (K : Type*) [Fintype K] [DecidableEq K]
    (B : ZMod N → Finset (ZMod N)) (h k : ZMod N)
    (he : ∀ s t, PaschKernelCount.checkMatrix B s t=
      (if s=t then 1 else 0)+(if s=t+h then 1 else 0)+(if s=t+k then 1 else 0))
    (hd : ∀ t, (B t).card=3) (v : K × ZMod N) :
    columnWeight (CyclicCSSCommute.scalar K h k : Matrix _ _ F) v=3 := by
  classical
  let S : Finset (K × ZMod N) := {v.1} ×ˢ B v.2
  have hi (a : K × ZMod N) : a∈S ↔ (CyclicCSSCommute.scalar K h k : Matrix _ _ F) a v=1 := by
    rcases a with ⟨c,s⟩
    rcases v with ⟨d,t⟩
    by_cases hc : c=d
    · subst d
      have hh := he s t
      have hm : (CyclicCSSCommute.scalar K h k : Matrix _ _ F) (c,s) (c,t)=
          PaschKernelCount.checkMatrix B s t := by
        simpa [CyclicCSSCommute.scalar,translation] using hh.symm
      rw [hm]
      simp [S,PaschKernelCount.checkMatrix]
    · simp [S,CyclicCSSCommute.scalar,translation,hc,Ne.symm hc]
  rw [columnWeight,Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype S hi]
  simp [S,hd]

theorem x_row_minus (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N)
    (hd : ∀ c, ((dual H) c).card=3) (a : C × ZMod N) :
    rowWeight (checksX H z (-1) (-3) : Matrix _ _ F) a=6 := by
  rw [checksX,block_row,transpose_cover,transpose_scalar,neg_neg,neg_neg]
  have hc := cover_column (dual H) (inverseLabels z) hd a
  have hs := scalar_column N C (ScalarTranspose.columns N) 1 3
    (ScalarTranspose.entry N hN) (ScalarTranspose.cubic N hN) a
  rw [hc,hs]

theorem x_row_plus (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N)
    (hd : ∀ c, ((dual H) c).card=3) (a : C × ZMod N) :
    rowWeight (checksX H z 1 3 : Matrix _ _ F) a=6 := by
  rw [checksX,block_row,transpose_cover,transpose_scalar]
  have hc := cover_column (dual H) (inverseLabels z) hd a
  have he (s t : ZMod N) : PaschKernelCount.checkMatrix (ScalarIncidence.columns N) s t=
      (if s=t then 1 else 0)+(if s=t+(-1) then 1 else 0)+(if s=t+(-3) then 1 else 0) := by
    simpa only [sub_eq_add_neg] using ScalarIncidence.entry N hN s t
  have hs := scalar_column N C (ScalarIncidence.columns N) (-1) (-3) he
    (ScalarIncidence.cubic N hN) a
  rw [hc,hs]

theorem dual_dual (H : V → Finset C) : dual (dual H)=H := by
  funext v
  ext c
  simp [dual]

theorem z_row_minus (hN : 7≤N) (H : V → Finset C) (z : V → C → ZMod N)
    (hd : ∀ v, (H v).card=3) (a : V × ZMod N) :
    rowWeight (checksZ H z (-1) (-3) : Matrix _ _ F) a=6 := by
  rw [GraphMatrices.z_as_swapped_x N H z]
  let M := (checksX (dual H) (inverseLabels z) 1 3 : Matrix _ _ F)
  have hc : rowWeight (M.submatrix id Sum.swap) a=rowWeight M a := by
    exact Nat.card_congr (Equiv.subtypeEquiv (Equiv.sumComm _ _) (fun _ => Iff.rfl))
  change rowWeight (M.submatrix id Sum.swap) a=6
  rw [hc]
  apply x_row_plus N hN (dual H) (inverseLabels z)
  rw [dual_dual]
  exact hd

#print axioms x_row_minus
#print axioms z_row_minus
end SparseRowDegrees
