import MomentBound
import BadStopping
namespace StoppingMoment
open Matrix Finset
/-- A global spectral lower-bound function of matrix sizes, regular degrees and
fourth singular-value moment. It uses no small-size exclusion premise. -/
noncomputable def regularReplacement (m N γ k : ℕ) (M4 : ℝ) : ℕ := by
  classical
  exact if M4+(N:ℝ)*γ=(N:ℝ)*(γ:ℝ)^2+(m:ℝ)*(k:ℝ)^2 then γ+1 else 2

theorem regularReplacement_ge_two (m N γ k : ℕ) (M4 : ℝ) (hγ : 0<γ) :
    2 ≤ regularReplacement m N γ k M4 := by
  classical
  unfold regularReplacement
  split_ifs <;> omega

theorem regularReplacement_valid {C V : Type*} [Fintype C] [Fintype V]
    [DecidableEq C] [DecidableEq V] (E : V → C → Prop) [DecidableRel E]
    (γ k : ℕ) (hγ : 0<γ)
    (hcol : ∀ v, (PartitionStopping.neighbors E v).card=γ)
    (hrow : ∀ c, rowWeight E c=k)
    (S : Finset V) (hS : Incidence.Stopping E S) :
    regularReplacement (Fintype.card C) (Fintype.card V) γ k
      (∑ i,(StoppingSpectral.eigs (H E) i)^2) ≤ S.card := by
  classical
  unfold regularReplacement
  split_ifs with h
  · exact regular_spectral_bound E γ k hcol hrow h S hS
  · apply Bicycle.Family.positive_stopping_ge_two E _ S hS
    intro v
    have hc : 0 < (PartitionStopping.neighbors E v).card := by rw [hcol]; exact hγ
    obtain ⟨c,hc⟩ := card_pos.mp hc
    exact ⟨c,(mem_filter.mp hc).2⟩
end StoppingMoment
