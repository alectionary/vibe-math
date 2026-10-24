import Mathlib.FieldTheory.Finiteness
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod

set_option maxHeartbeats 0
namespace RankFromKernel
open Matrix Module
variable {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]

theorem nullity_nine (A : Matrix m n (ZMod 2))
    (h : Nat.card {x : n → ZMod 2 // A *ᵥx=0}=512) :
    Module.finrank (ZMod 2) (LinearMap.ker A.mulVecLin)=9 := by
  have hk : Nat.card (LinearMap.ker A.mulVecLin)=512 := h
  rw [Module.natCard_eq_pow_finrank (K := ZMod 2),Nat.card_eq_fintype_card,ZMod.card] at hk
  apply Nat.pow_right_injective (by decide : 2≤2)
  exact hk

theorem rank_of_kernel (A : Matrix m n (ZMod 2))
    (h : Nat.card {x : n → ZMod 2 // A *ᵥx=0}=512) :
    A.rank+9=Fintype.card n := by
  have hr := A.mulVecLin.finrank_range_add_finrank_ker
  rw [nullity_nine A h] at hr
  simpa only [Matrix.rank,Module.finrank_fintype_fun_eq_card] using hr

theorem check_rank (H : Matrix m n (ZMod 2))
    (h : Nat.card {x : m → ZMod 2 // H.transpose *ᵥx=0}=512) :
    H.rank+9=Fintype.card m := by
  simpa only [Matrix.rank_transpose] using rank_of_kernel H.transpose h

#print axioms nullity_nine
#print axioms rank_of_kernel
#print axioms check_rank
end RankFromKernel
