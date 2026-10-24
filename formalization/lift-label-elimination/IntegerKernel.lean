import Mathlib.Data.Matrix.Mul
import Mathlib.Data.ZMod.Basic
import Mathlib.SetTheory.Cardinal.Finite

set_option maxHeartbeats 0
namespace IntegerKernel
open Matrix
variable {R : Type*} [CommRing R]
variable {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]

def Kernel (A : Matrix m n R) := {x : n → R // A *ᵥ x = 0}

theorem forward (A D : Matrix m n R) (U : Matrix m m R) (V Vi : Matrix n n R)
    (hV : V * Vi = 1) (h : U * A * V = D) (x : n → R) (hx : A *ᵥ x = 0) :
    D *ᵥ (Vi *ᵥ x) = 0 := by
  rw [← h]
  simp only [← mulVec_mulVec]
  rw [mulVec_mulVec x V Vi, hV, one_mulVec, hx, mulVec_zero]

theorem backward (A D : Matrix m n R) (U Ui : Matrix m m R) (V : Matrix n n R)
    (hU : Ui * U = 1) (h : U * A * V = D) (y : n → R) (hy : D *ᵥ y = 0) :
    A *ᵥ (V *ᵥ y) = 0 := by
  have hz : Ui *ᵥ (D *ᵥ y) = 0 := by rw [hy, mulVec_zero]
  rw [← h] at hz
  simp only [mulVec_mulVec] at hz
  rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, hU, Matrix.one_mul] at hz
  simpa only [mulVec_mulVec] using hz

/-- Explicit unimodular certificates give actual solution equivalences over any ring. -/
def transport (A D : Matrix m n R) (U Ui : Matrix m m R) (V Vi : Matrix n n R)
    (hU : Ui * U = 1) (hV : V * Vi = 1) (hVi : Vi * V = 1)
    (h : U * A * V = D) : Kernel A ≃ Kernel D where
  toFun x := ⟨Vi *ᵥ x.val, forward A D U V Vi hV h x.val x.prop⟩
  invFun y := ⟨V *ᵥ y.val, backward A D U Ui V hU h y.val y.prop⟩
  left_inv x := Subtype.ext (by simp only [mulVec_mulVec, hV, one_mulVec])
  right_inv y := Subtype.ext (by simp only [mulVec_mulVec, hVi, one_mulVec])

/-- A diagonal unit block imposes exactly one zero coordinate per row. -/
def coordinateEquiv (r k : ℕ) :
    {x : Fin r ⊕ Fin k → R // ∀ i : Fin r, x (Sum.inl i) = 0} ≃ (Fin k → R) where
  toFun x j := x.val (Sum.inr j)
  invFun y := ⟨Sum.elim (fun _ => 0) y, fun _ => rfl⟩
  left_inv x := Subtype.ext (by funext j; cases j with
    | inl i => exact (x.prop i).symm
    | inr i => rfl)
  right_inv _ := rfl

theorem coordinate_card (N r k : ℕ) [NeZero N] :
    Nat.card {x : Fin r ⊕ Fin k → ZMod N // ∀ i : Fin r, x (Sum.inl i) = 0} = N^k := by
  rw [Nat.card_congr (coordinateEquiv r k), Nat.card_eq_fintype_card,
    Fintype.card_fun, ZMod.card, Fintype.card_fin]

#print axioms transport
#print axioms coordinate_card
end IntegerKernel
