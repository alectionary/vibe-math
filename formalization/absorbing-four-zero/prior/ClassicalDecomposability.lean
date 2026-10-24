import FanoBlock
import HGPIncidence
import GramCounterexample12

set_option maxHeartbeats 0
namespace ClassicalDecomposability

/-- A row partition into three groups, with each column meeting a group at
most once. For a cubic column this means exactly once in every group. This
is the row-decomposition hypothesis in Raeisi-Gholami 2024, not a hypothesis
of the broader arbitrary-protograph chordless-cycle papers. -/
def ThreeGroups {V C : Type*} [DecidableEq C] (H : V → Finset C) : Prop :=
  ∃ color : C → Fin 3, ∀ v, Set.InjOn color (H v : Set C)

theorem fano_pair_complete : ∀ r s : Fin 7, r ≠ s →
    ∃ a : Fin 7, r ∈ FanoBlock.columns a ∧ s ∈ FanoBlock.columns a := by
  decide

theorem fano_not_three_groups : ¬ ThreeGroups FanoBlock.columns := by
  rintro ⟨color,hcolor⟩
  have hi : Function.Injective color := by
    intro r s h
    by_contra hrs
    obtain ⟨a,hr,hs⟩ := fano_pair_complete r s hrs
    exact hrs (hcolor a hr hs h)
  have hc := Fintype.card_le_of_injective color hi
  norm_num at hc

/-- Each 168-column witness contains a complete Fano block at any fixed
left check coordinate, so neither has a three-group row decomposition. -/
theorem source_not_three_groups (base : Absorbing42Small.Incidence) :
    ¬ ThreeGroups (HGPIncidence.columns base FanoBlock.columns) := by
  rintro ⟨color,hcolor⟩
  apply fano_not_three_groups
  refine ⟨fun r => color (0,r),?_⟩
  intro a r hr s hs heq
  have hr' : (0,r) ∈ HGPIncidence.columns base FanoBlock.columns (.inr (0,a)) := by
    change (0,r) ∈ ({0} : Finset (Fin 12)) ×ˢ FanoBlock.columns a
    exact Finset.mem_product.mpr ⟨Finset.mem_singleton_self _,hr⟩
  have hs' : (0,s) ∈ HGPIncidence.columns base FanoBlock.columns (.inr (0,a)) := by
    change (0,s) ∈ ({0} : Finset (Fin 12)) ×ˢ FanoBlock.columns a
    exact Finset.mem_product.mpr ⟨Finset.mem_singleton_self _,hs⟩
  exact congrArg Prod.snd (hcolor (.inr (0,a)) hr' hs' heq)

#print axioms fano_pair_complete
#print axioms fano_not_three_groups
#print axioms source_not_three_groups
end ClassicalDecomposability
