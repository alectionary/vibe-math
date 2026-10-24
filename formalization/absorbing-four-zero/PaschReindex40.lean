import PaschKernelCount
import IncidenceEquivalence
set_option maxHeartbeats 0
namespace PaschReindex40
open GlobalCounting PaschKernelCount
variable {V W C D : Type*} [Fintype V] [Fintype W] [Fintype C] [Fintype D]
    [DecidableEq V] [DecidableEq W] [DecidableEq C] [DecidableEq D]

theorem check40_transfer (H : V → Finset C) (K : W → Finset D) (e : V ≃ W) (f : C ≃ D)
    (hp : ∀ v, K (e v) = (H v).image f) (S : Finset V) :
    elementary40Check H S ↔ elementary40Check K (S.image e) := by
  have hs := IncidenceEquivalence.selected_card H K e f hp S
  constructor
  · rintro ⟨ha,hb⟩
    constructor
    · intro d
      simpa only [hs (f.symm d),Equiv.apply_symm_apply] using ha (f.symm d)
    · intro d
      simpa only [hs (f.symm d),Equiv.apply_symm_apply] using hb (f.symm d)
  · rintro ⟨ha,hb⟩
    constructor
    · intro c; simpa only [hs c] using ha (f c)
    · intro c; simpa only [hs c] using hb (f c)

theorem count40_eq (H : V → Finset C) (K : W → Finset D) (e : V ≃ W) (f : C ≃ D)
    (hp : ∀ v, K (e v) = (H v).image f) : count40 H = count40 K := by
  unfold count40
  apply Finset.card_bij (fun S _ => S.image e)
  · intro S hS
    have h := Finset.mem_filter.mp hS
    apply Finset.mem_filter.mpr
    constructor
    · have hc := (Finset.mem_powersetCard.mp h.1).2
      apply Finset.mem_powersetCard.mpr
      exact ⟨Finset.subset_univ _,by simpa only [Finset.card_image_of_injective _ e.injective] using hc⟩
    · exact (check40_transfer H K e f hp S).mp h.2
  · intro S _ T _ h
    have hh := congrArg (Finset.image e.symm) h
    simpa [Finset.image_image] using hh
  · intro T hT
    let S := T.image e.symm
    have hST : S.image e = T := by simp [S,Finset.image_image]
    refine ⟨S,?_,hST⟩
    have h := Finset.mem_filter.mp hT
    apply Finset.mem_filter.mpr
    constructor
    · have hc := (Finset.mem_powersetCard.mp h.1).2
      apply Finset.mem_powersetCard.mpr
      exact ⟨Finset.subset_univ _,by simpa only [S,Finset.card_image_of_injective _ e.symm.injective] using hc⟩
    · apply (check40_transfer H K e f hp S).mpr
      simpa only [hST] using h.2

#print axioms count40_eq
end PaschReindex40
