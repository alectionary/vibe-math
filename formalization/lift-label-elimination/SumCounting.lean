import CoverCounting
import Mathlib.Data.Finset.Sum

set_option maxHeartbeats 0
namespace SumCounting
open GlobalCounting PaschKernelCount
variable {U W C : Type*} [Fintype U] [Fintype W] [Fintype C]
  [DecidableEq U] [DecidableEq W] [DecidableEq C]

def good {V : Type*} [Fintype V] [DecidableEq V] (H : V → Finset C) :=
  (fourSupports : Finset (Finset V)).filter (elementary40Check H)

theorem selected_map {V : Type*} [Fintype V] [DecidableEq V] (H : V → Finset C)
    (f : U ↪ V) (S : Finset U) (c : C) :
    selected H (S.map f) c=(selected (fun u => H (f u)) S c).map f := by
  simp only [selected,Finset.filter_map,Function.comp_def]

theorem elementary_map {V : Type*} [Fintype V] [DecidableEq V] (H : V → Finset C)
    (f : U ↪ V) (S : Finset U) :
    elementary40Check H (S.map f) ↔ elementary40Check (fun u => H (f u)) S := by
  simp only [elementary40Check,selected_map,Finset.card_map]

theorem mem_good {V : Type*} [Fintype V] [DecidableEq V] (H : V → Finset C)
    (S : Finset V) : S∈good H ↔ S.card=4 ∧ elementary40Check H S := by
  simp only [good,Finset.mem_filter,fourSupports,Finset.mem_powersetCard,Finset.subset_univ,true_and]

/-- A finite partition theorem for unordered supports in a sum of variable sectors. -/
theorem count_partition (H : U ⊕ W → Finset C)
    (hs : ∀ T : FourSupport (U ⊕ W), elementary40Check H T.val →
      T.val.toRight=∅ ∨ T.val.toLeft=∅) :
    count40 H=count40 (fun u => H (.inl u))+count40 (fun w => H (.inr w)) := by
  classical
  let L : Finset (Finset (U ⊕ W)) := (good (fun u => H (.inl u))).image (fun S => S.map Function.Embedding.inl)
  let R : Finset (Finset (U ⊕ W)) := (good (fun w => H (.inr w))).image (fun S => S.map Function.Embedding.inr)
  have hL : L.card=count40 (fun u => H (.inl u)) := by
    dsimp [L]
    rw [Finset.card_image_of_injective _ (Finset.map_injective _)]; rfl
  have hR : R.card=count40 (fun w => H (.inr w)) := by
    dsimp [R]
    rw [Finset.card_image_of_injective _ (Finset.map_injective _)]; rfl
  have hd : Disjoint L R := by
    apply Finset.disjoint_left.mpr
    intro T ht hr
    obtain ⟨S,hS,hST⟩ := Finset.mem_image.mp ht
    obtain ⟨Q,hQ,hQT⟩ := Finset.mem_image.mp hr
    have hc := (mem_good _ S).mp hS |>.1
    have hn : S.Nonempty := Finset.card_pos.mp (by omega)
    obtain ⟨u,hu⟩ := hn
    have hm : Sum.inl u∈Q.map (Function.Embedding.inr : W ↪ U ⊕ W) := by
      rw [hQT,← hST]
      exact Finset.mem_map.mpr ⟨u,hu,rfl⟩
    obtain ⟨v,hv,he⟩ := Finset.mem_map.mp hm
    cases he
  have heq : good H=L∪R := by
    ext T
    constructor
    · intro hT
      obtain ⟨hcard,hE⟩ := (mem_good H T).mp hT
      have hS : T∈(fourSupports : Finset (Finset (U ⊕ W))) :=
        Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _,hcard⟩
      rcases hs ⟨T,hS⟩ hE with hright | hleft
      · have ht : T=T.toLeft.map Function.Embedding.inl := by
          have hh := T.toLeft_disjSum_toRight
          rw [hright,Finset.disjSum_empty] at hh
          exact hh.symm
        apply Finset.mem_union_left
        apply Finset.mem_image.mpr
        refine ⟨T.toLeft,(mem_good _ _).mpr ⟨?_,?_⟩,ht.symm⟩
        · rw [ht,Finset.card_map] at hcard; exact hcard
        · apply (elementary_map H Function.Embedding.inl T.toLeft).mp
          rwa [← ht]
      · have ht : T=T.toRight.map Function.Embedding.inr := by
          have hh := T.toLeft_disjSum_toRight
          rw [hleft,Finset.empty_disjSum] at hh
          exact hh.symm
        apply Finset.mem_union_right
        apply Finset.mem_image.mpr
        refine ⟨T.toRight,(mem_good _ _).mpr ⟨?_,?_⟩,ht.symm⟩
        · rw [ht,Finset.card_map] at hcard; exact hcard
        · apply (elementary_map H Function.Embedding.inr T.toRight).mp
          rwa [← ht]
    · intro hT
      rcases Finset.mem_union.mp hT with hT | hT
      · obtain ⟨S,hS,rfl⟩ := Finset.mem_image.mp hT
        obtain ⟨hc,hE⟩ := (mem_good _ S).mp hS
        exact (mem_good H _).mpr ⟨by simpa only [Finset.card_map] using hc,
          (elementary_map H Function.Embedding.inl S).mpr hE⟩
      · obtain ⟨S,hS,rfl⟩ := Finset.mem_image.mp hT
        obtain ⟨hc,hE⟩ := (mem_good _ S).mp hS
        exact (mem_good H _).mpr ⟨by simpa only [Finset.card_map] using hc,
          (elementary_map H Function.Embedding.inr S).mpr hE⟩
  change (good H).card=_
  rw [heq,Finset.card_union_of_disjoint hd,hL,hR]

#print axioms count_partition
end SumCounting
