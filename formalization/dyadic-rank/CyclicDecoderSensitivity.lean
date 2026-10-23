import CyclicDecoderTubeGraph
import CyclicDecoderTubeData.PreviousHoldout
import CyclicDecoderTubeData.MinimumHoldout

/-! A limitation of a uniform maximum-distance contraction argument. The decoder
and its prior remain fixed. The second internal message state is a hypothetical
operator input; it is not asserted reachable from the channel. -/
namespace CyclicDecoderSensitivity
open CyclicDecoderPersistence CyclicDecoderTubeData

def low : E → Int := fun _ => CyclicMergedMessages.prior
def high : E → Int := fun _ => CyclicMergedMessages.prior + 1000

def Within (radius : Int) (q z : E → Int) : Prop := ∀ e, |q e - z e| ≤ radius

def NonexpansiveAt1000 (d : Decoder E V C) (s : C → Bool) : Prop :=
  ∀ q z, Within 1000 q z → Within 1000 (next d s q) (next d s z)

theorem input_near : Within 1000 high low := by
  intro e
  norm_num [high, low]

/-- Two normalized incoming check messages can expand a perturbation by 1.6. -/
theorem two_message_gain (negative : Bool) :
    |CyclicMergedMessages.clip
      (CyclicMergedMessages.prior + CyclicMergedMessages.signed negative 2666745 + CyclicMergedMessages.signed negative 2666745) -
     CyclicMergedMessages.clip
      (CyclicMergedMessages.prior + CyclicMergedMessages.signed negative 2665945 + CyclicMergedMessages.signed negative 2665945)| = 1600 := by
  cases negative <;> decide +kernel

namespace Previous
abbrev decoder := CyclicDecoderTubeData.PreviousHoldout.decoder
abbrev target := CyclicDecoderTubeData.PreviousHoldout.target

theorem output_gain : |next decoder target high (0 : E) - next decoder target low (0 : E)| = 1600 := by
  decide +kernel

theorem not_nonexpansive : ¬NonexpansiveAt1000 decoder target := by
  intro h
  have bad := h high low input_near (0 : E)
  rw [output_gain] at bad
  norm_num at bad
end Previous

namespace Minimum
abbrev decoder := CyclicDecoderTubeData.MinimumHoldout.decoder
abbrev target := CyclicDecoderTubeData.MinimumHoldout.target

theorem output_gain : |next decoder target high (0 : E) - next decoder target low (0 : E)| = 1600 := by
  decide +kernel

theorem not_nonexpansive : ¬NonexpansiveAt1000 decoder target := by
  intro h
  have bad := h high low input_near (0 : E)
  rw [output_gain] at bad
  norm_num at bad
end Minimum
end CyclicDecoderSensitivity
#print axioms CyclicDecoderSensitivity.Previous.not_nonexpansive
#print axioms CyclicDecoderSensitivity.Minimum.not_nonexpansive
