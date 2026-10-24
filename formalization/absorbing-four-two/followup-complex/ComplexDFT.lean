import ComplexCharacter

set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {N : ℕ} [NeZero N]

noncomputable def standardRoot (N : ℕ) [NeZero N] : ℂ :=
  ZMod.stdAddChar (1 : ZMod N)

theorem standardRoot_exp : standardRoot N =
    Complex.exp (2 * Real.pi * Complex.I / (N : ℂ)) := by
  simpa only [standardRoot, Int.cast_one, mul_one] using ZMod.stdAddChar_coe (N := N) (1 : ℤ)

theorem standard_character_neg_product (j a : ZMod N) :
    ZMod.stdAddChar (-(j*a)) =
      standardRoot N ^ (-(j.val : ℤ) * (a.val : ℤ)) := by
  have h := (ZMod.toCircle (N := N)).map_zsmul_eq_zpow
    (-(j.val : ℤ) * (a.val : ℤ)) (1 : ZMod N)
  have he : (-(j.val : ℤ) * (a.val : ℤ)) • (1 : ZMod N) = -(j*a) := by
    simp only [zsmul_eq_mul, Int.cast_mul, Int.cast_neg, Int.cast_natCast,
      ZMod.natCast_zmod_val, mul_one, neg_mul]
  rw [he] at h
  change (ZMod.toCircle (-(j*a)) : ℂ) = _
  rw [h]
  simp only [Circle.coe_zpow, standardRoot, ZMod.stdAddChar_apply]

theorem standard_dft_eq_powers (f : ZMod N → ℂ) (j : ZMod N) :
    dft ZMod.stdAddChar f j =
      ∑ a : ZMod N, standardRoot N ^ (-(j.val : ℤ) * (a.val : ℤ)) * f a := by
  simp only [dft, standard_character_neg_product]

variable {P R : Type*} [DecidableEq R]

theorem standard_evaluatedMatrix_eq_powers (sockets : P → Finset (R × ZMod N))
    (j : ZMod N) (r : R) (p : P) :
    evaluatedMatrix ZMod.stdAddChar sockets j r p =
      ∑ s ∈ sockets p, if s.1 = r then
        standardRoot N ^ (-(j.val : ℤ) * (s.2.val : ℤ)) else 0 := by
  simp only [evaluatedMatrix, standard_character_neg_product]

#print axioms standardRoot_exp
#print axioms standard_character_neg_product
#print axioms standard_dft_eq_powers
#print axioms standard_evaluatedMatrix_eq_powers
end AbsorbingFourier
