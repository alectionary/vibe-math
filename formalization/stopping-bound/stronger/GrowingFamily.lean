import PowersFamily
namespace PowersThree
/-- The varying-degree subfamily has exponentially vanishing incidence density. -/
lemma two_mul_le_pow (d : ℕ) : 2*d ≤ 3^d := by
  induction d with
  | zero => norm_num
  | succ d ih =>
    rw [pow_succ]
    have hp : 1 ≤ (3:ℕ)^d := Nat.one_le_pow _ _ (by omega)
    omega

theorem density_certificate (d : ℕ) : (2*d)*3^d ≤ 3^(2*d) := by
  have h := Nat.mul_le_mul_right (3^d) (two_mul_le_pow d)
  simpa only [show 2*d=d+d by omega,pow_add] using h

/-- Choose the degree together with the length to obtain a growing stopping
lower bound. This makes no fixed-degree growth or positive-rate claim. -/
theorem growing_guarantee (d : ℕ) [NeZero (liftLength d 0)]
    (T : Finset (Bool × ZMod (liftLength d 0)))
    (hT : Incidence.Stopping (SidonStopping.E (support (2*d) (liftLength d 0))) T) :
    d+1 ≤ T.card ∧ (2*d)*3^d ≤ liftLength d 0 := by
  constructor
  · exact arbitrary_fixed_guarantee d 0 T hT
  · simpa [liftLength] using density_certificate d
end PowersThree
