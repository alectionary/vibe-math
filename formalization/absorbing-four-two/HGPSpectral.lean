import HGPCSS
import Mathlib.Algebra.Star.Basic
set_option maxHeartbeats 0
namespace HGPSpectral
open scoped BigOperators
variable {U C : Type*} [Fintype U] [Fintype C] [DecidableEq C]
variable {K : Type*} [CommRing K] [StarRing K]

/-- Evaluated rectangular source matrix for the constant-label family:
    D_j = [A | beta_j I]. -/
def D (base : U → Finset C) (beta : K) (c : C) : Sum U C → K
  | .inl u => if c ∈ base u then 1 else 0
  | .inr d => if c=d then beta else 0

def M (base : U → Finset C) (beta : K) (c d : C) : K :=
  ∑ x, D base beta c x * star (D base beta d x)

theorem M_eq_gram (base : U → Finset C) (beta : K) (c d : C) :
    M base beta c d = (HGPGramObstruction.checkGram base c d : K) +
      if c=d then beta * star beta else 0 := by
  have hl (u : U) :
      D base beta c (.inl u) * star (D base beta d (.inl u)) =
      ((if c ∈ base u ∧ d ∈ base u then 1 else 0 : ℕ) : K) := by
    by_cases hc : c ∈ base u <;> by_cases hd : d ∈ base u <;> simp [D,hc,hd]
  have hr (r : C) :
      D base beta c (.inr r) * star (D base beta d (.inr r)) =
      if c=d then (if r=c then beta * star beta else 0) else 0 := by
    by_cases hcd : c=d
    · subst d
      by_cases hrc : r=c
      · subst r; simp [D]
      · simp [D,hrc,Ne.symm hrc]
    · by_cases hrc : r=c
      · subst r; simp [D,hcd,Ne.symm hcd]
      · simp [D,hrc,Ne.symm hrc]
  simp only [M,Fintype.sum_sum_type]
  simp_rw [hl,hr]
  rw [HGPGramObstruction.checkGram,Nat.cast_sum]
  by_cases hcd : c=d <;> simp [hcd]

theorem evaluated_M_eq_source_data (beta : Fin 7 → K) :
    (fun j c d => M Absorbing42Small.baseA (beta j) c d) =
      HGPGramObstruction.sourceSpectralData Absorbing42Small.baseA
        (fun j => beta j * star (beta j)) := by
  funext j c d
  rw [M_eq_gram,HGPGramObstruction.base_gram_bridge]
  rfl

theorem identical_all_evaluated_M (beta : Fin 7 → K) :
    (fun j c d => M Absorbing42Small.baseA (beta j) c d) =
      (fun j c d => M Absorbing42Small.baseB (beta j) c d) := by
  funext j c d
  rw [M_eq_gram,M_eq_gram,HGPGramObstruction.base_gram_bridge,
    HGPGramObstruction.base_gram_bridge,Absorbing42Small.same_check_gram]

theorem no_evaluated_M_only_count (beta : Fin 7 → K) :
    ¬ ∃ f : (Fin 7 → Fin 12 → Fin 12 → K) → ℕ,
      ∀ base : Absorbing42Small.Incidence, Absorbing42Small.CubicLinear base →
        f (fun j c d => M base (beta j) c d) =
          GlobalCounting.count42 (HGPIncidence.columns base FanoBlock.columns) := by
  rintro ⟨f,hf⟩
  have ha := hf Absorbing42Small.baseA Absorbing42Small.baseA_cubic_linear
  have hb := hf Absorbing42Small.baseB Absorbing42Small.baseB_cubic_linear
  rw [identical_all_evaluated_M] at ha
  change f _ = GlobalCounting.count42 HGPCounts.Concrete.XA at ha
  change f _ = GlobalCounting.count42 HGPCounts.Concrete.XB at hb
  rw [HGPCounts.Concrete.full_A_count] at ha
  rw [HGPCounts.Concrete.full_B_count] at hb
  have he : (49 : ℕ) = 35 := ha.symm.trans hb
  norm_num at he

#print axioms M_eq_gram
#print axioms identical_all_evaluated_M
#print axioms no_evaluated_M_only_count
end HGPSpectral
