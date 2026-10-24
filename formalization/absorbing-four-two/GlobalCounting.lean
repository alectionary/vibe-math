import FourColumnClassification
import Mathlib.Data.Fintype.CardEmbedding

set_option maxHeartbeats 0
set_option maxRecDepth 100000

open scoped BigOperators
open FourColumnClassification

namespace GlobalCounting

variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def fourSupports : Finset (Finset V) := Finset.univ.powersetCard 4

abbrev FourSupport (V : Type*) [Fintype V] [DecidableEq V] :=
  ↥(fourSupports : Finset (Finset V))

theorem support_card (S : FourSupport V) : S.val.card = 4 :=
  (Finset.mem_powersetCard.mp S.property).2

noncomputable def label (S : FourSupport V) : I ≃ ↥S.val :=
  (Fintype.equivFinOfCardEq (by simpa using support_card S)).symm

noncomputable def localCols (H : V → Finset C) (S : FourSupport V) (i : I) : Finset C :=
  H ((label S i).val)

def selected (H : V → Finset C) (S : Finset V) (c : C) : Finset V :=
  S.filter (fun v => c ∈ H v)

def elementary42Check (H : V → Finset C) (S : Finset V) : Prop :=
  (∀ c, (selected H S c).card ≤ 2) ∧
  (Finset.univ.filter (fun c => (selected H S c).card % 2 = 1)).card = 2

instance (H : V → Finset C) (S : Finset V) : Decidable (elementary42Check H S) :=
  inferInstanceAs (Decidable ((∀ c, (selected H S c).card ≤ 2) ∧
  (Finset.univ.filter (fun c => (selected H S c).card % 2 = 1)).card = 2))

def count42 (H : V → Finset C) : ℕ :=
  ((fourSupports : Finset (Finset V)).filter (elementary42Check H)).card

noncomputable def rootSum (H : V → Finset C) : ℕ :=
  ∑ S : FourSupport V, rawRootCount (localCols H S)

theorem local_degree (H : V → Finset C) (hd : ∀ v, (H v).card = 3)
    (S : FourSupport V) : ∀ i, (localCols H S i).card = 3 := by
  intro i
  exact hd _

theorem local_linear (H : V → Finset C)
    (h4 : ∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1)
    (S : FourSupport V) :
    ∀ i j, i ≠ j → ((localCols H S i) ∩ (localCols H S j)).card ≤ 1 := by
  intro i j hij
  apply h4
  intro he
  have hsub : label S i = label S j := Subtype.ext he
  exact hij ((label S).injective hsub)

theorem support_selected_card (H : V → Finset C) (S : FourSupport V) (c : C) :
    (support (localCols H S) c).card = (selected H S.val c).card := by
  apply Finset.card_bij (fun i _ => (label S i).val)
  · intro i hi
    simp only [selected, Finset.mem_filter]
    refine ⟨(label S i).property, ?_⟩
    exact (mem_support (localCols H S) c i).mp hi
  · intro i hi j hj hij
    have hsub : label S i = label S j := Subtype.ext hij
    exact (label S).injective hsub
  · intro v hv
    have hmem : v ∈ S.val := (Finset.mem_filter.mp hv).1
    refine ⟨(label S).symm ⟨v,hmem⟩, ?_, ?_⟩
    · apply (mem_support (localCols H S) c _).mpr
      unfold localCols
      simpa only [Equiv.apply_symm_apply] using (Finset.mem_filter.mp hv).2
    · simp

theorem local_count_indicator (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1)
    (S : FourSupport V) :
    rawRootCount (localCols H S) = if elementary42Check H S.val then 4 else 0 := by
  have h := exact_local_multiplicity (localCols H S) (local_degree H hd S) (local_linear H h4 S)
  have hfilter :
      (Finset.univ.filter (fun c => (support (localCols H S) c).card % 2 = 1)) =
      (Finset.univ.filter (fun c => (selected H S.val c).card % 2 = 1)) := by
    ext c
    simp only [Finset.mem_filter,Finset.mem_univ,true_and,support_selected_card]
  have hc : ((∀ c, (support (localCols H S) c).card ≤ 2) ∧
      (Finset.univ.filter (fun c => (support (localCols H S) c).card % 2 = 1)).card = 2)
      ↔ elementary42Check H S.val := by
    unfold elementary42Check
    rw [hfilter]
    simp only [support_selected_card]
  by_cases hp : elementary42Check H S.val
  · have hh := hc.mpr hp
    rw [if_pos hh] at h
    rw [if_pos hp]
    exact h
  · have hh : ¬ ((∀ c, (support (localCols H S) c).card ≤ 2) ∧
        (Finset.univ.filter (fun c => (support (localCols H S) c).card % 2 = 1)).card = 2) :=
      fun h => hp (hc.mp h)
    rw [if_neg hh] at h
    rw [if_neg hp]
    exact h

theorem support_filter_card (H : V → Finset C) :
    (Finset.univ.filter (fun S : FourSupport V => elementary42Check H S.val)).card = count42 H := by
  unfold count42
  apply Finset.card_bij (fun S _ => S.val)
  · intro S hS
    exact Finset.mem_filter.mpr ⟨S.property,(Finset.mem_filter.mp hS).2⟩
  · intro S hS T hT heq
    exact Subtype.ext heq
  · intro S hS
    refine ⟨⟨S,(Finset.mem_filter.mp hS).1⟩, ?_, rfl⟩
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,(Finset.mem_filter.mp hS).2⟩

/-- General four-to-one count over actual four-variable supports. No code,
lift size, or numerical certificate is assumed. -/
theorem rootSum_eq_four_count42 (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1) :
    rootSum H = 4 * count42 H := by
  classical
  unfold rootSum
  simp_rw [local_count_indicator H hd h4]
  rw [Finset.sum_ite]
  simp only [Finset.sum_const, Finset.sum_const_zero, add_zero, Nat.nsmul_eq_mul]
  rw [support_filter_card]
  omega

/-- The check used by count42 agrees with the absorbing majority condition
under the explicit cubic/no-four-cycle hypotheses. -/
theorem counted_support_is_absorbing (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1)
    (S : FourSupport V) (hS : elementary42Check H S.val) :
    ∀ v ∈ S.val,
      ((H v).filter (fun c => (selected H S.val c).card % 2 = 1)).card <
      ((H v).filter (fun c => (selected H S.val c).card % 2 = 0)).card := by
  have he : ∀ c, (support (localCols H S) c).card ≤ 2 := by
    intro c
    rw [support_selected_card]
    exact hS.1 c
  have ho : (Finset.univ.filter (fun c => (support (localCols H S) c).card % 2 = 1)).card = 2 := by
    simpa only [support_selected_card] using hS.2
  have hAbs := elementary_42_is_absorbing (localCols H S) he (local_degree H hd S) (local_linear H h4 S) ho
  intro v hv
  have hh := hAbs ((label S).symm ⟨v,hv⟩)
  unfold oddAt evenAt at hh
  simp_rw [support_selected_card] at hh
  unfold localCols at hh
  simpa only [Equiv.apply_symm_apply] using hh

#print axioms rootSum_eq_four_count42
#print axioms counted_support_is_absorbing

end GlobalCounting
