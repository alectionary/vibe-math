import Normalization
import IntegerSoundness
set_option maxHeartbeats 0
namespace TruncatedDistance
open TannerSix
variable {L : ℕ} [NeZero L]

theorem source_four_form_nonzero (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (i k : Fin 3) (hik : i≠k)
    (a b : Fin 4) (hab : a≠b) : e i a-e k a+e k b-e i b≠0 := by
  intro he
  apply hab
  apply row_differences_injective e h4 i k hik
  linear_combination he

/-- The normalized six-cycle closure uses three distinct column types and
three distinct row types, hence it is an actual simple Tanner cycle. -/
theorem source_six_form_nonzero (e : Fin 3 → Fin 4 → ZMod L)
    (h6 : NoSix (CEdge e)) (h0 : ∀ j,e 0 j=0)
    (a b c : Fin 4) (hab : a≠b) (hbc : b≠c) (hca : c≠a) :
    e 1 b-e 1 a+e 2 c-e 2 b≠0 := by
  intro he
  apply h6 (a,0) (b,e 1 a-e 1 b) (c,0) (1,e 1 a) (2,e 2 c) (0,0)
  · intro h;exact hab (congrArg Prod.fst h)
  · intro h;exact hbc (congrArg Prod.fst h)
  · intro h;exact hca (congrArg Prod.fst h)
  · intro h;have h' := congrArg Prod.fst h;norm_num at h'
  · intro h;have h' := congrArg Prod.fst h;norm_num at h'
  · intro h;have h' := congrArg Prod.fst h;norm_num at h'
  · simp [CEdge]
  · change e 1 a=(e 1 a-e 1 b)+e 1 b
    ring
  · change e 2 c=(e 1 a-e 1 b)+e 2 b
    linear_combination he
  · simp [CEdge]
  · simp [CEdge,h0]
  · simp [CEdge,h0]

#print axioms source_four_form_nonzero
#print axioms source_six_form_nonzero
end TruncatedDistance
