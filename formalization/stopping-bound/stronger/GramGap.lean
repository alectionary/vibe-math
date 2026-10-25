import GrowingFamily
import RealGramBound
namespace PowersThree
open Matrix
/-- For every requested multiplicative factor, the valid Gram-only lower bound
is smaller by more than that factor than every good stopping support.
The degree may depend on M; for fixed M the lift parameter t is unbounded. -/
theorem unbounded_gram_gap (M t : ℕ) [NeZero (liftLength (2*M) t)]
    (lower : Matrix (ZMod (liftLength (2*M) t)) (ZMod (liftLength (2*M) t)) ℝ → ℝ)
    (valid_bad : ∀ U : Finset (Bool × ZMod (liftLength (2*M) t)),
      Incidence.Stopping (SidonStopping.badE (support (4*M) (liftLength (2*M) t))) U →
      lower (SidonStopping.BadX ℝ (support (4*M) (liftLength (2*M) t)) *
        (SidonStopping.BadX ℝ (support (4*M) (liftLength (2*M) t)))ᵀ) ≤ (U.card : ℝ))
    (T : Finset (Bool × ZMod (liftLength (2*M) t)))
    (hT : Incidence.Stopping (SidonStopping.E (support (4*M) (liftLength (2*M) t))) T) :
    (M:ℝ)*lower (SidonStopping.X ℝ (support (4*M) (liftLength (2*M) t)) *
      (SidonStopping.X ℝ (support (4*M) (liftLength (2*M) t)))ᵀ) < (T.card : ℝ) := by
  have hbound := SidonStopping.real_gram_only_bound _ lower valid_bad
  have hrewrite : 4*M = 2*(2*M) := by omega
  rw [hrewrite] at hT
  have hg := arbitrary_fixed_guarantee (2*M) t T hT
  have hgr : (2*M+1:ℕ) ≤ T.card := hg
  have hrr : (2*(M:ℝ)+1) ≤ (T.card:ℝ) := by exact_mod_cast hgr
  have hmul := mul_le_mul_of_nonneg_left hbound (Nat.cast_nonneg M : (0:ℝ) ≤ M)
  linarith
end PowersThree
