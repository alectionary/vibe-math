module

public import CyclicLift

@[expose] public section

open CyclicLift
namespace CyclicPriorArt
variable {I J : Type*} {r : ℕ}

-- Fossorier (2004), equations (3)-(5), restricted to two steps.
-- This checks algebraic translation, not a formalization of the published theorem itself.
theorem fossorier_two_step (B : I → J → ZMod r) (a b : I) (c d : J) :
    (B a c - B b c) + (B b d - B a d) = baseRectangle B a b c d := by
  unfold baseRectangle
  abel

-- For three steps, reverse the last two rows and columns to match our horizontal convention.
theorem fossorier_three_step (B : I → J → ZMod r) (a b c : I) (d e f : J) :
    (B a d - B b d) + (B b e - B c e) + (B c f - B a f) =
      baseHexagon B a c b d f e := by
  unfold baseHexagon
  abel

-- The four-label cancellation in Raveendran-Declercq-Vasic (2025), Section III-B,
-- paragraph following equation (20). The abstract symbols include conjugate exponents.
theorem published_eight_cancellation (x y u v : ZMod r) :
    x - u + v - x + y - v + u - y = 0 := by
  abel

#print axioms fossorier_two_step
#print axioms fossorier_three_step
#print axioms published_eight_cancellation
end CyclicPriorArt
