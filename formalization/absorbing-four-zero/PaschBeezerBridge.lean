import PaschClassification

set_option maxHeartbeats 0
namespace PaschBeezerBridge
open FourColumnClassification
variable {C : Type*} [Fintype C] [DecidableEq C]

/-- Beezer journal Definition3.1, written for arbitrary finite check types. -/
def Generator (t : ℕ) (H : I → Finset C) : Prop :=
  ∀ i, t < ((H i).filter (fun c => 2 ≤ (support H c).card)).card

/-- A zero-syndrome cubic four-configuration is a generator for t=1 and t=2.
Thus the non-generator reduction leaves its Pasch count as an input. -/
theorem zero_syndrome_generator (H : I → Finset C)
    (hd : ∀ i, (H i).card = 3) (heven : PaschClassification.EvenChecks H)
    (t : ℕ) (ht : t < 3) : Generator t H := by
  intro i
  have hf : ((H i).filter (fun c => 2 ≤ (support H c).card)) = H i := by
    apply Finset.filter_eq_self.mpr
    intro c hc
    have hp : 0 < (support H c).card :=
      Finset.card_pos.mpr ⟨i,(mem_support H c i).mpr hc⟩
    have he := heven c
    omega
  rw [hf,hd i]
  exact ht

#print axioms zero_syndrome_generator
end PaschBeezerBridge
