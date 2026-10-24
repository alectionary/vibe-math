import Mathlib.LinearAlgebra.Matrix.Circulant
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Fintype.Prod
import Mathlib.Tactic.NormNum

namespace GramStopping
open Matrix
variable {G R : Type*} [Fintype G] [AddCommGroup G] [CommSemiring R]
/-- The two constituent blocks, indexed without an implicit column permutation. -/
def paired (A : Matrix G G R) : Matrix G (Bool × G) R :=
  fun c v => if v.1 then A v.2 c else A c v.2
def doubled (A : Matrix G G R) : Matrix G (Bool × G) R := fun c v => A c v.2

theorem paired_gram (A : Matrix G G R) :
    paired A * (paired A)ᵀ = A * Aᵀ + Aᵀ * A := by
  ext i j
  simp only [mul_apply,transpose_apply,paired,add_apply]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool,Bool.false_eq_true,↓reduceIte]
  exact add_comm _ _

theorem doubled_gram (A : Matrix G G R) :
    doubled A * (doubled A)ᵀ = A * Aᵀ + A * Aᵀ := by
  ext i j
  simp only [mul_apply,transpose_apply,doubled,add_apply]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool]

theorem circulant_gram_equal (f : G → R) :
    paired (circulant f) * (paired (circulant f))ᵀ =
      doubled (circulant f) * (doubled (circulant f))ᵀ := by
  rw [paired_gram,doubled_gram,transpose_circulant]
  rw [circulant_mul_comm f (fun i => f (-i))]

/-- In characteristic two the transposed-pair construction is CSS. -/
theorem paired_css (f : G → ZMod 2) :
    paired (circulant f) * (paired (circulant f))ᵀ = 0 := by
  rw [paired_gram,transpose_circulant,circulant_mul_comm]
  ext i j
  exact (show ∀ x : ZMod 2, x+x=0 by decide) _

/-- The repeated-constituent construction is CSS with its explicit companion. -/
theorem doubled_css (A : Matrix G G (ZMod 2)) :
    doubled A * (doubled Aᵀ)ᵀ = 0 := by
  ext i j
  simp only [mul_apply,transpose_apply,doubled]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool,transpose_apply]
  exact (show ∀ x : ZMod 2, x+x=0 by decide) _

/-- A universally valid bound based on Gram data cannot distinguish a bad twin.
The premise is validity on the actual class, not an assumption on the desired code. -/
theorem gram_bound_obstruction {Code Data : Type*} (gram : Code → Data)
    (distance : Code → ℕ) (lower : Data → ℕ)
    (valid : ∀ Q, lower (gram Q) ≤ distance Q)
    (good bad : Code) (heq : gram good = gram bad) (hbad : distance bad = 2) :
    lower (gram good) ≤ 2 := by
  rw [heq]
  simpa [hbad] using valid bad
end GramStopping
