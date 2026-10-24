import PaschKernelCount

set_option maxHeartbeats 0
namespace PaschAbsorbingBridge
open GlobalCounting PaschKernelCount
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

/-- Literal global majority condition for every counted (4,0) support. -/
theorem counted_support_is_absorbing40 (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3) (S : Finset V) (hS : elementary40Check H S) :
    ∀ v ∈ S,
      ((H v).filter (fun c => (selected H S c).card % 2 = 1)).card <
      ((H v).filter (fun c => (selected H S c).card % 2 = 0)).card := by
  intro v hv
  have ho : (H v).filter (fun c => (selected H S c).card % 2 = 1) = ∅ := by
    apply Finset.filter_eq_empty_iff.mpr
    intro c hc
    have hz := hS.2 c
    omega
  have he : (H v).filter (fun c => (selected H S c).card % 2 = 0) = H v := by
    apply Finset.filter_eq_self.mpr
    intro c hc
    exact hS.2 c
  rw [ho,he,Finset.card_empty,hd v]
  decide

/-- The all-even condition equals the source's zero odd-check count. -/
theorem elementary40Check_iff_zero_odd (H : V → Finset C) (S : Finset V) :
    elementary40Check H S ↔
      (∀ c, (selected H S c).card ≤ 2) ∧
      (Finset.univ.filter (fun c => (selected H S c).card % 2 = 1)).card = 0 := by
  constructor
  · rintro ⟨he,hz⟩
    refine ⟨he,?_⟩
    have h : Finset.univ.filter (fun c => (selected H S c).card % 2 = 1) = ∅ := by
      apply Finset.filter_eq_empty_iff.mpr
      intro c hc
      have hh := hz c
      omega
    rw [h,Finset.card_empty]
  · rintro ⟨he,hz⟩
    refine ⟨he,?_⟩
    have hf := Finset.card_eq_zero.mp hz
    intro c
    have hn : ¬ (selected H S c).card % 2 = 1 := by
      intro hh
      have hm : c ∈ Finset.univ.filter (fun c => (selected H S c).card % 2 = 1) := by simp [hh]
      rw [hf] at hm
      exact Finset.notMem_empty c hm
    omega

#print axioms counted_support_is_absorbing40
#print axioms elementary40Check_iff_zero_odd
end PaschAbsorbingBridge
