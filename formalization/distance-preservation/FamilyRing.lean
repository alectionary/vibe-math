import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Algebra.CharP.Two
import Mathlib.Tactic

set_option maxHeartbeats 0
namespace FamilyRing
open scoped Matrix CharTwo
variable {R : Type*} [CommRing R] [CharP R 2]

def base (x : ℤ → R) : Matrix (Fin 3) (Fin 4) R :=
  !![x 0, x 0, x 0, x 0;
     x 0, x 1, x 5, x 3;
     x 0, x 2, x 10, x 7]
def conjugateTranspose (x : ℤ → R) : Matrix (Fin 4) (Fin 3) R :=
  !![x 0, x 0, x 0;
     x 0, x (-1), x (-2);
     x 0, x (-5), x (-10);
     x 0, x (-3), x (-7)]
def leftWord (x : ℤ → R) : Matrix (Fin 4) (Fin 4) R :=
  !![x 0, 0, 0, 0;
     0, x (-2), 0, 0;
     0, 0, x (-10), 0;
     x (-2), x (-4) + x (-2), x (-7), x (-4)]
def rightWord (x : ℤ → R) : Matrix (Fin 3) (Fin 3) R :=
  !![0, 0, x 0; 0, x 0, 0; x 0, 0, 0]

/-- The mixed-sector cycle identity, valid in every characteristic-two
commutative ring with a multiplicative integer-exponent family. -/
theorem mixed_cycle (x : ℤ → R) (h0 : x 0 = 1)
    (hm : ∀ a b, x a * x b = x (a+b)) :
    leftWord x * (base x).transpose = conjugateTranspose x * rightWord x := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [leftWord, rightWord, base, conjugateTranspose,
      Matrix.mul_apply, Fin.sum_univ_succ, mul_add, add_mul, hm, h0,
      add_comm, add_left_comm, add_assoc]

#print axioms mixed_cycle
end FamilyRing
