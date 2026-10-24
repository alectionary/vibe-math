import IncidenceCore
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.Linarith

namespace PartitionStopping
open Finset
variable {V C : Type*} [Fintype C] [DecidableEq V] [DecidableEq C]
variable (E : V → C → Prop) [DecidableRel E]
def neighbors (v : V) : Finset C := univ.filter (E v)
def overlap (v w : V) : ℕ := (neighbors E v ∩ neighbors E w).card

/-- Every neighbor of a selected column must be shared with another selected column. -/
theorem degree_le_overlap_sum (S : Finset V) (hS : Incidence.Stopping E S)
    (v : V) (hv : v ∈ S) :
    (neighbors E v).card ≤ ∑ w ∈ S.erase v, overlap E v w := by
  classical
  have hc : neighbors E v ⊆ (S.erase v).biUnion
      (fun w => neighbors E v ∩ neighbors E w) := by
    intro c hc
    have he : E v c := (mem_filter.mp hc).2
    obtain ⟨w, hw, hne, hew⟩ := Incidence.stopping_extension E S {v} hS
      (singleton_subset_iff.mpr hv) c (by simp only [Finset.filter_singleton, he, ↓reduceIte, Finset.card_singleton])
    apply mem_biUnion.mpr
    exact ⟨w, mem_erase.mpr ⟨by simpa using hne, hw⟩,
      mem_inter.mpr ⟨hc, mem_filter.mpr ⟨mem_univ _, hew⟩⟩⟩
  exact (card_le_card hc).trans (card_biUnion_le)

/-- A selected column's degree is bounded by the weighted counts in both parts. -/
theorem column_budget (color : V → Bool) (S : Finset V)
    (hS : Incidence.Stopping E S) (γ σ τ : ℕ)
    (hdeg : ∀ v ∈ S, γ ≤ (neighbors E v).card)
    (hov : ∀ v ∈ S, ∀ w ∈ S, v ≠ w →
      overlap E v w ≤ if color v = color w then σ else τ)
    (v : V) (hv : v ∈ S) :
    γ + σ ≤ σ * (S.filter (fun w => color w = color v)).card +
      τ * (S.filter (fun w => color w ≠ color v)).card := by
  classical
  have hb := (hdeg v hv).trans (degree_le_overlap_sum E S hS v hv)
  have hs : (∑ w ∈ S.erase v, overlap E v w) ≤
      ∑ w ∈ S.erase v, if color w = color v then σ else τ := by
    apply sum_le_sum
    intro w hw
    have h := hov v hv w (mem_of_mem_erase hw) (Ne.symm (ne_of_mem_erase hw))
    simpa [eq_comm] using h
  have he : (∑ w ∈ S, if color w = color v then σ else τ) =
      (∑ w ∈ S.erase v, if color w = color v then σ else τ) + σ := by
    have h := sum_erase_add S (fun w => if color w = color v then σ else τ) hv
    simpa using h.symm
  have hf : (∑ w ∈ S, if color w = color v then σ else τ) =
      σ * (S.filter (fun w => color w = color v)).card +
      τ * (S.filter (fun w => color w ≠ color v)).card := by
    rw [sum_ite]
    simp [mul_comm]
  omega

/-- Two block overlap bounds yield a bound stronger than their maximum alone. -/
theorem partition_bound (color : V → Bool) (S : Finset V)
    (hS : Incidence.Stopping E S) (γ σ τ : ℕ) (hst : σ ≤ τ)
    (hdeg : ∀ v ∈ S, γ ≤ (neighbors E v).card)
    (hov : ∀ v ∈ S, ∀ w ∈ S, v ≠ w →
      overlap E v w ≤ if color v = color w then σ else τ) :
    2 * (γ + σ) ≤ (σ + τ) * S.card := by
  classical
  let P := S.filter (fun w => color w = false)
  let Q := S.filter (fun w => color w = true)
  have hcard : P.card + Q.card = S.card := by
    have h := card_filter_add_card_filter_not (s := S) (fun w => color w = false)
    simpa [P,Q,Bool.not_eq_false] using h
  have hfalse (v : V) (hv : v ∈ S) (hc : color v = false) :
      γ + σ ≤ σ * P.card + τ * Q.card := by
    have h := column_budget E color S hS γ σ τ hdeg hov v hv
    simpa [hc,P,Q,Bool.not_eq_false] using h
  have htrue (v : V) (hv : v ∈ S) (hc : color v = true) :
      γ + σ ≤ τ * P.card + σ * Q.card := by
    have h := column_budget E color S hS γ σ τ hdeg hov v hv
    simpa [hc,P,Q,Bool.not_eq_true,add_comm] using h
  by_cases hp : P.Nonempty
  · obtain ⟨v,hv⟩ := hp
    have hv' := mem_filter.mp hv
    have hb := hfalse v hv'.1 hv'.2
    by_cases hq : Q.Nonempty
    · obtain ⟨w,hw⟩ := hq
      have hw' := mem_filter.mp hw
      have hb' := htrue w hw'.1 hw'.2
      nlinarith
    · have hq0 : Q.card = 0 := card_eq_zero.mpr (not_nonempty_iff_eq_empty.mp hq)
      nlinarith [Nat.mul_le_mul_right P.card hst]
  · have hp0 : P.card = 0 := card_eq_zero.mpr (not_nonempty_iff_eq_empty.mp hp)
    obtain ⟨v,hv⟩ := hS.1
    have hc : color v = true := by
      cases hc : color v
      · have : v ∈ P := mem_filter.mpr ⟨hv,hc⟩
        exact False.elim (hp ⟨v,this⟩)
      · rfl
    have hb := htrue v hv hc
    nlinarith [Nat.mul_le_mul_right Q.card hst]

theorem weight_four_bound (color : V → Bool) (S : Finset V)
    (hS : Incidence.Stopping E S)
    (hdeg : ∀ v ∈ S, 4 ≤ (neighbors E v).card)
    (hov : ∀ v ∈ S, ∀ w ∈ S, v ≠ w →
      overlap E v w ≤ if color v = color w then 1 else 2) :
    4 ≤ S.card := by
  have h := partition_bound E color S hS 4 1 2 (by omega) hdeg hov
  omega

end PartitionStopping

namespace PartitionStopping
open Finset
variable {V C : Type*} [Fintype C] [DecidableEq V] [DecidableEq C]
variable (E : V → C → Prop) [DecidableRel E]
/-- The classical uniform intersection count, in a division-free form. Compare
Kashyap-Vardy, Stopping Sets in Codes from Designs, Theorem1. -/
theorem uniform_overlap_bound (S : Finset V) (hS : Incidence.Stopping E S) (γ μ : ℕ)
    (hdeg : ∀ v ∈ S, γ ≤ (neighbors E v).card)
    (hov : ∀ v ∈ S, ∀ w ∈ S, v ≠ w → overlap E v w ≤ μ) :
    γ + μ ≤ μ*S.card := by
  obtain ⟨v,hv⟩ := hS.1
  have hh := column_budget E (fun _ => false) S hS γ μ μ hdeg
    (by intro v hv w hw hne; simpa using hov v hv w hw hne) v hv
  simpa using hh
end PartitionStopping
