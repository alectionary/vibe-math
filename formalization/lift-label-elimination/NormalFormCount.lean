import IntegerKernel
import Mathlib.Data.Matrix.Block

set_option maxHeartbeats 0
namespace NormalFormCount
open Matrix
variable {R : Type*} [CommRing R]

def diagonal (r l k : ℕ) : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) R :=
  Matrix.fromBlocks 1 0 0 0

theorem diagonal_kernel (r l k : ℕ) (x : Fin r ⊕ Fin k → R) :
    diagonal r l k *ᵥ x=0 ↔ ∀ i : Fin r, x (Sum.inl i)=0 := by
  simp only [diagonal, Matrix.fromBlocks_mulVec, Matrix.one_mulVec,
    Matrix.zero_mulVec, add_zero, zero_add]
  constructor
  · intro h i
    exact congrFun h (Sum.inl i)
  · intro h
    funext j
    cases j with
    | inl i => exact h i
    | inr i => rfl

noncomputable def diagonalEquiv (r l k : ℕ) :
    IntegerKernel.Kernel (diagonal r l k : Matrix _ _ R) ≃ (Fin k → R) :=
  (Equiv.subtypeEquivRight (diagonal_kernel r l k)).trans
    (IntegerKernel.coordinateEquiv r k)

theorem count (N r l k : ℕ) [NeZero N]
    (A : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) (ZMod N))
    (U Ui : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin l) (ZMod N))
    (V Vi : Matrix (Fin r ⊕ Fin k) (Fin r ⊕ Fin k) (ZMod N))
    (hU : Ui*U=1) (hV : V*Vi=1) (hVi : Vi*V=1)
    (hD : U*A*V=diagonal r l k) :
    Nat.card (IntegerKernel.Kernel A)=N^k := by
  rw [Nat.card_congr ((IntegerKernel.transport A (diagonal r l k) U Ui V Vi
    hU hV hVi hD).trans (diagonalEquiv r l k)),
    Nat.card_eq_fintype_card, Fintype.card_fun, ZMod.card, Fintype.card_fin]

/-- Integer certificate identities survive reduction modulo every positive N. -/
theorem count_integer (N r l k : ℕ) [NeZero N]
    (A : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ)
    (U Ui : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin l) ℤ)
    (V Vi : Matrix (Fin r ⊕ Fin k) (Fin r ⊕ Fin k) ℤ)
    (hU : Ui*U=1) (hV : V*Vi=1) (hVi : Vi*V=1)
    (hD : U*A*V=diagonal r l k) :
    Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^k := by
  let f := Int.castRingHom (ZMod N)
  have h1 : (Ui.map f)*(U.map f)=1 := by
    rw [← Matrix.map_mul, hU]; ext i j; simp [Matrix.one_apply]
  have h2 : (V.map f)*(Vi.map f)=1 := by
    rw [← Matrix.map_mul, hV]; ext i j; simp [Matrix.one_apply]
  have h3 : (Vi.map f)*(V.map f)=1 := by
    rw [← Matrix.map_mul, hVi]; ext i j; simp [Matrix.one_apply]
  have h4 : (U.map f)*(A.map f)*(V.map f)=diagonal r l k := by
    rw [← Matrix.map_mul, ← Matrix.map_mul, hD]
    ext i j
    cases i <;> cases j <;> simp [diagonal, Matrix.fromBlocks, Matrix.one_apply]
  exact count N r l k (A.map f) (U.map f) (Ui.map f) (V.map f) (Vi.map f)
    h1 h2 h3 h4

#print axioms diagonal_kernel
#print axioms count
#print axioms count_integer
end NormalFormCount
